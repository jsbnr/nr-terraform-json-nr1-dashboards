#!/bin/bash

#
# Get a dashboard and save to file utility script
# You could just use the UI 'Copy JSON to Clipboard' function!
#
# ./get_dash.sh DASH-GUID {filename}
#

if [ "$NEWRELIC_API_KEY" = "" ]; then
  echo "New Relic API key is missing, expected in env var NEWRELIC_API_KEY"
  exit 1
fi

if [ "$1" = "" ]; then
  echo "Dashboard GUID must be supplied as parm 1. Parm 2 can optionally be a filename to save to."
  exit 1
fi

if [ "$2" != "" ]; then
  OUTFILE=" -o $2"
  echo "Saving dashboard to file: $2"
fi


curl -sS -X POST https://api.newrelic.com/graphql \
  -H 'Content-Type: application/json' \
  -H "API-Key: $NEWRELIC_API_KEY" \
  --data-binary "{\"query\":\"{ actor { entity(guid: \\\"${1}\\\") { ... on DashboardEntity { name permissions pages { name widgets { visualization { id } title layout { row width height column } rawConfiguration } } } } } } \", \"variables\":\"\"}" \
  $OUTFILE