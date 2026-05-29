-- TASK 1: Revenue & Target Tracking

/*
The business wants to know how actual monthly revenue compares to targets. 
Calculate: 
1. total successful transaction volume per month
2. total fee revenue per month
3. the revenue target for that month
4. actual vs target gap
5. whether the month Hit or Missed target. Order chronologically.
*/


WITH monthly_rev AS (
  SELECT t.txn_month,
         COUNT(*)                                   AS total_txns,
         COUNT(CASE WHEN t.status='success' THEN 1 END) AS successful_txns,
         SUM(CASE WHEN t.status='success' THEN t.amount ELSE 0 END) AS gross_volume,
         SUM(CASE WHEN t.status='success' THEN t.fee    ELSE 0 END) AS fee_revenue
  FROM transactions t
  GROUP BY t.txn_month
)
SELECT r.txn_month,
       r.successful_txns,
       r.gross_volume,
       r.fee_revenue,
       tg.revenue_target,
       r.gross_volume - tg.revenue_target            AS gap_vs_target,
       ROUND(r.gross_volume * 100.0 / tg.revenue_target, 1) AS pct_of_target,
       CASE
         WHEN r.gross_volume >= tg.revenue_target THEN 'Hit ✓'
         ELSE                                          'Missed ✗'
       END AS target_status
FROM monthly_rev r
INNER JOIN monthly_targets tg ON r.txn_month = tg.month
ORDER BY r.txn_month;

