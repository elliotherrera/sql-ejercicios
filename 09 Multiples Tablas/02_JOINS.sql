
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


-- EJERCICIOS BASICOS

/* 1. Muestra el nombre de cada empleado junto con el nombre de su departamento.
   empleados (id_empleado, nombre, id_departamento, salario, fecha_contratacion)
   departamentos (id_departamento, nombre_departamento, ubicacion) */

SELECT emp.nombre, dep.nombre_departamento
FROM empleados AS emp
INNER JOIN departamentos AS dep
    ON emp.id_departamento = dep.id_departamento;


/* 2. Muestra el nombre de cada producto junto con el nombre de su proveedor.
   productos (id_producto, nombre, id_proveedor, precio, stock)
   proveedores (id_proveedor, nombre, pais) */

SELECT pr.nombre, pe.nombre
FROM productos AS pr
INNER JOIN proveedores AS pe
    ON pr.id_proveedor = pe.id_proveedor;

/* 3. Muestra el nombre de cada ciudad junto con el nombre del país al que pertenece.
   ciudades (id_ciudad, nombre_ciudad, id_pais, es_capital)
   paises (id_pais, nombre_pais, continente, poblacion) */

SELECT c.nombre_ciudad, p.nombre_pais
FROM ciudades AS c
INNER JOIN paises AS p
    ON c.id_pais = p.id_pais;


-- EJERCICIOS INTERMEDIOS

/* 1. Muestra el nombre del empleado, su salario y el nombre del departamento,
   solo para empleados cuyo salario sea mayor a 3000.
   empleados (id_empleado, nombre, id_departamento, salario, fecha_contratacion)
   departamentos (id_departamento, nombre_departamento, ubicacion) */

SELECT emp.nombre, emp.salario, dep.nombre_departamento
FROM empleados AS emp
INNER JOIN departamentos AS dep
    ON emp.id_departamento = dep.id_departamento
WHERE emp.salario > 3000;

/* 2. Muestra el nombre de cada proveedor junto con la cantidad de productos
   distintos que provee, ordenado de mayor a menor cantidad.
   productos (id_producto, nombre, id_proveedor, precio, stock)
   proveedores (id_proveedor, nombre, pais) */

SELECT prov.nombre, COUNT(DISTINCT prod.nombre) as cantidad
FROM productos AS prod
JOIN proveedores AS prov
    ON prod.id_proveedor = prov.id_proveedor
GROUP BY prov.nombre
ORDER BY cantidad DESC;

/* 3. Muestra el nombre del cliente, el id del pedido y el total, solo para
   pedidos realizados entre '2025-01-01' y '2025-03-31'.
   clientes (id_cliente, nombre, ciudad)
   pedidos (id_pedido, id_cliente, fecha_pedido, total) */

SELECT cl.nombre, pe.id_pedido, pe.total
FROM clientes AS cl
JOIN pedidos AS pe
    ON cl.id_cliente = pe.id_cliente
WHERE pe.fecha_pedido BETWEEN '2025-01-01' AND '2025-03-31';

/* 4. Muestra el nombre del país, su población y el nombre de su ciudad capital
   (es_capital = 1), ordenado por población de mayor a menor, mostrando solo
   los 5 primeros.
   paises (id_pais, nombre_pais, continente, poblacion)
   ciudades (id_ciudad, nombre_ciudad, id_pais, es_capital) */

SELECT pa.nombre_pais, pa.poblacion, ci.nombre_ciudad
FROM paises AS pa
JOIN ciudades AS ci
    ON pa.id_pais = ci.id_pais
WHERE ci.es_capital = 1
ORDER BY pa.poblacion DESC
LIMIT 5;


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla (o da un resultado ambiguo/incorrecto) esta query? Explicá
   el motivo y cómo corregirla.
   empleados (id_empleado, nombre, id_departamento, salario, fecha_contratacion)
   departamentos (id_departamento, nombre_departamento, ubicacion) */
SELECT e.nombre, d.nombre_departamento, COUNT(*) AS cantidad_empleados
FROM empleados AS e
INNER JOIN departamentos AS d
    ON e.id_departamento = d.id_departamento
GROUP BY d.nombre_departamento;
/* razon del error 
    Falta agregar un campo a GROUP BY, en select hay integracio nagregada y 2 columnas, en group by tambei ndebe haber esas 2:
SELECT e.nombre, d.nombre_departamento, COUNT(*) AS cantidad_empleados
FROM empleados AS e
INNER JOIN departamentos AS d
    ON e.id_departamento = d.id_departamento
GROUP BY e.nombre, d.nombre_departamento;
*/


/* 2. ¿Por qué el total que devuelve esta query es mayor al total real de
   ventas de cada cliente? Explicá el motivo y cómo corregirla.
   clientes (id_cliente, nombre, ciudad)
   pedidos (id_pedido, id_cliente, fecha_pedido, total)
   pedido_items (id_item, id_pedido, id_producto, cantidad) */
SELECT c.nombre, SUM(p.total) AS total_ventas
FROM clientes AS c
INNER JOIN pedidos AS p
    ON c.id_cliente = p.id_cliente
INNER JOIN pedido_items AS pi
    ON p.id_pedido = pi.id_pedido
GROUP BY c.nombre;
/* razon del error 
No necesitamos unir la tabla pedido_item:

SELECT c.nombre, SUM(p.total) AS total_ventas
FROM clientes AS c
INNER JOIN pedidos AS p
    ON c.id_cliente = p.id_cliente
GROUP BY c.nombre;
*/


/* 3. ¿Por qué esta query nunca devuelve ningún país, aunque existan países sin
   ninguna ciudad registrada? Explicá el motivo y cómo corregirla.
   paises (id_pais, nombre_pais, continente, poblacion)
   ciudades (id_ciudad, nombre_ciudad, id_pais, es_capital) */
SELECT p.nombre_pais
FROM paises AS p
INNER JOIN ciudades AS c
    ON p.id_pais = c.id_pais
WHERE c.id_ciudad IS NULL;
/* razon del error 
Para encontrar paises sin ciudades usaremos LEFT JOIN (asi vemos los null cuando no hay match)

SELECT p.nombre_pais
FROM paises AS p
LEFT JOIN ciudades AS c
    ON p.id_pais = c.id_pais
WHERE c.id_ciudad IS NULL;
*/