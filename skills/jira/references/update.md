# Update & Transition

## Update Fields

```bash
$jira PUT "/issue/PROJ-123" -H "Content-Type: application/json" \
  -d '{"fields": {"priority": {"name": "High"}, "summary": "New title"}}'
```

### Labels

```bash
# Add
$jira PUT "/issue/PROJ-123" -H "Content-Type: application/json" \
  -d '{"update": {"labels": [{"add": "needs-review"}]}}'
# Remove
$jira PUT "/issue/PROJ-123" -H "Content-Type: application/json" \
  -d '{"update": {"labels": [{"remove": "wontfix"}]}}'
```

### Assign

```bash
$jira PUT "/issue/PROJ-123" -H "Content-Type: application/json" \
  -d '{"fields": {"assignee": {"name": "USERNAME"}}}'
```

### Due Date & Milestone

```bash
$jira PUT "/issue/PROJ-123" -H "Content-Type: application/json" \
  -d '{"fields": {"duedate": "2026-04-15", "fixVersions": [{"name": "v2.1"}]}}'
```

## Transitions (Status Changes)

Transitions move issues through workflow states (To Do → In Progress → Done). Transition IDs vary per project/workflow — always discover first.

### Step 1: Discover available transitions

```bash
$jira GET "/issue/PROJ-123/transitions" | jq '.transitions[] | {id, name, to: .to.name}'
```

Example output:
```json
{"id": "21", "name": "Start Work", "to": "In Progress"}
{"id": "31", "name": "Done", "to": "Done"}
{"id": "41", "name": "Reopen", "to": "To Do"}
```

### Step 2: Execute transition

```bash
$jira POST "/issue/PROJ-123/transitions" -H "Content-Type: application/json" \
  -d '{"transition": {"id": "21"}}'
```

### Step 3: Transition with comment (optional)

```bash
$jira POST "/issue/PROJ-123/transitions" -H "Content-Type: application/json" \
  -d '{
    "transition": {"id": "31"},
    "update": {"comment": [{"add": {"body": "Completed — merged in !42"}}]}
  }'
```

### Common transitions

| Action | Typical Transition Name | Notes |
|--------|------------------------|-------|
| Start work | "Start Work", "In Progress" | |
| Submit for review | "Ready for Review", "In Review" | |
| Complete | "Done", "Close", "Resolve" | May require resolution field |
| Reopen | "Reopen", "Back to Open" | |
| Block | "Blocked" | Set blocker link too |

### With resolution (for Done/Close)

```bash
$jira POST "/issue/PROJ-123/transitions" -H "Content-Type: application/json" \
  -d '{"transition": {"id": "31"}, "fields": {"resolution": {"name": "Done"}}}'
```

## Close Issue (shortcut)

```bash
# Find the "Done" transition ID
DONE_ID=$($jira GET "/issue/PROJ-123/transitions" | jq -r '.transitions[] | select(.to.name == "Done") | .id')
# Execute
$jira POST "/issue/PROJ-123/transitions" -H "Content-Type: application/json" \
  -d "{\"transition\": {\"id\": \"$DONE_ID\"}, \"fields\": {\"resolution\": {\"name\": \"Done\"}}}"
```
