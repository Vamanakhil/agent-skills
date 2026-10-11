# OWASP Top 10 2025 → Moodle plugin map

Upstream canonical docs: https://github.com/OWASP/Top10/tree/master/2025/docs/en (files `A01_2025-*.md` … `A10_2025-*.md`). Categories changed vs 2021 — use 2025 names below.

## A01:2025 Broken Access Control → M004/M005/M006/M007/M010/M011
Core Moodle failure. Check: `require_login`, `has_capability` (display) + `require_capability` (action), record-ownership (`$DB->get_record(..., ['id'=>..,'userid'=>$USER->id])` or capability on that context), IDOR (`accountInfo?acct=notmyacct`), force-browse (`curl` admin URL as student), missing POST/PUT/DELETE authz in `classes/external/*`, CORS `Access-Control-Allow-Origin: *`, CSRF without sesskey (CWE-352), SSRF via user URL fetched server-side. CWEs: 22/23/59/200/284/285/352/639/862/863/918.
Prevent: deny-by-default, one reusable check per entry/external fn, `context_course::instance($courseid)` correct level, log failures, rate-limit.

## A02:2025 Security Misconfiguration → M012
Debug on prod (`$CFG->debugdisplay`), verbose `debugging()/print_error` with paths, directory listing, `.git/backup` in web root, default creds, missing security headers. Check `config.php` guidance + error handling reveals only generic message to user, detail to logs.

## A03:2025 Software Supply Chain Failures → M012/M013/M014
(former Vulnerable Components, widened). Check `thirdpartylibs.xml`, bundled `thirdparty/*`, vendored jQuery/Bootstrap already in core, pinned version + known CVE, GPL-compatible license, no `composer install` required at deploy (must work out of box), `version.php dependencies`.

## A04:2025 Cryptographic Failures → M015
Secrets in code/comments (CWE-798/540/615), weak hash (`md5/sha1` for passwords — must use `password_hash`/core APIs), sensitive data over HTTP, PII in logs/URLs. Fix: admin settings via `get_config/set_config`, env/secret store, TLS-only, redact.

## A05:2025 Injection → M002/M003/M008/M009
Biggest Moodle bucket. SQLi (CWE-89): concat → placeholders/DML. XSS stored/reflected/DOM (CWE-79/80/83): `s/format_string/format_text/data_for_js`. Command/argument injection (CWE-77/78/88): avoid shell; else `escapeshellarg/escapeshellcmd`. LFI/RFI (CWE-98): never `include $userpath`; allowlist. EL/SSTI in Mustache/custom renderers: no user template eval. LDAP/XPath if applicable.
Test strings: `< > & ' \' 碁 \ \` + classic `' OR '1'='1`, `; cat /etc/passwd` (authorized only).

## A06:2025 Insecure Design → M009/M010 + threat model
Missing abuse cases: GET deletes, no ownership model, unlimited enrol/self-assign, missing rate limits on expensive ops. Fix: POST+Form API, business-limit checks in domain code, unit tests for authz paths.

## A07:2025 Authentication Failures → M004
Missing `require_login`, weak session handling (fixation — rely on core, invalidate on logout), no brute-force throttle on plugin login/token endpoints, exposed `pluginfile`/ajax without login check. Only deliberately-public pages (front page, public WS) exempt — must be justified.

## A08:2025 Software or Data Integrity Failures → M008/M011
`unserialize()` on user data → `json_decode`; insecure `include/require`; unsigned auto-update/plugin download; deserialization in cache; sesskey-as-integrity-token misused in GET. Use core update APIs, verify checksums, sign webhooks.

## A09:2025 Security Logging and Alerting Failures → new explicit
No event on access-control failure, no `trigger()` of `\core\event\*` / `add_to_log` equivalent, silent catch swallowing attacks, no alert on repeated 403s. Fix: `event::create([...])->trigger()`, log actor+context+IP, don't log secrets/sesskey.

## A10:2025 Mishandling of Exceptional Conditions → new 2025
Uncaught exceptions leaking paths/SQL (info leak), half-done writes with no transaction (`$DB->start_delegated_transaction`), DoS via expensive unbounded queries/imports without limits. Fix: try/catch → generic user message + detailed log, transactions, pagination/limits.
