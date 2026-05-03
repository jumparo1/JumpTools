# Deploy repo — LOCAL-FIRST Release Rule

This is the **live publish target** (`jumparo1/JumpTools` → `https://jumparo1.github.io/JumpTools/*`). Every push to `main` is a deploy. Local validation is mandatory before push.

## Canonical release-gate URL

- Trading Journal: `http://10.85.1.82:8080/trading-journal.html`

Port **8080** is the canonical gate.

## Live URL

- Trading Journal: `https://jumparo1.github.io/JumpTools/trading-journal.html`

Fund HQ does **not** live in this repo. Canonical Fund HQ is `https://jumparo1.github.io/JumpHQ/fund-hq.html`. The previous JumpTools Fund HQ mirror was removed on 2026-05-03 (commit `7c58324`); do not redeploy it here.

## Protocol

1. **Verify the server.** Before push, load `http://10.85.1.82:8080/<file>`. Confirm `curl -s http://10.85.1.82:8080/<file> | wc -c` matches what's on disk in this repo.
2. **Exercise the edited surface** in a browser. No blank panels, no red console errors.
3. **Report** the URL tested and what you verified.
4. **Ask for explicit approval** before `git push origin main`.
5. **If local testing cannot happen, STOP.** Never use GitHub Pages as the first test.

## Pre-push STOP conditions

Do not push if any of:

- Port 8080 size/SHA doesn't match the file on disk in this repo.
- `scripts/preflight.sh` (in TradingJournal) reports drift or marker regression.
- `git status` shows unexpected staged files (e.g. anything Fund-HQ-related — that should never be in this repo again).
- Commit message doesn't match what's actually staged.

## Aggregator discipline

This repo hosts multiple apps. Never bulk-stage. Always:

```bash
git -C /Users/jumparo/deploy add <single-file>
git -C /Users/jumparo/deploy commit -m "..."
```

Forbidden: `git add -A`, `git add -u`, `git add .`, `git commit -a`.
