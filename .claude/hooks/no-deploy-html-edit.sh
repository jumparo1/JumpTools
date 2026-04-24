#!/usr/bin/env bash
# PreToolUse(Edit|Write) hook: block hand-edits to published HTML in the deploy repo.
#
# Override: JUMP_ALLOW_DEPLOY_HTML_EDIT=1 (use sparingly — only for tag rollback).
set -u

INPUT=$(cat)
FILE=$(printf '%s' "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")

case "$FILE" in
  /Users/jumparo/deploy/trading-journal.html|/Users/jumparo/deploy/fund-hq.html)
    if [ "${JUMP_ALLOW_DEPLOY_HTML_EDIT:-}" = "1" ]; then
      echo "no-deploy-html-edit: override active (JUMP_ALLOW_DEPLOY_HTML_EDIT=1) — allowing edit to $FILE" >&2
      exit 0
    fi
    cat >&2 <<EOF
no-deploy-html-edit: BLOCKED — hand-editing deploy HTML is forbidden
  File: $FILE
  Reason: deploy HTML is a published artifact. The authorized writers are the release scripts in the source repos.
  For trading-journal.html:
    edit  /Users/jumparo/JumpTools/TradingJournal/trading-journal.html
    then  /Users/jumparo/JumpTools/TradingJournal/scripts/release-live.sh -y "msg"
  For fund-hq.html (mirror): edit /Users/jumparo/FundHQ/fund-hq.html, ship via FundHQ/scripts/release.sh.
  Emergency override: JUMP_ALLOW_DEPLOY_HTML_EDIT=1
EOF
    exit 2
    ;;
esac
exit 0
