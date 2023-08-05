#!/bin/bash
# Parse the output.json created by the Sphinx linkchecker
# and summarise broken and redirected links

set -eu
LINKCHECK="$1"
ERROR_ON_BROKEN_LINKS=${2:-true}

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

echo "broken-link-count=$N_BROKEN" >> "$GITHUB_OUTPUT"
echo "permanent-redirect-count=$N_PERMANENT_REDIRECT" >> "$GITHUB_OUTPUT"

if [[ $ERROR_ON_BROKEN_LINKS != "false" ]]; then
    exit "$N_BROKEN"
fi
