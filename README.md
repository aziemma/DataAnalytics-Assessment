# 💼 Data Analyst Assessment – Cowrywse

This repository contains SQL solutions for key analytics scenarios based on real-world banking and fintech use cases. The tasks were part of a data analytics assessment designed to demonstrate practical SQL proficiency, business understanding, and data storytelling ability.

---

## 📊 Project Overview

The project covers four major analytical tasks:

1. **High-Value Customers with Multiple Products**  
My Thought Process:
-- When I looked at this problem, I had to make some assumptions about how to identify savings plans versus investment plans in our database. Looking at the plans_plan table, I noticed we have Boolean flags is_regular_savings and is_fixed_investment which clearly differentiate between the two plan types we're interested in.
-- I started by joining our three core tables. The user table gives us customer information, the plans table tells us what type of plans they have, and the savings account table shows us the actual transaction data and amounts.
-- For "funded" plans, I'm assuming that means plans with a positive confirmed amount in the savings_savingsaccount table. I'm using the confirmed_amount field rather than just amount since this represents money that has actually settled in the account.
-- I'm excluding inactive, deleted, or disabled accounts since we only want to target active customers for cross-selling. This helps keep our marketing efforts focused on users who can actually respond.
-- The HAVING clause is where the real magic happens - it filters for users with at least one savings plan AND at least one investment plan. I'm using COUNT(DISTINCT...) to ensure we count each plan only once even if it has multiple transactions.
-- Finally, I'm ordering by total deposits to prioritize our highest-value customers first. These are the ones most likely to respond positively to cross-selling efforts and who represent the highest potential lifetime value.
-- This query gives us a focused list of customers who have already shown interest in both savings and investment products, making them prime candidates for deeper engagement and additional product offerings.RetryClaude does not have the ability to run the code it generates yet.Claude can make mistakes. Please double-check responses.


2. **Transaction Frequency Analysis**  
-- My Thought Process:
-- Looking at the expected output format, I realized we need summary statistics rather than individual customer data. This called for a different approach using a nested query.
-- First, I needed to calculate each customer's average monthly transactions in a subquery. This gives us a derived table with customer IDs and their individual transaction frequency.
-- In the outer query, I then:

-- Categorized each customer based on their average monthly transactions
-- Counted the number of customers in each category
-- Calculated the average of all the individual monthly transaction averages within each category

-- The ORDER BY clause uses a CASE statement to ensure the categories appear in the logical order (High → Medium → Low) rather than alphabetical order.
-- This view gives the finance team exactly what they need - a clear breakdown of how many customers fall into each frequency category and what the average activity level is within each group. They can use this data to:

-- Understand the overall distribution of customer activity
-- Set realistic targets for shifting customers between segments
-- Measure the effectiveness of campaigns designed to increase transaction frequency
-- Report on customer engagement metrics to stakeholders

-- The analysis focuses only on active accounts with completed transactions, giving us the most accurate picture of genuine customer behavior.RetryClaude does not have the ability to run the code it generates yet.


3. **Account Inactivity Alert**
   -- My Thought process
-- While reviewing the request from the ops team, I set out to identify active savings and investment accounts that hadn't received any inflow transactions in over a year. 
-- I began by examining the plans_plan table to find active plans — filtering out any that were marked as deleted or archived. 
-- Then, I focused on just the savings and investment accounts, using the is_regular_savings and is_fixed_investment flags. 
-- To track activity, I turned to the savings_savingsaccount table and assumed that inflow transactions were tagged with a specific transaction_type_id. 
-- I used a LEFT JOIN to ensure I included even those plans with no transactions at all, and calculated how many days had passed since the last inflow. 
-- Finally, I filtered the results to only include those with more than 365 days of inactivity, producing a concise list of dormant yet active accounts that needed attention.



4. **Customer Lifetime Value (CLV) Estimation**
   -- My Thought process
-- To help marketing estimate customer lifetime value (CLV), I built a simple model using two things: how long a customer has been with us and how often they transact. 
-- I pulled the signup date from users_customuser to calculate tenure in months, and used savings_savingsaccount to count each customer’s total transactions.

-- Assuming we make a 0.1% profit on each transaction, I calculated the average profit per transaction as 0.001 * AVG(transaction amount). Then, I used this formula to estimate CLV:

-- CLV=(total transactions/tenure months) × 12 × avg profit per transaction

-- This gives us an annualized value based on how frequently the customer transacts.
-- I also made sure to avoid dividing by zero for new users. Finally, 
-- I sorted the list from highest to lowest CLV so the team can focus on our most valuable customers.

### Challenges faced:
1. Determining inflow transactions was tricky because the savings_savingsaccount table didn’t explicitly label transaction types, so I had to assume which transaction_type_id values represented inflows.
2. Identifying active accounts required interpretation, since fields like is_archived, is_deleted, and status_id weren’t documented, so I assumed that non-archived, non-deleted plans with valid status were active.
3. Avoiding division by zero in CLV calculation was necessary for customers with less than a month of tenure, so I used NULLIF to safely skip those edge cases.

---
