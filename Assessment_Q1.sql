-- My Thought Process:
-- When I looked at this problem, I had to make some assumptions about how to identify savings plans versus investment plans in our database. Looking at the plans_plan table, I noticed we have Boolean flags is_regular_savings and is_fixed_investment which clearly differentiate between the two plan types we're interested in.
-- I started by joining our three core tables. The user table gives us customer information, the plans table tells us what type of plans they have, and the savings account table shows us the actual transaction data and amounts.
-- For "funded" plans, I'm assuming that means plans with a positive confirmed amount in the savings_savingsaccount table. I'm using the confirmed_amount field rather than just amount since this represents money that has actually settled in the account.
-- I'm excluding inactive, deleted, or disabled accounts since we only want to target active customers for cross-selling. This helps keep our marketing efforts focused on users who can actually respond.
-- The HAVING clause is where the real magic happens - it filters for users with at least one savings plan AND at least one investment plan. I'm using COUNT(DISTINCT...) to ensure we count each plan only once even if it has multiple transactions.
-- Finally, I'm ordering by total deposits to prioritize our highest-value customers first. These are the ones most likely to respond positively to cross-selling efforts and who represent the highest potential lifetime value.
-- This query gives us a focused list of customers who have already shown interest in both savings and investment products, making them prime candidates for deeper engagement and additional product offerings.RetryClaude does not have the ability to run the code it generates yet.Claude can make mistakes. Please double-check responses.


-- Query to identify high-value customers with both savings and investment plans
-- This helps us target cross-selling opportunities
SELECT 
   u.id AS owner_id,
   -- i had to add email, cuz there was no data for name
   u.email, 
   u.name,
   -- Count distinct savings plans per user
   COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
   -- Count distinct investment plans per user
   COUNT(DISTINCT CASE WHEN p.is_fixed_investment = 1 THEN p.id END) AS investment_count,
   -- Calculate total deposits across all plans
   SUM(s.confirmed_amount) AS total_deposits
FROM 
   -- Start with the users table as our base
   users_customuser u
JOIN 
   -- Connect to plans table to identify plan types
   plans_plan p ON u.id = p.owner_id
JOIN 
   -- Connect to savings accounts to get transaction details
   savings_savingsaccount s ON p.id = s.plan_id AND s.owner_id = u.id
WHERE 
   -- Only include funded accounts (positive confirmed amount)
   s.confirmed_amount > 0
   -- Exclude inactive users
   AND u.is_active = 1
   -- Exclude deleted accounts
   AND u.is_account_deleted = 0
   -- Exclude disabled accounts
   AND u.is_account_disabled = 0
GROUP BY 
   u.id, u.email, u.name
HAVING 
   -- Filter for users with at least one savings plan
   COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) >= 1
   -- AND at least one investment plan
   AND COUNT(DISTINCT CASE WHEN p.is_fixed_investment = 1 THEN p.id END) >= 1
ORDER BY 
   -- Sort by total deposits (highest first) to identify highest-value customers
   total_deposits DESC;
   
   
    
    
