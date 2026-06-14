---
name: daily-summary
description: >-
  Summarize everything the user did across Jira, GitLab, and Confluence.
  Covers issues created/updated/closed, MRs opened/merged/reviewed, commits,
  and wiki pages edited. Supports daily, weekly, and sprint rollups.
  Produces standup-ready output with personality (ranks + fun stats).
  Trigger on "what did I do today", "daily summary", "standup notes", "my activity",
  "what have I done", "summarize my day", "standup", "daily standup", "show my work",
  "weekly summary", "what did I do this week", "sprint summary", "my contributions".
  Exclude: creating issues, updating issues, searching for specific items, time logging.
compatibility: >-
  Requires GITLAB_TOKEN and JIRA_TOKEN env vars, curl, jq.
  Optional: CONFLUENCE_TOKEN for wiki activity.
  Configure GITLAB_URL and JIRA_URL env vars for your instance.
metadata:
  author: ai-engineering-team
  version: "2.0.0"
tags:
  - daily-summary
  - standup
  - activity
---

# Daily Summary

Aggregate the user's activity across Jira, GitLab, and Confluence into a standup-ready summary with personality. Supports daily (default), weekly, and sprint rollup modes.

## Configuration

The skill uses environment variables for platform URLs. This makes it portable across organizations.

| Variable | Required | Default | Purpose |
|----------|----------|---------|---------|
| `GITLAB_URL` | Yes | `https://gitlab.com` | GitLab instance base URL |
| `GITLAB_TOKEN` | Yes | — | GitLab personal access token |
| `JIRA_URL` | Yes | — | Jira instance base URL (e.g., `https://jira.example.com`) |
| `JIRA_TOKEN` | Yes | — | Jira Bearer token |
| `CONFLUENCE_URL` | No | — | Confluence instance URL (enables wiki activity) |
| `CONFLUENCE_TOKEN` | No | — | Confluence Bearer token |

If a token is missing, skip that platform gracefully and note it in the output.

## Behavior

### Step 1: Determine Time Window

- Default: last 16 hours (covers a workday)
- User can say "last 3 days", "this week", "this sprint", "yesterday"
- For weekly: last 7 days, group output by day
- For sprint: last 14 days, group output by theme/epic

### Step 2: Resolve Username

```bash
GL_USER=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "$GITLAB_URL/api/v4/user" | jq -r '.username')
```

If this fails, ask the user for their username. Don't proceed without it.

### Step 3: Query All Platforms (in parallel)

Run all available platform queries simultaneously. Skip any platform where the token is not configured.

#### Jira Activity

```bash
JIRA_API="$JIRA_URL/rest/api/2"
HOURS=16  # adjust based on time window

# Issues created
curl -s -H "Authorization: Bearer $JIRA_TOKEN" \
  "$JIRA_API/search?jql=reporter%3D${USER}+AND+created+>%3D+-${HOURS}h+ORDER+BY+created+DESC&maxResults=30&fields=summary,status,issuetype,project,priority"

# Issues updated/worked on
curl -s -H "Authorization: Bearer $JIRA_TOKEN" \
  "$JIRA_API/search?jql=(reporter%3D${USER}+OR+assignee%3D${USER})+AND+updated+>%3D+-${HOURS}h+ORDER+BY+updated+DESC&maxResults=30&fields=summary,status,issuetype,project,priority"

# Issues closed/resolved
curl -s -H "Authorization: Bearer $JIRA_TOKEN" \
  "$JIRA_API/search?jql=assignee%3D${USER}+AND+status+changed+to+(Done,Closed)+after+-${HOURS}h+ORDER+BY+updated+DESC&maxResults=30&fields=summary,status,issuetype,project,priority"
```

#### GitLab MRs

```bash
GL="$GITLAB_URL/api/v4"
AFTER=$(date -u -v-${HOURS}H +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -d "${HOURS} hours ago" +%Y-%m-%dT%H:%M:%SZ)

# MRs authored
curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "$GL/merge_requests?author_username=${GL_USER}&updated_after=$AFTER&scope=all&state=all&per_page=30"

# MRs reviewed
curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "$GL/merge_requests?reviewer_username=${GL_USER}&updated_after=$AFTER&scope=all&state=all&per_page=30"
```

#### GitLab Issues

```bash
# Issues authored
curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "$GL/issues?author_username=${GL_USER}&updated_after=$AFTER&scope=all&per_page=30"

# Issues assigned and updated
curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "$GL/issues?assignee_username=${GL_USER}&updated_after=$AFTER&scope=all&per_page=30"
```

#### Confluence Activity (optional — only if CONFLUENCE_TOKEN is set)

```bash
# Pages created/updated by user
curl -s -H "Authorization: Bearer $CONFLUENCE_TOKEN" \
  "$CONFLUENCE_URL/rest/api/content?type=page&expand=version,space&limit=20" \
  | jq --arg user "$USER" '[.results[] | select(.version.by.username == $user and .version.when > "'$AFTER'")]'
```

### Step 4: Fetch Enrichments

**Commit count** (via events API — note: may overcount force-pushes):
```bash
curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "$GL/users/${GL_USER}/events?action=pushed&after=$(date -v-1d +%Y-%m-%d)&per_page=50" \
  | jq '[.[].push_data.commit_count // 0] | add'
```

**Line stats** — use MR stats endpoint (fast, reliable) instead of parsing diffs:
```bash
# For each MR, get additions/deletions from the MR detail
curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "$GL/projects/$PID/merge_requests/$IID?include_diverged_commits_count=false" \
  | jq '{additions: .changes_count, diff_stats: {additions, deletions}}'
```

If the stats endpoint returns null (draft MRs, very large MRs), fall back to showing "stats unavailable" rather than crashing.

### Step 5: Compute Daily Rank

Rank is weighted by impact, not just count:

| Points | Activity |
|--------|----------|
| 3 | MR merged |
| 2 | MR opened / Issue closed |
| 1 | MR reviewed / Issue updated / Comment added |
| 1 | Confluence page created/updated |
| 0.5 | Per 50 lines changed |

| Total Points | Rank |
|-------------|------|
| 0 | 💀 Ghost Mode |
| 1-3 | 🧘 Chill Day |
| 4-7 | 👷 Solid Day |
| 8-12 | ⚡ Productive |
| 13-18 | 🔥 On Fire |
| 19+ | 🚀 Unstoppable |

### Step 6: Write Narrative Summary

Generate a 2-4 sentence narrative paragraph that captures WHAT the user accomplished and WHY it matters. Guidelines:

- Synthesize from MR titles + Jira issue summaries — don't just list them
- Focus on outcomes ("Fixed X which was causing Y") not actions ("Opened a MR")
- Group related items ("Worked on the payment pipeline — fixed a bug and added retry logic")
- If the day was review-heavy, say so ("Spent the day reviewing team contributions")
- Keep it conversational — this goes into standup messages

**Good:** "Fixed the publish pipeline for community skills — tags were parsed as characters instead of comma-separated values. Reviewed the tr-solution-finder contribution and got it published."

**Bad:** "Created MR !12. Updated MR !13. Reviewed MR !7."

### Step 7: Compute Fun Stats

Pick 2-3 that apply (most relevant first):

- More deletions than additions: "🎉 Net negative — cleaned up more than you wrote"
- All MRs merged: "✅ Perfect merge rate"
- Activity across 3+ repos: "🌍 Cross-repo warrior"
- First and last activity timestamps: "⏰ 08:12 → 17:45 (9h spread)"
- Single repo focus: "🎯 Laser-focused on {repo}"
- Lots of reviews: "👀 Review machine — {N} MRs reviewed"
- Big MR: "🐘 Biggest MR: {title} (+{N}/-{N})"
- Jira-heavy day: "📋 Jira day — {N} issues touched"
- Zero Jira: "🎧 Heads-down coding — zero Jira interruptions"
- Confluence pages: "📝 Doc warrior — {N} pages updated"
- High priority closes: "🎯 Crushed {N} high-priority issues"

## Output Format

### Daily (default)

```markdown
## April 10 — ⚡ Productive

Fixed the publish pipeline for community skills — tags were parsed as
characters instead of comma-separated values. Reviewed the tr-solution-finder
contribution and got it published to DevPortal.

| MR | Repo | Title | Status | +/- |
|---|---|---|---|---|
| !12 | agenthub-community | 🐛 Fix publish tags | Merged | +4/-1 |
| !13 | agenthub-community | 🐛 Fix owner format | Merged | +5/-3 |
| !7  | agenthub-community | ✨ Add tr-solution-finder | Reviewed | +147/-0 |

**4 MRs · +251/-38 · 12 commits · 2 repos**
📊 Net negative — cleaned up more · ⏰ 08:12 → 17:45 · 👀 2 MRs reviewed
```

### Weekly Rollup

```markdown
## Week of April 7–11 — 🔥 On Fire (total: 32 points)

### Narrative
Focused on pipeline reliability and community contributions. Fixed 3 bugs
in the publish workflow, reviewed 8 community MRs, and shipped the new
skill discovery feature.

### Day-by-Day
| Day | Rank | MRs | Issues | Highlights |
|-----|------|-----|--------|-----------|
| Mon | ⚡ | 3 | 2 | Pipeline fixes |
| Tue | 👷 | 1 | 3 | Jira grooming |
| Wed | 🔥 | 5 | 1 | Community reviews |
| Thu | ⚡ | 2 | 2 | Skill discovery feature |
| Fri | 🧘 | 1 | 0 | Documentation |

### Totals
**12 MRs · 8 issues closed · +890/-234 · 47 commits · 5 repos**
```

## Error Handling

Graceful degradation — never crash, always produce what you can:

| Failure | Behavior |
|---------|----------|
| GITLAB_TOKEN missing/invalid | Skip GitLab. Note: "⚠️ GitLab unavailable (token issue)" |
| JIRA_TOKEN missing/invalid | Skip Jira. Note: "⚠️ Jira unavailable (token issue)" |
| CONFLUENCE_TOKEN not set | Skip silently (it's optional) |
| API returns empty | Show the section as empty, don't omit it — "No MRs today" is valid data |
| API timeout | Retry once, then skip with note |
| Username resolution fails | Ask the user for their username before proceeding |

Always show which platforms were queried successfully at the end:
```
---
*Sources: ✅ GitLab ✅ Jira ⚠️ Confluence (not configured)*
```

## Rules

- Header: date + rank emoji and label
- Summary paragraph: synthesized narrative, 2-4 sentences (see Step 6)
- Table: every MR, sorted by repo then MR number
- Totals line: MR count, total +/-, commit count, repo count
- Fun stats line: 2-3 applicable stats separated by ·
- Skip empty sections entirely (except note "No activity" if everything is empty)
- Deduplicate: if an item appears in both "created" and "updated", show only in "created"
- Weekly mode: group by day, show per-day ranks, aggregate totals at bottom

## Gotchas

- `date -v` is macOS-specific; the `date -d` fallback handles Linux. In containers, use `date -d`.
- GitLab `updated_after` is inclusive — items updated exactly at the boundary are included
- `currentUser()` in JQL only works with authenticated requests — if auth fails it silently returns empty
- Force-pushes create multiple push events — commit count may overcount. Note this in output if count seems high.
- Some GitLab instances use `Private-Token` header, others use `Authorization: Bearer`. Try `Private-Token` first.
- Confluence REST API pagination: default limit is 25. For active doc writers, increase to 50.
- MR `changes_count` returns null for MRs with no commits yet (drafts) — handle gracefully
- Jira cloud vs server have different API paths (`/rest/api/2` vs `/rest/api/latest`) — document which is expected
