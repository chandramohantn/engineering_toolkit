#!/bin/bash
# Scaffold a GitLab CI/CD component

NAME=$1
OUT_DIR=${2:-"."}
MULTI=false

if [ -z "$NAME" ]; then
    echo "Usage: $0 <name> [output-dir] [--multi]"
    exit 1
fi

for arg in "$@"; do
    if [ "$arg" == "--multi" ]; then
        MULTI=true
    fi
done

if [ "$MULTI" == "true" ]; then
    mkdir -p "$OUT_DIR/templates/build"
    mkdir -p "$OUT_DIR/templates/test"
    mkdir -p "$OUT_DIR/templates/deploy"
    touch "$OUT_DIR/templates/build/template.yml"
    touch "$OUT_DIR/templates/test/template.yml"
    touch "$OUT_DIR/templates/deploy/template.yml"
else
    mkdir -p "$OUT_DIR/templates/$NAME"
    touch "$OUT_DIR/templates/$NAME/template.yml"
fi

cat > "$OUT_DIR/.gitlab-ci.yml" <<EOF
# CI/CD Component configuration
stages: [test, release]

include:
  - component: \$CI_SERVER_FQDN/\$CI_PROJECT_PATH/$NAME@\$CI_COMMIT_SHA
    inputs:
      stage: test
EOF

cat > "$OUT_DIR/README.md" <<EOF
# $NAME Component

This is a GitLab CI/CD component.

## Usage

\`\`\`yaml
include:
  - component: \$CI_SERVER_FQDN/\$CI_PROJECT_PATH/$NAME@<version>
    inputs:
      stage: test
\`\`\`
EOF

touch "$OUT_DIR/LICENSE.md"

echo "Scaffolded component '$NAME' in '$OUT_DIR'"
