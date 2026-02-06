# Planning with Teams

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-blue)](https://code.claude.com/docs/en/plugins)
[![Agent Teams](https://img.shields.io/badge/Agent%20Teams-Enabled-blueviolet)](https://code.claude.com/docs/en/agent-teams)
[![Version](https://img.shields.io/badge/version-1.0.0-brightgreen)](https://github.com/OthmanAdi/planning-with-teams/releases)
[![Opus 4.6](https://img.shields.io/badge/Opus%204.6-Compatible-cc785c)](https://anthropic.com/news/claude-opus-4-6)
[![skillcheck passed](https://raw.githubusercontent.com/olgasafonova/skillcheck-free/main/skill-check/passed.svg)](https://getskillcheck.com)

**Manus-style context engineering for Claude Code Agent Teams.**

Coordinate multiple Claude Code instances with shared planning files, structured task assignment, and persistent working memory. The first skill to apply proven context engineering methodology to multi-agent workflows.

> Based on [planning-with-files](https://github.com/OthmanAdi/planning-with-files) methodology

---

## ⚠️ IMPORTANT: Agent Teams Must Be Enabled

<details>
<summary><strong>Click to expand - You MUST enable Agent Teams before using this skill</strong></summary>

### Why This Matters

Without Agent Teams enabled, this skill will fall back to using Task subagents. While subagents work, they **cannot** use the native Agent Teams features:
- ❌ No peer-to-peer messaging between teammates
- ❌ No Teammate, SendMessage, TaskCreate tools
- ❌ Limited to Task tool (standard subagents)

### How to Enable

**Option 1: Settings.json (Recommended)**

Add this to `~/.claude/settings.json`:
```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

**Option 2: Environment Variable**

Add to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):
```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

### Verify It's Enabled

After enabling, **restart Claude Code** and check that the skill uses "Agent Teams" mode instead of "Task subagents" mode in the team plan.

</details>

---

## Why This Exists

Claude Code's [Agent Teams](https://code.claude.com/docs/en/agent-teams) feature lets you coordinate multiple Claude instances working in parallel. But without proper coordination:

- Teammates forget the overall goal
- Findings get siloed in individual contexts
- Work gets duplicated or conflicts
- Token costs skyrocket with no benefit

**Planning with Teams** solves this by applying [Manus principles](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus) to multi-agent coordination:

```
Single Agent:     Context Window = RAM (volatile)
                  Filesystem = Disk (persistent)

Agent Team:       Each Agent = Separate RAM (isolated)
                  Shared Files = Shared Disk (accessible to ALL)

→ Shared planning files become the team's "collective memory"
```

---

## Features

- **100% Native Agent Teams** — Uses Anthropic's built-in Teammate, SendMessage, TaskCreate tools
- **Shared Planning Files** — `team_plan.md`, `team_findings.md`, `team_progress.md`
- **Manus Methodology** — Re-read before decide, log errors, 3-Strike Protocol
- **Clear Ownership** — File ownership prevents conflicts
- **Hooks Integration** — Automatic status checks on session end
- **Cross-Platform Scripts** — Bash, PowerShell, and Python utilities

---

## Quick Start

### 1. Enable Agent Teams

```bash
# In your shell
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# Or in settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

### 2. Install the Plugin

```bash
# Add marketplace
/plugin marketplace add OthmanAdi/planning-with-teams

# Install plugin
/plugin install planning-with-teams
```

Or clone manually:
```bash
git clone https://github.com/OthmanAdi/planning-with-teams.git ~/.claude/plugins/planning-with-teams
```

### 3. Use It

```
/team
```

Or describe your task:
```
Create an agent team to review PR #142 for security, performance, and test coverage.
Use planning-with-teams for coordination.
```

---

## How It Works

### The Coordination Pattern

```
┌─────────────────────────────────────────────────────────┐
│                    TEAM LEAD                             │
│         └─ Creates team_plan.md                         │
│         └─ Assigns phases to teammates                   │
│         └─ Synthesizes team_findings.md                  │
├─────────────────────────────────────────────────────────┤
│  TEAMMATE 1        TEAMMATE 2        TEAMMATE 3         │
│  (Phase 1)         (Phase 2)         (Phase 3)          │
│       │                 │                 │              │
│       └─────────────────┴─────────────────┘              │
│                         │                                │
│               SHARED PLANNING FILES                      │
│       team_plan.md | team_findings.md | team_progress    │
└─────────────────────────────────────────────────────────┘
```

### The Three Shared Files

| File | Purpose | Who Updates |
|------|---------|-------------|
| `team_plan.md` | Shared roadmap, phases, status | Lead + all teammates |
| `team_findings.md` | Discoveries, errors, decisions | All teammates |
| `team_progress.md` | Session log, activity tracking | All teammates |

### Each Teammate Follows Manus Rules

1. **Read team_plan.md before major decisions** — Re-orients to team goal
2. **Write findings immediately** — Don't wait, context is volatile
3. **Apply 3-Strike Error Protocol** — Log failures, don't repeat
4. **Message lead when phase complete** — Coordination

---

## Commands

| Command | Description |
|---------|-------------|
| `/team` | Start team planning with guided setup |
| `/spawn-team` | Quick spawn team for a task |
| `/team-status` | Get comprehensive status report |

---

## When to Use Agent Teams

**Use teams for:**
- Parallel code review (security + performance + tests)
- Research with competing hypotheses
- Feature development (frontend + backend + tests)
- Large refactoring (multiple modules)
- Debugging with multiple theories

**Don't use teams for:**
- Simple single-file edits
- Sequential dependent work
- Tasks under 5 tool calls
- Same-file modifications (conflict risk)

---

## Examples

### Parallel Code Review

```
Create an agent team to review PR #142:

Teammate 1 (security-reviewer):
- Focus on security vulnerabilities
- Write to team_findings.md under "## Security Findings"

Teammate 2 (perf-reviewer):
- Focus on performance impact
- Write to team_findings.md under "## Performance Findings"

Teammate 3 (test-reviewer):
- Focus on test coverage
- Write to team_findings.md under "## Test Coverage"
```

### Debugging with Competing Hypotheses

```
Create an agent team to investigate the connection dropout bug:

Spawn 4 investigators with different hypotheses:
1. WebSocket handling issue
2. Timeout/keepalive misconfiguration
3. State management corruption
4. Memory leak

Have them document evidence FOR and AGAINST in team_findings.md,
challenge each other's findings, and converge on root cause.
```

See [examples.md](skills/planning-with-teams/examples.md) for more.

---

## Token Economics

| Mode | Cost | When to Use |
|------|------|-------------|
| Single agent | 1x | Simple tasks |
| Subagents | 1.5-2x | Focused delegation |
| **Agent Teams** | 3-5x | Complex parallel work |

Agent Teams are expensive. Use them when parallel exploration genuinely adds value.

---

## Requirements

- Claude Code 2.1.32+
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- For split-pane mode: tmux or iTerm2

---

## Documentation

- [SKILL.md](skills/planning-with-teams/SKILL.md) — Full methodology
- [reference.md](skills/planning-with-teams/reference.md) — Manus principles adapted for teams
- [examples.md](skills/planning-with-teams/examples.md) — Real use cases

---

## Related Projects

- [planning-with-files](https://github.com/OthmanAdi/planning-with-files) — Single-agent planning (the foundation)
- [Claude Code Agent Teams Docs](https://code.claude.com/docs/en/agent-teams) — Official documentation

---

## License

MIT License - see [LICENSE](LICENSE)

---

## Author

**Ahmad Othman Ammar Adi**

- GitHub: [@OthmanAdi](https://github.com/OthmanAdi)
- Website: [othmanadi.com](https://othmanadi.com)
