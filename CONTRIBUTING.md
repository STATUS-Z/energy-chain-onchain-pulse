# Contributing

## Fork the dashboard

1. Open each query in [`README.md`](README.md) and fork on Dune.
2. Keep the shared params: `date_range`, `blockchain`.
3. Do **not** add hex / color columns to SQL. Set series colors in the viz UI ([`docs/color-palette.md`](docs/color-palette.md)).
4. After any `updateDashboard` API write, re-link params in the UI ([`docs/manual-ui-steps.md`](docs/manual-ui-steps.md)). Widget IDs regenerate.

## Extend the energy universe

Edit the `energy_syms` CTE in every query the same way. Keep bucket labels: `crude`, `energy_equity`, `natgas`, `metals`, and add distillate/residual buckets only when real on-chain coverage exists.

## Verify

Run each query on Dune free/community engine. Confirm non-empty rows for the default `30d` / `all` params before shipping layout changes.
