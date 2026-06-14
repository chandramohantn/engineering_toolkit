---
name: learn-by-asking
description: >-
  Answer questions in depth for learning — explains what, why, when, how with
  scenarios, code examples, mermaid diagrams, and exercises. Adapts difficulty
  to user level. Writes answers to markdown files, tracks learning progress,
  and supports review/recall of past topics. Use when the user wants to learn
  something by asking questions or understand a concept deeply.
  Trigger on "learn:", "explain", "how does", "what is", "why does", "teach me",
  "learn about", "understand", "deep dive", "break down", "walk me through",
  "quick:", "review:", "ELI5".
  Exclude: code generation tasks, debugging, file editing, project work.
metadata:
  author: ai-engineering-team
  version: "2.0.0"
tags:
  - learn-by-asking
  - learning
  - teaching
---

# Learn by Asking

Answer questions so the user genuinely understands. Adapts depth to their level, uses the right language for the concept, and builds a persistent learning journal.

## Modes

| Prefix | Mode | Behavior |
|--------|------|----------|
| `learn:` | **Full** (default) | Structured deep answer, saved to file |
| `quick:` | **Quick/ELI5** | 1-3 paragraph answer, no file, no diagrams |
| `review:` | **Review** | Load past qa files, quiz user on previous topics |

Natural phrases ("explain", "what is", "teach me") use Full mode. Detect if the question is trivially simple and suggest Quick mode.

## Difficulty Calibration

Before answering, assess the question's complexity and the user's implied level:

| Level | Signals | Approach |
|-------|---------|----------|
| **Beginner** | "what is", basic terminology, no jargon in question | Explain from zero. Define every term. Use analogies. Simple code. |
| **Intermediate** | Uses some domain terms, asks "how" or "when" | Assume basics known. Focus on mechanics and tradeoffs. Realistic code. |
| **Advanced** | Uses precise terminology, asks "why" or about edge cases | Go deep. Internals, performance, failure modes. Production code. |

If unsure, start at intermediate and adjust based on follow-up questions.

## File Handling

- Write all answers to: `qa-YYYY-MM-DD.md` (one file per day)
- Create in the user's current working directory
- All questions in a session append to the same day's file
- Quick mode does NOT write to file (ephemeral)
- Update `learning-log.md` with topic + date after each answer

## Answering a Question (Full Mode)

Adapt structure to complexity — not every question needs every section.

```markdown
# <Question as heading>

**Difficulty:** [Beginner | Intermediate | Advanced]

## What
<Clear definition — assume zero prior knowledge for beginner, assume basics for higher>

## Why
<Why this exists, what problem it solves>

## When
<When to use / not use, real-world contexts>

## How
<Mechanics, steps, internals — depth matches difficulty level>

## Scenarios
<Concrete examples showing the concept in action>

## Code Example
<Language appropriate to the concept — commented, runnable>

## Try It Yourself
<1-2 mini-exercises that test understanding — not busywork>

## Further Reading
- <2-3 links to official docs, papers, or authoritative sources>

## Curiosity Questions
- <3-5 follow-up questions that naturally extend from what was explained>
```

## Quick Mode (`quick:` prefix)

1-3 paragraphs. No file output. No diagrams. No exercises. Just the answer.

Good for: simple definitions, quick clarifications, yes/no questions, reminders.

## Review Mode (`review:` prefix)

1. Load `learning-log.md` to see what topics were covered
2. Pick 3-5 topics from recent sessions
3. Quiz the user with short questions (not recall-by-rote — test understanding)
4. Based on answers, identify gaps and suggest revisiting specific topics

Example interaction:
```
User: review: last week's topics
Agent: Based on your learning log, you covered: event sourcing, RAFT consensus, and CAP theorem.

Quick check:
1. A system claims to be CP under the CAP theorem. What does it sacrifice during a partition?
2. In event sourcing, what's the difference between a snapshot and replaying events?
3. What happens in RAFT when the leader fails mid-heartbeat?
```

## Code Examples

Use the language most natural to the concept:

| Topic Domain | Default Language |
|-------------|-----------------|
| General programming, algorithms, ML | Python |
| Database concepts, queries | SQL |
| Infrastructure, Kubernetes | YAML + bash |
| Web APIs, HTTP | curl + JSON |
| Systems programming | Go or Rust (briefly) |
| Frontend concepts | JavaScript/TypeScript |
| Language-agnostic concepts | Python |

Always: commented, self-contained, runnable, realistic names (not foo/bar).

## Mermaid Diagrams

Include when the concept involves:
- Workflows or sequences
- Component relationships / architecture
- State transitions
- Decision trees
- Data flow

Keep simple — max 10-12 nodes. Complex diagrams break rendering.

Skip for: simple definitions, straightforward concepts where prose suffices.

## Exercises ("Try It Yourself")

Add 1-2 mini-exercises after explanations. Rules:
- Must test understanding, not just recall
- Should take < 5 minutes
- Provide a hint (collapsed) and a solution (collapsed)
- Make them practical, not academic

```markdown
## Try It Yourself

**Exercise:** [specific task that demonstrates the concept]

<details><summary>💡 Hint</summary>
[breadcrumb without giving the answer]
</details>

<details><summary>✅ Solution</summary>

\`\`\`python
# solution code
\`\`\`

</details>
```

## Further Reading

After the answer, include 2-3 curated references:
- Official documentation (always first if it exists)
- A well-written blog post or tutorial
- The original paper (for academic concepts)

Only include links you're confident are real and authoritative. If unsure about a URL, describe the resource instead: "Search for: 'Raft consensus paper by Ongaro'"

## Learning Log

Maintain `learning-log.md` in the working directory:

```markdown
# Learning Log

| Date | Topic | Difficulty | File |
|------|-------|-----------|------|
| 2026-06-14 | Event Sourcing | Intermediate | qa-2026-06-14.md |
| 2026-06-14 | RAFT Consensus | Advanced | qa-2026-06-14.md |
| 2026-06-13 | Docker layers | Beginner | qa-2026-06-13.md |

## Suggested Next Topics
- How does RAFT handle network partitions? (extends RAFT)
- Event sourcing vs CQRS (extends Event Sourcing)
- Docker multi-stage builds (extends Docker layers)
```

Update after every Full mode answer. "Suggested Next Topics" derives from the curiosity questions of recent sessions.

## Follow-up Questions

After answering in Full mode:
1. Append `## Curiosity Questions` to the file with 3-5 follow-ups
2. Present them interactively: "Would you like me to answer any of these?"
3. If user picks one, answer and append to the same file

## Multiple Questions in One Session

If user asks several questions at once:
- Answer each as a separate `#` heading in the same file
- Put curiosity questions at the very end (covering all questions)

## Tone

- Patient mentor, not textbook
- Use analogies when they genuinely clarify
- Be precise — don't sacrifice accuracy for simplicity
- Address common misconceptions directly
- If a question has a "it depends" answer, explain what it depends on

## Gotchas

- Long answers cause eye-glazing — if the answer exceeds 500 words, add a TL;DR at the top
- Mermaid diagrams with more than 12 nodes often render broken — keep them simple
- Don't over-use analogies — one good analogy per concept, not three forced ones
- "Explain X" doesn't always mean from zero — check if the user used domain terms in their question
- Code examples that require `pip install` should note the dependency
- Quick mode shouldn't trigger file writes — users want ephemeral answers
- The learning log gets stale — only update it for Full mode answers, not quick questions
- Don't link to URLs you're not sure exist — describe the resource instead
