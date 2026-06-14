# Merge Requests

Full MR lifecycle — create, fix, review, merge. Detect which phase the user needs.

## List My MRs

```bash
# All projects — my open MRs
$gitlab GET "/merge_requests?state=opened&scope=all&per_page=50" \
  | jq '.[] | {iid, title, project: .references.full, web_url}'

# Specific project
$gitlab GET "/projects/$PROJECT_ENC/merge_requests?state=opened&author_username=$GL_USER&per_page=50" \
  | jq '.[] | {iid, title, web_url}'
```

## Create MR

1. Abort if on `main` or `master`
2. Check `git status --porcelain` — if changes, stage and commit
3. Rebase if behind: `git fetch origin main --quiet && git rebase origin/main`
4. Push: `git push -u origin $BRANCH` (use `--force-with-lease` if rebased)
5. Check for existing MR — if found, update it:
   ```bash
   $gitlab GET "/projects/$PROJECT_ENC/merge_requests?source_branch=$BRANCH&state=opened" | jq '.[0]'
   ```
6. **Check for MR templates:**
   ```bash
   # Look for default template
   if [ -f ".gitlab/merge_request_templates/Default.md" ]; then
     TEMPLATE=$(cat .gitlab/merge_request_templates/Default.md)
   fi
   ```
7. Create MR if none exists:
   ```bash
   $gitlab POST "/projects/$PROJECT_ENC/merge_requests" \
     -H "Content-Type: application/json" \
     -d "$(jq -n \
       --arg title "$(git log origin/main..HEAD --format='%s' -1)" \
       --arg source "$BRANCH" \
       --arg desc "${TEMPLATE:-$(git log origin/main..HEAD --format='%b' -1)}" \
       '{title: $title, source_branch: $source, target_branch: "main", description: $desc, remove_source_branch: true}')"
   ```

After creating, poll pipeline with `scripts/check-pipeline.sh -m $MR_IID`.

## Fix MR

Diagnose and fix blockers to get the MR mergeable.

### Gather status dashboard

```bash
$gitlab GET "/projects/$PROJECT_ENC/merge_requests/$MR_IID" \
  | jq '{state, detailed_merge_status, has_conflicts}'
$gitlab GET "/projects/$PROJECT_ENC/merge_requests/$MR_IID/pipelines" \
  | jq '.[0] | {id, status, web_url}'
$gitlab GET "/projects/$PROJECT_ENC/merge_requests/$MR_IID/discussions" \
  | jq '[.[] | select(.notes[0].resolvable == true and .notes[0].resolved == false)]'
$gitlab GET "/projects/$PROJECT_ENC/merge_requests/$MR_IID/approvals" \
  | jq '{approved, approvals_required, approvals_left}'
```

Present:
```
MR !{iid}: {title}
Pipeline:    ✅ success | ❌ failed | 🔄 running
Rebase:      ✅ clean | ⚠️ needed
Conflicts:   ✅ none | ❌ has conflicts
Discussions: ✅ all resolved | ⚠️ N unresolved
Approvals:   ✅ approved | ⚠️ N more needed
```

### Handle unresolved discussions

```bash
# Reply to discussion
$gitlab POST "/projects/$PROJECT_ENC/merge_requests/$MR_IID/discussions/$DISCUSSION_ID/notes" \
  --data-urlencode "body=$REPLY"
# Resolve
$gitlab PUT "/projects/$PROJECT_ENC/merge_requests/$MR_IID/discussions/$DISCUSSION_ID?resolved=true"
```

### Handle rebase

```bash
$gitlab PUT "/projects/$PROJECT_ENC/merge_requests/$MR_IID/rebase"
# Poll until rebase_in_progress == false
```

### Handle pipeline failures

```bash
PIPELINE_ID=$($gitlab GET "/projects/$PROJECT_ENC/merge_requests/$MR_IID/pipelines" | jq -r '.[0].id')
$gitlab GET "/projects/$PROJECT_ENC/pipelines/$PIPELINE_ID/jobs?scope[]=failed" \
  | jq '.[] | {id, name, stage, web_url}'
# Get job log
$gitlab GET "/projects/$PROJECT_ENC/jobs/$JOB_ID/trace" | tail -50
```

**Retry a failed job:**
```bash
$gitlab POST "/projects/$PROJECT_ENC/jobs/$JOB_ID/retry"
```

**Retry entire pipeline (all failed jobs):**
```bash
$gitlab POST "/projects/$PROJECT_ENC/pipelines/$PIPELINE_ID/retry"
```

If zero failed jobs (instant pipeline fail), YAML failed to parse:
```bash
$gitlab POST "/projects/$PROJECT_ENC/ci/lint" \
  -H "Content-Type: application/json" \
  -d "{\"content\": $(cat .gitlab-ci.yml | jq -Rs .)}" | jq '{valid, errors}'
```

### Handle conflicts

Report "manual resolution needed" — conflicts require local merge/rebase.

## Review MR

```bash
# View diff
$gitlab GET "/projects/$PROJECT_ENC/merge_requests/$MR_IID/changes" \
  | jq '[.changes[] | {old_path, new_path, new_file, deleted_file}]'

# Inline comment
DIFF_REFS=$($gitlab GET "/projects/$PROJECT_ENC/merge_requests/$MR_IID" | jq '.diff_refs')
$gitlab POST "/projects/$PROJECT_ENC/merge_requests/$MR_IID/discussions" \
  -H "Content-Type: application/json" \
  -d "$(echo "$DIFF_REFS" | jq \
    --arg body "$COMMENT" --arg path "$FILE_PATH" --argjson line $LINE \
    '{body: $body, position: {base_sha: .base_sha, head_sha: .head_sha, start_sha: .start_sha, position_type: "text", new_path: $path, new_line: $line}}')"

# General comment
$gitlab POST "/projects/$PROJECT_ENC/merge_requests/$MR_IID/notes" --data-urlencode "body=$COMMENT"

# Approve
$gitlab POST "/projects/$PROJECT_ENC/merge_requests/$MR_IID/approve"
```

## Merge MR

### Pre-merge checks (all must pass)

```bash
$gitlab GET "/projects/$PROJECT_ENC/merge_requests/$MR_IID" \
  | jq '{state, detailed_merge_status, has_conflicts}'
$gitlab GET "/projects/$PROJECT_ENC/merge_requests/$MR_IID/approvals" \
  | jq '{approved, approvals_required, approvals_left}'
```

| Check | Blocker Action |
|-------|---------------|
| Already merged | Report and stop |
| Has conflicts | Report — run fix MR |
| Unresolved discussions | Report — run fix MR |
| Pipeline failed | Report — run fix MR |
| Approvals insufficient | Report who needs to approve — cannot override |

### Execute merge

```bash
$gitlab POST "/projects/$PROJECT_ENC/merge_requests/$MR_IID/approve"
$gitlab PUT "/projects/$PROJECT_ENC/merge_requests/$MR_IID/rebase"
$gitlab PUT "/projects/$PROJECT_ENC/merge_requests/$MR_IID/merge?should_remove_source_branch=true"
```

### Auto-merge (merge when pipeline succeeds)

```bash
$gitlab POST "/projects/$PROJECT_ENC/merge_requests/$MR_IID/approve"
$gitlab PUT "/projects/$PROJECT_ENC/merge_requests/$MR_IID/merge?merge_when_pipeline_succeeds=true&should_remove_source_branch=true"
```
