#!/bin/bash
# Run betterleaks with the given command, for example "git --staged" or "dir .".
# The secrets in the findings are redacted.
#
# Validation is off: betterleaks never sends a secret that it finds to the API
# of its provider. betterleaks 1 has the --validation option. betterleaks 2 has
# --validate and --analyze, and the environment variables BETTERLEAKS_VALIDATE
# and BETTERLEAKS_ANALYZE can turn them on. This script turns all of them off.
set -euo pipefail

if ! command -v betterleaks >/dev/null 2>&1; then
  echo "betterleaks is not installed. Install it (brew install betterleaks) and try again." >&2
  exit 1
fi

export BETTERLEAKS_VALIDATE=false BETTERLEAKS_ANALYZE=false
case "$(betterleaks version)" in
  1.* | v1.*) off=(--validation=false) ;;
  *) off=(--validate=false --analyze=false) ;;
esac
exec betterleaks "$@" --redact --no-banner "${off[@]}"
