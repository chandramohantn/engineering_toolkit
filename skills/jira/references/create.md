# Create Issues

## Workflow

1. Check AGENTS.md for project defaults (required fields, component, custom fields)
2. If not found, load [discover.md](discover.md) to find mandatory fields
3. Preview the issue for the user — confirm before creating
4. Create via `$jira` with all required fields
5. Add labels post-creation (most projects can't set labels on create)
6. Present URL: `${JIRA_URL}/browse/PROJECT-XXXX`

## Create via API

```bash
$jira POST "/issue" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "project": {"key": "'"$PROJECT"'"},
      "issuetype": {"name": "Story"},
      "summary": "...",
      "description": "...",
      "components": [{"name": "COMPONENT_NAME"}],
      "priority": {"name": "Medium"}
    }
  }'
```

Custom fields use their field ID:
```json
{"customfield_12310": {"id": "VALUE_ID"}, "customfield_99999": "free text"}
```

## Description Template

```
*Problem Statement*
<crisp description — what's wrong or what's needed>

*Acceptance Criteria*
- <criterion 1 — specific, verifiable>
- <criterion 2>

*Technical Notes*
- <relevant constraints or approach hints>
```

## Create Epic

```bash
$jira POST "/issue" -H "Content-Type: application/json" \
  -d '{"fields": {"project": {"key": "'"$PROJECT"'"}, "issuetype": {"name": "Epic"}, "summary": "...", "customfield_EPIC_NAME": "Epic Name"}}'
```

## Create Sub-task

```bash
$jira POST "/issue" -H "Content-Type: application/json" \
  -d '{"fields": {"project": {"key": "'"$PROJECT"'"}, "issuetype": {"name": "Sub-task"}, "summary": "...", "parent": {"key": "PROJ-123"}}}'
```

## Add Labels (post-creation)

```bash
$jira PUT "/issue/PROJ-123" -H "Content-Type: application/json" \
  -d '{"update": {"labels": [{"add": "ci-cd"}, {"add": "api-gateway"}]}}'
```
