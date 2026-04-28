# 📊 Customer Inactivity Analysis (SQL)

## 📌 Objective

This project analyzes customer inactivity by identifying accounts that have not made purchases in the last 90 days.

The goal is to measure customer engagement and support retention strategies.

---

## 🛠 Tools & Technologies

* SQL (PostgreSQL)
* Data Analysis

---

## 📊 Business Problem

In many businesses, identifying inactive customers is essential to prevent churn and improve retention.

This analysis answers:

* How many customers are inactive?
* What percentage of the customer base is no longer engaged?

---

## 🧮 SQL Analysis

```sql
WITH metrics AS (
    SELECT 
        (SELECT COUNT(tc.id_cliente) FROM decisionscard.t_cliente tc) AS total_accounts,
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
```

---

## 📈 Metrics

* Total number of accounts
* Number of inactive customers (90 days)
* Percentage of inactive customers

---

## 🧠 Key Insights

* A portion of the customer base becomes inactive over time
* Monitoring inactivity helps identify churn risk
* Businesses can target inactive users with retention campaigns

---

## 🚀 Conclusion

This analysis helps businesses track customer inactivity and take proactive actions to improve retention and engagement.

---

## 👨‍💻 Author

Manoel Sousa Gomes

🔗 LinkedIn: https://www.linkedin.com/in/manoel-sousa-712a6b240/
🔗 GitHub: https://github.com/Maelsousa
