# Health Index

## Bands

| Band | Range |
|------|-------|
| Weak | 0–24 |
| Soft | 25–49 |
| Strong | 50–74 |
| Hot | 75–100 |

## Formula

For each day in the selected window (excluding today on the *Current* counter):

```text
energy_score   = PERCENT_RANK() OVER (ORDER BY energy_volume_usd)
activity_score = PERCENT_RANK() OVER (ORDER BY active_senders)
fee_ease_score = 1 - PERCENT_RANK() OVER (ORDER BY avg_gas_gwei)

composite_raw  = 0.40 * energy_score
               + 0.30 * activity_score
               + 0.30 * fee_ease_score

health_index   = ROUND(100 * PERCENT_RANK() OVER (ORDER BY composite_raw), 0)
```

## Inputs

- `energy_volume_usd` from `dex.trades` on curated `energy_syms`
- `active_senders` / `avg_gas_gwei` from `gas.fees` on ethereum + optimism + arbitrum (or the selected chain)

## Queries

- Timeline: `8157001`
- Current (latest complete day): `8157021`
