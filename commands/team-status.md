---
description: "Get comprehensive status report for the current agent team. Shows phase progress, findings, and recommendations."
---

Provide a comprehensive status report for the current team planning session.

## What to Report

1. **Read all planning files:**
   - team_plan.md — Phase status
   - team_findings.md — Discoveries
   - team_progress.md — Activity log

2. **Summarize:**
   - Overall progress (X/Y phases complete)
   - Active teammates and their status
   - Key findings so far
   - Any blockers or open questions

3. **Recommend next actions:**
   - Which phases need attention
   - Questions that need answers
   - Whether ready to synthesize

## Output Format

```
📋 TEAM STATUS: [Task Name]

📊 PHASE PROGRESS:
   ✅ Complete:    X/Y
   🔄 In Progress: X/Y
   ⏳ Pending:     X/Y

👥 TEAMMATES:
   • [name]: [current phase] - [status]
   • [name]: [current phase] - [status]

📝 KEY FINDINGS:
   • [finding 1]
   • [finding 2]

🚫 BLOCKERS:
   • [blocker if any]

💡 RECOMMENDATIONS:
   • [next action]
```

## Alternative: Run Script

For detailed analysis, run:
```bash
python ${CLAUDE_PLUGIN_ROOT}/scripts/team-status.py
```
