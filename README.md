# Energy & Chain On-Chain Pulse

**Live:** [dune.com/za_chain/energy-chain-on-chain-pulse](https://dune.com/za_chain/energy-chain-on-chain-pulse)  **Dashboard ID:** `217228`

Unified dashboard tracking tokenized energy commodities, chain gas/transaction stats, and smart wallet flows. Updated daily.

Successor spirit to [DeFi Protocol Radar #1](https://dune.com/za_chain/defi-protocol-radar-1). Same Visual Intelligence spine (Crown → Scoreboard → Story|Context → Vault). Different domain.

> Collapse the Dune sidebar. Dark mode recommended.

---

## What this answers in 5 seconds

> Is the energy + chain pulse Weak, Soft, Strong, or Hot — and which chain / token is driving it?

It does **not** invent oil futures prices. It scores on-chain energy/commodity DEX activity against chain gas and address activity.

---

## How to read

| Zone | What you look at | What you learn |
|------|------------------|----------------|
| **Crown** | Health Index counter + line | Pulse 0–100 vs the selected window |
| **Scoreboard** | Energy volume · Gas fees · Whale net 7d · Busiest chain | Four KPIs, plain labels |
| **Story \| Context** | Chain tx/gas line · Top energy bars · Efficiency scatter | Where activity and cost sit |
| **Story** | Whale buy/sell/net area | Large-trade (≥ $25k) flows |
| **Vault** | Glossary + daily pivot table | Definitions and raw rows |

**Health Index bands**

| Band | Range |
|------|-------|
| Weak | 0–24 |
| Soft | 25–49 |
| Strong | 50–74 |
| Hot | 75–100 |

**Formula (product truth)**

```text
energy_score   = PERCENT_RANK(daily energy DEX volume USD)
activity_score = PERCENT_RANK(daily active senders)
fee_ease_score = 1 - PERCENT_RANK(daily avg gas gwei)
composite      = 0.40*energy + 0.30*activity + 0.30*fee_ease
health_index   = ROUND(100 * PERCENT_RANK(composite))
```

No hex colors in SQL. Paint series in the Dune UI. See [`docs/color-palette.md`](docs/color-palette.md).

---

## Repo map

| Path | Role |
|------|------|
| [`sql/`](sql/) | Live-synced DuneSQL (query ID in filename) |
| [`docs/architecture.md`](docs/architecture.md) | Zones, ownership, data path |
| [`docs/sources-found-missing.md`](docs/sources-found-missing.md) | Coverage vs gaps (distillates/residuals) |
| [`docs/widget-query-map.md`](docs/widget-query-map.md) | Widget ↔ viz ↔ query IDs |
| [`docs/health-index.md`](docs/health-index.md) | Math and bands |
| [`docs/manual-ui-steps.md`](docs/manual-ui-steps.md) | Colors, schedules, param re-links |
| [`docs/mcp-limitations.md`](docs/mcp-limitations.md) | What MCP can/can't do |
| [`docs/color-palette.md`](docs/color-palette.md) | UI-only hex reference |
| [`CHANGELOG.md`](CHANGELOG.md) | Ship history |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Fork-adapt on Dune |
| [`LICENSE`](LICENSE) | MIT |

---

## Queries (live)

| Query ID | Name | Zone |
|---------:|------|------|
| [8157021](https://dune.com/queries/8157021) | Health Index Current | Crown counter |
| [8157001](https://dune.com/queries/8157001) | Health Index Timeline | Crown line |
| [8157003](https://dune.com/queries/8157003) | Scoreboard Counters | Scoreboard |
| [8157004](https://dune.com/queries/8157004) | Chain Efficiency | Story \| Context |
| [8157005](https://dune.com/queries/8157005) | Top Energy Tokens Volume | Story \| Context |
| [8157011](https://dune.com/queries/8157011) | Whale Smart Flows | Story |
| [8157012](https://dune.com/queries/8157012) | Vault Audit Pivot | Vault |

Params on every query: `date_range` (7d/30d/90d/All), `blockchain` (ethereum/optimism/arbitrum/all). Link them per panel in the UI — do not rely on a single master router.

---

## Data spine

- **Energy / commodities:** `dex.trades` filtered to a curated symbol registry (crude, energy equities, natgas, metals). Community list `dune.exchain.dataset_rwa_tokens` for discovery.
- **Chain gas / tx:** `gas.fees` + `ethereum|optimism|arbitrum.blocks` for block time.
- **Whale flows:** same DEX universe, `amount_usd >= 25000`.
- **Premium gap:** `rwa_multichain.token_metadata` and related RWA spells are enterprise-gated on the community plan. Documented honestly in [`docs/sources-found-missing.md`](docs/sources-found-missing.md).

---

## Personas

| Persona | Path |
|---------|------|
| Whale | Crown + Scoreboard in 5s |
| Analyst | Filters + Vault pivot |
| Beginner | Glossary text + jargon-free titles |

---

## License

MIT
