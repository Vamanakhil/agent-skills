# Final audit report template (must follow exactly)

# Moodle Plugin Security Audit — <plugintype_pluginname> <version>
Date: <YYYY-MM-DD> | Moodle target: <e.g. 4.4+> | Auditor persona: senior tester | Scope: <plugin root path> | Mode: SAST (+DAST authorized / needs-live-confirmation)

## 1. Executive summary
- Overall: **PASS / FAIL (N critical, N high, N medium, N low)**
- One paragraph: what plugin does, attack surface size, worst issue + impact.
- Top-3 fixes to ship first (numbered).

## 2. Scope & method
- `version.php`: component, requires, dependencies. Entry points audited (list). Exclusions (intentional public pages + justification).
- Method: rg SAST per `grep-patterns.md` + Moodle-semantic review + OWASP 2025 map + manual DAST per `dast-playbook.md` (authorized-only).

## 3. M001–M015 checklist
| ID | Check | Status | Evidence (file:line) |
|---|---|---|---|
| M001 | latest checklist used | ✅/❌ | this report |
| M002 | superglobals/PARAM | ✅/❌ | … |
| … | … | … | … |
| M015 | secrets | ✅/❌ | … |
No ✅ without evidence. Use ⬜ only for explicitly out-of-scope with reason.

## 4. Findings (one block per finding, highest severity first)
### F-001 <title> — <Critical|High|Medium|Low|Info> (CVSS:3.1 <vector> <score>)
- OWASP: <A0X:2025 …> | CWE: <CWE-…> | M-ID: <M00X>
- Location: `path/to/file.php:123` (+ sink `file.php:140` if chained)
- Evidence:
```php
<3–8 line snippet>
```
- Exploit/PoC: <attacker role, request steps, Burp/sqlmap payload — or `needs-live-confirmation`>
- Impact: <confidentiality/integrity/availability in Moodle terms, e.g. student deletes other course data>
- Fix (prod-ready Moodle-idiomatic diff):
```php
<before → after, minimal diff>
```
- Retest: <exact grep or DAST step proving closure>
- Status: `open / fixed / risk-accepted`

## 5. DAST results table
| Test | Case | Role | Expected | Observed | Verdict |
|---|---|---|---|---|---|
| T3 | CSRF without sesskey | student | 403/no-op | … | PASS/FAIL/needs-live-confirmation |

## 6. Supply-chain & secrets verdict
- Vendored libs table: lib | version | latest | CVE | action (remove/update/keep+justify).
- Secrets scan: files checked, hits redacted `***REDACTED***`, storage fix (`get_config` admin setting).

## 7. Re-test checklist (for next run)
- [ ] `rg` Phase-1 suite clean on touched files
- [ ] `phpcs --standard=moodle` clean on touched files
- [ ] DAST T1–T8 re-run on staging as admin/teacher/student/guest
- [ ] `thirdpartylibs.xml` + `version.php` bumped

Overall: **PASS / FAIL (…)**. If FAIL, list must-fix before release (all Critical+High).
