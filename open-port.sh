#!/bin/bash
# After 5 seconds, turn Vite port to public and show no command output on CLI
sleep 5
if [ -n "$CODESPACES" ]; then
    gh codespace ports visibility 8080:public -c $CODESPACE_NAME > /dev/null 2>&1
elif [ -n "$GITPOD_WORKSPACE_URL" ]; then
    gp ports visibility 5173:public > /dev/null 2>&1
else
    echo "Neither CODESPACES or GITPOD_WORKSPACE_URL environment variable is set"
fi