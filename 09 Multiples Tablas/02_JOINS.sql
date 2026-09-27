
-- DESAFIO

/*  Tablas y columnas disponibles:
    orders: id, customer_id

products: id, unit_price, units_in_stock
order_items: id, order_id, product_id, quantity
Busca los IDs de los clientes que hayan pedido productos con un precio unitario inferior a 10 y muestra la cantidad total de esos productos baratos que ha pedido cada cliente.

Devuelve las siguientes columnas:

customer_id
total_quantity (la suma de las cantidades de productos con un precio unitario < 10 para cada cliente) */

SELECT o.customer_id, SUM(oi.quantity) as total_quantity
FROM orders as o
INNER JOIN order_items as oi
    ON o.id = oi.order_id
INNER JOIN products as pr
    ON oi.product_id = pr.id
WHERE pr.unit_price < 10
GROUP BY o.customer_id;