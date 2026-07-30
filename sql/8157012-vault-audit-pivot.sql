-- ECOP Vault Audit Pivot (query 8157012)
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
energy AS (
  SELECT
    t.block_date AS day,
    t.blockchain,
    ROUND(SUM(t.amount_usd), 2) AS energy_volume_usd,
    COUNT(*) AS energy_trades
  FROM dex.trades t
  CROSS JOIN params p
  WHERE t.block_date >= p.start_date
    AND t.block_month >= date_trunc('month', p.start_date)
    AND t.blockchain IN ('ethereum','optimism','arbitrum')
    AND (p.chain_filter = 'all' OR t.blockchain = p.chain_filter)
    AND (
      lower(t.token_bought_symbol) IN (SELECT lower(symbol) FROM energy_syms)
      OR lower(t.token_sold_symbol) IN (SELECT lower(symbol) FROM energy_syms)
    )
  GROUP BY 1, 2
),
chain AS (
  SELECT
    g.block_date AS day,
    g.blockchain,
    COUNT(*) AS tx_count,
    COUNT(DISTINCT g.tx_from) AS active_addresses,
    ROUND(AVG(CAST(g.gas_price AS DOUBLE) / 1e9), 6) AS avg_gas_gwei,
    ROUND(SUM(g.tx_fee_usd), 2) AS fee_usd
  FROM gas.fees g
  CROSS JOIN params p
  WHERE g.block_date >= p.start_date
    AND g.block_month >= date_trunc('month', p.start_date)
    AND g.blockchain IN ('ethereum','optimism','arbitrum')
    AND (p.chain_filter = 'all' OR g.blockchain = p.chain_filter)
  GROUP BY 1, 2
)
SELECT
  c.day,
  c.blockchain,
  c.tx_count,
  c.active_addresses,
  c.avg_gas_gwei,
  c.fee_usd,
  COALESCE(e.energy_volume_usd, 0) AS energy_volume_usd,
  COALESCE(e.energy_trades, 0) AS energy_trades
FROM chain c
LEFT JOIN energy e ON c.day = e.day AND c.blockchain = e.blockchain
ORDER BY c.day DESC, c.blockchain
