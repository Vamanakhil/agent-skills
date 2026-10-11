<?php
// EXAMPLE — FIXED. Moodle-idiomatic, cross-DB-safe companion to vulnerable.php.
// Plugin: local_x (fictional).

defined('MOODLE_INTERNAL') || die();

// M002+M003 FIXED: typed param + DML API (no SQL concat).
$id = required_param('id', PARAM_INT);
$rec = $DB->get_record('local_x', ['id' => $id], '*', MUST_EXIST);

// M004+M006+M007+M010 FIXED: login + capability + POST + sesskey.
require_login($course, false, $cm);
$context = context_module::instance($cm->id);
require_capability('local/x:delete', $context);
if (data_submitted() && confirm_sesskey()) {
    $delete = optional_param('delete', 0, PARAM_INT);
    if ($delete) {
        $DB->delete_records('local_x', ['id' => $delete]);
    }
}

// XSS FIXED: plain text escaped; rich content would use format_text().
echo s($rec->name);

// CMDI FIXED: avoid shell; if unavoidable, escape.
// Prefer a PHP library (e.g. core checkdnsrr / curl) over exec().
$domain = optional_param('domain', '', PARAM_HOST);
if ($domain !== '') {
    $cmd = 'nslookup ' . escapeshellarg($domain);
    exec($cmd, $out);
}

// LFI FIXED: allowlist, never include user input directly.
$allowed = ['overview' => 'overview.php', 'stats' => 'stats.php'];
$page = optional_param('page', 'overview', PARAM_ALPHA);
require($CFG->dirroot . '/local/x/pages/' . $allowed[$page]);

// M015 FIXED: secret from admin settings, never in code.
// Set via settings.php: $settings->add(new admin_setting_configpasswordunmask(...)).
$apikey = get_config('local_x', 'apikey');
