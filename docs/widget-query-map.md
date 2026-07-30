# Widget ↔ query map

Live: https://dune.com/za_chain/energy-chain-on-chain-pulse · ID **217228**  
Fetched via MCP `getDashboard` on 2026-07-30.

## Visualization widgets

| Widget ID | Viz ID | Label | Zone | Query | Position |
|----------:|-------:|-------|------|------:|----------|
| 2294166 | 12149078 | Health Now | Crown | 8157021 | r6 c0 2×6 |
| 2294167 | 12149052 | Health Index line | Crown | 8157001 | r6 c2 4×12 |
| 2294168 | 12149079 | Energy Volume | Scoreboard | 8157003 | r22 c0 2×5 |
| 2294169 | 12149080 | Gas Fees | Scoreboard | 8157003 | r22 c2 1×5 |
| 2294170 | 12149081 | Whale Net Flow | Scoreboard | 8157003 | r22 c3 2×5 |
| 2294171 | 12149083 | Most Active Chain | Scoreboard | 8157003 | r22 c5 1×5 |
| 2294172 | 12149084 | Chain Tx + Gas Line | Story\|Context | 8157004 | r29 c0 3×8 |
| 2294173 | 12149058 | Top Energy Volume | Story\|Context | 8157005 | r29 c3 3×8 |
| 2294174 | 12149056 | Chain Efficiency Scatter | Story\|Context | 8157004 | r37 c0 6×10 |
| 2294175 | 12149065 | Whale Flows Area | Story | 8157011 | r49 c0 6×10 |
| 2294176 | 12149068 | Vault Pivot | Vault | 8157012 | r67 c0 6×10 |

## Text widgets

| Widget ID | Role | Position |
|----------:|------|----------|
| 2294159 | Banner | r0 c0 6×4 |
| 2294160 | Crown subtitle | r4 c0 6×2 |
| 2294161 | Scoreboard subtitle | r20 c0 6×2 |
| 2294162 | Story\|Context subtitle | r27 c0 6×2 |
| 2294163 | Whale subtitle | r47 c0 6×2 |
| 2294164 | Glossary | r59 c0 6×6 |
| 2294165 | Vault note | r65 c0 6×2 |

## Params

API `paramWidgets` left empty on purpose. Link `date_range` and `blockchain` per query in the Dune UI. `updateDashboard` regenerates widget IDs — re-link after any full layout write.
