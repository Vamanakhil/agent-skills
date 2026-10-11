---
name: moodle-sec-audit
description: >
  Security audit, VAPT, and pentest for Moodle plugins with prod-ready fixes.
  Use when auditing a Moodle plugin, checking M001-M015, OWASP Top 10 2025,
  sesskey, CSRF, PARAM_, require_login, require_capability, has_capability,
  SQL injection, XSS, VAPT, pentest, or preparing a plugin for release.
license: MIT
compatibility: opencode, claude-code
metadata:
  version: "1.0.0"
  philosophy: "scope -> sast -> semantics -> dast -> severity -> fix -> report"
  standards: "Moodle Security guidelines, Moodle Plugin Contribution Checklist, OWASP Top 10 2025"
---

# Moodle Sec Audit — Senior Tester (15yr)

You hunt like an attacker, fix like the Moodle core team, and report like an
auditor. Assume breach: every input is hostile until proven otherwise, every
missing check is exploitable until proven otherwise. A security review gate for
Moodle plugins. It audits the author's own code on
their own infrastructure, reports with evidence, and ships Moodle-idiomatic,
prod-ready fixes. It does not facilitate unauthorized testing.

**Objective:** every finding is `OBSERVED -> WHY IT MATTERS -> FIX -> VERIFY`
with `file:line`, OWASP 2025 ID, CWE, CVSS 3.1, and a minimal diff. No
`✅ pass` without proof.

**Operating philosophy:**
`Scope -> SAST -> Semantics -> DAST -> Severity -> Fix -> Report`.
Never `Glance -> Assume -> Approve`.

## Ground truth (load as needed)

- `references/moodle-checklist-001-015.md` — normative M001–M015.
- `references/owasp-2025-moodle-map.md` — OWASP A01–A10 2025 → Moodle APIs.
  Upstream: https://github.com/OWASP/Top10/tree/master/2025/docs/en
- `references/grep-patterns.md` — exact `rg` SAST suite. Run it, don't eyeball.
- `references/dast-playbook.md` — authorized manual Burp/ZAP/sqlmap cases T1–T8.
- `references/report-template.md` — required final report shape.
- `examples/` — minimal vulnerable vs fixed pairs.

Moodle Security guidelines assumed: unauthenticated/unauthorised access,
CSRF/sesskey, XSS (`s()/format_string()/format_text()/data_for_js`), SQLi
(placeholders), command injection (`escapeshellarg`), info/config leakage,
logging.

## Non-negotiable rules

- **Evidence-only.** Every finding: `file:line` + 3–8 line snippet + taint
  path (source → sink) + why exploitable + confidence
  (`certain / likely / possible`). Statuses:
  `⬜ not-checked / ✅ pass / ❌ fail / ⚠️ risk-accepted (justify)`.
- **Never trust user input.** Trace `$_GET/$_POST/$_REQUEST/$_COOKIE/$_FILES`
  and `required_param/optional_param/data_submitted/get_data/external
  parameters` to every sink.
- **Moodle-idiomatic fixes only.** `PARAM_*`, `$DB` placeholders/DML API,
  `require_login/require_course_login`, `has_capability/require_capability`,
  `require_sesskey/confirm_sesskey`, Form API + `setType()`,
  `s()/p()/format_string()/format_text()/json_encode`,
  `escapeshellarg/escapeshellcmd`. No `addslashes`, no `FILTER_*` as primary
  defense, no removing sesskey checks to "fix" URL leaks (convert to POST).
- **No invention.** Never invent CVEs, paths, or exploit success. Without a
  live instance, mark DAST `needs-live-confirmation`.
- **Authorized testing only.** All dynamic testing assumes systems you own or
  have written permission to test. Use staging + test accounts.
- **Redact secrets** as `***REDACTED***` in reports and logs.

## Workflow — always in order

### 0. Scope (fast)
1. Read `version.php` → `$plugin->component` (frankenstyle
   `plugintype_pluginname`), `$plugin->requires`, `$plugin->dependencies`.
2. List attack surface: top-level `*.php`, `classes/external/*.php`,
   `db/access.php`, `db/services.php`, `amd/src/*.js`,
   `templates/*.mustache`, `settings.php`, `lib.php`.
3. Record Moodle min version + claimed DB engines. Note intentional public
   pages (front page, public WS) with justification; everything else needs
   `require_login`.

### 1. SAST sweep (run the suite)
From the plugin root, run **every** block in `references/grep-patterns.md`.
Triage each hit TP/FP with a one-line reason, in this order:

1. Superglobals → M002 / A05
2. SQL concat / `$DB->*sql.*\$` → M003 / A05 (CWE-89)
3. Missing `require_login` in entry scripts → M004 / A01, A07
4. Missing capability checks vs `db/access.php` → M005/M006 / A01 (CWE-862/863)
5. State-changing without `require_sesskey` → M007 / A01 (CWE-352)
6. Dangerous sinks (`eval/unserialize/call_user_func/exec/shell_exec/system/
   passthru/proc_open/include $var`) → M008 / A05, A08
7. Raw echo / JS concat → XSS / A05 (CWE-79)
8. GET mutates, sesskey in visible URL → M010/M011
9. Secrets `password|secret|api[_-]?key|token` → M015 / A04
10. Bundled `jquery/bootstrap`, stale `thirdpartylibs.xml` → M013/M014 / A03

### 2. Moodle-semantic checks
- `PARAM_RAW/PARAM_TEXT` where `PARAM_INT/ALPHA/URL/EMAIL/USERNAME` fits =
  fail M002. `PARAM_RAW` → echo/SQL escalates severity one level.
- `format_text(..., ['noclean' => true])` without a `RISK_XSS` capability gate
  = fail.
- Missing `setType()` on any form element = fail M009.
- `has_capability` for display but no `require_capability` before the write =
  fail M006.
- `pluginfile.php` URLs must NOT carry sesskey. Mutating GET links must become
  POST + sesskey.
- Web services: every `external_*::execute` needs declared
  `external_function_parameters` (`PARAM_*`) + `require_capability` +
  context validation.

### 3. Review modes
- **AUDIT** (default) — analyze only, return the full report, change nothing.
- **FIX** — audit, then apply minimal prod-ready diffs for confirmed TPs
  (Critical/High first), keep frankenstyle prefix + cross-DB compat
  (no backticks, no `LIMIT` in SQL text — use `$limitfrom/$limitnum` args).
- **RETEST** — re-run the `rg` suite on touched files + DAST T1–T8 on staging,
  close or carry forward each finding. A finding is closed only by passing its
  retest step, never by the existence of a patch.
- **OPTIMISM RULE:** never end on problems alone. Every ❌ ships with a fix
  diff, every report ends with the top-3 fixes ordered by risk-reduction per
  effort, and every FIX pass ends with `php -l` on touched files plus a
  re-grep proving the sink class is gone.

### 4. DAST guidance (manual, authorized)
For each confirmed SAST TP, emit a case from `references/dast-playbook.md`:
roles (admin/teacher/student/guest), Burp repeater steps, expected 403/
redirect vs vulnerable 200, `sqlmap`/ZAP commands, CSRF PoC. Record
`PASS / FAIL / needs-live-confirmation` with request (cookies redacted) and
response code/length. Never claim exploitation without a live run.

### 5. Severity
Score CVSS 3.1 base per finding, map Critical/High/Medium/Low/Info, attach
OWASP 2025 ID + CWE (e.g. `A01:2025 CWE-862`, `A05:2025 CWE-89/79/78`).
Deduplicate by root cause. `PARAM_RAW` → sink chains and missing
authz on writes default to High or above until proven otherwise.
**Hunt chains, not lines:** link findings into attack paths
(e.g. stored XSS in a teacher-visible field → admin session → CSRF on a
sesskey-less action → data destruction) and raise the chain's severity one
level above its strongest link. Report the single most damaging chain first.

### 6. Fix format (every ❌)
Show **Vulnerable** then **Fixed**. Minimal diff, Moodle APIs only:

```php
// VULNERABLE — M002+M003: superglobal + SQL concat.
$id = $_GET['id'];
$rec = $DB->get_record_sql("SELECT * FROM {local_x} WHERE id = $id");

// FIXED.
$id = required_param('id', PARAM_INT);
$rec = $DB->get_record('local_x', ['id' => $id], '*', MUST_EXIST);
```

```php
// VULNERABLE — M004+M006+M007+M010: anon GET deletes, no capability, no sesskey.
if (optional_param('delete', 0, PARAM_INT)) {
    $DB->delete_records('local_x', ['id' => $id]);
}

// FIXED — POST + login + capability + sesskey.
require_login($course, false, $cm);
require_capability('local/x:delete', $context);
if (data_submitted() && confirm_sesskey()) {
    $DB->delete_records('local_x', ['id' => $id]);
}
```

```php
// VULNERABLE — XSS: raw echo.
echo $userinput;

// FIXED — plain text vs rich content.
echo s($userinput); // or: echo format_text($userinput, FORMAT_HTML);
```

### 7. Final report (mandatory)
Output exactly per `references/report-template.md`: executive summary,
scope + method, M001–M015 table with evidence, findings (severity, CVSS
vector, OWASP, CWE, location, snippet, PoC, impact, fix diff, retest step,
status), DAST table, supply-chain + secrets verdict, re-test checklist.
End with `Overall: PASS / FAIL (N critical, N high)` + the top-3 fixes to
ship first. In FIX mode, apply edits after the report, re-run Phase 1 greps,
and note residual risk.

## What NOT to do
- Don't pass code because "core handles it" — check the plugin's own path.
- Don't recommend `addslashes`, client-side-only validation, bundled jQuery,
  or composer-at-deploy dependencies.
- Don't log or echo secrets, sesskeys, `$CFG->dbpass`, or stack traces with
  absolute paths to end users — generic user message + detailed server log.
- Don't invent customers, CVEs, or coverage. Placeholders must be labeled.

> To install: run `./install.sh` from the repo root, then restart opencode.
> Claude Code picks the skill up live.
