# Examples: Planning with Teams in Action

## Example 1: Parallel Code Review

**User Request:** "Review PR #142 for security, performance, and test coverage"

### Step 1: Lead Creates Team Plan

```markdown
# Team Plan: PR #142 Code Review

## Goal
Comprehensive review of PR #142 covering security, performance, and tests.

## Team Composition
| Teammate | Role | Focus | Model |
|----------|------|-------|-------|
| Lead | Coordinator | Synthesis | inherit |
| security-reviewer | Reviewer | Security vulnerabilities | sonnet |
| perf-reviewer | Reviewer | Performance impact | sonnet |
| test-reviewer | Reviewer | Test coverage | haiku |

## Phases

### Phase 1: Security Review [security-reviewer]
- [ ] Check for injection vulnerabilities
- [ ] Review authentication changes
- [ ] Audit data exposure
- **Status:** pending

### Phase 2: Performance Review [perf-reviewer]
- [ ] Analyze query complexity
- [ ] Check for N+1 patterns
- [ ] Review memory usage
- **Status:** pending

### Phase 3: Test Review [test-reviewer]
- [ ] Verify new code has tests
- [ ] Check edge cases covered
- [ ] Review test quality
- **Status:** pending

### Phase 4: Synthesis [Lead]
- [ ] Combine all findings
- [ ] Resolve any conflicts
- [ ] Create final review
- **Status:** pending
```

### Step 2: Lead Spawns Team

```
Create an agent team to review PR #142:

Teammate 1 (security-reviewer):
- Focus on security vulnerabilities (injection, auth, data exposure)
- Read team_plan.md first, then review the PR
- Write findings to team_findings.md under "## Security Findings"
- Model: sonnet

Teammate 2 (perf-reviewer):
- Focus on performance impact (queries, memory, algorithms)
- Read team_plan.md first, then review the PR
- Write findings to team_findings.md under "## Performance Findings"
- Model: sonnet

Teammate 3 (test-reviewer):
- Focus on test coverage and quality
- Read team_plan.md first, then review the PR
- Write findings to team_findings.md under "## Test Coverage Findings"
- Model: haiku
```

### Step 3: Teammates Work in Parallel

**security-reviewer:**
```bash
Read team_plan.md           # Understand scope
gh pr diff 142              # Get the changes
Read team_findings.md       # Check if others found anything
# ... analyze for security issues ...
Edit team_findings.md       # Add: "## Security Findings\n- Found SQL injection..."
Message lead: "Security review complete. Found 2 critical issues."
```

**perf-reviewer:**
```bash
Read team_plan.md           # Understand scope
gh pr diff 142              # Get the changes
# ... analyze for performance ...
Edit team_findings.md       # Add: "## Performance Findings\n- N+1 query in..."
Message lead: "Performance review complete. Found 1 warning."
```

**test-reviewer:**
```bash
Read team_plan.md           # Understand scope
gh pr diff 142              # Get the changes
# ... analyze test coverage ...
Edit team_findings.md       # Add: "## Test Coverage\n- Missing tests for..."
Message lead: "Test review complete. Coverage gaps identified."
```

### Step 4: Lead Synthesizes

```bash
Read team_findings.md       # All findings in one place!
# Synthesize into final review
gh pr comment 142 --body "## Code Review Summary..."
```

### Result: team_findings.md

```markdown
# Team Findings: PR #142 Review

## Security Findings
**Reviewer:** security-reviewer
**Severity:** 2 Critical, 1 Warning

### Critical: SQL Injection in search endpoint
- File: `src/api/search.ts:45`
- Issue: User input directly interpolated into query
- Fix: Use parameterized query

### Critical: Missing auth check on admin route
- File: `src/routes/admin.ts:12`
- Issue: No authentication middleware
- Fix: Add `requireAdmin` middleware

### Warning: Sensitive data in logs
- File: `src/utils/logger.ts:78`
- Issue: Email addresses logged in plain text
- Fix: Mask PII before logging

## Performance Findings
**Reviewer:** perf-reviewer
**Severity:** 1 Warning

### Warning: N+1 Query Pattern
- File: `src/services/users.ts:34`
- Issue: Loading related records in loop
- Fix: Use eager loading with `.include()`

## Test Coverage Findings
**Reviewer:** test-reviewer
**Coverage:** 67% (below 80% threshold)

### Missing Tests
- `src/api/search.ts` - No tests for search endpoint
- `src/routes/admin.ts` - No tests for admin routes

### Recommendations
- Add integration tests for new endpoints
- Add edge case tests for empty results
```

---

## Example 2: Debugging with Competing Hypotheses

**User Request:** "Users report the app exits after one message instead of staying connected"

### Team Plan

```markdown
# Team Plan: Connection Dropout Bug

## Goal
Identify root cause of connection dropping after one message.

## Team Composition
| Teammate | Role | Hypothesis | Model |
|----------|------|------------|-------|
| Lead | Coordinator | Synthesis | inherit |
| ws-investigator | Researcher | WebSocket issue | sonnet |
| timeout-investigator | Researcher | Timeout/keepalive | sonnet |
| state-investigator | Researcher | State management | sonnet |
| memory-investigator | Researcher | Memory leak | haiku |

## Investigation Rules
1. Each investigator explores their hypothesis
2. Document evidence FOR and AGAINST in team_findings.md
3. Challenge each other's findings
4. Converge on most likely cause
```

### Spawning the Debug Team

```
Create an agent team to debug the connection dropout:

Spawn 4 investigators, each with a different hypothesis:

1. ws-investigator: "WebSocket connection handling is broken"
2. timeout-investigator: "Keep-alive or timeout misconfiguration"
3. state-investigator: "State gets corrupted after first message"
4. memory-investigator: "Memory leak causes crash"

Have them:
- Explore their hypothesis
- Document evidence to team_findings.md
- Challenge each other's theories
- Converge on root cause
```

### Team Findings After Investigation

```markdown
# Team Findings: Connection Dropout

## Hypothesis 1: WebSocket Issue [ws-investigator]
**Verdict:** UNLIKELY

### Evidence For
- None found

### Evidence Against
- WebSocket connection established correctly
- Handshake completes successfully
- No errors in WS logs

## Hypothesis 2: Timeout/Keepalive [timeout-investigator]
**Verdict:** LIKELY - PRIMARY CAUSE

### Evidence For
- Server timeout set to 5 seconds (too short!)
- No keepalive ping/pong implemented
- Logs show "connection timeout" errors

### Evidence Against
- None

### Recommendation
- Increase timeout to 30 seconds
- Implement ping/pong keepalive

## Hypothesis 3: State Management [state-investigator]
**Verdict:** CONTRIBUTING FACTOR

### Evidence For
- State not persisted after first message
- Reconnection loses context

### Evidence Against
- Not the primary cause (connection drops regardless)

## Hypothesis 4: Memory Leak [memory-investigator]
**Verdict:** UNLIKELY

### Evidence For
- None found

### Evidence Against
- Memory usage stable
- No growth over time

## CONSENSUS
**Root Cause:** Timeout too short (5s) with no keepalive.
**Secondary Issue:** State not persisted on reconnect.

## Recommended Fix
1. Set timeout to 30 seconds
2. Implement ping/pong every 15 seconds
3. Add state persistence for reconnection
```

---

## Example 3: Feature Development (Frontend + Backend + Tests)

**User Request:** "Add a dark mode toggle to the settings page"

### Team Plan

```markdown
# Team Plan: Dark Mode Feature

## Goal
Add functional dark mode toggle with theme persistence.

## Team Composition
| Teammate | Role | Owns | Model |
|----------|------|------|-------|
| Lead | Coordinator | Synthesis, final review | inherit |
| frontend-dev | Implementer | UI components, toggle | sonnet |
| backend-dev | Implementer | API, persistence | sonnet |
| test-dev | Implementer | All tests | sonnet |

## File Ownership (AVOID CONFLICTS)
| Teammate | Files They Can Edit |
|----------|---------------------|
| frontend-dev | src/components/*, src/styles/* |
| backend-dev | src/api/*, src/services/* |
| test-dev | tests/*, *.test.ts |

## Phases

### Phase 1: Research [All teammates]
- Explore existing theme system
- Document in team_findings.md
- **Status:** pending

### Phase 2: Frontend Implementation [frontend-dev]
- Create toggle component
- Add theme context
- Style dark mode
- **Status:** pending

### Phase 3: Backend Implementation [backend-dev]
- Add preferences API
- Persist theme choice
- **Status:** pending

### Phase 4: Testing [test-dev]
- Unit tests for toggle
- Integration tests for API
- E2E test for full flow
- **Status:** pending

### Phase 5: Integration [Lead]
- Verify all parts work together
- Final testing
- **Status:** pending
```

### Coordinated Implementation

**Phase 1 - All Research:**
```markdown
## Research Findings

### Frontend [frontend-dev]
- Existing theme: CSS custom properties in `src/styles/theme.ts`
- Toggle location: `src/components/Settings/SettingsPage.tsx`
- Theme provider pattern already exists

### Backend [backend-dev]
- User preferences API: `src/api/preferences.ts`
- Storage: Already has preferences table
- Just need to add `theme` field

### Testing [test-dev]
- Test framework: Jest + React Testing Library
- E2E: Playwright
- Coverage threshold: 80%
```

**Phase 2-4 - Parallel Implementation:**

Each teammate works on their owned files, writing findings to team_findings.md as they go. No conflicts because file ownership is clear.

---

## Example 4: Error Recovery in Teams

### The Wrong Way

```
Teammate-1: Read config.json
Error: File not found
Teammate-1: Read config.json  # Silent retry
Teammate-1: Read config.json  # Another retry

Teammate-2: Read config.json  # SAME ERROR!
Teammate-2: Read config.json  # Repeating mistake
```

### The Right Way

```
Teammate-1: Read config.json
Error: File not found

Teammate-1: Edit team_findings.md
## Errors Encountered
| Error | Teammate | Resolution |
|-------|----------|------------|
| config.json not found | Teammate-1 | Will create default |

Teammate-1: Write config.json (default config)
Teammate-1: Read config.json
Success!

# Later...
Teammate-2: Read team_findings.md  # Sees the error already resolved
Teammate-2: Read config.json       # Works first try!
```

---

## Example 5: Research Task with Multiple Sources

**User Request:** "Research authentication best practices and recommend an approach for our app"

### Team Setup

```markdown
# Team Plan: Auth Research

## Goal
Research auth approaches and recommend best fit for our stack.

## Team Composition
| Teammate | Research Area | Model |
|----------|---------------|-------|
| oauth-researcher | OAuth/OIDC providers | haiku |
| jwt-researcher | JWT implementation | haiku |
| session-researcher | Session-based auth | haiku |
| security-researcher | Security comparison | sonnet |

## Research Questions
1. What are the pros/cons of each approach?
2. Which fits our stack (Node.js + React)?
3. What are the security implications?
4. What's the implementation complexity?
```

### Parallel Research

All four researchers work simultaneously:
- Each explores their assigned area
- Documents findings to team_findings.md
- Cross-references other findings

### Synthesized Recommendation

```markdown
# Team Findings: Authentication Research

## OAuth/OIDC [oauth-researcher]
**Pros:** Delegated auth, social login, industry standard
**Cons:** Complexity, external dependency
**Fit:** Good for consumer apps with social login

## JWT [jwt-researcher]
**Pros:** Stateless, scalable, cross-service
**Cons:** Token revocation complexity, size
**Fit:** Good for microservices, APIs

## Session-Based [session-researcher]
**Pros:** Simple, easy revocation, server control
**Cons:** Server state required, scaling challenges
**Fit:** Good for traditional web apps

## Security Comparison [security-researcher]
| Approach | OWASP Score | Common Vulnerabilities |
|----------|-------------|------------------------|
| OAuth | A | Redirect attacks, token leakage |
| JWT | B+ | None if implemented correctly |
| Session | B+ | CSRF, session fixation |

## RECOMMENDATION
For your Node.js + React stack with API-first architecture:
**Use JWT with short expiry + refresh tokens**

Rationale:
1. Stateless = easy scaling
2. Works well with React SPA
3. Good security when implemented correctly
4. Can add OAuth later for social login
```

---

## Key Patterns Across All Examples

### Pattern 1: Always Create Plan First
Every example starts with team_plan.md before spawning teammates.

### Pattern 2: Clear Ownership
Teammates know exactly what they own. No conflicts.

### Pattern 3: Shared Findings
Everything goes to team_findings.md. No siloed knowledge.

### Pattern 4: Communicate Completion
Teammates message lead when done. Lead knows when to synthesize.

### Pattern 5: Lead Synthesizes
Lead combines all findings into final deliverable.
