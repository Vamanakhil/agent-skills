<?php
// EXAMPLE — VULNERABLE. Do not ship. Used by the skill for demo/training.
// Plugin: local_x (fictional). Each block is intentionally bad.

defined('MOODLE_INTERNAL') || die();

// M002+M003: superglobal + SQL concat (A05:2025, CWE-89).
$id = $_GET['id'];
$rec = $DB->get_record_sql("SELECT * FROM {local_x} WHERE id = $id");

// M004+M006+M007+M010: anon GET deletes, no login/capability/sesskey (A01:2025).
if (optional_param('delete', 0, PARAM_INT)) {
    $DB->delete_records('local_x', ['id' => $id]);
}

// XSS: raw echo of user data (A05:2025, CWE-79).
echo $rec->name;

// CMDI: shell with user data (A05:2025, CWE-78).
$domain = $_POST['domain'];
exec('nslookup ' . $domain, $out);

// LFI: include from user input (A05:2025, CWE-98).
$page = $_GET['page'];
include($CFG->dirroot . '/local/x/pages/' . $page . '.php');

// M015: secret in code (A04:2025, CWE-798).
$apikey = 'sk-live-REPLACE-ME';
