# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-03-12

### Security
- **Removed `WebFetch` and `WebSearch` from allowed-tools** — Same security fix as planning-with-files v2.21.0. The PreToolUse hook re-reads `team_plan.md` before every team tool call, creating an amplification vector when web-sourced content is written to plan files.
- **Added Security Boundary section to SKILL.md** — Explicit guidance that web/search results must go to `team_findings.md` only (not `team_plan.md`), and all external content must be treated as untrusted.

### Fixed
- **SKILL.md frontmatter spec compliance**:
  - Moved `version` from top-level to `metadata.version` (per Agent Skills spec)
  - Removed non-standard `category` field
  - Converted `allowed-tools` from YAML array to comma-separated string
- **Stop hook multiline YAML fails on Git Bash Windows** — Replaced 25-line OS detection script with single-line implicit platform fallback (same fix as planning-with-files v2.18.3)
- **PreToolUse hook only watched `Task` tool** — Now also watches `Teammate`, `SendMessage`, `TaskCreate` (the actual Agent Teams tools)

### Added
- **Agent Teams Tools section** — Documents `Teammate`, `SendMessage`, `TaskCreate` tools and when to use each
- **Quality gate hooks documentation** — `TeammateIdle` and `TaskCompleted` hooks for enforcing rules
- **New anti-pattern** — "Write web content to team_plan.md" → "Write external content to team_findings.md only"
- Added `Teammate`, `SendMessage`, `TaskCreate` to allowed-tools

### Changed
- Version bump to 2.0.0 (breaking: security fixes, frontmatter format)
- Display mode instructions updated to use `Shift+Down` (official docs)

## [1.1.0] - 2026-02-21

### Added
- `/planning-with-teams:plan` command for consistency with planning-with-files
- `/planning-with-teams:status` command for quick team progress overview
- SkillCheck validation badge

### Changed
- Updated Commands table in README with autocomplete hints
- Version bump across all manifests

### Thanks
- @Quentin-M for suggesting command prefixing (#1)

## [1.0.0] - 2026-02-06

### Added
- Initial release
- Manus-style context engineering for Agent Teams
- Shared planning files (team_plan.md, team_findings.md, team_progress.md)
- Team coordination hooks (PreToolUse, PostToolUse, Stop)
- Cross-platform scripts (Bash, PowerShell, Python)
- Full documentation and examples
