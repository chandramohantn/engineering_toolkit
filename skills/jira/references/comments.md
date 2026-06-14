# Comments

Add comments to issues — plain or structured.

## Add Comment

```bash
$jira POST "/issue/PROJ-123/comment" -H "Content-Type: application/json" \
  -d '{"body": "Root cause found — session timeout config was wrong."}'
```

## List Comments

```bash
$jira GET "/issue/PROJ-123/comment" | jq '.comments[] | {author: .author.displayName, created, body}'
```

## Structured Development Comment

When updating a ticket with development results, use this format:

```
h2. Development Update — {date}

*Summary*
{One paragraph — what was done}

*Changes*
- {file/component}: {what changed}
- {file/component}: {what changed}

*Tests*
- {test description} — {pass/fail}

*Review Status:* {Reviewed / Pending / Changes Requested}

*Next Steps*
- {remaining work or "None — complete"}
```

## Progress Comment

For logging progress mid-work:

```
h3. Progress — {date}

*Done:*
- {completed item}
- {completed item}

*In Progress:*
- {current work}

*Blocked:*
- {blocker} (linked to {PROJ-XXX})
```

## Comment Formatting

- Use `*bold*` for headings within comments
- Use `- ` for bullet points
- Use `{code:java}...{code}` for code snippets
- Use `[link text|URL]` for links
- Use `{color:red}text{color}` for highlighting
