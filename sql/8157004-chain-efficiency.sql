-- ECOP Chain Efficiency (query 8157004)
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
gas_daily AS (
  SELECT
    g.blockchain,
    g.block_date AS day,
    COUNT(*) AS tx_count,
    COUNT(DISTINCT g.tx_from) AS active_addresses,
    AVG(CAST(g.gas_price AS DOUBLE) / 1e9) AS avg_gas_gwei,
    SUM(g.tx_fee_usd) AS fee_usd
  FROM gas.fees g
  CROSS JOIN params p
  WHERE g.block_date >= p.start_date
    AND g.block_month >= date_trunc('month', p.start_date)
    AND g.blockchain IN ('ethereum','optimism','arbitrum')
    AND (p.chain_filter = 'all' OR g.blockchain = p.chain_filter)
  GROUP BY 1, 2
),
block_times AS (
  SELECT 'ethereum' AS blockchain, date(time) AS day,
    date_diff('second', MIN(time), MAX(time)) * 1.0 / NULLIF(COUNT(*) - 1, 0) AS avg_block_time_sec
  FROM ethereum.blocks
  CROSS JOIN params p
  WHERE time >= CAST(p.start_date AS TIMESTAMP)
  GROUP BY 1, 2
  UNION ALL
  SELECT 'optimism', date(time),
    date_diff('second', MIN(time), MAX(time)) * 1.0 / NULLIF(COUNT(*) - 1, 0)
  FROM optimism.blocks
  CROSS JOIN params p
  WHERE time >= CAST(p.start_date AS TIMESTAMP)
  GROUP BY 1, 2
  UNION ALL
  SELECT 'arbitrum', date(time),
    date_diff('second', MIN(time), MAX(time)) * 1.0 / NULLIF(COUNT(*) - 1, 0)
  FROM arbitrum.blocks
  CROSS JOIN params p
  WHERE time >= CAST(p.start_date AS TIMESTAMP)
  GROUP BY 1, 2
)
SELECT
  g.day,
  g.blockchain,
  g.tx_count,
  g.active_addresses,
  ROUND(g.avg_gas_gwei, 6) AS avg_gas_gwei,
  ROUND(g.fee_usd, 2) AS fee_usd,
  ROUND(CAST(b.avg_block_time_sec AS DOUBLE), 4) AS avg_block_time_sec
FROM gas_daily g
LEFT JOIN block_times b
  ON g.blockchain = b.blockchain AND g.day = b.day
ORDER BY g.day, g.blockchain
