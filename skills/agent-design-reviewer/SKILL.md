---
name: agent-design-reviewer
description: >-
  Review whether an AI agent is actually needed and if the design is sound — checks
  if a single prompt suffices, if workflow orchestration is needed, if tool usage is
  justified, and if multi-agent is warranted. Prevents over-engineering with agents.
  Trigger on "review my agent design", "do I need an agent", "agent architecture review",
  "is multi-agent necessary", "agent vs workflow", "should this be agentic",
  "agent design review", "tool calling design".
  Exclude: RAG architecture, prompt engineering, LLM selection, chatbot UI.
metadata:
  author: ai-engineering-team
  version: "1.0.0"
tags:
  - agent-design-reviewer
  - genai
  - agent-architecture
---

# Agent Design Reviewer

Reviews agent designs with a critical eye — the primary goal is to prevent unnecessary complexity. Most "agent" use cases are better served by a single prompt, a RAG pipeline, or a simple workflow. This skill pushes back on agent designs that don't justify their complexity.

## Behavior

### Step 1: Gather Context

Ask for:
1. What is the agent supposed to do? (specific task, not vague goal)
2. What tools does it need? (APIs, databases, code execution, file access)
3. Why can't a single LLM call solve this?
4. What's the expected user interaction pattern?

### Step 2: Apply the Decision Ladder

Evaluate from simplest to most complex — stop at the first level that works:

**Level 0 — Single Prompt (no agent needed):**
- Can the task be completed in one LLM call with good prompting?
- Is the output deterministic enough without iteration?
- Does it need < 1 tool call that can be a function call?

→ If yes: **Recommend single prompt. No agent needed.**

**Level 1 — Chain/Workflow (deterministic sequence):**
- Is the task a fixed sequence of steps?
- Is the order always the same?
- Are the steps predictable (no dynamic branching)?

→ If yes: **Recommend a workflow/chain (LangChain chain, simple orchestration). Not an agent.**

**Level 2 — Single Agent (dynamic tool use):**
- Does the task require dynamic decision-making about which tool to use?
- Does it need to iterate based on intermediate results?
- Is the task completable in < 10 steps?
- Can one LLM handle all the reasoning?

→ If yes: **Recommend a single agent with tools.**

**Level 3 — Multi-Agent (specialized roles):**
- Are there genuinely different expertise domains needed?
- Would a single agent's prompt be too complex (>3000 tokens of instructions)?
- Do subtasks need different models or temperature settings?
- Is there a clear handoff/routing pattern?

→ If yes: **Recommend multi-agent. But verify each agent is necessary.**

### Step 3: Evaluate Design Quality

If an agent IS justified, review:

**Tool Design:**
- Are tools well-defined (clear input/output schema)?
- Are tools atomic (do one thing)?
- Are tools idempotent (safe to retry)?
- Are dangerous tools guarded (confirmation, rate limiting)?

**Safety Boundaries:**
- Is there a maximum iteration count (prevents infinite loops)?
- Is there a cost budget (prevents runaway API calls)?
- Is there human-in-the-loop for consequential actions?
- Can the agent gracefully fail (not just crash or hallucinate)?

**Memory & Context:**
- Is conversation memory needed or is each interaction stateless?
- If memory needed: what persistence mechanism?
- Is context window management addressed (long conversations)?

**Evaluation:**
- How do you know the agent is working correctly?
- Is there a golden dataset of expected behaviors?
- How do you detect when the agent is stuck in a loop?

### Step 4: Generate Review

```markdown
# Agent Design Review: [System Name]

## Verdict: [Agent Justified | Over-Engineered | Under-Engineered]
## Recommended Level: [0: Single Prompt | 1: Workflow | 2: Single Agent | 3: Multi-Agent]

## Complexity Assessment
- Proposed complexity: [Level X]
- Justified complexity: [Level Y]
- Delta: [Over-engineered by N levels | Appropriate | Needs more sophistication]

## If Agent IS Justified:
### Tool Design Review
- ...
### Safety Review
- ...
### Memory Review
- ...
### Evaluation Plan
- ...

## If Agent is NOT Justified:
### Simpler Alternative
[Specific implementation that achieves the goal without agents]
### Why This Works
[Evidence that the simpler approach handles the use cases]

## Risks
- ...

## Recommendations
1. ...
2. ...
```

## Gotchas

- 80% of "agent" projects are over-engineered — a single prompt + function calling usually suffices
- Multi-agent adds latency, cost, and debugging complexity — each agent must justify its existence
- "Autonomous agent" in production is rarely the right answer — humans should be in the loop for consequential actions
- ReAct loop without exit conditions will burn through your API budget
- Tools without proper error handling turn agents into infinite retry loops
- "Let the agent figure it out" is not a design — define the decision space explicitly
- Memory is expensive and often unnecessary — most tasks are stateless
