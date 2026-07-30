# SQL mirrors

Filenames: `{queryId}-{slug}.sql`. Source of truth is Dune; keep this folder synced after edits.

| File | Query |
|------|------:|
| `8157021-health-index-current.sql` | 8157021 |
| `8157001-health-index-timeline.sql` | 8157001 |
| `8157003-scoreboard-counters.sql` | 8157003 |
| `8157004-chain-efficiency.sql` | 8157004 |
| `8157005-top-energy-tokens-volume.sql` | 8157005 |
| `8157011-whale-smart-flows.sql` | 8157011 |
| `8157012-vault-audit-pivot.sql` | 8157012 |

All queries share params:

- `date_range`: enum `7d` | `30d` | `90d` | `All` (default `30d`)
- `blockchain`: enum `ethereum` | `optimism` | `arbitrum` | `all` (default `all`)
