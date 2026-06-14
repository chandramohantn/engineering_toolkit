---
name: gitlab
description: >-
  GitLab workflows for everyday developers — MRs, pipelines, issues, CI/CD editing,
  CI/CD components, project management, and releases. Use whenever the user works
  with GitLab in any way. Trigger on create MR, push MR, fix MR, merge MR, review MR,
  check pipeline, pipeline failed, retry pipeline, create issue, list issues, close issue,
  edit gitlab-ci, add CI job, create component, publish component, convert template,
  create release, tag version, gitlab api, glab, gitlab.
  Exclude: Jira operations, Gerrit workflows, Spinnaker pipelines, Jenkins builds.
compatibility: >-
  Requires GITLAB_TOKEN env var or .netrc entry for the GitLab host. Requires curl, jq, git.
  Set GITLAB_URL env var for non-gitlab.com instances.
metadata:
  author: ai-engineering-team
  version: "2.0.0"
tags:
  - gitlab
  - merge-requests
  - pipelines
  - ci-cd
---

# GitLab

Unified skill for all GitLab developer workflows. Detect the user's intent and load the relevant reference.

## Setup

```bash
gitlab="./scripts/gitlab.sh"
PROJECT_ENC=$(git remote get-url origin | sed -E 's#.*gitlab[^/:]*[/:]##;s#\.git$##' | sed 's|/|%2F|g')
BRANCH=$(git branch --show-current)
```

Auth priority: `GITLAB_TOKEN` env var → `~/.netrc` entry. The script auto-detects the GitLab host from git remote.

### URL extraction

When the user provides a GitLab URL like `https://gitlab.example.com/group/project/-/merge_requests/42`:
- Everything between hostname and `/-/` is the project path
- URL-encode slashes as `%2F` for API calls

## Intent Routing

| Intent | Triggers | Reference |
|--------|----------|-----------|
| **MR lifecycle** | create MR, push MR, fix MR, review MR, merge MR, auto-merge, list my MRs, MR diff | [references/merge-requests.md](references/merge-requests.md) |
| **Pipeline** | check pipeline, pipeline failed, retry pipeline, CI status, watch pipeline, why did build fail | [references/check-pipeline.md](references/check-pipeline.md) |
| **Issues** | create issue, list issues, close issue, assign issue, comment, link epic | [references/issues.md](references/issues.md) |
| **CI/CD editing** | edit gitlab-ci, add job, modify pipeline, add stage, change rules, CI/CD variables | [references/ci-cd-editing.md](references/ci-cd-editing.md) |
| **CI/CD components** | create component, publish component, convert template, component inputs, CI/CD catalog | [references/ci-cd-components.md](references/ci-cd-components.md) |
| **Project mgmt** | avatar, transfer project, rename, create group, set description | [references/project-management.md](references/project-management.md) |
| **Releases** | create release, tag version, changelog, publish release | [references/releases.md](references/releases.md) |

If the intent is clear, load the reference directly. If ambiguous, ask which area.

## Gotchas

- **Pagination:** API returns max `per_page=100`. For full results, follow `x-next-page` header or use `page=N` loop. Most listing commands here use `per_page=50` which is fine for typical use — warn user if results might be truncated.
- **Project path encoding:** Slashes in project paths MUST be `%2F` encoded for API — `my-group/my-project` → `my-group%2Fmy-project`.
- **Auth header:** Some instances need `PRIVATE-TOKEN` header, others accept `Authorization: Bearer`. The `gitlab.sh` script uses `PRIVATE-TOKEN` by default.
- **MR description templates:** If `.gitlab/merge_request_templates/` exists in the repo, use the default template content as MR description base.
- **Branch protection:** Before attempting merge, always check `approvals_left` — protected branches silently reject merge if approvals are insufficient.
- **Auto-merge requires approval first:** Always approve BEFORE setting `merge_when_pipeline_succeeds=true` — otherwise it blocks on `not_approved`.
- **Post-merge pipelines:** After merge, check the pipeline on `main` (not the MR pipeline) for deploy/publish jobs.
- **Retry vs Re-run:** Retrying a job re-runs just that job. Retrying a pipeline re-runs all failed jobs. Use job retry for flaky tests.
- **Date format:** All API date parameters use ISO 8601: `2026-01-15T10:30:00Z`. Use `date -u +%Y-%m-%dT%H:%M:%SZ`.
- **`glab` CLI vs API:** When using glab MCP tools, pass the `--repo` flag on every call — it defaults to a different repo.
