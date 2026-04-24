#!/usr/bin/env bash
# PreToolUse(Bash) hook: block `git push` in the deploy repo unless the
# TradingJournal preflight token is fresh.
#
# Reads Claude Code tool-call JSON from stdin. Exits 0 to allow, 2 to block.
# Emergency bypass: JUMP_SKIP_PREFLIGHT=1
set -u

INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# Only gate push commands.
if ! printf '%s' "$CMD" | grep -qE '\bgit[[:space:]]+push\b'; then
  exit 0
fi

if [ "${JUMP_SKIP_PREFLIGHT:-}" = "1" ]; then
  echo "preflight-gate (deploy): bypassed via JUMP_SKIP_PREFLIGHT=1" >&2
  exit 0
fi

TOKEN="${TMPDIR:-/tmp}/jump-preflight-trading-journal.ok"
if [ ! -f "$TOKEN" ]; then
  cat >&2 <<EOF
preflight-gate (deploy): BLOCKED — no preflight token.
  Command: $CMD
  Every push to /Users/jumparo/deploy is a live deploy (GitHub Pages).
  Fix:
    1. bash /Users/jumparo/JumpTools/TradingJournal/scripts/preflight.sh
    2. Load http://10.85.1.82:8080/trading-journal.html and exercise the change.
    3. Retry the push.
  Emergency bypass: JUMP_SKIP_PREFLIGHT=1 <command>
EOF
  exit 2
fi

TOKEN_MTIME=$(stat -f '%m' "$TOKEN" 2>/dev/null || echo 0)
AGE=$(( $(date +%s) - TOKEN_MTIME ))
if [ "$AGE" -gt 1800 ]; then
  echo "preflight-gate (deploy): BLOCKED — token is stale (${AGE}s old). Rerun preflight." >&2
  exit 2
fi

exit 0
