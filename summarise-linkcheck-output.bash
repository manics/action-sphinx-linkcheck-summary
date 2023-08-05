#!/bin/bash
# Parse the output.json created by the Sphinx linkchecker
# and summarise broken and redirected links

set -eu

LINKCHECK="$1"
NO_ERROR=${2:-false}

# Support running locally outside GitHub
if [[ ${CI:-} != "true" ]]; then
    GITHUB_OUTPUT="${GITHUB_OUTPUT:-/dev/null}"
fi

N_BROKEN=$(jq -r 'select(.status=="broken")' "$LINKCHECK" | jq -s length)
N_PERMANENT_REDIRECT=$(jq -r 'select(.status=="redirected")' "$LINKCHECK" | jq -s length)

if [[ $N_BROKEN -gt 0 ]]; then
    printf "\n\033[31;1m%s\033[0m\n" "Broken links"
    jq -r 'select(.status=="broken") | "\(.filename):\(.lineno) \(.uri)\n    \(.info)"' "$LINKCHECK"
fi

if [[ $N_PERMANENT_REDIRECT -gt 0 ]]; then
    printf "\n\033[35;1m%s\033[0m\n" "Permanently redirected links"
    jq -r 'select(.status=="redirected" and .code==301) | "\(.filename):\(.lineno) \(.uri)\n    \(.info)"' "$LINKCHECK"
fi

echo "broken-links-count=$N_BROKEN" >> "$GITHUB_OUTPUT"
echo "permanent-redirects-count=$N_PERMANENT_REDIRECT" >> "$GITHUB_OUTPUT"

if [[ $NO_ERROR != "true" ]]; then
    exit "$N_BROKEN"
fi
