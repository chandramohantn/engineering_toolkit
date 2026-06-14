# Check Pipeline

Check GitLab CI pipeline status, diagnose failures, and retry.

## Script

```bash
scripts/check-pipeline.sh [options]
```

| Option | Purpose |
|--------|---------|
| (no args) | Latest pipeline for current branch |
| `-b <branch>` | Specific branch |
| `-p <pipeline_id>` | Specific pipeline |
| `-m <mr_iid>` | Latest pipeline for an MR |
| `--log-lines N` | Log lines per failed job (default: 50) |

## Reading Output

First line is `STATUS: <status>`:

| Status | Action |
|--------|--------|
| `success` | Report good news |
| `running` / `pending` | Wait 30s, check again |
| `failed` | Show failed job logs |
| `canceled` / `skipped` | Report, no action needed |
| `NO_PIPELINE` | No pipeline — maybe not pushed yet |

## Retry

**Retry a single failed job** (use for flaky tests, transient runner issues):
```bash
$gitlab POST "/projects/$PROJECT_ENC/jobs/$JOB_ID/retry"
```

**Retry all failed jobs in a pipeline:**
```bash
$gitlab POST "/projects/$PROJECT_ENC/pipelines/$PIPELINE_ID/retry"
```

**Cancel a running pipeline:**
```bash
$gitlab POST "/projects/$PROJECT_ENC/pipelines/$PIPELINE_ID/cancel"
```

## Post-Merge Pipeline

After MR is merged, the pre-merge pipeline is done. Check `main` pipeline:
```bash
$gitlab GET "/projects/$PROJECT_ENC/pipelines?ref=main&per_page=1" | jq '.[0] | {id, status, created_at}'
PIPELINE_ID=$($gitlab GET "/projects/$PROJECT_ENC/pipelines?ref=main&per_page=1" | jq -r '.[0].id')
$gitlab GET "/projects/$PROJECT_ENC/pipelines/$PIPELINE_ID/jobs" | jq '.[] | {name, status, stage}'
```

## Polling Strategy

1. Run script for initial status
2. If running/pending → wait 30s, re-run
3. Max 20 polls (10 minutes) — then give user the web URL
4. After terminal state, report results

## Interpreting Failures

| Pattern in Logs | Likely Cause |
|----------------|-------------|
| Assertion errors, expected vs actual | Test failures |
| file:line + rule name | Lint errors |
| Missing dependencies, compilation errors | Build errors |
| Pull rate limits, auth failures | Docker/registry issues |
| Job exceeded time limit | Timeout — increase limit or optimize |
| "no matching runner" | Runner config issue — escalate |
| Zero failed jobs + instant fail | YAML parsing error |

For YAML errors:
```bash
$gitlab POST "/projects/$PROJECT_ENC/ci/lint" \
  -H "Content-Type: application/json" \
  -d "{\"content\": $(cat .gitlab-ci.yml | jq -Rs .)}" | jq '{valid, errors}'
```
