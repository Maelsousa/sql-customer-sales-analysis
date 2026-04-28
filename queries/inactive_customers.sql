WITH CTE AS (
SELECT 
(SELECT COUNT(tc.id_cliente) FROM decisionscard.t_cliente tc) AS total_contas_cadastradas, --total de contas
(SELECT COUNT(DISTINCT tc.id_cliente)
FROM decisionscard.t_cliente tc 
JOIN decisionscard.t_venda tv
ON tc.id_cliente = tv.id_cliente 
WHERE 
tc.fl_status_conta = 'A'  AND 
tv.fl_status_venda = 'A' AND 
tc.id_cliente
NOT IN (SELECT DISTINCT id_cliente FROM decisionscard.t_venda WHERE dt_venda BETWEEN 
(SELECT MAX(dt_venda) - INTERVAL '90 days' FROM decisionscard.t_venda) AND (SELECT MAX(dt_venda) FROM decisionscard.t_venda) )) AS contas_sem_compras_90_dias
)--contas sem compras a nos ultimos 90 dias
SELECT 
	total_contas_cadastradas,
	contas_sem_compras_90_dias,
	ROUND((contas_sem_compras_90_dias::NUMERIC / NULLIF(total_contas_cadastradas, 0)) * 100, 2) AS percentual_contas_sem_compras_90_dias --percentual de contas sem compras nos ultimos 90 dias
FROM CTE;
