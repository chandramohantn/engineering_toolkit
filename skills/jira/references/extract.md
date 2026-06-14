# Extract Requirements

Extract structured engineering requirements from a Jira ticket for planning purposes.

## When to Use

When ingesting a ticket to produce structured requirements for technical planning, sprint grooming, or handoff.

## Process

1. Fetch the ticket (ID, title, description, comments, fields)
2. Extract and structure the information below
3. Present to user for validation

## Output Structure

```markdown
## Requirement: PROJ-123 — {title}

### Summary
{One sentence — what needs to be built/changed}

### Requirements
1. {Discrete, actionable requirement}
2. {Requirement}
3. {Requirement}

### Acceptance Criteria
- [ ] {Specific, verifiable condition}
- [ ] {Condition}

### Technical Constraints
- {Constraint from description or comments}
- {Dependency}

### Affected Components
- {Component/module/service}

### Priority: {from ticket field}

### Open Questions
- {Anything unclear or missing from the ticket}
```

## Guidelines

- Extract requirements as discrete, actionable items (not paragraphs)
- If AC are not explicit, infer from description — flag as "inferred"
- Check comments for additional constraints or context
- Note absent fields as "Not specified" rather than inventing content
- Open questions section highlights what's unclear — surfaces gaps early
