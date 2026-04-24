# Deploy repo — Source/Deploy Sync Rule

This repo's `trading-journal.html` is a published copy. Source of truth lives in `/Users/jumparo/JumpTools/TradingJournal`. Drift = incident.

## Pre-release parity check

```bash
diff -q /Users/jumparo/JumpTools/TradingJournal/trading-journal.html \
        /Users/jumparo/deploy/trading-journal.html

shasum -a 256 /Users/jumparo/JumpTools/TradingJournal/trading-journal.html \
              /Users/jumparo/deploy/trading-journal.html
```

Before the release script runs, source must be the newer copy and deploy must match the previous live state. Any *other* pattern — e.g. deploy ahead of source — is drift, and is exactly the 2026-04-24 Coach V3 incident.

## Commits-in-deploy-not-in-source

```bash
git -C /Users/jumparo/deploy log --oneline v1.3.0-trading-journal..HEAD -- trading-journal.html
```

If that prints anything unfamiliar, deploy has direct-edit commits that never went through source. Resolve in source first.

## STOP / drift-resolution

- If deploy is ahead of source on `trading-journal.html`: **do not release**. Copy deploy → source, commit in source explaining the drift, then release normally.
- If source and deploy both have changes to the same regions: reconcile in source repo manually. Never silently overwrite.
- If either repo is ahead of `origin/main`: push the upstream-safe copy first. Don't let local state mask drift.

## Forbidden

- Hand-editing `/Users/jumparo/deploy/trading-journal.html`. The release script is the only authorized writer.
- Running `git add -u` / `git add -A` / `git commit -a` inside this repo.
- Committing an unrelated WIP file (e.g. `fund-hq.html`) into a `trading-journal.html` release commit.
