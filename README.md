<div align="center">

# agent-skills

**Portable Agent Skills for opencode & Claude Code**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![opencode](https://img.shields.io/badge/opencode-compatible-000000.svg)](https://opencode.ai)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-D97757.svg)](https://claude.com/claude-code)
[![CI](https://github.com/Vamanakhil/agent-skills/actions/workflows/validate.yml/badge.svg)](https://github.com/Vamanakhil/agent-skills/actions/workflows/validate.yml)

The skills I actually use, kept in one place so every project gets them.

</div>

---

## What is this?

Each skill is a folder with a `SKILL.md` file that teaches a coding agent how
to do one job well. This repo collects mine. Installing symlinks every skill
into `~/.claude/skills/`, which both opencode and Claude Code read — so once
installed, the skills work in every project on the machine, with no per-project
setup.

Skills live in `skills/`. Everything is validated by `scripts/validate.sh`,
which also runs in CI on every push.

## Skills

| Skill | What it does |
|---|---|
| [klean](skills/klean/SKILL.md) | Website quality gate. Reviews, redesigns, and hardens sites for launch across design, accessibility, performance, SEO, security, and reliability. |
| [moodle-sec-audit](skills/moodle-sec-audit/SKILL.md) | Security audit and VAPT for Moodle plugins. Checks the M001–M015 checklist, maps findings to OWASP Top 10 2025, and returns an evidence-backed report with prod-ready fixes. |

## Install

**New machine, one line:**

```bash
curl -fsSL https://raw.githubusercontent.com/Vamanakhil/agent-skills/main/install-remote.sh | bash
```

That clones this repo to `~/Projects/Skills` (or `$AGENT_SKILLS_DIR` if you set
it) and runs the local installer. Afterwards:

- **opencode:** restart it (skills load at startup), then check `/skills`
- **Claude Code:** nothing to restart, check `/skills` right away

**Already cloned this repo:**

```bash
git clone git@github.com:Vamanakhil/agent-skills.git
cd agent-skills
./install.sh
```

```bash
./install.sh --list      # show what would be installed
./install.sh --dry-run   # preview without changing anything
./install.sh --verbose   # print each link as it is created
./uninstall.sh           # remove only the symlinks pointing here
```

### Which installer is which

- `install.sh` — links every `skills/*` folder into `~/.claude/skills/`. Run
  this when you already have the repo checked out.
- `install-remote.sh` — for a fresh machine. Downloads the repo, then calls
  `install.sh`. This is what the one-liner above runs.
- `uninstall.sh` — removes only symlinks pointing back into this checkout.
  Your other skills are left alone.

## Use

Once installed, just ask in any project:

```text
audit my moodle plugin at ./local_myplugin
```

```text
review this site with klean, LAUNCH mode
```

The agent matches your words against each skill's description and loads the
right one.

## Add a skill

`template/` is a starter scaffold — copy it so the new skill matches the spec
from the first line:

```bash
cp -r template skills/my-skill
```

Then edit `skills/my-skill/SKILL.md`:

- `name` must equal the folder name, lowercase with hyphens (`my-skill`)
- `description` should say when to use it, with the words you'd actually type

Then check and install:

```bash
bash scripts/validate.sh
./install.sh
```

## Validation

`scripts/validate.sh` checks every skill in `skills/`:

- a `SKILL.md` exists in each skill folder
- frontmatter `name` matches the folder name
- `name` fits `^[a-z0-9]+(-[a-z0-9]+)*$`
- a `description` is present so agents can find it

It runs on GitHub Actions for every push and pull request. Keep it green.

## Layout

```text
agent-skills/
├── README.md / LICENSE / CHANGELOG.md
├── install.sh / install-remote.sh / uninstall.sh
├── skills/            # the skills (klean, moodle-sec-audit, …)
├── template/          # starter scaffold for a new skill
├── scripts/           # validate.sh (also runs in CI)
└── .github/workflows/ # CI: validate on push + PR
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md). Notable changes land under `Unreleased`
until cut into a tagged release.

## License

[MIT](LICENSE) © 2026 Vaman Akhil

## Roadmap

- [x] `moodle-sec-audit` — Moodle plugin security audit + VAPT
- [ ] More skills (git-workflow, code-review, release-notes, testing)
- [ ] Tagged releases (`v1.x`) once the skill set settles
- [ ] Remote skill loading via opencode `skills.urls`
