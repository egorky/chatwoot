#!/bin/bash

# This script replaces Chatwoot telemetry and reporting URLs with null or localhost
# to prevent any outgoing communication to Chatwoot servers.

echo "Nullifying Chatwoot telemetry URLs..."

# Define targets
TARGET_DOMAINS=(
  "hub.2.chatwoot.com"
  "app.chatwoot.com"
  "staging.chatwoot.com"
  "api.chatwoot.com"
)

for domain in "${TARGET_DOMAINS[@]}"; do
  echo "Processing domain: $domain"
  # Replace with localhost to ensure any stray calls fail quickly and don't leak data
  grep -rl "$domain" . --exclude-dir={node_modules,vendor,tmp,log,.git} | xargs -r sed -i "s|$domain|localhost|g"
done

# Specifically nullify some known constants in JS
sed -i "s|export const CHANGELOG_API_URL = '.*'|export const CHANGELOG_API_URL = ''|g" app/javascript/shared/constants/links.js

echo "Successfully nullified known Chatwoot telemetry domains."
