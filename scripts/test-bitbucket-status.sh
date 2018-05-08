#!/bin/sh
set -euo pipefail

URL="http://localhost:7990/status"

echo "Wait for the container to come up and Bitbucket to start"
i=0
until error="$(wget --spider "$URL" 2>&1)"; do
    if [ ${i} -gt 60 ]; then
        echo
        echo '!!! Timed out waiting for bitbucket to start up!'
        printf '%s\n' "$error" >&2
        exit 1
    fi
    printf '.'
    i=$((i+1))
    sleep 5
done

echo

# Now the container is up and running and Bitbucket is running. Let's wait until it shows the setup screen
echo "Check the /status output"
if ! wget -qS -O - "$URL" | grep 'FIRST_RUN'; then
    echo "Unexpected /status response"
    exit 1
else
    echo "Bitbucket seems to be up and running"
    exit 0
fi
