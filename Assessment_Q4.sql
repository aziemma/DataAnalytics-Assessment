-- My Thought process
-- To help marketing estimate customer lifetime value (CLV), I built a simple model using two things: how long a customer has been with us and how often they transact. 
-- I pulled the signup date from users_customuser to calculate tenure in months, and used savings_savingsaccount to count each customer’s total transactions.

-- Assuming we make a 0.1% profit on each transaction, I calculated the average profit per transaction as 0.001 * AVG(transaction amount). Then, I used this formula to estimate CLV:

-- CLV=(total transactions/tenure months) × 12 × avg profit per transaction

-- This gives us an annualized value based on how frequently the customer transacts.
-- I also made sure to avoid dividing by zero for new users. Finally, 
-- I sorted the list from highest to lowest CLV so the team can focus on our most valuable customers.

SELECT 
    u.id AS customer_id, -- Get the customer's unique ID
    u.name, -- Get the customer's name
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months, -- we Calculate how many months since the customer joined
    COUNT(s.id) AS total_transactions, -- then Count the total number of transactions the customer has made
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) -- and find the Average transactions per month (avoid division by zero)
        * 12 -- Annualize the rate
        * 0.001 -- Assume 0.1% profit per transaction
        * AVG(s.amount), -- Use the average transaction amount to estimate profit per transaction
    2) AS estimated_clv -- Round the final CLV to 2 decimal places
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id -- Join transactions to users using owner_id
GROUP BY u.id, u.name -- Group by customer to aggregate transactions and calculate CLV
ORDER BY estimated_clv DESC; -- Show customers with highest CLV first
