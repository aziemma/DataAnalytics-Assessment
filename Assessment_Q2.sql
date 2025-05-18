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


-- Categorize users based on their transaction frequency
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(transactions_per_month), 1) AS avg_transactions_per_month
FROM (
    -- Subquery to calculate each customer's monthly transaction average
    SELECT 
        u.id AS user_id,
        -- Calculate average transactions per month for each user
        COUNT(s.id) / COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) AS transactions_per_month,
        -- Create the category in the subquery instead of outer query
        CASE 
            WHEN COUNT(s.id) / COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) >= 10 THEN 'High Frequency'
            WHEN COUNT(s.id) / COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        users_customuser u
    JOIN 
        savings_savingsaccount s ON u.id = s.owner_id
    WHERE 
        s.confirmed_amount > 0
        AND u.is_active = 1
        AND u.is_account_deleted = 0
        AND u.is_account_disabled = 0
    GROUP BY 
        u.id
    HAVING 
        COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) > 0
) AS user_metrics
-- Now we can group by the field from the subquery
GROUP BY 
    frequency_category
-- Order by frequency (high to low)
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;