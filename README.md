📁 Project Overview
This analysis uses a simulated Nigerian fintech dataset (modelled after platforms like PalmPay, 
Flutterwave, and Moniepoint) to answer three real business questions a data analyst would be asked
in a quarterly business review.

DATABASE SCHEMA
customers          transactions          products
───────────        ─────────────         ────────
customer_id  PK    txn_id        PK      product_id  PK
name               customer_id   FK →    product_name
city               product_id    FK →    category
plan               amount                fee_rate
signup_month       txn_month
age_group          channel
                   status
                   fee

agents             monthly_targets
──────             ───────────────
agent_id    PK     month
agent_name         revenue_target
region             txn_target
customer_id FK →

Dataset stats:
- 20 customers across Lagos, Abuja, Kano, Enugu
- ~200 transactions spanning January – April 2024
- 6 financial products across 4 categories
- 4 sales agents across 4 regions

Analysis Questions & Key Findings
Q1 — Revenue & Target Tracking

"How did actual monthly revenue compare to our targets?"

This calculates gross transaction volume, fee revenue, and target attainment per month. 
Uses a JOIN to the targets table and a CASE WHEN label (Hit ✓ / Missed ✗) for executive-ready output.
Key finding: The platform hit revenue targets in January and February, but missed in March, which suggests a post-promotional dip.
April showed recovery, coming within 5% of target.

Q2 — Cohort Retention Analysis

"Of the customers who joined in January, how many were still transacting in February and March?"

Groups customers by sign-up month (cohort) and tracks the percentage that remained active at Month 0, Month 1, and Month 2. 
Uses conditional aggregation (MAX(CASE WHEN ...)) instead of multiple subqueries.
Key finding: January cohort had strong Month-1 retention (~80%) but dropped sharply at Month 2 (~55%). 
February and March cohorts showed similar Month-1 patterns, suggesting an onboarding drop-off problem rather than a product issue.

Q3 — Product & Channel Performance

"Which product categories and payment channels drive the most revenue?"

Joins transactions to products, groups by category + channel, and calculates each combination's share of total gross volume 
using SUM() OVER () — no subquery needed.
Key finding: Bank Transfers via mobile channel drove the highest absolute volume. 
POS Withdrawals had the highest fee rate (2.5%), making them disproportionately valuable per transaction despite lower volume.
