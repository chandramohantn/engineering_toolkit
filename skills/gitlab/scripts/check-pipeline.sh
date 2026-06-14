#!/bin/bash
# Check GitLab CI pipeline status

GITLAB_SH="$(dirname "$0")/gitlab.sh"

USAGE="Usage: $0 [-b <branch>] [-p <pipeline_id>] [-m <mr_iid>] [--log-lines N]"
BRANCH=""
PIPELINE_ID=""
MR_IID=""
LOG_LINES=50

while [[ $# -gt 0 ]]; do
    case $1 in
        -b) BRANCH="$2"; shift 2 ;;
        -p) PIPELINE_ID="$2"; shift 2 ;;
        -m) MR_IID="$2"; shift 2 ;;
        --log-lines) LOG_LINES="$2"; shift 2 ;;
        *) echo "$USAGE"; exit 1 ;;
    esac
done

# Need PROJECT_ENC. Try to detect it if not set
if [ -z "$PROJECT_ENC" ]; then
    PROJECT_ENC=$(git remote get-url origin 2>/dev/null | sed -E 's#.*gitlab[^/:]*[/:]##;s#\.git$##' | sed 's|/|%2F|g')
fi

if [ -n "$MR_IID" ]; then
    PIPELINE_ID=$( "$GITLAB_SH" GET "/projects/$PROJECT_ENC/merge_requests/$MR_IID/pipelines" | jq -r '.[0].id' )
elif [ -z "$PIPELINE_ID" ]; then
    if [ -z "$BRANCH" ]; then
        BRANCH=$(git branch --show-current 2>/dev/null)
    fi
    if [ -n "$BRANCH" ]; then
        PIPELINE_ID=$( "$GITLAB_SH" GET "/projects/$PROJECT_ENC/pipelines?ref=$BRANCH&per_page=1" | jq -r '.[0].id' )
    fi
fi

if [ "$PIPELINE_ID" == "null" ] || [ -z "$PIPELINE_ID" ]; then
    echo "STATUS: NO_PIPELINE"
    exit 0
fi

PIPELINE_DATA=$( "$GITLAB_SH" GET "/projects/$PROJECT_ENC/pipelines/$PIPELINE_ID" )
STATUS=$( echo "$PIPELINE_DATA" | jq -r '.status' )

echo "STATUS: $STATUS"
echo "URL: $( echo "$PIPELINE_DATA" | jq -r '.web_url' )"

if [ "$STATUS" == "failed" ]; then
    echo "--- FAILED JOBS ---"
    FAILED_JOBS=$( "$GITLAB_SH" GET "/projects/$PROJECT_ENC/pipelines/$PIPELINE_ID/jobs?scope[]=failed" )
    echo "$FAILED_JOBS" | jq -c '.[] | {id, name, stage, web_url}'
    
    echo "$FAILED_JOBS" | jq -r '.[].id' | while read -r JOB_ID; do
        [ -z "$JOB_ID" ] && continue
        JOB_NAME=$(echo "$FAILED_JOBS" | jq -r ".[] | select(.id == $JOB_ID) | .name")
        echo "LOG FOR JOB $JOB_NAME ($JOB_ID):"
        "$GITLAB_SH" GET "/projects/$PROJECT_ENC/jobs/$JOB_ID/trace" | tail -n "$LOG_LINES"
        echo "---"
    done
fi
