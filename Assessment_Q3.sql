-- My Thought process
-- While reviewing the request from the ops team, I set out to identify active savings and investment accounts that hadn't received any inflow transactions in over a year. 
-- I began by examining the plans_plan table to find active plans — filtering out any that were marked as deleted or archived. 
-- Then, I focused on just the savings and investment accounts, using the is_regular_savings and is_fixed_investment flags. 
-- To track activity, I turned to the savings_savingsaccount table and assumed that inflow transactions were tagged with a specific transaction_type_id. 
-- I used a LEFT JOIN to ensure I included even those plans with no transactions at all, and calculated how many days had passed since the last inflow. 
-- Finally, I filtered the results to only include those with more than 365 days of inactivity, producing a concise list of dormant yet active accounts that needed attention.


-- -- Account Inactivity Alert Query
-- -- Find active accounts with no inflow transactions for over 1 year (365 days)

SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_fixed_investment = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s 
    ON p.id = s.plan_id
    AND s.transaction_type_id = 1 -- assuming 1 means inflow
WHERE 
    p.is_deleted = 0
    AND p.is_archived = 0
    AND (
        p.is_regular_savings = 1 OR 
        p.is_fixed_investment = 1
    )
GROUP BY p.id, p.owner_id, type
HAVING MAX(s.transaction_date) IS NULL 
    OR DATEDIFF(CURDATE(), MAX(s.transaction_date)) > 365;