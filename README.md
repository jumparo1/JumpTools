# JumpTrading

Landing page and deploy folder for the JumpTrading tools suite hosted on Netlify.

## Live URLs

| Tool | URL |
|------|-----|
| Landing Page | [jumptrading.netlify.app](https://jumptrading.netlify.app) |
| Fund HQ | [jumptrading.netlify.app/fund-hq.html](https://jumptrading.netlify.app/fund-hq.html) |
| Trading Journal | [jumptrading.netlify.app/trading-journal.html](https://jumptrading.netlify.app/trading-journal.html) |
| Backtesting | [jumptrading.netlify.app/backtesting.html](https://jumptrading.netlify.app/backtesting.html) |

## Files

- `index.html` — Landing page with tool cards and role-based access
- `fund-hq.html` — Fund HQ (deploy copy with auth gate)
- `trading-journal.html` — Trading Journal Analyst (deploy copy with auth gate)
- `backtesting.html` — Backtesting Tool (deploy copy with auth gate)

## Access Control

- **jumparo** — Full access to all tools
- **tihomir** — Fund HQ only

## Deploy

```bash
npx netlify-cli deploy --prod --dir=. --site=b2e06d16-0d0a-4e71-b55c-8c087bfeeb4b
```

## Source Repos

- [FundHQ](https://github.com/jumparo1/FundHQ)
- [TradingJournal](https://github.com/jumparo1/TradingJournal)
- [Backtesting](https://github.com/jumparo1/Backtesting)
