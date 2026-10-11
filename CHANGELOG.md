# Changelog

All notable changes to this project are documented in this file.

## [Unreleased]

### Added

- `moodle-sec-audit` — Senior-tester Moodle plugin security audit, VAPT,
  and pentest skill (M001–M015 checklist, OWASP Top 10 2025 A01–A10 mapping,
  rg SAST suite, authorized DAST playbook T1–T8, CVSS-scored report template,
  prod-ready Moodle-idiomatic fixes, vulnerable/fixed examples).

### Changed

- Renamed the skill `moodle-plugin-sec-audit` to `moodle-sec-audit` (shorter,
  same triggers). Rewrote the root README in plain words and documented what
  each installer script is for.
- Hardened the skill stance: attacker mindset, confidence labels per finding,
  exploit-chain hunting with severity escalation, and a close-only-on-retest
  rule.

### Removed

- `.gitlab-ci.yml`. The repo lives on GitHub and its checks duplicated the
  GitHub Actions workflow. Restore it from history if a GitLab mirror ever
  needs CI.

## [1.0.0] - 2026-08-19

### Added

- `klean` — Website Quality Engineer skill (review, design, audit, and
  production-harden websites across design, accessibility, performance, SEO,
  security, reliability, and observability).
- Repo scaffolding: `install.sh`, `install-remote.sh`, `uninstall.sh`,
  `scripts/validate.sh`, `template/SKILL.md`, MIT `LICENSE`, and CI for
  GitHub Actions.