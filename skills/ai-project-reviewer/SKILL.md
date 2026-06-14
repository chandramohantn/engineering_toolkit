---
name: ai-project-reviewer
description: >-
  Review AI/ML/GenAI project proposals before committing resources — validates business
  problem definition, success criteria, feasibility, data availability, and go/no-go
  recommendation. Acts as a senior ML engineer's critical eye on project proposals.
  Trigger on "review this AI project", "should we do this ML project", "project feasibility",
  "go no-go decision", "AI project proposal review", "is this project viable",
  "review project scope", "ML project assessment".
  Exclude: dataset analysis, model training, architecture design, code review.
metadata:
  author: ai-engineering-team
  version: "1.0.0"
tags:
  - ai-project-reviewer
  - project-review
  - feasibility
---

# AI Project Reviewer

Reviews AI/ML/GenAI project proposals and produces a go/no-go recommendation. Evaluates whether the problem is well-defined, success criteria are measurable, data exists, and the approach is justified. Prevents teams from wasting months on projects that should have been rejected in week one.

## Behavior

### Step 1: Gather Context

Ask for (in this order — stop as soon as you have enough):
1. Problem statement — what are we solving?
2. Available data — what do we have?
3. Success criteria — how do we know it works?
4. Constraints — timeline, budget, team, infrastructure

If a project doc or proposal exists, read it first and extract answers.

### Step 2: Evaluate Against Framework

**Problem Definition (25%):**
- Is the problem specific and measurable (not "use AI for X")?
- Is there a clear cost of NOT solving it?
- Who are the users? What decisions do they make with the output?
- Can the problem be stated without the words "AI" or "ML"?

**Success Criteria (20%):**
- Are metrics defined (not "better performance")?
- Is there a measurable baseline?
- Is the target realistic (not "99% accuracy")?
- Is the minimum acceptable threshold defined?

**Feasibility (25%):**
- Has a simple approach been considered first (rules, heuristics)?
- Is AI actually needed, or is this engineering laziness?
- Is there a learnable pattern in the data?
- Has this been solved before in industry?
- Is the timeline realistic for the complexity?

**Data Readiness (20%):**
- Does data exist? Has anyone actually looked at it?
- Is it labeled (or can labels be obtained)?
- Is the volume sufficient for the proposed approach?
- Are there known quality issues?
- Can we access it within the project timeline?

**Organizational Readiness (10%):**
- Is there sustained sponsorship?
- Is there a path to production (not just a PoC)?
- Who maintains this in production?
- Are domain experts available?

### Step 3: Identify Red Flags

Instant-fail conditions — if any of these are true, recommend rejection:
- "We don't have data yet but we'll figure it out"
- No measurable success criteria exist
- "Just use GenAI/ChatGPT for this" (solution-first thinking)
- No one owns this in production
- The problem can be solved with a SQL query or rule engine
- Timeline is <2 weeks for a non-trivial ML project

### Step 4: Generate Review

```markdown
# AI Project Review: [Project Name]

## Verdict: [GO | GO WITH CONDITIONS | NO-GO]
## Confidence: [High | Medium | Low]

## One-Line Summary
[What this project is trying to do and whether it should proceed]

## Scores
| Dimension | Score (/5) | Key Issue |
|-----------|-----------|-----------|
| Problem Definition | | |
| Success Criteria | | |
| Feasibility | | |
| Data Readiness | | |
| Organizational Readiness | | |

## Red Flags
[Any instant-fail conditions triggered]

## Critical Questions (must be answered before proceeding)
1. ...
2. ...

## Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|

## Recommendation
[Detailed recommendation: proceed, pivot, or stop — with rationale]

## If Proceeding: Next Steps
1. ...
2. ...
3. ...
```

## Gotchas

- Projects that sound exciting are often the worst investments — excitement ≠ feasibility
- "We tried this before and it didn't work" + no new data = same outcome
- Executive-driven projects still need the same rigor — sponsorship ≠ feasibility
- GenAI projects fail for different reasons than classical ML — assess hallucination risk, cost at scale
- A successful PoC does NOT mean production is feasible — always ask about the path from PoC to prod
