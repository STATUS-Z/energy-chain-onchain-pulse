# Sources found vs missing

## Found (used in live queries)

| Source | Role |
|--------|------|
| `dex.trades` | Energy/commodity DEX volume, top tokens, whale flows |
| `gas.fees` | Daily tx count, avg gas gwei, fee USD, active senders (ethereum, optimism, arbitrum) |
| `ethereum.blocks` / `optimism.blocks` / `arbitrum.blocks` | Avg block time |
| `dune.exchain.dataset_rwa_tokens` | Discovery: commodities category + Ondo energy equities (USOon, XOMon, CVXon, …) |

### Curated energy universe (SQL `energy_syms`)

| Bucket | Symbols (examples) |
|--------|--------------------|
| crude | OIL, USO, USOon, WTIC, WTI, XOIL, CRUDE, Oil |
| energy_equity | XLE, XOMon, CVXon, CEGon, NEEon, TLNon |
| natgas | NATGAS, NGAS, NGTG$$ |
| metals | PAXG, XAUt, XAUt0, XAUT0 (commodity adjacency; gold dominates volume) |

## Missing / gated

| Item | Status |
|------|--------|
| Distillates (gasoline, diesel, heating oil, jet fuel) | **No reliable tokenized RWA / DEX symbol coverage found** |
| Residuals (fuel oil, bunker, asphalt) | **No reliable on-chain coverage found** |
| `rwa_multichain.token_metadata` | Enterprise / premium dataset — not readable on community_fluid_engine_v2 |
| `rwa_multichain.supply` / balances / trades (spell sector) | Same premium gate on this plan |
| `rwa_hyperliquid.markets` | Premium / private on this plan |
| Native ERC-4337 smart-wallet spell | Sparse community uploads only; whale proxy uses ≥ $25k DEX trades |

## Honest product stance

Ship best available: DEX energy/commodity legs + chain gas spine + whale large-trade flows. When distillate/residual tokens appear on Dune with real volume, add them to `energy_syms` and bump CHANGELOG.
