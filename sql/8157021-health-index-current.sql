-- ECOP Health Index Current (query 8157021)
-- Latest complete day (excludes today partial). Same formula as 8157001.
-- Params: date_range, blockchain

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
    ('OIL'),('USO'),('USOon'),('WTIC'),('WTI'),('XOIL'),('CRUDE'),('Oil'),
    ('XLE'),('XOMon'),('CVXon'),('CEGon'),('NEEon'),('TLNon'),
    ('NATGAS'),('NGAS'),('NGTG$$'),('PAXG'),('XAUt'),('XAUt0'),('XAUT0')
  ) AS t(symbol)
),
energy_daily AS (
  SELECT t.block_date AS day, SUM(t.amount_usd) AS energy_volume_usd
  FROM dex.trades t CROSS JOIN params p
  WHERE t.block_date >= p.start_date AND t.block_date < CURRENT_DATE
    AND t.block_month >= date_trunc('month', p.start_date)
    AND (p.chain_filter = 'all' OR t.blockchain = p.chain_filter)
    AND (lower(t.token_bought_symbol) IN (SELECT lower(symbol) FROM energy_syms)
      OR lower(t.token_sold_symbol) IN (SELECT lower(symbol) FROM energy_syms))
  GROUP BY 1
),
chain_daily AS (
  SELECT g.block_date AS day, COUNT(*) AS tx_count,
    COUNT(DISTINCT g.tx_from) AS active_senders,
    AVG(CAST(g.gas_price AS DOUBLE) / 1e9) AS avg_gas_gwei
  FROM gas.fees g CROSS JOIN params p
  WHERE g.block_date >= p.start_date AND g.block_date < CURRENT_DATE
    AND g.block_month >= date_trunc('month', p.start_date)
    AND g.blockchain IN ('ethereum','optimism','arbitrum')
    AND (p.chain_filter = 'all' OR g.blockchain = p.chain_filter)
  GROUP BY 1
),
joined AS (
  SELECT COALESCE(c.day, e.day) AS day,
    COALESCE(e.energy_volume_usd, 0) AS energy_volume_usd,
    COALESCE(c.active_senders, 0) AS active_senders,
    COALESCE(c.avg_gas_gwei, 0) AS avg_gas_gwei
  FROM chain_daily c FULL OUTER JOIN energy_daily e ON c.day = e.day
),
scored AS (
  SELECT day, energy_volume_usd, active_senders, avg_gas_gwei,
    COALESCE(PERCENT_RANK() OVER (ORDER BY energy_volume_usd), 0) AS energy_score,
    COALESCE(PERCENT_RANK() OVER (ORDER BY active_senders), 0) AS activity_score,
    1 - COALESCE(PERCENT_RANK() OVER (ORDER BY avg_gas_gwei), 0) AS fee_ease_score
  FROM joined WHERE day IS NOT NULL
),
composited AS (
  SELECT day,
    0.40 * energy_score + 0.30 * activity_score + 0.30 * fee_ease_score AS composite_raw,
    ROUND(100 * PERCENT_RANK() OVER (ORDER BY 0.40 * energy_score + 0.30 * activity_score + 0.30 * fee_ease_score), 0) AS health_index
  FROM scored
)
SELECT day, health_index, ROUND(composite_raw, 4) AS composite_raw
FROM composited
ORDER BY day DESC
LIMIT 1
