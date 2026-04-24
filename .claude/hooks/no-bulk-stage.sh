#!/usr/bin/env bash
# PreToolUse(Bash) hook: block bulk-staging inside /Users/jumparo/deploy.
# The deploy repo aggregates multiple apps; bulk-stage catches unrelated WIP
# (e.g. the pre-existing fund-hq.html diff). Always name the file explicitly.
set -u

INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# Only gate commands that look like they touch the deploy repo.
if ! printf '%s' "$CMD" | grep -qE '/Users/jumparo/deploy\b|(^|[;&|[:space:]])cd[[:space:]]+/Users/jumparo/deploy\b'; then
  exit 0
fi

# Match: git add -A | -u | . | ; git commit -a | --all
if printf '%s' "$CMD" | grep -qE '\bgit[[:space:]]+add[[:space:]]+(-A|-u|--all|\.)(\b|[[:space:]]|$)'; then
  cat >&2 <<EOF
no-bulk-stage: BLOCKED — bulk-stage forbidden in /Users/jumparo/deploy
  Command: $CMD
  Reason: this repo aggregates multiple apps and currently has a pre-existing WIP diff on fund-hq.html that must NOT be staged.
  Fix: name the file, e.g.
       git -C /Users/jumparo/deploy add trading-journal.html
EOF
  exit 2
fi

if printf '%s' "$CMD" | grep -qE '\bgit[[:space:]]+commit[[:space:]]+(-a|--all)(\b|[[:space:]]|$)'; then
  cat >&2 <<EOF
no-bulk-stage: BLOCKED — \`git commit -a\` forbidden in /Users/jumparo/deploy
  Command: $CMD
  Fix: stage explicitly, then commit:
       git -C /Users/jumparo/deploy add <file>
       git -C /Users/jumparo/deploy commit -m "..."
EOF
  exit 2
fi

exit 0
