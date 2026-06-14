# Project & Group Management

Manage GitLab projects, groups, avatars, and CI/CD variables via API.

## Project Description

```bash
$gitlab PUT "/projects/$PROJECT_ENC" \
  -H "Content-Type: application/json" -d '{"description": "My project description"}'
```

## Avatars

### Upload (requires multipart — use curl directly)

```bash
GITLAB_HOST=$(git remote get-url origin | sed -E 's#.*@([^:]+):.*#\1#;s#https?://([^/]+)/.*#\1#')
curl -s --request PUT \
  --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  --form "avatar=@logo.png" \
  "https://$GITLAB_HOST/api/v4/projects/$PROJECT_ENC"
```

### Download

```bash
$gitlab GET "/projects/$PROJECT_ENC/avatar" > avatar.png
```

## Transfer Project

```bash
$gitlab PUT "/projects/$PROJECT_ENC/transfer" \
  -H "Content-Type: application/json" -d '{"namespace": GROUP_ID}'
```

After transfer, update local remote:
```bash
git remote set-url origin git@GITLAB_HOST:new/path/project.git
```

## Create Subgroup

```bash
$gitlab POST "/groups" \
  -H "Content-Type: application/json" \
  -d '{"name": "my-group", "path": "my-group", "parent_id": PARENT_GROUP_ID, "visibility": "internal"}'
```

## CI/CD Variables

```bash
# List
$gitlab GET "/projects/$PROJECT_ENC/variables" | jq '.[] | {key, masked, protected}'

# Create
$gitlab POST "/projects/$PROJECT_ENC/variables" \
  -H "Content-Type: application/json" \
  -d '{"key": "MY_VAR", "value": "secret", "masked": true, "protected": true}'

# Update
$gitlab PUT "/projects/$PROJECT_ENC/variables/MY_VAR" \
  -H "Content-Type: application/json" -d '{"value": "new-value"}'

# Delete
$gitlab DELETE "/projects/$PROJECT_ENC/variables/MY_VAR"
```
