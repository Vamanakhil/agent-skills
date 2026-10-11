# moodle-plugin-sec-audit

**Senior-tester security audit, VAPT, and pentest for Moodle plugins — with prod-ready fixes.**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
[![opencode](https://img.shields.io/badge/opencode-compatible-000000.svg)](https://opencode.ai)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-D97757.svg)](https://claude.com/claude-code)
[![Standards](https://img.shields.io/badge/standards-OWASP_Top10_2025-green.svg)](https://github.com/OWASP/Top10/tree/master/2025/docs/en)

Acts as a senior application security tester (15yr Moodle + PHP + OWASP). Audits
**your own plugin on your own infrastructure**, maps every issue to the
**Moodle M001–M015 checklist** and **OWASP Top 10 2025 (A01–A10)**, and returns an
evidence-backed report plus minimal, Moodle-idiomatic, cross-DB-safe patches.

## When to use

Use when you say things like:

- `audit my moodle plugin at ./local_myplugin`
- `run the M001-M015 security checklist`
- `check sesskey / PARAM_ / require_capability / SQL placeholders`
- `VAPT / pentest my plugin before release`
- `map findings to OWASP Top 10 2025`

Modes: **AUDIT** (report only, default) · **FIX** (report + patch) · **RETEST**
(verify previous findings on staging).

> Authorized testing only. Dynamic tests assume a staging Moodle you own or have
> written permission to test. Never point the DAST playbook at systems you don't
> control.

## What it checks

| ID | Gate | OWASP 2025 |
|---|---|---|
| M002 | No `$_GET/$_POST/$_REQUEST/$_COOKIE` — `required/optional_param` with most-specific `PARAM_*` | A05 |
| M003 | SQL via `?`/`:named` placeholders or DML API, no concat | A05 (CWE-89) |
| M004 | `require_login` / `require_course_login` on entry scripts | A01, A07 |
| M005/M006 | `has_capability` gates UI, `require_capability` gates the action | A01 (CWE-862/863) |
| M007 | `require_sesskey` / `confirm_sesskey` / Form API on state changes | A01 (CWE-352) |
| M008 | No `eval/unserialize/call_user_func/exec/shell_exec/system` on user data | A05, A08 |
| M009/M010 | Form API + `setType()`; GET reads, POST mutates | A05, A06 |
| M011 | Sesskey never in URL bar, Referer, logs, or `pluginfile.php` | A01 |
| M012–M014 | Supported deps, no bundled core libs (jQuery), fresh `thirdpartylibs.xml` | A02, A03 |
| M015 | No passwords/keys/tokens in code, comments, or logs | A04 |

Plus Moodle-semantic gates: `PARAM_RAW` → sink escalation, `format_text`
`noclean` behind `RISK_XSS`, `setType()` completeness, record-ownership/IDOR,
web-service `PARAM_*` + capability checks, cross-DB compat, event logging
(A09), exception handling without path/SQL leaks (A10).

Full normative text: [`references/moodle-checklist-001-015.md`](references/moodle-checklist-001-015.md).
OWASP mapping: [`references/owasp-2025-moodle-map.md`](references/owasp-2025-moodle-map.md).

## How it works

```
Scope → SAST (rg suite) → Moodle semantics → DAST guidance → CVSS severity → Fix → Report
```

1. **Scope** — reads `version.php` (frankenstyle component, requires,
   dependencies), lists entry points, external functions, AMD, templates.
2. **SAST** — runs every pattern in [`references/grep-patterns.md`](references/grep-patterns.md),
   triages TP/FP with one-line reasons.
3. **Semantics** — PARAM specificity, output escaping (`s()/format_text()`),
   sesskey/GET-vs-POST, capability chains, supply chain, secrets.
4. **DAST** — per-finding manual cases T1–T8 in [`references/dast-playbook.md`](references/dast-playbook.md)
   (Burp/ZAP/sqlmap, attacker vs victim roles). Results recorded as
   `PASS / FAIL / needs-live-confirmation` — never invented.
5. **Report + patch** — exactly per [`references/report-template.md`](references/report-template.md):
   executive summary, M001–M015 ⬜/✅/❌ table, findings with
   severity/CVSS/OWASP/CWE/evidence/PoC/impact/fix-diff/retest, DAST table,
   supply-chain + secrets verdict. FIX mode applies minimal diffs, then re-greps.

Example — SQLi (see [`examples/`](examples/)):

```php
// VULNERABLE
$id = $_GET['id'];
$rec = $DB->get_record_sql("SELECT * FROM {local_x} WHERE id = $id");

// FIXED
$id = required_param('id', PARAM_INT);
$rec = $DB->get_record('local_x', ['id' => $id], '*', MUST_EXIST);
```

## Install

From the repo root (symlinks every `skills/*` into `~/.claude/skills/` for both
tools):

```bash
./install.sh
./install.sh --list     # preview
./install.sh --dry-run  # no changes
```

- **opencode:** restart opencode (skills load at startup), verify with `/skills`.
- **Claude Code:** picked up live, verify with `/skills`.

Validate (also runs in CI):

```bash
bash scripts/validate.sh
```

## Use

In opencode or Claude Code, from any project:

```text
audit my moodle plugin at ./local_myplugin
```

```text
run M001-M015 on skills/moodle-plugin-sec-audit/examples, AUDIT mode,
map to OWASP 2025, CVSS-score each finding
```

```text
FIX mode: patch the confirmed High findings with Moodle-idiomatic diffs,
keep cross-DB compat, then re-run the rg suite
```

Expected output ends with:

```text
Overall: PASS / FAIL (N critical, N high) + top-3 fixes to ship first
```

## Layout

```text
skills/moodle-plugin-sec-audit/
├── SKILL.md                      # agent instructions (spec entry point)
├── README.md                     # this file (humans)
├── references/
│   ├── moodle-checklist-001-015.md
│   ├── owasp-2025-moodle-map.md
│   ├── grep-patterns.md
│   ├── dast-playbook.md
│   └── report-template.md
└── examples/
    ├── vulnerable.php
    └── fixed.php
```

## Sources

- OWASP Top 10 2025 (EN): <https://github.com/OWASP/Top10/tree/master/2025/docs/en>
- Moodle Security guidelines (Policies → Security) and Plugin contribution checklist → Security.
- Moodle DML, Form API, output functions (`s/format_string/format_text/data_for_js`).

## License

[MIT](../../LICENSE). Authorized-testing-only; you are responsible for ensuring
you have permission to test any system you point this skill at.
