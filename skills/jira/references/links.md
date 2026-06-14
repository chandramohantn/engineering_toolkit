# Links & Epics

Link issues together, manage epic relationships, and set parent/child hierarchy.

## Issue Links

```bash
$jira POST "/issueLink" -H "Content-Type: application/json" \
  -d '{
    "type": {"name": "Blocks"},
    "inwardIssue": {"key": "PROJ-123"},
    "outwardIssue": {"key": "PROJ-456"}
  }'
```

### Link Types

| Type | Inward | Outward |
|------|--------|---------|
| Blocks | is blocked by | blocks |
| Relates | relates to | relates to |
| Duplicates | is duplicated by | duplicates |
| Cloners | is cloned by | clones |

## Epic Link

```bash
# Find the Epic Link field ID (varies per instance)
EPIC_FIELD=$($jira GET "/field" | jq -r '.[] | select(.name == "Epic Link") | .id')

# Link issue to epic
$jira PUT "/issue/PROJ-456" -H "Content-Type: application/json" \
  -d "{\"fields\": {\"$EPIC_FIELD\": \"PROJ-100\"}}"
```

## Parent Link (Sub-task)

```bash
# Create sub-task with parent
$jira POST "/issue" -H "Content-Type: application/json" \
  -d '{"fields": {"project": {"key": "PROJ"}, "issuetype": {"name": "Sub-task"}, "parent": {"key": "PROJ-123"}, "summary": "Sub-task title"}}'
```

## List Links on an Issue

```bash
$jira GET "/issue/PROJ-123?fields=issuelinks" \
  | jq '.fields.issuelinks[] | {type: .type.name, inward: .inwardIssue.key, outward: .outwardIssue.key}'
```

## Remove Link

```bash
# Get link ID first
LINK_ID=$($jira GET "/issue/PROJ-123?fields=issuelinks" | jq -r '.fields.issuelinks[0].id')
$jira DELETE "/issueLink/$LINK_ID"
```
