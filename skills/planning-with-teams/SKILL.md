---
name: planning-with-teams
version: "1.0.0"
description: Manus-style context engineering for Agent Teams. Coordinate multiple Claude Code instances with shared planning files. Use when complex tasks need parallel work (code review, debugging, feature development). Requires CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1.
category:
  - development
  - automation
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - WebFetch
  - WebSearch
  - Task
hooks:
  PreToolUse:
    - matcher: "Task"
      hooks:
        - type: command
          command: "cat team_plan.md 2>/dev/null | head -50 || true"
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "echo '[planning-with-teams] File updated. Ensure teammates are notified if this affects shared context.'"
  Stop:
    - hooks:
        - type: command
          command: |
            SCRIPT_DIR="${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/planning-with-teams}/scripts"

            IS_WINDOWS=0
            if [ "${OS-}" = "Windows_NT" ]; then
              IS_WINDOWS=1
            else
              UNAME_S="$(uname -s 2>/dev/null || echo '')"
              case "$UNAME_S" in
                CYGWIN*|MINGW*|MSYS*) IS_WINDOWS=1 ;;
              esac
            fi

            if [ "$IS_WINDOWS" -eq 1 ]; then
              if command -v pwsh >/dev/null 2>&1; then
                pwsh -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-team-complete.ps1" 2>/dev/null ||
                powershell -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-team-complete.ps1" 2>/dev/null ||
                sh "$SCRIPT_DIR/check-team-complete.sh"
              else
                powershell -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-team-complete.ps1" 2>/dev/null ||
                sh "$SCRIPT_DIR/check-team-complete.sh"
              fi
            else
              sh "$SCRIPT_DIR/check-team-complete.sh"
            fi
---

# Planning with Teams

Manus-style context engineering for Claude Code Agent Teams. Coordinate multiple Claude instances with shared planning files, structured task assignment, and persistent working memory.

## Prerequisites

**Agent Teams must be enabled:**
```bash
# In your shell or settings.json
CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

Without this, Claude cannot spawn teammates. The skill will fall back to subagent mode.

## The Core Insight

Agent Teams give each teammate their own context window. But without coordination:
- Teammates forget the overall goal
- Findings get lost between agents
- Work gets duplicated or conflicts

**Solution:** Apply Manus principles to multi-agent coordination.

```
Single Agent:     Context Window = RAM (volatile)
                  Filesystem = Disk (persistent)

Agent Team:       Each Agent = Separate RAM
                  Shared Files = Shared Disk

→ Shared planning files become the team's "collective memory"
```

## Quick Start

Before ANY team-based task:

1. **Create `team_plan.md`** — Shared roadmap all teammates reference
2. **Create `team_findings.md`** — Shared discovery log
3. **Create `team_progress.md`** — Shared session log
4. **Spawn team with clear roles** — Each teammate owns specific phases
5. **Teammates re-read plan before decisions** — Keeps everyone aligned

> **Critical:** All files go in YOUR PROJECT directory, not the skill folder.

## File Locations

| Location | What Goes There |
|----------|-----------------|
| Skill directory (`${CLAUDE_PLUGIN_ROOT}/`) | Templates, scripts, reference docs |
| Your project directory | `team_plan.md`, `team_findings.md`, `team_progress.md` |
| `~/.claude/teams/{team-name}/` | Anthropic's team config (auto-managed) |
| `~/.claude/tasks/{team-name}/` | Anthropic's shared task list (auto-managed) |

## The Team Coordination Pattern

### Phase 1: Team Lead Creates Plan

Before spawning teammates, the lead creates the shared planning files:

```bash
# Create team_plan.md with phases assigned to teammates
Write team_plan.md

# Create empty findings and progress files
Write team_findings.md
Write team_progress.md
```

### Phase 2: Spawn Team with Clear Roles

```
Create an agent team for [TASK]:

Teammate 1 (researcher):
- Owns Phase 1: Discovery and requirements
- Writes findings to team_findings.md
- Model: haiku (fast, cheap for research)

Teammate 2 (implementer):
- Owns Phase 2-3: Design and implementation
- Reads team_findings.md before starting
- Model: sonnet (balanced)

Teammate 3 (reviewer):
- Owns Phase 4: Testing and verification
- Challenges findings, looks for issues
- Model: sonnet (needs reasoning)
```

### Phase 3: Teammates Follow Manus Rules

Each teammate MUST:

1. **Read team_plan.md before major decisions** — Re-orients to team goal
2. **Write discoveries to team_findings.md** — Shared knowledge
3. **Update team_progress.md after actions** — Visibility for lead
4. **Apply 3-Strike Error Protocol** — Log failures, don't repeat
5. **Message lead when phase complete** — Coordination

### Phase 4: Lead Synthesizes

When teammates finish:
1. Read all shared files
2. Synthesize findings
3. Resolve any conflicts
4. Deliver final result

## Team Roles

| Role | Responsibility | When to Use |
|------|----------------|-------------|
| **Lead** | Coordinates, synthesizes, owns team_plan.md | Always needed |
| **Researcher** | Explores, gathers context, documents findings | Research-heavy tasks |
| **Implementer** | Writes code, creates deliverables | Feature development |
| **Reviewer** | Tests, validates, challenges assumptions | Quality-critical work |
| **Devil's Advocate** | Questions decisions, finds edge cases | Complex design tasks |

## Critical Rules

### Rule 1: Shared Files Are Sacred

All teammates read from and write to the SAME files:
- `team_plan.md` — Single source of truth for phases
- `team_findings.md` — All discoveries go here
- `team_progress.md` — All activity logged here

### Rule 2: Re-Read Before Decide

Each teammate re-reads `team_plan.md` before major decisions:
```
[Teammate has done many tool calls...]
[Original team goal may be forgotten...]

→ Read team_plan.md     # Goal refreshed in attention!
→ Now make decision     # Aligned with team objective
```

### Rule 3: Write Findings Immediately

After ANY discovery (code found, error hit, decision made):
```bash
Edit team_findings.md   # Add finding immediately
```

Don't wait. Context is volatile. Disk is persistent.

### Rule 4: The 2-Action Rule (Per Teammate)

> "After every 2 view/browser/search operations, IMMEDIATELY save findings."

This applies to EACH teammate individually.

### Rule 5: No Duplicate Work

Before starting work, teammates check team_findings.md:
```bash
Read team_findings.md   # Has someone already found this?
```

### Rule 6: Message on Phase Complete

When a teammate finishes their phase:
```
Message lead: "Phase X complete. Key findings in team_findings.md section Y.
Ready for Phase X+1 or need review."
```

## Team Plan Structure

```markdown
# Team Plan: [Task Description]

## Goal
[One sentence — the north star for ALL teammates]

## Team Composition
| Teammate | Role | Phases Owned | Model |
|----------|------|--------------|-------|
| Lead | Coordinator | Synthesis | inherit |
| Agent-1 | Researcher | 1 | haiku |
| Agent-2 | Implementer | 2, 3 | sonnet |
| Agent-3 | Reviewer | 4 | sonnet |

## Current Status
- Phase 1: complete (Agent-1)
- Phase 2: in_progress (Agent-2)
- Phase 3: pending
- Phase 4: pending

## Phases

### Phase 1: Discovery [Agent-1]
- [ ] Research existing code
- [ ] Document patterns found
- [ ] Identify constraints
- **Status:** complete
- **Findings:** See team_findings.md#discovery

### Phase 2: Design [Agent-2]
- [ ] Review Phase 1 findings
- [ ] Create implementation plan
- [ ] Get lead approval if needed
- **Status:** in_progress
```

## When to Use Agent Teams

**Use teams for:**
- Parallel code review (security + performance + tests)
- Research with competing hypotheses
- Feature development (frontend + backend + tests)
- Large refactoring (multiple modules)
- Cross-layer changes

**Don't use teams for:**
- Simple single-file edits
- Sequential dependent work
- Tasks under 5 tool calls
- Same-file modifications (conflict risk)

## Display Modes

Set in your Claude Code settings:

| Mode | How | Best For |
|------|-----|----------|
| **in-process** | `--teammate-mode in-process` | Any terminal, default |
| **split-panes** | `--teammate-mode tmux` | tmux/iTerm2, visual monitoring |

In-process: Use `Shift+Up/Down` to select teammates, `Ctrl+T` for task list.

## The 3-Strike Protocol (Team Version)

```
STRIKE 1: Teammate diagnoses & fixes
  → Log error to team_findings.md
  → Try alternative approach

STRIKE 2: Teammate tries different method
  → Update team_findings.md with attempt
  → If still failing, message lead

STRIKE 3: Escalate to lead
  → Lead reviews team_findings.md
  → Lead may reassign or intervene

AFTER 3 STRIKES: Lead escalates to user
  → Explain team's attempts
  → Share specific blockers
  → Ask for guidance
```

## Anti-Patterns

| Don't | Do Instead |
|-------|------------|
| Let teammates work in isolation | Require shared file updates |
| Give vague teammate instructions | Assign specific phases with clear deliverables |
| Skip the planning phase | Always create team_plan.md first |
| Have teammates edit same files | Assign file ownership to avoid conflicts |
| Run many teammates for simple tasks | Use single agent or subagents |
| Forget to clean up team | Always cleanup when done |

## Templates

Copy these to start:
- [templates/team_plan.md](templates/team_plan.md) — Team phase tracking
- [templates/team_findings.md](templates/team_findings.md) — Shared discoveries
- [templates/team_progress.md](templates/team_progress.md) — Session logging

## Scripts

- `scripts/check-team-complete.sh` — Verify all phases complete
- `scripts/check-team-complete.ps1` — Windows version
- `scripts/team-status.py` — Get team status summary

## Advanced Topics

- **Manus Principles:** See [reference.md](reference.md)
- **Real Examples:** See [examples.md](examples.md)

## Cleanup

When finished, always clean up the team:

```
Clean up the team
```

This removes team resources. Shut down teammates first if any are still running.
