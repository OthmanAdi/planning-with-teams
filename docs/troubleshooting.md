# Troubleshooting

## Common Issues

### Agent Teams Not Working

**Symptom:** Claude falls back to subagents or says Agent Teams is not available.

**Solution:**
1. Verify `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set
2. Restart Claude Code after setting
3. Check Claude Code version is 2.1.32+

```bash
# Check environment variable
echo $CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS

# Check Claude Code version
claude --version
```

### Teammates Not Seeing Shared Files

**Symptom:** Teammates report they can't find `team_plan.md` or `team_findings.md`.

**Solution:**
1. Ensure files are in the project root, not the skill directory
2. Give teammates the full path when spawning
3. Have teammates run `ls` to verify they're in the right directory

### File Conflicts Between Teammates

**Symptom:** Teammates overwrite each other's changes.

**Solution:**
1. Define clear file ownership in `team_plan.md`
2. Use sections within shared files (e.g., "## Security Findings" vs "## Performance Findings")
3. Have teammates check file before writing

### Teammates Forgetting the Goal

**Symptom:** Teammates drift from the objective or duplicate work.

**Solution:**
1. Ensure teammates read `team_plan.md` before major decisions
2. Keep the goal statement clear and prominent
3. Use the 2-Action Rule: write findings after every 2 operations

### High Token Usage

**Symptom:** Agent Teams consuming too many tokens.

**Solution:**
1. Use haiku model for research-heavy teammates
2. Keep team size minimal (2-4 teammates)
3. Ensure tasks warrant parallel work (5+ tool calls per teammate)
4. Consider subagents for simpler tasks

### Teammates Not Communicating

**Symptom:** Lead doesn't know when phases complete.

**Solution:**
1. Include "Message lead when complete" in phase instructions
2. Set up clear communication expectations in team_plan.md
3. Check task list status periodically

### Split-Pane Mode Not Working

**Symptom:** Teammates don't appear in separate panes.

**Solution:**
1. Verify tmux is installed: `which tmux`
2. Or verify iTerm2 with `it2` CLI is configured
3. Use `--teammate-mode tmux` explicitly
4. Fall back to in-process mode if needed

### Scripts Not Running

**Symptom:** Hook scripts fail silently.

**Solution:**
1. Make scripts executable: `chmod +x scripts/*.sh`
2. Verify PowerShell execution policy on Windows
3. Check script path in SKILL.md frontmatter

## Getting Help

If you're still stuck:

1. Check the [examples](../skills/planning-with-teams/examples.md) for working patterns
2. Review the [reference](../skills/planning-with-teams/reference.md) for methodology
3. Open an issue on GitHub with:
   - Claude Code version
   - Error messages
   - What you tried
