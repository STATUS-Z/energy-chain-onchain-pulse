-- ECOP Scoreboard Counters (query 8157003)
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
energy_vol AS (
  SELECT COALESCE(SUM(t.amount_usd), 0) AS energy_volume_usd
  FROM dex.trades t
  CROSS JOIN params p
  WHERE t.block_date >= p.start_date
    AND t.block_month >= date_trunc('month', p.start_date)
    AND (p.chain_filter = 'all' OR t.blockchain = p.chain_filter)
    AND (
      lower(t.token_bought_symbol) IN (SELECT lower(symbol) FROM energy_syms)
      OR lower(t.token_sold_symbol) IN (SELECT lower(symbol) FROM energy_syms)
    )
),
gas_agg AS (
  SELECT COALESCE(SUM(g.tx_fee_usd), 0) AS gas_fees_usd
  FROM gas.fees g
  CROSS JOIN params p
  WHERE g.block_date >= p.start_date
    AND g.block_month >= date_trunc('month', p.start_date)
    AND g.blockchain IN ('ethereum','optimism','arbitrum')
    AND (p.chain_filter = 'all' OR g.blockchain = p.chain_filter)
),
whale_flows AS (
  SELECT
    SUM(CASE
      WHEN lower(t.token_bought_symbol) IN (SELECT lower(symbol) FROM energy_syms)
        THEN t.amount_usd ELSE 0 END)
    - SUM(CASE
      WHEN lower(t.token_sold_symbol) IN (SELECT lower(symbol) FROM energy_syms)
        THEN t.amount_usd ELSE 0 END) AS whale_net_flow_usd
  FROM dex.trades t
  CROSS JOIN params p
  WHERE t.block_date >= GREATEST(p.start_date, CURRENT_DATE - INTERVAL '7' DAY)
    AND t.block_month >= date_trunc('month', GREATEST(p.start_date, CURRENT_DATE - INTERVAL '7' DAY))
    AND (p.chain_filter = 'all' OR t.blockchain = p.chain_filter)
    AND t.amount_usd >= 25000
    AND (
      lower(t.token_bought_symbol) IN (SELECT lower(symbol) FROM energy_syms)
      OR lower(t.token_sold_symbol) IN (SELECT lower(symbol) FROM energy_syms)
    )
),
most_active AS (
  SELECT blockchain AS most_active_chain, tx_count
  FROM (
    SELECT g.blockchain, COUNT(*) AS tx_count
    FROM gas.fees g
    CROSS JOIN params p
    WHERE g.block_date >= p.start_date
      AND g.block_month >= date_trunc('month', p.start_date)
      AND g.blockchain IN ('ethereum','optimism','arbitrum')
      AND (p.chain_filter = 'all' OR g.blockchain = p.chain_filter)
    GROUP BY 1
  )
  ORDER BY tx_count DESC
  LIMIT 1
)
SELECT
  ROUND(e.energy_volume_usd, 0) AS energy_volume_usd,
  ROUND(g.gas_fees_usd, 0) AS gas_fees_usd,
  ROUND(COALESCE(w.whale_net_flow_usd, 0), 0) AS whale_net_flow_7d_usd,
  COALESCE(m.most_active_chain, 'n/a') AS most_active_chain,
  COALESCE(m.tx_count, 0) AS most_active_tx_count
FROM energy_vol e
CROSS JOIN gas_agg g
CROSS JOIN whale_flows w
CROSS JOIN most_active m
