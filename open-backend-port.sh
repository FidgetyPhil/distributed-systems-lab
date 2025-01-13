#!/bin/bash
if [ -n "$CODESPACES" ]; then
    gh codespace ports visibility 8080:public -c $CODESPACE_NAME > /dev/null 2>&1
else
    echo "Neither CODESPACES or GITPOD_WORKSPACE_URL environment variable is set"
fi