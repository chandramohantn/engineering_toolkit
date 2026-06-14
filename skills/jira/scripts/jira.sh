#!/bin/bash
# JIRA API wrapper script

if [ -z "$JIRA_URL" ]; then
    echo "Error: JIRA_URL environment variable is not set." >&2
    exit 1
fi

METHOD=$1
PATH_SUFFIX=$2
shift 2

AUTH_HEADER=()
if [ -n "$JIRA_TOKEN" ]; then
    AUTH_HEADER=(-H "Authorization: Bearer $JIRA_TOKEN")
else
    AUTH_HEADER=(-n)
fi

# Ensure PATH_SUFFIX starts with /
[[ $PATH_SUFFIX != /* ]] && PATH_SUFFIX="/$PATH_SUFFIX"

curl -s "${AUTH_HEADER[@]}" -X "$METHOD" "${JIRA_URL}/rest/api/2${PATH_SUFFIX}" "$@"
