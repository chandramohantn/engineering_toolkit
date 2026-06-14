#!/bin/bash
# GitLab API wrapper script

if [ -z "$GITLAB_URL" ]; then
    GITLAB_URL="https://gitlab.com"
fi

METHOD=$1
PATH_SUFFIX=$2
shift 2

# Support for PRIVATE-TOKEN header (standard for GitLab API)
# Priority: GITLAB_TOKEN env var -> fallback to .netrc (via curl -n)
AUTH_HEADER=()
if [ -n "$GITLAB_TOKEN" ]; then
    AUTH_HEADER=(-H "PRIVATE-TOKEN: $GITLAB_TOKEN")
else
    AUTH_HEADER=(-n)
fi

# Ensure PATH_SUFFIX starts with /
[[ $PATH_SUFFIX != /* ]] && PATH_SUFFIX="/$PATH_SUFFIX"

# API path for GitLab is /api/v4
curl -s "${AUTH_HEADER[@]}" -X "$METHOD" "${GITLAB_URL}/api/v4${PATH_SUFFIX}" "$@"
