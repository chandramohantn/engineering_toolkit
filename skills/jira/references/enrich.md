# Enrich Ticket

Interactive questioning to flesh out sparse tickets into development-ready tickets.

## When to Use

When a ticket has minimal detail (one-liner, vague summary) and needs to be fleshed out before development begins.

## Process

### Step 1: Read Existing Ticket

Fetch the ticket. Read title, description, priority, components, labels, AC. Understand what exists.

### Step 2: Assess Completeness

- **Minimal** — one-liner, needs full enrichment
- **Partial** — some context exists, gaps in scope/criteria
- **Adequate** — mostly complete, minor refinement

Share assessment before proceeding.

### Step 3: Interactive Questioning

Ask adaptively based on what's missing. 2-4 questions per round, 2-3 rounds typical. Don't ask what the ticket already answers.

**Tier 1 — What & Why:**
- What exactly needs to happen?
- Why is this needed? What problem does it solve?
- Who is affected?

**Tier 2 — Scope & Boundaries:**
- What is in scope / out of scope?
- Dependencies or constraints?
- Known edge cases?

**Tier 3 — Acceptance Criteria:**
- How do we verify this is done?
- Non-functional requirements?

**Tier 4 — Technical Direction (brief):**
- Preferred approach or open?
- Affected components?

### Step 4: Generate Enriched Description

```
h2. Summary
- <what this ticket is about>

h2. Background / Context
- <why needed, problem solved, who affected>

h2. Scope
*In Scope:*
- <item>
*Out of Scope:*
- <item>

h2. Acceptance Criteria
- [ ] <specific, verifiable condition>
- [ ] <condition>

h2. Technical Notes
- <approach, affected components, constraints>

h2. Edge Cases
- <edge case>
```

### Step 5: Confirm & Update

Show enriched content. Wait for user confirmation. Update via API:

```bash
$jira PUT "/issue/PROJ-123" -H "Content-Type: application/json" \
  -d '{"fields": {"description": "...enriched content..."}}'
```

## Guidelines

- Keep tone collaborative, not interrogative
- "TBD" is acceptable for unknowns — better than forcing an answer
- Acceptance criteria must be specific and verifiable
- Preserve useful content from original description
- Don't add implementation details the user didn't provide
