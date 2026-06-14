# Worklog

Log work on issues with structured format.

## API Call

```bash
$jira POST "/issue/PROJ-123/worklog" -H "Content-Type: application/json" \
  -d '{
    "timeSpent": "6h 30m",
    "started": "2026-04-06T09:00:00.000+0000",
    "comment": "..."
  }'
```

## Standard Format

Every worklog comment MUST follow this structure:

```
## Work Summary — {Month Day, Year}

### {Session Name} ({duration})
- {Specific activity performed}
- {Outcome or deliverable}

### {Session Name} ({duration})
- {Specific activity performed}
```

**Rules:**
- Date: `Month Day, Year` format. Default to today if unspecified.
- Sessions: Group by time block or topic. Durations must sum to total.
- Activities: Specific and actionable — describe WHAT was done.
- Time format: Jira format — `6h 30m`, `4h`, `45m`. Minimum 15m granularity.
- Issue: Log on sub-task, not parent story. Ask which if user gives a story key.
- Started: Use `started` param for past dates. Default 09:00 UTC.

**Good activities:**
- "Implemented retry logic with exponential backoff for API 429 errors"
- "Sprint planning — estimated 12 stories, discussed priorities"
- "Code review of PR #142 — identified missing null checks"

**Bad activities:**
- "Worked on the feature"
- "Meetings"
- "Development"

## Workflow

1. Parse user's request for: issue key, total time, date, activities
2. Format into standard structure
3. Show preview and ask for confirmation
4. Call API with `timeSpent`, `started`, and formatted `comment`

## Multiple Issues

If logging on multiple tasks, create separate worklogs for each. Preview all before logging any.

## Quick Log

For minimal input (e.g., "log 2h on PROJ-123 code review"):

```
## Work Summary — April 6, 2026

### Code Review (2h)
- Reviewed code changes and provided feedback
```

Ask if user wants to add more detail before logging.
