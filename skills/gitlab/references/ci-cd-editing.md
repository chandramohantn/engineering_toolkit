# CI/CD Editing

Edit `.gitlab-ci.yml` — add jobs, modify rules, manage stages, and configure variables.

## Common Edits

### Add a job

```yaml
my-new-job:
  stage: test
  image: python:3.11
  script:
    - pip install -r requirements.txt
    - pytest
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
```

### Add a stage

Stages must be declared in order:
```yaml
stages:
  - build
  - test
  - deploy   # add new stage here
```

### Change job rules

Common rule patterns:
```yaml
rules:
  - if: $CI_COMMIT_BRANCH == "main"           # only on main
  - if: $CI_PIPELINE_SOURCE == "merge_request_event"  # only in MRs
  - if: $CI_COMMIT_TAG =~ /^v[0-9]/           # only on version tags
  - when: manual                               # manual trigger
  - changes: ["src/**/*"]                      # only when files change
```

### Include external configs

```yaml
include:
  - local: .gitlab/ci/tests.yml
  - project: 'my-group/my-templates'
    ref: main
    file: '/templates/deploy.yml'
  - component: $CI_SERVER_FQDN/my-org/my-component@1.0.0
    inputs:
      stage: build
```

## CI/CD Variables

### List project variables

```bash
$gitlab GET "/projects/$PROJECT_ENC/variables" | jq '.[] | {key, masked, protected}'
```

### Create/Update variable

```bash
$gitlab POST "/projects/$PROJECT_ENC/variables" \
  -H "Content-Type: application/json" \
  -d '{"key": "MY_VAR", "value": "secret", "masked": true, "protected": true}'

$gitlab PUT "/projects/$PROJECT_ENC/variables/MY_VAR" \
  -H "Content-Type: application/json" \
  -d '{"value": "new-value"}'
```

### Delete variable

```bash
$gitlab DELETE "/projects/$PROJECT_ENC/variables/MY_VAR"
```

## Validate YAML

```bash
$gitlab POST "/projects/$PROJECT_ENC/ci/lint" \
  -H "Content-Type: application/json" \
  -d "{\"content\": $(cat .gitlab-ci.yml | jq -Rs .)}" | jq '{valid, errors}'
```

## Common Patterns

**Cache:**
```yaml
cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths: [node_modules/, .cache/]
```

**Artifacts:**
```yaml
artifacts:
  paths: [dist/]
  expire_in: 1 week
  reports:
    junit: report.xml
```

**Services (e.g., database for tests):**
```yaml
services:
  - postgres:15
variables:
  POSTGRES_DB: test
  POSTGRES_USER: runner
  POSTGRES_PASSWORD: ""
```
