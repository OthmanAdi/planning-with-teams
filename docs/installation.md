# Installation Guide

## Prerequisites

1. **Claude Code 2.1.32+** — Agent Teams requires this version or later
2. **Agent Teams enabled** — The experimental feature must be turned on

## Step 1: Enable Agent Teams

Agent Teams is an experimental feature. Enable it before installing:

### Option A: Environment Variable

```bash
# Add to your shell profile (~/.bashrc, ~/.zshrc, etc.)
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

### Option B: Settings.json

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

Settings.json locations:
- **User:** `~/.claude/settings.json`
- **Project:** `.claude/settings.json`

## Step 2: Install the Plugin

### Option A: Via Marketplace (Recommended)

```bash
# Add the marketplace
/plugin marketplace add nibzard/planning-with-teams

# Install the plugin
/plugin install planning-with-teams
```

### Option B: Manual Clone

```bash
# Clone to plugins directory
git clone https://github.com/nibzard/planning-with-teams.git ~/.claude/plugins/planning-with-teams
```

### Option C: Copy to Skills Directory

For skill-only installation (no hooks):

```bash
# Copy to user skills
cp -r skills/planning-with-teams ~/.claude/skills/
```

## Step 3: Verify Installation

Start Claude Code and run:

```
/team
```

If installed correctly, Claude will guide you through team planning setup.

## Troubleshooting

### "Agent Teams not enabled"

Verify the environment variable is set:
```bash
echo $CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS
```

Should output `1`. If not, check your shell profile.

### "Skill not found"

Verify installation:
```bash
ls ~/.claude/plugins/planning-with-teams/
# or
ls ~/.claude/skills/planning-with-teams/
```

### "Cannot spawn teammates"

1. Ensure you're running Claude Code 2.1.32+
2. Check that Agent Teams is enabled (see above)
3. Restart Claude Code after enabling

## Uninstallation

```bash
# Remove plugin
rm -rf ~/.claude/plugins/planning-with-teams

# Or remove skill only
rm -rf ~/.claude/skills/planning-with-teams
```
