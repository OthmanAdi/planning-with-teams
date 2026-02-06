---
description: "Quick spawn an agent team for a task. Creates minimal planning files and spawns teammates immediately."
---

Quick-start team spawning for users who want to jump straight into parallel work.

## Quick Setup

1. **Ask the user:** "What task do you want the team to work on?"

2. **Create minimal team_plan.md** with:
   - Goal (one sentence)
   - Team composition (2-4 teammates)
   - Phases assigned to each teammate

3. **Create empty team_findings.md and team_progress.md**

4. **Spawn the team immediately** with instructions:
   - Each teammate reads team_plan.md first
   - Each teammate writes findings to team_findings.md
   - Each teammate messages lead when phase complete

## Default Team Templates

### For Code Review:
```
Spawn 3 teammates:
- security-reviewer: Check for vulnerabilities
- perf-reviewer: Check for performance issues
- test-reviewer: Check test coverage
```

### For Bug Investigation:
```
Spawn 3-4 teammates with different hypotheses:
- Each investigates their theory
- Document evidence to team_findings.md
- Challenge each other's findings
```

### For Feature Development:
```
Spawn 2-3 teammates:
- frontend-dev: UI components
- backend-dev: API and services
- test-dev: All tests
```

## Important

Always verify `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set before spawning.
If not enabled, fall back to sequential subagent approach.
