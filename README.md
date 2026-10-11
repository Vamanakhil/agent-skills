<div align="center">

# agent-skills

**Portable Agent Skills for opencode & Claude Code**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![opencode](https://img.shields.io/badge/opencode-compatible-000000.svg?logo=opencode)](https://opencode.ai)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-D97757.svg?logo=anthropic)](https://claude.com/claude-code)
[![CI](https://github.com/Vamanakhil/agent-skills/actions/workflows/validate.yml/badge.svg)](https://github.com/Vamanakhil/agent-skills/actions/workflows/validate.yml)

One source of truth for reusable skills, installable globally so every project
gains them in **both** opencode and Claude Code.

</div>

---

## What is this?

A collection of high-quality [Agent Skills](https://agentskills.io) — folders
with a `SKILL.md` that teach coding agents how to do a specific job well.
Skills live in `skills/`, are validated in CI, and install with one command.

Every skill follows the open Agent Skills spec, so a single skill works across
tools. Installing creates a **symlink** in `~/.claude/skills/`, which both
opencode and Claude Code load globally — on every project.

## Skills

| Skill | Description |
|---|---|
| [klean](skills/klean/SKILL.md) | **Website Quality Engineer.** Review, design, and production-harden websites so they feel intentional, product-specific, accessible, fast, trustworthy, and secure — not statistically generic AI-generated UI. |
| [moodle-plugin-sec-audit](skills/moodle-plugin-sec-audit/SKILL.md) | **Moodle Plugin Security Audit + VAPT.** Senior-tester audit of Moodle plugins against M001–M015 and OWASP Top 10 2025, with evidence-backed report and prod-ready fixes. |

## Install

**One-liner (recommended):**

```bash
curl -fsSL https://raw.githubusercontent.com/Vamanakhil/agent-skills/main/install-remote.sh | bash
```

That's it. It clones the repo (or updates it if you already have it) and
symlinks every skill into `~/.claude/skills/`.

What it does:

- Symlinks every `skills/*` folder into `~/.claude/skills/`
- **opencode:** restart opencode (skills load at startup)
- **Claude Code:** picks skills up live, no restart needed

Verify with opencode's `/skills` or Claude Code's `/skills` — you should see
`klean` and `moodle-plugin-sec-audit` listed.

> Want it installed somewhere else? Set `AGENT_SKILLS_DIR`:
> `AGENT_SKILLS_DIR=~/.agent-skills curl -fsSL <url> | bash`

### Alternative: clone & run

```bash
git clone git@github.com:Vamanakhil/agent-skills.git
cd agent-skills
./install.sh
```

### Installer options

```bash
./install.sh --list      # show skills that would be installed
./install.sh --dry-run   # preview without changing anything
./install.sh --verbose   # print each link as it is created
```

### Uninstall

```bash
./uninstall.sh
```

Removes only symlinks pointing back into this repo — never touches the source
or your other skills.

## Add a skill

1. Copy the scaffold: `cp -r template skills/my-skill`
2. Edit `skills/my-skill/SKILL.md`
   - `name` (lowercase, hyphen-separated) **must match the folder name**
   - `description` should front-load the trigger keywords (e.g. "Use when ...")
3. Run `bash scripts/validate.sh` — this runs in CI too, so keep it green
4. `./install.sh` and commit

## Validation

`scripts/validate.sh` checks every skill:

- `SKILL.md` exists in each `skills/*/` folder
- frontmatter `name` matches the folder name
- `name` matches `^[a-z0-9]+(-[a-z0-9]+)*$` (the Agent Skills spec)
- a trigger-forward `description` is present

Runs automatically on GitHub Actions and GitLab CI.

## License

[MIT](LICENSE) © 2026 Vaman Akhil

## Roadmap

- [ ] More skills (git-workflow, code-review, release-notes, testing)
- [x] `moodle-plugin-sec-audit` — Moodle plugin security audit + VAPT (M001–M015, OWASP 2025)
- [ ] Versioned releases + changelog automation
- [ ] `skills.urls` hosting for remote loading in opencode
- [ ] Claude Code plugin packaging (`/plugin` installable)