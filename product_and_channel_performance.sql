-- Task 3: Product & Channel Performance
/*
Product & Channel Performance
Which products and channels are driving the most revenue? 
Write a query showing: for each product category AND channel combination — transaction count, 
gross volume, fee revenue, average transaction size, and % of total volume. 
Order by gross volume descending.
*/

-- txn_details CTE block to get only success transaction info
WITH txn_detail AS (
  SELECT t.txn_month,
         p.category,
         t.channel,
         t.amount,
         t.fee,
         t.status
  FROM transactions t
  INNER JOIN products p ON t.product_id = p.product_id
  WHERE t.status = 'success'
),
agg AS (      -- aggregate CTE block
  SELECT category,
         channel,
         COUNT(*)       AS txn_count,
         SUM(amount)    AS gross_volume,
         SUM(fee)       AS fee_revenue,
         AVG(amount)    AS avg_txn_size
  FROM txn_detail
  GROUP BY category, channel
)
SELECT category,
       channel,
       txn_count,
       gross_volume,
       fee_revenue,
       ROUND(avg_txn_size, 0)                                     AS avg_txn_size,
       ROUND(gross_volume * 100.0 / SUM(gross_volume) OVER (), 1) AS pct_of_total
FROM agg
ORDER BY gross_volume DESC;