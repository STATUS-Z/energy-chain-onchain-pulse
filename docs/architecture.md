# Architecture

## Product

Public Dune dashboard for energy + chain pulse. Owner `za_chain`. Dashboard ID `217228`.

## Zones (Visual Intelligence)

```text
Crown (Health Index counter + line)
  → Scoreboard (4 counters)
    → Story|Context (chain line + top tokens + scatter)
      → Story (whale area)
        → Vault (glossary + pivot)
```

6-column Dune grid. Positions in [`widget-query-map.md`](widget-query-map.md).

## Data path

```text
dex.trades  ──energy_syms──► energy volume / whale flows / top tokens
gas.fees    ──ETH/OP/ARB──► tx count, fees, active senders, avg gwei
*.blocks    ───────────────► avg block time
community RWA list ────────► discovery only (exchain upload)
```

## Query modularity

Separate queries per panel. Shared param *names*, not a master widget router. Lesson from DeFi Protocol Radar: one router cannot drive all panels reliably.

## Ownership

| Surface | ID |
|---------|-----|
| Dashboard | 217228 |
| Health timeline | 8157001 |
| Health current | 8157021 |
| Scoreboard | 8157003 |
| Chain efficiency | 8157004 |
| Top tokens | 8157005 |
| Whale flows | 8157011 |
| Vault | 8157012 |
