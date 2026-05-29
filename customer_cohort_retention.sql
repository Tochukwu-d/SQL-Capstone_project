-- Task 2

/* Customer Cohort Retention
Group customers by signup month (cohort). For each cohort, 
calculate how many customers transacted in Month 0 (their signup month), 
Month 1 (one month later), and Month 2 (two months later). 
Show retention % at each stage. Use only successful transactions.
*/

-- cohort_class CTE block to classify the different customer cohort based on signup
WITH cohort_class AS (        
  SELECT c.customer_id,
         c.signup_month AS cohort,
         MAX(CASE WHEN t.txn_month = c.signup_month THEN 1 ELSE 0 END) AS m0,
         MAX(CASE WHEN t.txn_month = CASE c.signup_month
               WHEN '2024-01' THEN '2024-02'
               WHEN '2024-02' THEN '2024-03'
               WHEN '2024-03' THEN '2024-04'
               ELSE NULL END THEN 1 ELSE 0 END) AS m1,
         MAX(CASE WHEN t.txn_month = CASE c.signup_month
               WHEN '2024-01' THEN '2024-03'
               WHEN '2024-02' THEN '2024-04'
               ELSE NULL END THEN 1 ELSE 0 END) AS m2
  FROM customers c
  LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
    AND t.status = 'success'
  GROUP BY c.customer_id, c.signup_month
),
cohort_summary AS (     -- cohort_summary CTE block to produce a summary table
  SELECT cohort,
         COUNT(*)       AS cohort_size,
         SUM(m0)        AS active_m0,
         SUM(m1)        AS active_m1,
         SUM(m2)        AS active_m2
  FROM cohort_class
  GROUP BY cohort
)
SELECT cohort,
       cohort_size,
       active_m0,
       ROUND(active_m0 * 100.0 / cohort_size, 0) AS m0_pct,
       active_m1,
       ROUND(active_m1 * 100.0 / cohort_size, 0) AS m1_pct,
       active_m2,
       ROUND(active_m2 * 100.0 / cohort_size, 0) AS m2_pct
FROM cohort_summary
ORDER BY cohort;
