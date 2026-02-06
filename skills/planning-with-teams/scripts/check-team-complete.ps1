# Check if all phases in team_plan.md are complete
# Always exits 0 — uses stdout for status reporting
# Used by Stop hook to report team completion status

param(
    [string]$PlanFile = "team_plan.md"
)

if (-not (Test-Path $PlanFile)) {
    Write-Host "[planning-with-teams] No team_plan.md found — no active team planning session."
    exit 0
}

$content = Get-Content $PlanFile -Raw

# Count total phases
$totalMatches = [regex]::Matches($content, "### Phase")
$total = $totalMatches.Count

# Check for **Status:** format
$completeMatches = [regex]::Matches($content, "\*\*Status:\*\* complete")
$inProgressMatches = [regex]::Matches($content, "\*\*Status:\*\* in_progress")
$pendingMatches = [regex]::Matches($content, "\*\*Status:\*\* pending")

$complete = $completeMatches.Count
$inProgress = $inProgressMatches.Count
$pending = $pendingMatches.Count

# Fallback to inline format
if ($complete -eq 0 -and $inProgress -eq 0 -and $pending -eq 0) {
    $complete = ([regex]::Matches($content, "\[complete\]")).Count
    $inProgress = ([regex]::Matches($content, "\[in_progress\]")).Count
    $pending = ([regex]::Matches($content, "\[pending\]")).Count
}

# Report status
Write-Host "╔═══════════════════════════════════════════════════════════╗"
Write-Host "║           PLANNING WITH TEAMS - STATUS REPORT             ║"
Write-Host "╠═══════════════════════════════════════════════════════════╣"

if ($complete -eq $total -and $total -gt 0) {
    Write-Host "║  STATUS: ALL PHASES COMPLETE ($complete/$total)                    ║"
    Write-Host "║                                                           ║"
    Write-Host "║  Next steps:                                              ║"
    Write-Host "║  1. Review team_findings.md for all discoveries           ║"
    Write-Host "║  2. Check team_progress.md for session summary            ║"
    Write-Host "║  3. Shut down teammates if still running                  ║"
    Write-Host "║  4. Clean up the team                                     ║"
} else {
    Write-Host "║  STATUS: TEAM IN PROGRESS                                 ║"
    Write-Host "║                                                           ║"
    Write-Host ("║  Phases: {0} complete, {1} in progress, {2} pending       ║" -f $complete, $inProgress, $pending)
    Write-Host "║                                                           ║"
    if ($inProgress -gt 0) {
        Write-Host "║  Teammates still working on assigned phases.              ║"
    }
    if ($pending -gt 0) {
        Write-Host "║  Some phases not yet started.                             ║"
    }
}

Write-Host "╚═══════════════════════════════════════════════════════════╝"

# Check for team_findings.md
if (Test-Path "team_findings.md") {
    $findingsContent = Get-Content "team_findings.md" -Raw
    $findingsCount = ([regex]::Matches($findingsContent, "^### ", [System.Text.RegularExpressions.RegexOptions]::Multiline)).Count
    Write-Host "[planning-with-teams] team_findings.md has $findingsCount sections."
}

# Check for team_progress.md
if (Test-Path "team_progress.md") {
    Write-Host "[planning-with-teams] team_progress.md exists."
}

exit 0
