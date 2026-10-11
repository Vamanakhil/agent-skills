# DAST / pentest playbook — AUTHORIZED TESTING ONLY

Only run against a Moodle instance and data you own or have explicit written permission to test. Stop on production data; use staging + test accounts (admin, teacher, student, guest).

## Setup
- Deploy plugin on staging Moodle (debug OFF to match prod, then ON for a second pass to catch path leaks).
- Create users: `admin1, teacher1 (course A), student1 (course A), student2 (course B), guest`.
- Proxy via Burp/ZAP; keep two browsers (victim=admin, attacker=student).

## T1. Auth bypass / force-browse (M004, A01/A07)
1. As anonymous: `curl -i '<page.php?id=X>'` and each `ajax/*.php`, `classes/external` endpoint. Expect redirect to login. 200 with data = FAIL.
2. As student2: open course-A-only URL from plugin. Expect 403. 200 = IDOR/BOLA FAIL.

## T2. IDOR / ownership (M006, A01)
Change `id`, `userid`, `cmid`, `courseid` to another user's record. Valid cases: `view.php?id=<other>`, `delete.php?id=<other>`, WS `mod_x_delete_entry(entryid=<other>)`. Expect 403/“not found”. Other user's data shown/modified = FAIL.

## T3. CSRF / sesskey (M007/M011, A01 CWE-352)
1. Replay state-changing request with `sesskey` removed/altered → must fail.
2. Replay as attacker with victim's other params but attacker sesskey → must fail.
3. Craft external HTML auto-POST without sesskey; lure test victim account → must NOT execute.
4. If sesskey appears in URL bar after action, or in Referer to external domain (check Burp), or on `pluginfile.php` → M011 FAIL (convert to POST).

## T4. SQLi (M003, A05 CWE-89) — blur manual + sqlmap confirm
Payloads per param: `'`, `"`, `' OR '1'='1`, `1 AND SLEEP(3)-- -`, `1;SELECT pg_sleep(3)--`. Watch time/errors/DML diffs. Then (authorized): `sqlmap -u 'https://staging/mod/x/view.php?id=1' --batch --dbs --level 2 --risk 1 --cookie='<student>'`. Any extra rows/errors/time-delta = FAIL.

## T5. XSS stored/reflected/DOM (M002/M009, A05 CWE-79)
Submit `<script>alert(1)</script>`, `"'><img src=x onerror=alert(1)>`, `javascript:alert(1)`, SVG/iframe variants into every text field + URL param reflected in page. Check stored view as admin AND student. Inspect whether output uses `s()/format_text`. Alert fires or JS executes = FAIL. Also check `amd/src/*.js` for `innerHTML = userData` / `document.write`.

## T6. CMDI / LFI (M008, A05/A08)
If plugin shells out or includes files: try `;id|`, `$(id)`, `../../config.php`, `php://filter/convert.base64-encode/resource=index`. Command output or file content = FAIL. Code must use `escapeshellarg` or remove shell; includes must be allowlisted.

## T7. Method tampering (M010)
Send state-changing GET (`delete=1`) via link/img load — must NOT mutate. Mutates on GET = FAIL. Repeat with POST minus sesskey — must NOT mutate.

## T8. Secrets/config leak (M015, A02/A04)
View-source + Burp history for `sk-`, `password=`, stack traces with `/var/www/...`, `phpinfo`, `$CFG->dbpass`. Any hit = FAIL. Confirm `thirdpartylibs.xml` versions: `npx -y retire` / `npm audit`-style check on vendored JS, plus CVE search for vendored PHP libs.

Record per test: `PASS/FAIL`, request (redacted cookies), response code/length, accounts used. Mark untestable as `needs-live-confirmation` — never invent a result.
