# MCP limitations

| Capability | Status |
|------------|--------|
| searchTables / searchDocs | Works |
| createAndExecuteQuery (free engine) | Works |
| generateVisualization / updateVisualization | Works |
| createDashboard / updateDashboard / getDashboard | Works |
| Series hex colors | **UI only** |
| Query schedules (08:00 / 13:00 UTC) | **UI only** — no schedule tool on this plan |
| Shared dashboard params across all queries | Fragile; prefer per-query links |
| `updateDashboard` widget IDs | **Regenerate** on every full widget write |
| Premium `rwa_multichain.token_metadata` | Not readable on community plan |
| performance medium/large | Rejected for some datasets ("dataset 11"); use `free` |

## Lessons carried from Protocol Radar

1. Split queries per panel. Do not use a master widget router for all panels.
2. Minimize full layout churn after ship.
3. Document manual param re-links every time layout is rewritten via API.
