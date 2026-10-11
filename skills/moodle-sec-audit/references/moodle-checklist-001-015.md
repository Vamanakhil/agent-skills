# Moodle Plugin Security Checklist M001–M015 (normative)

Status legend: `⬜ not-checked` `✅ pass` `❌ fail` `⚠️ risk-accepted (justify)`. Never mark ✅ without file:line evidence.

| ID | What to check | Fail pattern | Pass pattern | OWASP 2025 |
|---|---|---|---|---|
| M001 | Audit against latest checklist + Moodle Security guidelines | no audit trail | this report exists | A06 |
| M002 | No direct `$_GET/$_POST/$_REQUEST/$_COOKIE/$_FILES`. Use `required_param()/optional_param()` with most-specific `PARAM_*` | `$_GET['id']`, `PARAM_RAW` for an int | `required_param('id', PARAM_INT)` | A05 (CWE-20) |
| M003 | SQL via placeholders `?` / `:named` or DML API. No concat/interpolation | `"WHERE id = $id"`, `"...'.$name.'"` | `$DB->get_record('x', ['id'=>$id])`, `get_record_sql($sql, [$a,$b])` | A05 (CWE-89) |
| M004 | `require_login()` / `require_course_login()` at top of every entry script (except intentional public pages) | entry `.php` with no login call | `require_login($course,false,$cm)` right after params | A01/A07 |
| M005 | `has_capability()` gates UI widgets/action links | delete link shown to all | `if (has_capability('mod/x:delete',$ctx)) echo $link` | A01 (CWE-862) |
| M006 | `require_capability()` immediately before action | writes without check | `require_capability('mod/x:delete',$ctx)` before `$DB->delete_records` | A01 (CWE-863) |
| M007 | `require_sesskey()` / `confirm_sesskey()` / Form API check before state change | insert/update/delete with no sesskey | `if (data_submitted() && confirm_sesskey()) {...}` | A01 (CWE-352) |
| M008 | No dangerous sinks on user data: `eval, assert, create_function, call_user_func[_array], unserialize, preg_replace /e, exec, shell_exec, system, passthru, proc_open, popen, include/require $var` | any of left on tainted path | remove use; allowlist + `escapeshellarg` if shell unavoidable; `json_decode` instead of `unserialize` | A05/A08 (CWE-94/95/78/98) |
| M009 | Form API + `->setType()` on every element | raw `<form>` + `$_POST` | `moodleform` + `$mform->setType('name', PARAM_TEXT)` | A05/A06 |
| M010 | GET=read-only, POST=mutate | `page.php?delete=1` deletes | delete via POST form / `single_button` + sesskey | A01/A06 |
| M011 | Never leak sesskey: URL bar, Referer to 3rd party, logs, `pluginfile.php` | `new moodle_url('/x/view.php',['sesskey'=>sesskey()])` on long-lived GET | POST body only; AJAX sub-request + immediate redirect; no sesskey on `pluginfile.php` | A01 |
| M012 | No outdated/insecure required plugins or Moodle min-version below supported | `$plugin->requires = 2020061500` | supported branch + declared `dependencies` in `version.php` | A02/A03 |
| M013 | Don't bundle libs Moodle core already ships (jQuery, Bootstrap…) | `thirdparty/jquery.min.js` | use core AMD/`$PAGE->requires->js` | A03 |
| M014 | Bundled third-party libs up to date + declared in `thirdpartylibs.xml` | 3-yr-old lib, no xml entry | current version + xml entry + license GPL-compatible | A03 |
| M015 | No passwords/keys/tokens in code/comments/logs | `$apikey = 'sk-live-...'` | `get_config('plugintype_name','apikey')` admin setting, redact logs | A04 (CWE-798/540) |

## Extra Moodle-semantic gates (treat as M002–M011 extensions)
- XSS output: plain → `s()/p()`; label → `format_string()`; rich HTML → `format_text()`; `noclean=>true` only behind `RISK_XSS` capability. JS data → `$PAGE->requires->data_for_js()` / `json_encode`, never `"...$var..."` in `<script>`.
- `db/access.php` capabilities must declare `riskbitmask` (`RISK_XSS|RISK_PERSONAL|RISK_SPAM|RISK_CONFIG`) where applicable; privacy provider (`classes/privacy/provider.php`) required if personal data stored.
- Cross-DB: no backticks, no `LIMIT` in SQL text, no `GROUP_CONCAT`/engine-specific functions; use `$DB->sql_*` helpers.
- Secrets: also grep `TODO.*password`, `// admin:pass`, `.pem/.key` committed files.
