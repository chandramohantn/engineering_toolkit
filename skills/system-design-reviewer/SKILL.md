---
name: system-design-reviewer
description: >-
  Review system designs before implementation — evaluates scalability, availability,
  consistency, performance bottlenecks, cost efficiency, and operational complexity.
  Produces a review report identifying architectural risks and improvements.
  Trigger on "review my system design", "architecture review", "scalability review",
  "will this scale", "system design feedback", "design review", "architecture assessment",
  "infrastructure design review", "is this architecture sound".
  Exclude: code review, unit testing, CI/CD pipelines, deployment procedures,
  database query optimization.
metadata:
  author: ai-engineering-team
  version: "1.0.0"
tags:
  - system-design-reviewer
  - architecture
  - scalability
---

# System Design Reviewer

Reviews system designs with the mindset of a staff engineer — not just "does it work?" but "will it survive production?" Evaluates designs against fundamental distributed systems principles and operational reality.

## Behavior

### Step 1: Gather Context

Ask for:
1. Architecture diagram or description (services, data stores, message queues)
2. Scale requirements (users, requests/sec, data volume)
3. Availability requirements (SLA target)
4. The specific concern (or "general review")

Read any provided design docs, diagrams, or code before starting.

### Step 2: Evaluate Against Dimensions

**Scalability:**
- Can each component scale horizontally?
- Where are the bottlenecks at 10x current load?
- Are there shared mutable state dependencies?
- Is the data partitioned/sharded appropriately?
- Are there single-writer bottlenecks?

**Availability & Reliability:**
- What happens when each component fails?
- Is there redundancy for critical path components?
- What's the blast radius of a single failure?
- Are there circuit breakers between services?
- What's the recovery time objective (RTO)?
- Are there single points of failure?

**Consistency & Data:**
- What consistency model is needed (strong, eventual, causal)?
- Are there split-brain scenarios?
- How is data durability guaranteed?
- What happens during network partitions?
- Is there a strategy for data consistency across services?

**Performance:**
- What's the critical path latency?
- Are there N+1 query problems?
- Is caching applied at the right layer?
- Are expensive operations async where possible?
- Are there hot spots (uneven load distribution)?

**Operational Complexity:**
- Can you debug this at 3 AM?
- Is there observability (tracing, metrics, logs)?
- How complex is deployment (how many things can go wrong)?
- Is there a clear ownership model?
- Can you do zero-downtime deployments?

**Cost Efficiency:**
- Is this over-provisioned for the expected load?
- Are there cheaper alternatives that meet requirements?
- Are expensive resources (GPUs, managed services) justified?
- Is there autoscaling to avoid paying for idle capacity?

**Security:**
- Is the attack surface minimized?
- Are services communicating securely (mTLS, VPC)?
- Is there defense in depth (not just perimeter)?
- Are secrets managed properly?

### Step 3: Generate Review

```markdown
# System Design Review: [System Name]

## Overall Assessment: [Sound | Needs Work | Fundamental Issues]

## Architecture Summary
[2-3 sentence description of what was reviewed]

## Strengths
- ...

## Critical Issues (must fix before production)
| # | Issue | Risk | Recommendation |
|---|-------|------|---------------|

## Improvements (should fix)
| # | Issue | Impact | Recommendation |
|---|-------|--------|---------------|

## Dimension Scores
| Dimension | Rating | Key Concern |
|-----------|--------|------------|
| Scalability | ★★★☆☆ | |
| Availability | ★★★☆☆ | |
| Consistency | ★★★☆☆ | |
| Performance | ★★★☆☆ | |
| Operations | ★★★☆☆ | |
| Cost | ★★★☆☆ | |
| Security | ★★★☆☆ | |

## Failure Scenario Analysis
| Scenario | Impact | Current Handling | Recommendation |
|----------|--------|-----------------|---------------|
| [Component X dies] | | | |
| [DB becomes slow] | | | |
| [Traffic spike 10x] | | | |

## Alternative Approaches Considered
[If fundamental redesign is warranted]

## Questions for the Team
[Things that couldn't be assessed without more context]
```

## Gotchas

- "We'll optimize later" means it ships slow and stays slow — identify performance issues in design
- Microservices don't automatically mean scalable — distributed monoliths are worse than monoliths
- Consistency requirements are often over-specified — ask if eventual consistency would actually be acceptable
- The #1 cause of outages is cascading failures between services — always ask about circuit breakers
- "It works on my machine" designs break at scale because of shared state assumptions
- Every network call is a potential failure point — minimize synchronous cross-service calls
- Auto-scaling has warm-up time — it won't save you from traffic spikes faster than scale-up time
