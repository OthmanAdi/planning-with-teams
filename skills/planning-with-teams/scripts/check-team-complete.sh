#!/bin/bash
# Check if all phases in team_plan.md are complete
# Always exits 0 — uses stdout for status reporting
# Used by Stop hook to report team completion status

PLAN_FILE="${1:-team_plan.md}"

if [ ! -f "$PLAN_FILE" ]; then
    echo "[planning-with-teams] No team_plan.md found — no active team planning session."
    exit 0
fi

# Count total phases
TOTAL=$(grep -c "### Phase" "$PLAN_FILE" 2>/dev/null || echo "0")

# Check for **Status:** format first
COMPLETE=$(grep -cF "**Status:** complete" "$PLAN_FILE" 2>/dev/null || echo "0")
IN_PROGRESS=$(grep -cF "**Status:** in_progress" "$PLAN_FILE" 2>/dev/null || echo "0")
PENDING=$(grep -cF "**Status:** pending" "$PLAN_FILE" 2>/dev/null || echo "0")

# Fallback: check for [complete] inline format if **Status:** not found
if [ "$COMPLETE" -eq 0 ] && [ "$IN_PROGRESS" -eq 0 ] && [ "$PENDING" -eq 0 ]; then
    COMPLETE=$(grep -c "\[complete\]" "$PLAN_FILE" 2>/dev/null || echo "0")
    IN_PROGRESS=$(grep -c "\[in_progress\]" "$PLAN_FILE" 2>/dev/null || echo "0")
    PENDING=$(grep -c "\[pending\]" "$PLAN_FILE" 2>/dev/null || echo "0")
fi

# Count teammates mentioned
TEAMMATES=$(grep -c "| Teammate" "$PLAN_FILE" 2>/dev/null || echo "0")

# Report status
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           PLANNING WITH TEAMS - STATUS REPORT             ║"
echo "╠═══════════════════════════════════════════════════════════╣"

if [ "$COMPLETE" -eq "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
    echo "║  STATUS: ALL PHASES COMPLETE ($COMPLETE/$TOTAL)                    ║"
    echo "║                                                           ║"
    echo "║  Next steps:                                              ║"
    echo "║  1. Review team_findings.md for all discoveries           ║"
    echo "║  2. Check team_progress.md for session summary            ║"
    echo "║  3. Shut down teammates if still running                  ║"
    echo "║  4. Clean up the team                                     ║"
else
    echo "║  STATUS: TEAM IN PROGRESS                                 ║"
    echo "║                                                           ║"
    printf "║  Phases: %d complete, %d in progress, %d pending       ║\n" "$COMPLETE" "$IN_PROGRESS" "$PENDING"
    echo "║                                                           ║"
    if [ "$IN_PROGRESS" -gt 0 ]; then
        echo "║  Teammates still working on assigned phases.              ║"
    fi
    if [ "$PENDING" -gt 0 ]; then
        echo "║  Some phases not yet started.                             ║"
    fi
fi

echo "╚═══════════════════════════════════════════════════════════╝"

# Check for team_findings.md
if [ -f "team_findings.md" ]; then
    FINDINGS_COUNT=$(grep -c "^### " "team_findings.md" 2>/dev/null || echo "0")
    echo "[planning-with-teams] team_findings.md has $FINDINGS_COUNT sections."
fi

# Check for team_progress.md
if [ -f "team_progress.md" ]; then
    echo "[planning-with-teams] team_progress.md exists."
fi

exit 0
