# CI/CD Components

Create reusable pipeline components with typed inputs, versioning, and catalog publishing.

## Scaffold

```bash
scripts/init-component.sh <name> [output-dir] [--multi]
```

- Default: single-component project layout
- `--multi`: multi-component layout (multiple templates in one repo)

## Directory Structure

**Single component:**
```
my-component/
├── templates/my-component/template.yml
├── .gitlab-ci.yml
├── README.md
└── LICENSE.md
```

**Multi-component:**
```
my-components/
├── templates/
│   ├── build/template.yml
│   ├── test/template.yml
│   └── deploy/template.yml
├── .gitlab-ci.yml
└── README.md
```

## Writing a Component

Every component starts with a `spec:` block, separated from jobs by `---`:

```yaml
spec:
  inputs:
    stage:
      default: test
      description: "Pipeline stage"
    image_tag:
      default: latest
    enable_cache:
      type: boolean
      default: false
---

my-job:
  stage: $[[ inputs.stage ]]
  image: my-tool:$[[ inputs.image_tag ]]
  script:
    - run-tool
```

### Input types

| Type | Example | Notes |
|------|---------|-------|
| `string` | `default: "latest"` | Default type |
| `number` | `default: 10` | |
| `boolean` | `default: false` | Use with extends pattern |
| `array` | `default: [{when: on_success}]` | For rules |

Restrict with `options:` or `regex:`.

### Key rules

- No global keywords (`default:`, `stages:`, `workflow:`) — they bleed into consumer pipelines
- Use `$[[ inputs.stage ]]` — never hardcode stages
- Use `$CI_SERVER_FQDN` not hardcoded domains
- Use `$CI_API_V4_URL` not hardcoded API URLs
- Secrets go in CI/CD variables, not inputs (inputs are visible in config)

## Testing

Include from current commit:
```yaml
include:
  - component: $CI_SERVER_FQDN/$CI_PROJECT_PATH/my-component@$CI_COMMIT_SHA
    inputs:
      stage: test
stages: [test, release]
```

## Publishing

1. Enable catalog: Settings → General → toggle "CI/CD Catalog project"
2. Ensure project has description + README + component in `templates/`
3. Tag and push:
   ```bash
   git tag 1.0.0 && git push origin 1.0.0
   ```

### Versioning

- Major: breaking (removed/renamed inputs)
- Minor: new optional inputs, backwards-compatible
- Patch: bug fixes

Consumers pin: `@1.2` (latest 1.2.x), `@1` (latest 1.x.x).

## Consumer Usage

```yaml
include:
  - component: $CI_SERVER_FQDN/my-org/my-component@1.0.0
    inputs:
      stage: build
```

## Converting Templates to Components

1. Identify hardcoded values → make them inputs
2. Move global keywords into each job
3. Create `spec:` block with typed inputs + defaults
4. Replace hardcoded values with `$[[ inputs.name ]]`
5. Test by including from `$CI_COMMIT_SHA`

## Advanced Patterns

**Boolean toggle:**
```yaml
.my-component:enable_cache:true:
  cache:
    key: $CI_COMMIT_SHA
    paths: [.]
.my-component:enable_cache:false:
  extends: null
my-job:
  extends: '.my-component:enable_cache:$[[ inputs.enable_cache ]]'
```

**Options enum:**
```yaml
spec:
  inputs:
    mode:
      options: [fast, thorough, minimal]
```

**Component context (versioned image):**
```yaml
spec:
  component: [version, reference]
---
run-tool:
  image: $CI_REGISTRY_IMAGE/my-tool:$[[ component.version ]]
```
