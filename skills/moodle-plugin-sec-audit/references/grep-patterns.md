# SAST grep patterns — run from plugin root with rg

Run all; triage TP/FP. Keep the exact `file:line:snippet`.

## 1. Superglobals (M002)
```
rg -n --no-heading '\$_(GET|POST|REQUEST|COOKIE|FILES|SERVER|SESSION)\b' -g '*.php'
rg -n --no-heading 'optional_param|required_param|optional_param_array|required_param_array' -g '*.php'
```
Flag every superglobal hit; verify the companion `required/optional_param` uses most-specific `PARAM_INT|PARAM_ALPHA|PARAM_ALPHANUM|PARAM_URL|PARAM_EMAIL|PARAM_USERNAME|PARAM_TEXT|PARAM_BOOL` (not `PARAM_RAW`/`PARAM_CLEANHTML` by default).

## 2. SQL injection (M003)
```
rg -n --no-heading 'get_record_sql|get_records_sql|execute\(|get_fieldset_sql' -g '*.php'
rg -n --no-heading '"SELECT.*\$|\x27\s*\.\s*\$|\.\s*\$_(GET|POST)' -g '*.php'
rg -n --no-heading '\$DB->(get_record|get_records|get_field|count_records|delete_records|update_record|insert_record)\b' -g '*.php'
```
TP = SQL string contains `$var` / concatenation. FP = `get_record_sql($sql, $params)` with `?`/`:named` + params array.

## 3. Auth / capability / sesskey (M004–M007)
```
rg -n --no-heading 'require_login|require_course_login' -g '*.php'
rg -n --no-heading 'has_capability|require_capability' -g '*.php' db/access.php classes -g '*.php'
rg -n --no-heading 'require_sesskey|confirm_sesskey|sesskey\(\)|data_submitted' -g '*.php'
rg -n --no-heading 'delete_records|update_record|insert_record|set_field|execute\(' -g '*.php'
```
For each top-level script + each `external_*::execute`, assert login→capability→sesskey chain present before write.

## 4. Dangerous sinks (M008)
```
rg -n --no-heading 'eval\s*\(|assert\s*\(|create_function|call_user_func(_array)?|unserialize\s*\(|preg_replace\s*\(.*\/e|exec\s*\(|shell_exec|system\s*\(|passthru|proc_open|popen\b' -g '*.php'
rg -n --no-heading 'include(_once)?\s*\(?\s*\$|require(_once)?\s*\(?\s*\$' -g '*.php'
rg -n --no-heading 'escapeshellarg|escapeshellcmd' -g '*.php'
```

## 5. XSS sinks (M002/M009)
```
rg -n --no-heading 'echo\s+\$|print\s+\$|\{\{\{?.*user' -g '*.php' -g '*.mustache'
rg -n --no-heading '\bs\(|\bp\(|format_string|format_text|data_for_js|js_function_call|json_encode' -g '*.php'
rg -n --no-heading '<script.*\$|innerHTML|document\.write|outerHTML' -g '*.php' -g '*.js'
```
TP = user-tainted var echoed without `s()/format_*`, or PHP var interpolated into `<script>`/JS string.

## 6. GET-mutates + sesskey leak (M010/M011)
```
rg -n --no-heading "optional_param\('(?:delete|action|confirm|do)'|required_param\('(?:delete|action)'" -g '*.php'
rg -n --no-heading 'sesskey' -g '*.php' -g '*.js' -g '*.mustache'
rg -n --no-heading 'pluginfile' -g '*.php'
```
TP = `$_GET`/GET param triggers write; sesskey inside `moodle_url` for a rendered GET page or `pluginfile` URL.

## 7. Secrets (M015)
```
rg -n --no-heading -i 'password|passwd|pwd\s*=|secret|api[_-]?key|auth[_-]?token|private[_-]?key|sk-live|Bearer\s+[A-Za-z0-9]' -g '*.php' -g '*.js' -g '*.md'
rg -n --no-heading '\.pem|\.key\b|id_rsa' -g '*'
```
TP = literal credential; FP = `get_config('...')` / lang string saying "enter your API key".

## 8. Supply chain (M012–M014)
```
rg -n --no-heading 'jquery|bootstrap(\.min)?\.js' -g '*' --files-with-matches
cat thirdpartylibs.xml 2>/dev/null; rg -n 'requires|dependencies' version.php
```
TP = vendored copy of core-shipped lib, or lib >12mo old / CVE-listed.

## 9. Capability + privacy + misc
```
cat db/access.php 2>/dev/null; rg -n 'RISK_|capabilities' db/access.php classes -g '*.php'
rg -n --no-heading 'add_to_log|::create\(\[|->trigger\(\)' -g '*.php'
rg -n --no-heading 'print_error|debugging\(|var_dump|print_r\(\$|phpinfo|display_errors' -g '*.php'
```
