# 💼 Data Analyst Assessment – Cowrywise

This repository contains SQL solutions for key analytics scenarios based on real-world banking and fintech use cases. The tasks were part of a data analytics assessment designed to demonstrate practical SQL proficiency, business understanding, and data storytelling ability.

---

## 📊 Project Overview

The project consists of four major analytical tasks:

---

### 1. High-Value Customers with Multiple Products

**🧠 Thought Process:**

- I used `is_regular_savings` and `is_fixed_investment` flags in the `plans_plan` table to distinguish between savings and investment plans.
- The query joins three core tables: `users_customuser`, `plans_plan`, and `savings_savingsaccount`.
- "Funded" plans were identified by a positive `confirmed_amount`.
- I filtered out inactive, archived, or deleted accounts to focus on currently active customers.
- The `HAVING` clause ensures customers have at least one savings plan and one investment plan.
- Results are ordered by total deposits to prioritize customers with higher value and engagement.

**💡 Outcome:**  
A curated list of active, high-value customers with diversified portfolios, ideal for targeted marketing or cross-sell campaigns.

---

### 2. Transaction Frequency Analysis

**🧠 Thought Process:**

- A subquery was used to calculate each customer's average monthly transactions.
- In the outer query:
  - Customers were segmented into **High**, **Medium**, or **Low** activity categories.
  - Counts and averages were computed per segment.
- A `CASE` statement in `ORDER BY` ensured logical sorting of frequency bands.
- The analysis focused only on completed, active transactions for accuracy.

**📈 Business Use:**  
Enables the business to monitor engagement levels, track campaign effectiveness, and identify opportunities to shift users into higher activity segments.

---

### 3. Account Inactivity Alert

**🧠 Thought Process:**

- The goal was to find active accounts (savings or investments) with no inflow transactions in the last 365 days.
- Used `is_regular_savings` and `is_fixed_investment` to focus on relevant plans.
- Excluded plans that were archived, deleted, or inactive based on `is_deleted`, `is_archived`, and `status_id`.
- A `LEFT JOIN` ensured inclusion of plans even with no transactions.
- Identified inflows using a specific `transaction_type_id` and filtered based on last transaction date.

**📌 Result:**  
A report listing dormant accounts that are still marked active, allowing the operations team to investigate or prompt user re-engagement.

---

### 4. Customer Lifetime Value (CLV) Estimation

**🧠 Thought Process:**

- Tenure was calculated from `date_joined` in months using `TIMESTAMPDIFF`.
- Total transactions were counted from `savings_savingsaccount`.
- Assumed a 0.1% profit margin per transaction.
- Used the formula:  
  `CLV = (total_transactions / tenure_months) × 12 × average_profit_per_transaction`
- Employed `NULLIF` to avoid division by zero for users with very short tenure.
- Results were sorted by CLV, highlighting the most valuable customers.

**💰 Benefit:**  
Provides marketing with a prioritized view of high-value customers, supporting personalized campaigns and retention strategies.

---

## ⚠️ Challenges Faced

1. **Ambiguous inflow identification** – The `transaction_type_id` field wasn’t well documented, so I had to assume which values indicated actual deposits.
2. **Determining active plans** – I inferred plan activity status using `is_archived`, `is_deleted`, and `status_id` without clear definitions.
3. **Edge cases in CLV calculation** – Preventing divide-by-zero errors required careful use of `NULLIF` for users with very short account tenure.

---
