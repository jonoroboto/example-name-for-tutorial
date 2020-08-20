#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5f3e442d7fd919001cc7c4dd/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5f3e442d7fd919001cc7c4dd 
fi
curl -s -X POST https://api.stackbit.com/project/5f3e442d7fd919001cc7c4dd/webhook/build/ssgbuild > /dev/null
gatsby build
./inject-netlify-identity-widget.js public
curl -s -X POST https://api.stackbit.com/project/5f3e442d7fd919001cc7c4dd/webhook/build/publish > /dev/null
