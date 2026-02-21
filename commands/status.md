---
description: "Show team planning progress at a glance. Quick view of phase status, active teammates, and key findings."
---

Read the team planning files and provide a concise status summary:

1. **Read planning files:**
   - team_plan.md — Phase status and assignments
   - team_findings.md — Key discoveries
   - team_progress.md — Recent activity

2. **Output compact status:**

```
📋 TEAM STATUS: [Task Name]

Progress: X/Y phases complete
Active: [teammate names and current phases]
Findings: [count] discoveries logged
Blockers: [any blockers or "none"]

Next: [recommended action]
```

If no team planning files exist, inform the user:
> No team planning session found. Use `/planning-with-teams:plan` to start one.
