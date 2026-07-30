-- ECOP Top Energy Tokens Volume (query 8157005)
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
    ('OIL','crude'),('USO','crude'),('USOon','crude'),('WTIC','crude'),('WTI','crude'),
    ('XOIL','crude'),('CRUDE','crude'),('Oil','crude'),
    ('XLE','energy_equity'),('XOMon','energy_equity'),('CVXon','energy_equity'),
    ('CEGon','energy_equity'),('NEEon','energy_equity'),('TLNon','energy_equity'),
    ('NATGAS','natgas'),('NGAS','natgas'),('NGTG$$','natgas'),
    ('PAXG','metals'),('XAUt','metals'),('XAUt0','metals'),('XAUT0','metals')
  ) AS t(symbol, bucket)
),
legs AS (
  SELECT
    CASE
      WHEN lower(t.token_bought_symbol) IN (SELECT lower(symbol) FROM energy_syms)
        THEN t.token_bought_symbol
      ELSE t.token_sold_symbol
    END AS token_symbol,
    t.blockchain,
    t.amount_usd
  FROM dex.trades t
  CROSS JOIN params p
  WHERE t.block_date >= p.start_date
    AND t.block_month >= date_trunc('month', p.start_date)
    AND (p.chain_filter = 'all' OR t.blockchain = p.chain_filter)
    AND (
      lower(t.token_bought_symbol) IN (SELECT lower(symbol) FROM energy_syms)
      OR lower(t.token_sold_symbol) IN (SELECT lower(symbol) FROM energy_syms)
    )
)
SELECT
  l.token_symbol,
  COALESCE(e.bucket, 'other') AS bucket,
  ROUND(SUM(l.amount_usd), 0) AS volume_usd,
  COUNT(*) AS trades
FROM legs l
LEFT JOIN energy_syms e ON lower(l.token_symbol) = lower(e.symbol)
GROUP BY 1, 2
ORDER BY volume_usd DESC
LIMIT 15
