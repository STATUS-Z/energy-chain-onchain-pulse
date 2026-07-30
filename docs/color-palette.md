# Color palette (UI-only)

**Rule:** No hex / `color_map` columns in SQL. Colors are set in the Dune visualization UI.

Reference scrape (from prior Web3 Career inventory): `assets/palette/`.

## Suggested series

| Series | Hex | Role |
|--------|-----|------|
| Health Index | `#FFFFFF` | Crown line |
| Ethereum | `#0DCAF0` | Chain series |
| Optimism | `#FF0420` | Chain series |
| Arbitrum | `#28A0F0` | Chain series |
| Whale buys | `#19FF85` | Area |
| Whale sells | `#DC3545` | Area |
| Whale net | `#FFC107` | Right axis |
| Top energy bars | `#FD7E14` | Column accent |
| Weak band note | `#DC3545` | Docs only |
| Soft | `#FD7E14` | Docs only |
| Strong | `#0DCAF0` | Docs only |
| Hot | `#19FF85` | Docs only |

## Why not SQL colors

Dune MCP cannot set series hex. Encoding colors in query results couples data to one theme and breaks forks.
