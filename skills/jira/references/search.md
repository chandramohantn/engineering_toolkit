# Search Issues (JQL)

Use the built-in `search_issues` tool for simple queries. Use `$jira` for specific fields or pagination.

## Common JQL Patterns

```sql
-- My open issues
assignee = currentUser() AND resolution = Unresolved ORDER BY updated DESC

-- Created by me
reporter = currentUser() AND project = PROJECT ORDER BY created DESC

-- Sprint issues
project = PROJECT AND sprint in openSprints() ORDER BY rank

-- Recent activity
project = PROJECT AND updated >= -7d ORDER BY updated DESC

-- Issues in epic
"Epic Link" = PROJECT-1234

-- Unresolved bugs
project = PROJECT AND issuetype = Bug AND resolution = Unresolved ORDER BY priority DESC

-- By component
project = PROJECT AND component = "ComponentName" AND resolution = Unresolved

-- By label
project = PROJECT AND labels = "my-label" ORDER BY updated DESC

-- Text search
project = PROJECT AND text ~ "search term"

-- Status changed recently
project = PROJECT AND status changed AFTER -7d

-- Date range
project = PROJECT AND created >= "2025-01-01" AND created <= "2025-03-31"
```

## Via API

```bash
JQL_ENC=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$JQL'))")
$jira GET "/search?jql=$JQL_ENC&maxResults=50&fields=summary,status,assignee,priority"
```

## Pagination

```bash
$jira GET "/search?jql=$JQL_ENC&maxResults=50&startAt=0"   # page 1
$jira GET "/search?jql=$JQL_ENC&maxResults=50&startAt=50"  # page 2
```

Response includes `total` — continue while `startAt + maxResults < total`.

## Useful Fields Parameter

```
fields=summary,status,assignee,priority,components,labels,fixVersions,created,updated
```
