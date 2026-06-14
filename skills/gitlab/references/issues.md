# Issues

Manage GitLab issues via REST API.

## Create

```bash
$gitlab POST "/projects/$PROJECT_ENC/issues" \
  -H "Content-Type: application/json" \
  -d '{"title": "Bug: login fails", "description": "Steps:\n1. ...", "labels": "bug,priority::high", "assignee_ids": [12345]}'
```

For complex descriptions, use a temp file:
```bash
jq -n --arg t "$TITLE" --arg d "$DESC" --arg l "$LABELS" \
  '{title: $t, description: $d, labels: $l}' > /tmp/gl-issue.json
$gitlab POST "/projects/$PROJECT_ENC/issues" -H "Content-Type: application/json" -d @/tmp/gl-issue.json
```

## List

```bash
$gitlab GET "/projects/$PROJECT_ENC/issues?state=opened&per_page=50"
$gitlab GET "/projects/$PROJECT_ENC/issues?labels=bug&state=opened"
$gitlab GET "/projects/$PROJECT_ENC/issues?assignee_username=$USER&per_page=50"
$gitlab GET "/projects/$PROJECT_ENC/issues?search=keyword&per_page=50"
```

## Update

```bash
$gitlab PUT "/projects/$PROJECT_ENC/issues/$IID" \
  -H "Content-Type: application/json" -d '{"title": "Updated title"}'

# Labels
$gitlab PUT "/projects/$PROJECT_ENC/issues/$IID" \
  -H "Content-Type: application/json" -d '{"add_labels": "needs-review"}'
$gitlab PUT "/projects/$PROJECT_ENC/issues/$IID" \
  -H "Content-Type: application/json" -d '{"remove_labels": "wontfix"}'
```

## Assign

```bash
USER_ID=$($gitlab GET "/users?username=$USERNAME" | jq '.[0].id')
$gitlab PUT "/projects/$PROJECT_ENC/issues/$IID" \
  -H "Content-Type: application/json" -d "{\"assignee_ids\": [$USER_ID]}"
```

## Close / Reopen

```bash
$gitlab PUT "/projects/$PROJECT_ENC/issues/$IID" \
  -H "Content-Type: application/json" -d '{"state_event": "close"}'
```

## Comment

```bash
$gitlab POST "/projects/$PROJECT_ENC/issues/$IID/notes" \
  -H "Content-Type: application/json" -d '{"body": "Root cause found."}'
```

## Link to Epic

```bash
$gitlab POST "/groups/$GROUP_ID/epics/$EPIC_IID/issues/$ISSUE_ID"
```

## Due Date and Milestone

```bash
$gitlab PUT "/projects/$PROJECT_ENC/issues/$IID" \
  -H "Content-Type: application/json" -d '{"due_date": "2026-04-15", "milestone_id": 5}'
```
