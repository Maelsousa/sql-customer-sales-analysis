-- 📊 Customer Inactivity Analysis (Last 90 Days)
-- Objective: Identify inactive customers and calculate inactivity rate

WITH metrics AS (
    SELECT 
        -- Total registered accounts
        (SELECT COUNT(tc.id_cliente) 
         FROM decisionscard.t_cliente tc) AS total_accounts,

        -- Customers without purchases in the last 90 days
        (SELECT COUNT(DISTINCT tc.id_cliente)
         FROM decisionscard.t_cliente tc 
         JOIN decisionscard.t_venda tv
           ON tc.id_cliente = tv.id_cliente 
         WHERE 
            tc.fl_status_conta = 'A'
            AND tv.fl_status_venda = 'A'
            AND tc.id_cliente NOT IN (
                SELECT DISTINCT id_cliente 
                FROM decisionscard.t_venda 
                WHERE dt_venda BETWEEN 
                    (SELECT MAX(dt_venda) - INTERVAL '90 days' FROM decisionscard.t_venda)
                    AND 
                    (SELECT MAX(dt_venda) FROM decisionscard.t_venda)
            )
        ) AS inactive_customers
)

SELECT 
    total_accounts,
    inactive_customers,
    ROUND(
        (inactive_customers::NUMERIC / NULLIF(total_accounts, 0)) * 100, 
        2
    ) AS inactivity_rate_percentage
FROM metrics;
