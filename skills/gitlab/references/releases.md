# Releases

Create tags, releases, and changelogs.

## Create a Tag

```bash
$gitlab POST "/projects/$PROJECT_ENC/repository/tags" \
  -H "Content-Type: application/json" \
  -d '{"tag_name": "v1.0.0", "ref": "main", "message": "Release v1.0.0"}'
```

## Create a Release

```bash
$gitlab POST "/projects/$PROJECT_ENC/releases" \
  -H "Content-Type: application/json" \
  -d '{
    "tag_name": "v1.0.0",
    "name": "v1.0.0",
    "description": "## Changelog\n\n- Feature A\n- Bugfix B"
  }'
```

## Generate Changelog (from MR titles)

```bash
# Get MRs merged since last tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [[ -n "$LAST_TAG" ]]; then
  AFTER=$(git log -1 --format=%aI "$LAST_TAG")
  $gitlab GET "/projects/$PROJECT_ENC/merge_requests?state=merged&updated_after=$AFTER&per_page=100" \
    | jq -r '.[] | "- \(.title) (!$(.iid))"'
fi
```

## List Releases

```bash
$gitlab GET "/projects/$PROJECT_ENC/releases?per_page=10" \
  | jq '.[] | {tag_name, name, created_at}'
```

## Delete a Release

```bash
$gitlab DELETE "/projects/$PROJECT_ENC/releases/v1.0.0"
```

## Attach Assets to Release

```bash
# Upload a file first
UPLOAD=$($gitlab POST "/projects/$PROJECT_ENC/uploads" --form "file=@dist/app.zip" | jq -r '.full_path')

# Link to release
$gitlab POST "/projects/$PROJECT_ENC/releases/v1.0.0/assets/links" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"app.zip\", \"url\": \"https://GITLAB_HOST/$PROJECT_PATH$UPLOAD\"}"
```
