# Check if all phases in team_plan.md are complete

param([string]$PlanFile = "team_plan.md")

if (-not (Test-Path $PlanFile)) {
    Write-Host "[planning-with-teams] No team_plan.md found — no active team planning session."
    exit 0
}

$content = Get-Content $PlanFile -Raw
$total = ([regex]::Matches($content, "### Phase")).Count
$complete = ([regex]::Matches($content, "\*\*Status:\*\* complete")).Count
$inProgress = ([regex]::Matches($content, "\*\*Status:\*\* in_progress")).Count
$pending = ([regex]::Matches($content, "\*\*Status:\*\* pending")).Count

Write-Host "PLANNING WITH TEAMS - STATUS REPORT"
Write-Host "==================================="

if ($complete -eq $total -and $total -gt 0) {
    Write-Host "STATUS: ALL PHASES COMPLETE ($complete/$total)"
} else {
    Write-Host "STATUS: TEAM IN PROGRESS"
    Write-Host "Phases: $complete complete, $inProgress in progress, $pending pending"
}

exit 0
