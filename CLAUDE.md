# JumpTools deploy repo — Operator rules

**This is the GitHub Pages publishing target (`jumparo1/JumpTools`).** Every push to `main` goes live at `https://jumparo1.github.io/JumpTools/*`. Treat every push like a ship.

## What this repo hosts

| File | Source repo | Live URL |
|---|---|---|
| `trading-journal.html` | `/Users/jumparo/JumpTools/TradingJournal` → `jumparo1/TradingJournal` | `https://jumparo1.github.io/JumpTools/trading-journal.html` |
| `fund-hq.html` | `/Users/jumparo/FundHQ` → `jumparo1/JumpHQ` (mirror) | `https://jumparo1.github.io/JumpTools/fund-hq.html` |
| `backtesting.html`, `index.html` | legacy / this repo | same host |

This repo is an **aggregator**. Bulk-staging is unsafe.

## Hard rules

### Never hand-edit published HTML
- **Never** hand-edit `/Users/jumparo/deploy/trading-journal.html`. The only authorized writer is `/Users/jumparo/JumpTools/TradingJournal/scripts/release-live.sh`.
- **Never** hand-edit `/Users/jumparo/deploy/fund-hq.html`. Its source of truth is FundHQ.

### Never bulk-stage
- **Never** run `git add -A`, `git add -u`, or `git commit -a` in this repo. Always name the file explicitly:
  ```bash
  git -C /Users/jumparo/deploy add trading-journal.html
  ```
- There is currently a large pre-existing WIP diff on `fund-hq.html`. Leave it unstaged and untouched. Do **not** `git stash`, `git reset`, or `git restore` it. Do not include it in any commit unrelated to that WIP.

### LOCAL-FIRST release gate

Before any `git push origin main` to this repo:

1. Load the canonical local URL for the app you changed:
   - `http://10.85.1.82:8080/trading-journal.html`
   - `http://10.85.1.82:8080/fund-hq.html`
2. Exercise the changed feature. No blank page, no console errors.
3. Report the URL tested.
4. Ask for explicit approval before the push.

If local testing cannot happen, **STOP**. Don't use GitHub Pages as the test environment. Full rule: `.claude/rules/local-first-release.md`.

### Source/deploy parity

Before releasing `trading-journal.html`, source and deploy copies **must** match:

```bash
bash /Users/jumparo/JumpTools/TradingJournal/scripts/preflight.sh
```

If drift is detected, resolve it in the source repo first — never silently overwrite. Full rule: `.claude/rules/source-deploy-sync.md`.

### Stable anchor

| Field | Value |
|---|---|
| Tag | `v1.3.0-trading-journal` |
| Deploy commit | `8673f25` |
| Source commit | `30fe24a` |
| Live size | `529,889 bytes` |

Rollback to the tag:

```bash
git -C /Users/jumparo/deploy reset --hard v1.3.0-trading-journal
# Only force-push with explicit human approval:
# git -C /Users/jumparo/deploy push --force-with-lease origin main
```

### Forbidden without explicit approval

- `git push --force` / `--force-with-lease`
- Tag deletion / force-replacement (`v1.3.0-trading-journal` is stable; do not recreate)
- Direct edits to `trading-journal.html` / `fund-hq.html`
- Bulk-staging (`-A`, `-u`, `-a`)
- Committing `backups/`

## Companion docs

- `~/.claude/CLAUDE.md` — global rules (local-first, repo map)
- `/Users/jumparo/JumpTools/TradingJournal/RELEASE_SAFETY.md` — incident lesson, full release workflow
- `/Users/jumparo/JumpTools/TradingJournal/docs/runbook.md` — operational runbook
