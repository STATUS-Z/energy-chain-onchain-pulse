-- ECOP Whale Smart Flows (query 8157011)
-- Whale = single DEX trade >= $25k USD
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
flows AS (
  SELECT
    t.block_date AS day,
    SUM(CASE WHEN lower(t.token_bought_symbol) IN (SELECT lower(symbol) FROM energy_syms)
      THEN t.amount_usd ELSE 0 END) AS whale_buy_usd,
    SUM(CASE WHEN lower(t.token_sold_symbol) IN (SELECT lower(symbol) FROM energy_syms)
      THEN t.amount_usd ELSE 0 END) AS whale_sell_usd
  FROM dex.trades t
  CROSS JOIN params p
  WHERE t.block_date >= p.start_date
    AND t.block_month >= date_trunc('month', p.start_date)
    AND (p.chain_filter = 'all' OR t.blockchain = p.chain_filter)
    AND t.amount_usd >= 25000
    AND (
      lower(t.token_bought_symbol) IN (SELECT lower(symbol) FROM energy_syms)
      OR lower(t.token_sold_symbol) IN (SELECT lower(symbol) FROM energy_syms)
    )
  GROUP BY 1
)
SELECT
  day,
  ROUND(whale_buy_usd, 0) AS whale_buy_usd,
  ROUND(whale_sell_usd, 0) AS whale_sell_usd,
  ROUND(whale_buy_usd - whale_sell_usd, 0) AS whale_net_usd
FROM flows
ORDER BY day
