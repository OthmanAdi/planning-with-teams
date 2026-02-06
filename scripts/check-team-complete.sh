#!/bin/bash
# Check if all phases in team_plan.md are complete
# Always exits 0 — uses stdout for status reporting

PLAN_FILE="${1:-team_plan.md}"

if [ ! -f "$PLAN_FILE" ]; then
    echo "[planning-with-teams] No team_plan.md found — no active team planning session."
    exit 0
fi

TOTAL=$(grep -c "### Phase" "$PLAN_FILE" 2>/dev/null || echo "0")
COMPLETE=$(grep -cF "**Status:** complete" "$PLAN_FILE" 2>/dev/null || echo "0")
IN_PROGRESS=$(grep -cF "**Status:** in_progress" "$PLAN_FILE" 2>/dev/null || echo "0")
PENDING=$(grep -cF "**Status:** pending" "$PLAN_FILE" 2>/dev/null || echo "0")

if [ "$COMPLETE" -eq 0 ] && [ "$IN_PROGRESS" -eq 0 ] && [ "$PENDING" -eq 0 ]; then
    COMPLETE=$(grep -c "\[complete\]" "$PLAN_FILE" 2>/dev/null || echo "0")
    IN_PROGRESS=$(grep -c "\[in_progress\]" "$PLAN_FILE" 2>/dev/null || echo "0")
    PENDING=$(grep -c "\[pending\]" "$PLAN_FILE" 2>/dev/null || echo "0")
fi

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           PLANNING WITH TEAMS - STATUS REPORT             ║"
echo "╠═══════════════════════════════════════════════════════════╣"

if [ "$COMPLETE" -eq "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
    echo "║  STATUS: ALL PHASES COMPLETE ($COMPLETE/$TOTAL)                    ║"
else
    echo "║  STATUS: TEAM IN PROGRESS                                 ║"
    printf "║  Phases: %d complete, %d in progress, %d pending       ║\n" "$COMPLETE" "$IN_PROGRESS" "$PENDING"
fi

echo "╚═══════════════════════════════════════════════════════════╝"
exit 0
