#!/usr/bin/env bash
# Deploy repo preflight — forwards to the canonical script in TradingJournal source.
# This repo publishes to GitHub Pages; source of truth for validation logic lives
# in the source repo so both repos run identical checks.

set -u

CANONICAL="/Users/jumparo/JumpTools/TradingJournal/scripts/preflight.sh"

if [ ! -x "$CANONICAL" ]; then
  echo "ERROR: canonical preflight not found or not executable: $CANONICAL" >&2
  echo "Fix: chmod +x $CANONICAL" >&2
  exit 2
fi

exec "$CANONICAL" "$@"
