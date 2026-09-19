
-- SUBCONSULTAS PARTE 2

/* Hay tres tipos principales de subconsultas
    1. Subconsultas escalares: Devuelven un unico valor (una fila, una columna).
    2. Subconsultas de fila: Devuelven una unica fila con varias columnas.
    3. Subconsultas de tabla: Devuelven varias filas y columnas. */

-- Subconsulta escalar - comparaciones simples (>, <, =):

SELECT name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Subconsulta de fila - Coincidir con varias columnas: *encuentra empleado(s) con el mismo departamento y salario que Alice

SELECT name
FROM employees
WHERE (department, salary) = (
    SELECT department, salary
    FROM employees
    WHERE name = 'Alice'
);

-- Subconsulta de tabla - Consultar a partir de un conjunto de resultados: * mostrar los departamentos y su cantidad de empleados

SELECT department, count
FROM (
    SELECT department, COUNT(*) as count
    FROM employees
    GROUP BY department
) as dept_counts;


-- DESAFIO

/* Tablas y columnas disponibles:
    shop: price, quantity, category, list_date

Encuentra las categorías cuya cantidad total sea mayor que el promedio de todas las cantidades de la tienda. Devuelve category y la cantidad sumada llamada total_quantity.

Importante: Debes usar una subconsulta dentro de la cláusula HAVING para calcular el promedio. No uses un valor codificado manualmente ni una consulta separada: la subconsulta debe calcular AVG(quantity) directamente de la tabla shop dentro de HAVING.

Pasos para resolverlo:

Primero, escribe una subconsulta que calcule el promedio de todas las cantidades de la tienda: SELECT AVG(quantity) FROM shop
Después, para cada categoría, suma sus cantidades y compáralas con esta subconsulta usando la palabra clave HAVING*/

SELECT 
    category, 
    SUM(quantity) as total_quantity
FROM shop
GROUP BY category
HAVING total_quantity > (
    SELECT AVG(quantity)
    FROM shop
);


-- EJERCICIOS BASICOS

/* 1. Usando una subconsulta escalar, mostrá el nombre y la población de los países
   cuya población sea mayor al promedio de población de todos los países.
   paises (id_pais, nombre, continente, moneda, poblacion) */

SELECT nombre, poblacion
FROM paises
WHERE poblacion > (
    SELECT AVG(poblacion)
    FROM paises
);

/* 2. Usando una subconsulta de fila, mostrá el nombre de los productos que tengan
   la misma categoria y el mismo proveedor que el producto 'Teclado Mecánico K2'.
   inventario (id_producto, producto, categoria, proveedor, stock, precio_unitario) */

SELECT producto
FROM inventario
WHERE (categoria, proveedor) = (
    SELECT categoria, proveedor
    FROM inventario
    WHERE producto = 'Teclado Mecánico K2'
);


/* 3. Usando una subconsulta de tabla en el FROM, calculá por cliente la cantidad de
   ventas (cantidad_ventas) y el total facturado (total_facturado). Desde la consulta
   externa, mostrá cliente, cantidad_ventas y total_facturado.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

SELECT cliente, cantidad_ventas, total_facturado
FROM (
    SELECT cliente, COUNT(*) as cantidad_ventas, SUM(total) as total_facturado
    FROM ventas
    GROUP BY cliente
) as ventas_sub;

/* 3. Calculá el promedio de stock total por categoría (promedio_stock_por_categoria):
   primero obtené el stock total de cada categoría y después promediá esos totales.
   Usá una subconsulta de tabla en el FROM. Devolvé una única fila con una única columna.
   inventario (id_producto, producto, categoria, proveedor, stock, precio_unitario) */

SELECT AVG(total_stock_por_categoria) as promedio_stock_por_categoria
FROM (
    SELECT categoria, SUM(stock) as total_stock_por_categoria
    FROM inventario
    GROUP BY categoria
) as stock_por_categoria;


-- EJERCICIOS INTERMEDIOS

/* 1. Mostrá id_venta, cliente, total y fecha_venta de las 5 ventas de mayor importe
   realizadas en 2025 (usá BETWEEN con fechas) cuyo total supere el total promedio de
   todas las ventas (subconsulta escalar). Ordenalas de mayor a menor total.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

SELECT id_venta, cliente, total, fecha_venta
FROM ventas
WHERE (fecha_venta BETWEEN '2025-01-01' AND '2025-12-31') AND total > (
    SELECT AVG(total)
    FROM ventas
)
ORDER BY total DESC
LIMIT 5;

/* 2. Para los países de 'Asia' o 'Europa' (usá IN) cuya población supere el promedio
   de población de todos los países, mostrá nombre, poblacion y una columna
   porcentaje_mundial con el porcentaje que representa su población sobre la población
   total de todos los países, redondeado a 2 decimales (subconsulta escalar dentro del
   SELECT). Ordená de mayor a menor porcentaje_mundial.
   paises (id_pais, nombre, continente, moneda, poblacion) */

SELECT nombre, poblacion, ROUND(poblacion * 100 / (SELECT SUM(poblacion) FROM paises), 2) AS porcentaje_mundial
FROM paises
WHERE continente IN ('Asia', 'Europa') AND poblacion > (
    SELECT AVG(poblacion)
    FROM paises
)
ORDER BY porcentaje_mundial DESC;

/* 3. Mostrá nombre, area, cargo y salario de los empleados que compartan area y cargo
   con el empleado mejor pagado de la empresa (subconsulta de fila que use ORDER BY y
   LIMIT 1) y que hayan ingresado a partir del 2020-01-01. Ordená por salario de mayor
   a menor.
   empleados (id_empleado, nombre, area, cargo, salario, fecha_ingreso, id_jefe) */

SELECT nombre, area, cargo, salario
FROM empleados
WHERE (area, cargo) = (
    SELECT area, cargo
    FROM empleados
    ORDER BY salario DESC
    LIMIT 1
) AND fecha_ingreso >= '2020-01-01'
ORDER BY salario DESC;

/* 4. Mostrá producto, categoria y stock de los productos cuya categoria pertenezca a
   alguna categoría con stock total menor a 200 unidades (usá IN con una subconsulta
   que utilice GROUP BY y HAVING). Ordená por categoria ascendente y, dentro de cada
   una, por stock descendente.
   inventario (id_producto, producto, categoria, proveedor, stock, precio_unitario) */

SELECT producto, categoria, stock
FROM inventario
WHERE categoria IN(
    SELECT categoria
    FROM inventario
    GROUP BY categoria
    HAVING SUM(stock) < 200
)
ORDER BY categoria ASC, stock DESC;



-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   Se quiere ver a los empleados que cobran lo mismo que alguien del área 'Ventas'.
   empleados (id_empleado, nombre, area, cargo, salario, fecha_ingreso, id_jefe) */
SELECT nombre, salario
FROM empleados
WHERE salario = (
    SELECT salario
    FROM empleados
    WHERE area = 'Ventas'
);
/* razon del error 
    el problema es que la subconsulta puede arrojar varias filas y al compararla con un = da error. EN su lugar utilizaremos IN para comprar quienes tienen salarios igualles dentr odel area 'Ventas'

SELECT nombre, salario
FROM empleados
WHERE salario IN (
    SELECT salario
    FROM empleados
    WHERE area = 'Ventas'
);
*/


/* 2. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   Se quiere ver la cantidad de ventas por categoría.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */
SELECT categoria, cantidad
FROM (
    SELECT categoria, COUNT(*) AS cantidad
    FROM ventas
    GROUP BY categoria
);
/* razon del error 
    falto el aliasing de la subconsulat en from, podriamos poner
SELECT categoria, cantidad
FROM (
    SELECT categoria, COUNT(*) AS cantidad
    FROM ventas
    GROUP BY categoria
) as cantidad_ventas;
*/


/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   Se quiere ver los países que tienen el mismo continente y la misma moneda que Argentina.
   paises (id_pais, nombre, continente, moneda, poblacion) */
SELECT nombre
FROM paises
WHERE (continente, moneda) = (
    SELECT continente
    FROM paises
    WHERE nombre = 'Argentina'
);
/* En una subconsulta de fila, la cantidad de columnas a cada lado de = tiene que coincidir:
SELECT nombre
FROM paises
WHERE (continente, moneda) = (
    SELECT continente, moneda
    FROM paises
    WHERE nombre = 'Argentina'
);

*/


/* 4. Esta query no da error, pero devuelve 0 filas aunque sabemos que hay empleados
   que no son jefes de nadie (el director general tiene id_jefe en NULL).
   ¿Por qué pasa esto? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, area, cargo, salario, fecha_ingreso, id_jefe) */
SELECT nombre
FROM empleados
WHERE id_empleado NOT IN (
    SELECT id_jefe
    FROM empleados
);
/* razon del error 
    aclarar que se debe trabajar sin nulls
    solucion:
SELECT nombre
FROM empleados
WHERE id_empleado NOT IN (
    SELECT id_jefe
    FROM empleados
    WHERE id_jefe IS NOT NULL
);
*/


