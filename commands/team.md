---
description: "Start Manus-style team planning. Creates shared planning files and guides team setup for parallel work."
---

Invoke the planning-with-teams:planning-with-teams skill and follow it exactly.

## Prerequisite Check

First, verify Agent Teams is enabled:
```bash
echo $CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS
```

If not set to `1`, inform the user:
> Agent Teams requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in your environment or settings.json.
> Without this, I'll use subagents instead (less coordination capability).

## Setup Steps

1. **Create the three shared planning files** in the current project directory:
   - `team_plan.md` — Shared roadmap for all teammates
   - `team_findings.md` — Shared discovery log
   - `team_progress.md` — Shared session log

2. **Guide the user through team planning:**
   - Ask what task they want to accomplish
   - Suggest appropriate team composition
   - Define phases and assign to teammates
   - Clarify file ownership to avoid conflicts

3. **Once plan is ready, offer to spawn the team:**
   - Create teammates with clear roles
   - Give each teammate their assigned phases
   - Instruct teammates to follow Manus principles

## Key Principles to Follow

- All teammates must read `team_plan.md` before major decisions
- All discoveries go to `team_findings.md` immediately
- Log all activity to `team_progress.md`
- Apply 3-Strike Error Protocol (log failures, don't repeat)
- Message lead when phases complete
