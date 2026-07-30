-- ECOP Health Index Timeline (query 8157001)
-- Formula (product truth):
--   energy_score  = PERCENT_RANK of daily energy_dex_volume_usd over window
--   activity_score = PERCENT_RANK of daily active_senders over window
--   fee_ease_score = 1 - PERCENT_RANK of daily avg_gas_gwei (lower gas = better)
--   composite = 0.40*energy + 0.30*activity + 0.30*fee_ease
--   health_index = ROUND(100 * PERCENT_RANK(composite))
-- No hex colors in SQL.
-- Params: date_range (7d|30d|90d|All), blockchain (ethereum|optimism|arbitrum|all)

WITH params AS (
  SELECT
    CASE '{{date_range}}'
      WHEN '7d' THEN CURRENT_DATE - INTERVAL '7' DAY
      WHEN '30d' THEN CURRENT_DATE - INTERVAL '30' DAY
      WHEN '90d' THEN CURRENT_DATE - INTERVAL '90' DAY
      ELSE DATE '2024-01-01'
    END AS start_date,
    '{{blockchain}}' AS chain_filter
),
energy_syms AS (
  SELECT * FROM (VALUES
    ('OIL','crude'),('USO','crude'),('USOon','crude'),('WTIC','crude'),('WTI','crude'),
    ('XOIL','crude'),('CRUDE','crude'),('Oil','crude'),
    ('XLE','energy_equity'),('XOMon','energy_equity'),('CVXon','energy_equity'),
    ('CEGon','energy_equity'),('NEEon','energy_equity'),('TLNon','energy_equity'),
    ('NATGAS','natgas'),('NGAS','natgas'),('NGTG$$','natgas'),
    ('PAXG','metals'),('XAUt','metals'),('XAUt0','metals'),('XAUT0','metals')
  ) AS t(symbol, bucket)
),
energy_daily AS (
  SELECT
    t.block_date AS day,
    SUM(t.amount_usd) AS energy_volume_usd
  FROM dex.trades t
  CROSS JOIN params p
  WHERE t.block_date >= p.start_date
    AND t.block_month >= date_trunc('month', p.start_date)
    AND (p.chain_filter = 'all' OR t.blockchain = p.chain_filter)
    AND (
      lower(t.token_bought_symbol) IN (SELECT lower(symbol) FROM energy_syms)
      OR lower(t.token_sold_symbol) IN (SELECT lower(symbol) FROM energy_syms)
    )
  GROUP BY 1
),
chain_daily AS (
  SELECT
    g.block_date AS day,
    COUNT(*) AS tx_count,
    COUNT(DISTINCT g.tx_from) AS active_senders,
    AVG(CAST(g.gas_price AS DOUBLE) / 1e9) AS avg_gas_gwei,
    SUM(g.tx_fee_usd) AS fee_usd
  FROM gas.fees g
  CROSS JOIN params p
  WHERE g.block_date >= p.start_date
    AND g.block_month >= date_trunc('month', p.start_date)
    AND g.blockchain IN ('ethereum','optimism','arbitrum')
    AND (p.chain_filter = 'all' OR g.blockchain = p.chain_filter)
  GROUP BY 1
),
joined AS (
  SELECT
    COALESCE(c.day, e.day) AS day,
    COALESCE(e.energy_volume_usd, 0) AS energy_volume_usd,
    COALESCE(c.tx_count, 0) AS tx_count,
    COALESCE(c.active_senders, 0) AS active_senders,
    COALESCE(c.avg_gas_gwei, 0) AS avg_gas_gwei,
    COALESCE(c.fee_usd, 0) AS fee_usd
  FROM chain_daily c
  FULL OUTER JOIN energy_daily e ON c.day = e.day
),
scored AS (
  SELECT
    day,
    energy_volume_usd,
    tx_count,
    active_senders,
    avg_gas_gwei,
    fee_usd,
    COALESCE(PERCENT_RANK() OVER (ORDER BY energy_volume_usd), 0) AS energy_score,
    COALESCE(PERCENT_RANK() OVER (ORDER BY active_senders), 0) AS activity_score,
    1 - COALESCE(PERCENT_RANK() OVER (ORDER BY avg_gas_gwei), 0) AS fee_ease_score
  FROM joined
  WHERE day IS NOT NULL
),
composited AS (
  SELECT
    *,
    0.40 * energy_score + 0.30 * activity_score + 0.30 * fee_ease_score AS composite_raw
  FROM scored
)
SELECT
  day,
  ROUND(100 * PERCENT_RANK() OVER (ORDER BY composite_raw), 0) AS health_index,
  ROUND(composite_raw, 4) AS composite_raw,
  ROUND(energy_volume_usd, 2) AS energy_volume_usd,
  tx_count,
  active_senders,
  ROUND(avg_gas_gwei, 4) AS avg_gas_gwei,
  ROUND(fee_usd, 2) AS fee_usd,
  ROUND(energy_score, 4) AS energy_score,
  ROUND(activity_score, 4) AS activity_score,
  ROUND(fee_ease_score, 4) AS fee_ease_score
FROM composited
ORDER BY day
