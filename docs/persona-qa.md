# Persona QA

## Whale (Crown + Scoreboard ≤ 5s)

| Check | Result |
|-------|--------|
| Health Index visible without scroll on wide layout | Pass — counter + line occupy Crown |
| Four KPIs plain-labeled | Pass — Energy Volume, Gas Fees, Whale Net Flow, Most Active Chain |
| Jargon-light titles | Pass |
| Actionable in 5s | Pass — Strong/Soft band from Crown; chain + whale direction from Scoreboard |

## Analyst (filters + Vault)

| Check | Result |
|-------|--------|
| `date_range` / `blockchain` on every query | Pass (params defined; UI re-link required) |
| Vault pivot with chain×day grain | Pass — query 8157012 |
| Formula documented | Pass — health-index.md + glossary widget |
| Gaps called out | Pass — distillates/residuals + premium RWA |

## Beginner (glossary + how-to-read)

| Check | Result |
|-------|--------|
| Banner how-to-read | Pass |
| Glossary table in Vault text | Pass |
| Titles avoid crypto slang where possible | Pass ("Health Index", "Whale Net Flow" kept as defined terms) |

## Known soft spots

- Metals (PAXG/XAUt) dominate volume vs crude oil tokens — Crown can read "commodity" more than "oil".
- Today’s partial day can drag Health Timeline; Current counter excludes today.
- Distillates/residuals absent — beginner glossary states the gap.
