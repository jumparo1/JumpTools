# JumpTools deploy repo — Operator rules

**This is the GitHub Pages publishing target (`jumparo1/JumpTools`).** Every push to `main` goes live at `https://jumparo1.github.io/JumpTools/*`. Treat every push like a ship.

## What this repo hosts

| File | Source repo | Live URL |
|---|---|---|
| `trading-journal.html` | `/Users/jumparo/JumpTools/TradingJournal` → `jumparo1/TradingJournal` | `https://jumparo1.github.io/JumpTools/trading-journal.html` |
| `index.html` | this repo | `https://jumparo1.github.io/JumpTools/` (single Trading Journal card) |

**This repo hosts Trading Journal only.** Fund HQ lives at `jumparo1/JumpHQ` — never redeploy it here. See "Do not redeploy Fund HQ" below.

Bulk-staging is still unsafe — keep the discipline in case other tools land here later.

## Hard rules

### Never hand-edit published HTML
- **Never** hand-edit `/Users/jumparo/deploy/trading-journal.html`. The only authorized writer is `/Users/jumparo/JumpTools/TradingJournal/scripts/release-live.sh`.

### Do not redeploy Fund HQ
- Fund HQ canonical is `jumparo1/JumpHQ` (`https://jumparo1.github.io/JumpHQ/fund-hq.html`).
- The previous JumpTools mirror (`fund-hq.html` here) was removed on 2026-05-03 in commit `7c58324`. The pre-existing WIP for that file was preserved at `~/backups/jumptools-fundhq-wip-2026-05-03.html` (the only remaining copy).
- `backtesting.html` was removed in the same commit and is intentionally gone.
- Do **not** re-add `fund-hq.html`, `backtesting.html`, or any Fund HQ assets to this repo. Do not re-add Fund HQ or Backtesting cards to `index.html`. If a future request seems to want either, push back and ask the user first.

### Never bulk-stage
- **Never** run `git add -A`, `git add -u`, or `git commit -a` in this repo. Always name the file explicitly:
  ```bash
  git -C /Users/jumparo/deploy add trading-journal.html
  ```

### LOCAL-FIRST release gate

Before any `git push origin main` to this repo:

1. Load the canonical local URL for the app you changed:
   - `http://10.85.1.82:8080/trading-journal.html`
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
- Direct edits to `trading-journal.html`
- Re-adding `fund-hq.html`, `backtesting.html`, or any Fund HQ asset to this repo
- Bulk-staging (`-A`, `-u`, `-a`)
- Committing `backups/`

## Companion docs

- `~/.claude/CLAUDE.md` — global rules (local-first, repo map)
- `/Users/jumparo/JumpTools/TradingJournal/RELEASE_SAFETY.md` — incident lesson, full release workflow
- `/Users/jumparo/JumpTools/TradingJournal/docs/runbook.md` — operational runbook
