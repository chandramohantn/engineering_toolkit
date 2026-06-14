# Discover Project Fields

Find mandatory fields, custom field IDs, components, issue types, and other project metadata. Run these once per project to configure your defaults.

## Issue Types

```bash
$jira GET "/project/$PROJECT" | jq '.issueTypes[] | {name, id, subtask}'
```

## Required Fields for Creation (Createmeta)

```bash
$jira GET "/issue/createmeta/$PROJECT/issuetypes" | jq '.values[] | {name, id}'
# Then for a specific type:
$jira GET "/issue/createmeta/$PROJECT/issuetypes/$TYPE_ID" | jq '.values[] | select(.required == true) | {name, key, required}'
```

## Components

```bash
$jira GET "/project/$PROJECT/components" | jq '.[] | {name, id}'
```

## Custom Field Values

For fields with allowed values (select lists):
```bash
FIELD_ID="customfield_12310"
$jira GET "/issue/createmeta/$PROJECT/issuetypes/$TYPE_ID" \
  | jq --arg f "$FIELD_ID" '.values[] | select(.fieldId == $f) | .allowedValues[] | {name, id}'
```

## All Fields (filtered)

```bash
# Find field by name
$jira GET "/field" | jq '.[] | select(.name | test("epic"; "i")) | {name, id, custom}'
```

## Priorities

```bash
$jira GET "/priority" | jq '.[] | {name, id}'
```

## Workflows & Transitions

```bash
$jira GET "/issue/PROJ-123/transitions" | jq '.transitions[] | {id, name, to: .to.name}'
```

## Versions (Fix Versions)

```bash
$jira GET "/project/$PROJECT/versions" | jq '.[] | {name, id, released}'
```

## Save Your Defaults

After discovery, save to your AGENTS.md:
```markdown
## JIRA Defaults — PROJECT
- Component: "MyTeam" (id: 12345)
- Product field: customfield_12310, value: "MyProduct" (id: 67890)
- Epic Link field: customfield_10008
- Story type ID: 10001
- Bug type ID: 10004
- Done transition ID: 31
```
