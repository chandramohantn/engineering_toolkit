---
name: jira
description: >-
  JIRA workflows — create issues, search with JQL, update/transition, structured
  comments, worklog with standard format, enrich sparse tickets, extract requirements,
  link issues/epics, and discover project fields. Use whenever the user works with
  JIRA in any way. Trigger on create issue, create story, create bug, create epic,
  new jira ticket, search jira, JQL, find issues, update ticket, change status,
  transition, close issue, add comment, log work, worklog, register hours, enrich
  ticket, extract requirements, link issues, epic link, jira formatting, custom fields,
  jira, eteamproject. Exclude: Confluence operations, GitLab issues, sprint board
  management, release planning.
compatibility: >-
  Requires JIRA_URL and JIRA_TOKEN env vars. Requires curl, jq.
  Optional: JIRA_DEFAULT_PROJECT to skip project selection.
metadata:
  author: ai-engineering-team
  version: "2.0.0"
tags:
  - jira
  - issues
  - jql
  - worklog
---

# JIRA

Unified skill for all JIRA operations. Detect the user's intent and load the relevant reference.

## Setup

```bash
jira="./scripts/jira.sh"
PROJECT="${JIRA_DEFAULT_PROJECT:-}"
```

`jira.sh` calls `${JIRA_URL}/rest/api/2`. Auth: `JIRA_TOKEN` env var (Bearer token), falls back to `.netrc`.

| Variable | Required | Purpose |
|----------|----------|---------|
| `JIRA_URL` | Yes | Jira instance URL (e.g., `https://jira.example.com`) |
| `JIRA_TOKEN` | Yes | Personal access token (Bearer auth) |
| `JIRA_DEFAULT_PROJECT` | No | Skip "which project?" question |

If `JIRA_DEFAULT_PROJECT` is not set, ask the user for the project key before proceeding.

### Project-Specific Defaults

Every project has different mandatory fields. Put project defaults in your AGENTS.md:
```markdown
## JIRA Defaults
- Project: MYPROJECT
- Component: "MyTeam" (required on create)
- Custom field: customfield_XXXXX = VALUE_ID
```

Run discovery commands (see [references/discover.md](references/discover.md)) once to find your project's required fields.

## Intent Routing

| Intent | Triggers | Reference |
|--------|----------|-----------|
| **Create** | create issue, new ticket, create story/bug/epic/task, raise a ticket | [references/create.md](references/create.md) |
| **Search** | search jira, JQL, find issues, my issues, sprint issues | [references/search.md](references/search.md) |
| **Update** | update ticket, change priority/status/labels, transition, close, move to Done | [references/update.md](references/update.md) |
| **Comment** | add comment, log progress, post results, development update | [references/comments.md](references/comments.md) |
| **Worklog** | log work, add worklog, register hours, time spent | [references/worklog.md](references/worklog.md) |
| **Enrich** | enrich ticket, flesh out, add details, ticket is vague, needs AC | [references/enrich.md](references/enrich.md) |
| **Extract** | extract requirements, parse ticket, structured requirements | [references/extract.md](references/extract.md) |
| **Links** | link issues, epic link, parent link, blocks, relates to | [references/links.md](references/links.md) |
| **Discover** | what fields, mandatory fields, custom fields, project setup, createmeta | [references/discover.md](references/discover.md) |

If the intent is clear, load the reference directly. If ambiguous, ask which area.

## Shared Conventions

**Preview before action:** Always show what will be created/updated and wait for user confirmation.

**Priority inference:**
- Blocking/production-down → Highest
- Important, not urgent → High
- Normal work → Medium (default)
- Nice-to-have → Low

**Labels:** Derive 2-4 labels from content. Lowercase, hyphenated (e.g., `ci-cd`, `api-gateway`).

**Formatting:** Use Jira wiki markup: `*bold*`, `_italic_`, `h2. Heading`, `- bullet`, `{code}...{code}`. See [references/formatting.md](references/formatting.md) if unsure.

## Gotchas

- The built-in `create_issue` tool only sends project, type, summary, description. Projects with mandatory custom fields will get 400 — use `$jira` with full field payload instead.
- Labels cannot be set on the create screen in most projects — add them post-creation via update.
- `currentUser()` in JQL only works with authenticated requests — misconfigured auth silently returns empty results.
- JQL field names with spaces must be quoted: `"Epic Link" = PROJ-123`.
- The `/field` endpoint returns 2600+ fields — always filter with jq.
- Epic link field ID varies per JIRA instance — always discover it via API, never hardcode.
- Transitions have IDs that vary per project/workflow — discover them first, then execute.
- Worklogs should go on sub-tasks, not parent stories — ask which sub-task if user provides a story key.
- The agile API (`/rest/agile/1.0/`) has a different base path — `$jira` won't work for it, use curl directly.
