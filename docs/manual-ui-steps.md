# Manual UI steps

MCP cannot set series hex, schedule crons, or reliably share params across all panels. Do these in the Dune UI.

## 1. Series colors (UI only)

Apply palette from [`color-palette.md`](color-palette.md). Never add color columns to SQL.

Suggested:

| Series | Hex |
|--------|-----|
| Health Index | `#FFFFFF` |
| Ethereum | `#0DCAF0` |
| Optimism | `#FF0420` |
| Arbitrum | `#28A0F0` |
| Whale buys | `#19FF85` |
| Whale sells | `#DC3545` |
| Whale net | `#FFC107` |
| Energy bars | `#FD7E14` |

## 2. Schedules

Schedule each production query for **08:00 UTC** and **13:00 UTC** (Query → Schedule). MCP has no schedule API on this plan.

Queries to schedule: `8157021`, `8157001`, `8157003`, `8157004`, `8157005`, `8157011`, `8157012`.

## 3. Param re-links

After any dashboard API layout write, widget IDs change.

1. Open the dashboard edit view.
2. For each visualization, open parameters.
3. Attach dashboard-level `date_range` and `blockchain` to that query's matching keys.
4. Do **not** point every panel at a single "master" query router.

## 4. Description

Confirm dashboard description is:

> Unified dashboard tracking tokenized energy commodities, chain gas/transaction stats, and smart wallet flows. Updated daily.
