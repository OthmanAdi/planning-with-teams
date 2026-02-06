# Reference: Manus Principles for Agent Teams

This skill applies Manus context engineering principles to Claude Code's native Agent Teams feature. Manus was acquired by Meta for $2 billion in December 2025.

## Why Manus Principles + Agent Teams?

**The Problem:**
- Agent Teams give each teammate their OWN context window
- Without coordination, teammates drift from the goal
- Findings get siloed in individual contexts
- Work duplicates or conflicts

**The Solution:**
- Shared planning files = shared memory across all agents
- Manus principles ensure each agent stays aligned
- Structured communication prevents chaos

```
┌─────────────────────────────────────────────────────────┐
│                    TEAM LEAD                             │
│         └─ Owns team_plan.md                            │
│         └─ Synthesizes team_findings.md                  │
├─────────────────────────────────────────────────────────┤
│  TEAMMATE 1        TEAMMATE 2        TEAMMATE 3         │
│  Own context       Own context       Own context         │
│       │                 │                 │              │
│       └─────────────────┴─────────────────┘              │
│                         │                                │
│               SHARED PLANNING FILES                      │
│         team_plan.md | team_findings.md | team_progress  │
└─────────────────────────────────────────────────────────┘
```

---

## The 6 Manus Principles (Adapted for Teams)

### Principle 1: KV-Cache Efficiency

> "KV-cache hit rate is THE single most important metric."

**Single Agent:** Keep prompts stable for cache hits.

**For Teams:** Each teammate has their own cache. The shared files provide consistency across caches.

**Implementation:**
- Shared file structure stays consistent
- Each teammate reads the same team_plan.md
- Stable file format = better cache efficiency per agent

### Principle 2: Mask, Don't Remove

> "Don't dynamically remove tools (breaks KV-cache). Use logit masking instead."

**For Teams:**
- Don't change teammate tool access mid-task
- Define tool restrictions at spawn time
- Use role-based tool sets consistently

### Principle 3: Filesystem as External Memory (CRITICAL FOR TEAMS)

> "Markdown is my 'working memory' on disk."

**Single Agent:**
```
Context Window = RAM (volatile, limited)
Filesystem = Disk (persistent, unlimited)
```

**For Teams:**
```
Teammate 1 Context = RAM-1 (volatile, isolated)
Teammate 2 Context = RAM-2 (volatile, isolated)
Teammate N Context = RAM-N (volatile, isolated)
Shared Files = SHARED DISK (persistent, accessible to ALL)
```

**The shared files ARE the team's collective memory.**

### Principle 4: Manipulate Attention Through Recitation

> "Re-read todo.md to push goals into attention span."

**For Teams:** Each teammate re-reads team_plan.md before major decisions.

```
Teammate-2 has done 30 tool calls...
Original team goal is fading from attention...

→ Read team_plan.md              # Team goal refreshed!
→ Read team_findings.md          # See what others found!
→ Now make decision              # Aligned with team
```

### Principle 5: Keep the Wrong Stuff In

> "Leave the wrong turns in the context."

**For Teams:** Log ALL errors to team_findings.md, not just local context.

```markdown
## Errors Encountered

### Teammate-1 (Researcher)
| Error | Attempt | Resolution |
|-------|---------|------------|
| API rate limit | 1 | Added delay between requests |

### Teammate-2 (Implementer)
| Error | Attempt | Resolution |
|-------|---------|------------|
| Import not found | 1 | Package needed: pip install X |
```

This prevents OTHER teammates from hitting the same errors.

### Principle 6: Don't Get Few-Shotted

> "Uniformity breeds fragility."

**For Teams:** Varied approaches across teammates.

- Researcher uses breadth-first exploration
- Implementer uses focused implementation
- Reviewer uses skeptical validation

Different perspectives = more robust outcome.

---

## The 3 Context Strategies (Adapted for Teams)

### Strategy 1: Context Reduction

**Single Agent:** Compact old tool results.

**For Teams:**
- Each teammate compacts their OWN context
- Key findings go to team_findings.md BEFORE compaction
- Shared files survive individual context limits

### Strategy 2: Context Isolation (THIS IS AGENT TEAMS!)

**Manus Architecture:**
```
Planner Agent → Assigns to Executors
Knowledge Manager → Reviews conversations
Executor Sub-Agents → Own context windows
```

**Agent Teams Architecture:**
```
Team Lead → Assigns phases to Teammates
Shared Files → Persistent team knowledge
Teammates → Own context windows, own work
```

**Key Insight:** Manus found ~33% of actions were spent updating todo.md. Agent Teams solve this with native task management.

### Strategy 3: Context Offloading

**For Teams:** Teammates offload to shared files:
- Findings → team_findings.md
- Progress → team_progress.md
- Decisions → team_plan.md

---

## Anthropic Agent Teams Architecture

### Native Tools Available

When `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`:

| Tool | Purpose |
|------|---------|
| `Teammate` | Spawn teammates, cleanup team |
| `SendMessage` | Message teammates, broadcast |
| `TaskCreate` | Create task in shared list |
| `TaskUpdate` | Update task status |
| `TaskList` | View all team tasks |
| `TaskGet` | Get specific task details |

### Storage Locations

| What | Where |
|------|-------|
| Team config | `~/.claude/teams/{team-name}/config.json` |
| Task list | `~/.claude/tasks/{team-name}/` |
| **Your planning files** | Your project directory |

### Task States

```
pending → in_progress → completed
```

- Teammates can self-claim pending tasks
- Task dependencies auto-unblock when prerequisites complete

---

## Team Communication Patterns

### Pattern 1: Lead-Centric

```
         ┌──────────┐
         │   LEAD   │
         └────┬─────┘
              │
    ┌─────────┼─────────┐
    │         │         │
    ▼         ▼         ▼
 [TM-1]    [TM-2]    [TM-3]
```

All communication through lead. Best for simple coordination.

### Pattern 2: Peer-to-Peer via Files

```
         ┌──────────┐
         │   LEAD   │
         └────┬─────┘
              │
    ┌─────────┼─────────┐
    │         │         │
    ▼         ▼         ▼
 [TM-1]────[TM-2]────[TM-3]
    │         │         │
    └─────────┴─────────┘
              │
     [SHARED FILES]
```

Teammates coordinate through shared files. Best for complex collaboration.

### Pattern 3: Broadcast Updates

```
Lead: "All teammates: Phase 1 complete. Researcher found auth bug.
      See team_findings.md#auth-issue. Proceed to Phase 2."
```

Use sparingly. Broadcast consumes tokens across all teammates.

---

## The Team Agent Loop

Each teammate operates in this loop:

```
┌─────────────────────────────────────────┐
│  1. READ SHARED CONTEXT                  │
│     - Read team_plan.md                  │
│     - Read team_findings.md              │
│     - Understand team state              │
├─────────────────────────────────────────┤
│  2. ANALYZE OWN TASK                     │
│     - What phase am I on?                │
│     - What do I need to deliver?         │
├─────────────────────────────────────────┤
│  3. EXECUTE                              │
│     - Do the work                        │
│     - Apply Manus principles             │
├─────────────────────────────────────────┤
│  4. UPDATE SHARED FILES                  │
│     - Write findings immediately         │
│     - Log progress                       │
├─────────────────────────────────────────┤
│  5. COMMUNICATE                          │
│     - Message lead on phase complete     │
│     - Flag blockers early                │
├─────────────────────────────────────────┤
│  6. ITERATE OR COMPLETE                  │
│     - More work? Return to step 1        │
│     - Done? Request shutdown             │
└─────────────────────────────────────────┘
```

---

## Token Economics

| Mode | Token Cost | When to Use |
|------|-----------|-------------|
| Single agent | 1x | Simple tasks |
| Subagents | 1.5-2x | Focused delegation |
| Agent Teams | 3-5x | Complex parallel work |

**Agent Teams are expensive.** Use them when:
- Parallel exploration adds real value
- Task naturally splits into independent pieces
- Multiple perspectives improve outcome

---

## Key Quotes

> "Context window = RAM (volatile). Filesystem = Disk (persistent). For teams, shared files = shared disk."

> "Each teammate re-reading team_plan.md is like a team standup — everyone realigns."

> "Log errors to shared files. Your failure saves your teammate's time."

> "Agent Teams without shared files is just expensive parallel chaos."

---

## Source Materials

- Manus Context Engineering: https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
- Claude Code Agent Teams: https://code.claude.com/docs/en/agent-teams
- Anthropic Opus 4.6 Announcement: https://www.anthropic.com/news/claude-opus-4-6
