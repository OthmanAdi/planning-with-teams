#!/usr/bin/env python3
"""
Team Status Summary Script

Reads team planning files and provides a comprehensive status report.
Useful for lead to get quick overview of team state.

Usage:
    python team-status.py [project_dir]
"""

import os
import re
import sys
import json
from pathlib import Path
from datetime import datetime


def read_file(filepath):
    """Read file contents, return empty string if not found."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            return f.read()
    except FileNotFoundError:
        return ""
    except Exception as e:
        print(f"Warning: Could not read {filepath}: {e}")
        return ""


def count_pattern(content, pattern):
    """Count occurrences of regex pattern in content."""
    return len(re.findall(pattern, content, re.MULTILINE))


def extract_table_rows(content, table_header):
    """Extract rows from a markdown table following a header."""
    rows = []
    in_table = False
    header_found = False

    for line in content.split('\n'):
        if table_header in line:
            header_found = True
            continue
        if header_found and line.startswith('|'):
            if '---' in line:
                in_table = True
                continue
            if in_table:
                cells = [c.strip() for c in line.split('|')[1:-1]]
                if cells and any(cells):
                    rows.append(cells)
        elif header_found and in_table and not line.startswith('|'):
            break

    return rows


def analyze_team_plan(content):
    """Analyze team_plan.md and return status info."""
    if not content:
        return None

    # Extract goal
    goal_match = re.search(r'## Goal\s*\n+(.+?)(?=\n#|\n\n##|\Z)', content, re.DOTALL)
    goal = goal_match.group(1).strip().split('\n')[0] if goal_match else "Unknown"

    # Count phases
    total_phases = count_pattern(content, r'^### Phase', )
    complete = count_pattern(content, r'\*\*Status:\*\* complete')
    in_progress = count_pattern(content, r'\*\*Status:\*\* in_progress')
    pending = count_pattern(content, r'\*\*Status:\*\* pending')

    # Fallback to inline format
    if complete == 0 and in_progress == 0 and pending == 0:
        complete = count_pattern(content, r'\[complete\]')
        in_progress = count_pattern(content, r'\[in_progress\]')
        pending = count_pattern(content, r'\[pending\]')

    # Extract team composition
    team_rows = extract_table_rows(content, "## Team Composition")

    # Extract blockers
    blocker_rows = extract_table_rows(content, "## Blockers")
    active_blockers = [r for r in blocker_rows if len(r) > 3 and r[3].lower() != 'resolved']

    return {
        'goal': goal,
        'total_phases': total_phases,
        'complete': complete,
        'in_progress': in_progress,
        'pending': pending,
        'team_size': len(team_rows),
        'team': team_rows,
        'blockers': len(active_blockers)
    }


def analyze_team_findings(content):
    """Analyze team_findings.md and return findings info."""
    if not content:
        return None

    # Count sections
    sections = count_pattern(content, r'^### ')

    # Count errors logged
    errors = count_pattern(content, r'^\| .+ \| \d+ \|')

    # Count decisions
    decisions = extract_table_rows(content, "## Decisions Made")

    # Count open questions
    questions = extract_table_rows(content, "## Open Questions")
    unanswered = [q for q in questions if len(q) > 3 and not q[3].strip()]

    return {
        'sections': sections,
        'errors_logged': errors,
        'decisions': len(decisions),
        'open_questions': len(unanswered)
    }


def analyze_team_progress(content):
    """Analyze team_progress.md and return progress info."""
    if not content:
        return None

    # Count activity entries
    activities = count_pattern(content, r'^\| .+ \| .+ \| .+ \|')

    # Count messages
    messages = extract_table_rows(content, "## Messages Exchanged")

    # Count files modified
    files_modified = extract_table_rows(content, "## Files Modified")

    return {
        'activity_entries': activities,
        'messages': len(messages),
        'files_modified': len(files_modified)
    }


def print_status_report(plan, findings, progress):
    """Print formatted status report."""

    print("\n" + "=" * 65)
    print("           PLANNING WITH TEAMS - COMPREHENSIVE STATUS")
    print("=" * 65)

    if plan:
        print(f"\n📋 GOAL: {plan['goal'][:50]}...")
        print("\n📊 PHASE PROGRESS:")
        print(f"   ✅ Complete:    {plan['complete']}/{plan['total_phases']}")
        print(f"   🔄 In Progress: {plan['in_progress']}/{plan['total_phases']}")
        print(f"   ⏳ Pending:     {plan['pending']}/{plan['total_phases']}")

        if plan['total_phases'] > 0:
            pct = (plan['complete'] / plan['total_phases']) * 100
            bar_len = 30
            filled = int(bar_len * plan['complete'] / plan['total_phases'])
            bar = "█" * filled + "░" * (bar_len - filled)
            print(f"\n   [{bar}] {pct:.0f}%")

        print(f"\n👥 TEAM: {plan['team_size']} members")
        if plan['team']:
            for member in plan['team'][:5]:  # Show first 5
                if len(member) >= 2:
                    print(f"   • {member[0]}: {member[1]}")

        if plan['blockers'] > 0:
            print(f"\n🚫 BLOCKERS: {plan['blockers']} active")
    else:
        print("\n⚠️  No team_plan.md found")

    if findings:
        print(f"\n📝 FINDINGS:")
        print(f"   • Sections documented: {findings['sections']}")
        print(f"   • Errors logged: {findings['errors_logged']}")
        print(f"   • Decisions made: {findings['decisions']}")
        if findings['open_questions'] > 0:
            print(f"   • Open questions: {findings['open_questions']} ⚠️")
    else:
        print("\n⚠️  No team_findings.md found")

    if progress:
        print(f"\n📈 ACTIVITY:")
        print(f"   • Log entries: {progress['activity_entries']}")
        print(f"   • Messages: {progress['messages']}")
        print(f"   • Files modified: {progress['files_modified']}")
    else:
        print("\n⚠️  No team_progress.md found")

    # Recommendations
    print("\n" + "-" * 65)
    print("💡 RECOMMENDATIONS:")

    if plan and plan['in_progress'] > 0:
        print("   • Check on teammates with in-progress phases")
    if plan and plan['blockers'] > 0:
        print("   • Resolve active blockers before proceeding")
    if findings and findings['open_questions'] > 0:
        print("   • Answer open questions in team_findings.md")
    if plan and plan['complete'] == plan['total_phases'] and plan['total_phases'] > 0:
        print("   • All phases complete! Ready to synthesize and deliver.")
        print("   • Don't forget to clean up the team when done.")

    print("\n" + "=" * 65 + "\n")


def main():
    # Get project directory
    project_dir = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
    project_dir = Path(project_dir)

    print(f"\n🔍 Analyzing team status in: {project_dir}")

    # Read files
    plan_content = read_file(project_dir / "team_plan.md")
    findings_content = read_file(project_dir / "team_findings.md")
    progress_content = read_file(project_dir / "team_progress.md")

    # Analyze
    plan = analyze_team_plan(plan_content)
    findings = analyze_team_findings(findings_content)
    progress = analyze_team_progress(progress_content)

    # Print report
    print_status_report(plan, findings, progress)

    # Output JSON for programmatic use
    if '--json' in sys.argv:
        result = {
            'plan': plan,
            'findings': findings,
            'progress': progress,
            'timestamp': datetime.now().isoformat()
        }
        print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
