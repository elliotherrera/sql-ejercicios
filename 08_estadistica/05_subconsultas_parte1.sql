
-- SUBCONSULTAS, PARTE 1

/* Las subconsultas nos permiten combinar varias consultas en una sola. Por ejemplo, considera la siguiente tabla employees:

--id--|-salario-
--1---|---48----
--2---|---34----
--3---|---46----
--4---|---13----
--5---|---28----

Necesitamos una subconsulta porque no podemos usar WHERE salary > AVG(salary) directamente, ya que las funciones de agregación como AVG() no se pueden usar en una cláusula WHERE; solo se pueden usar después de que los datos se hayan agrupado. */

SELECT id, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

/* Una subconsulta nos ayuda a encontrar empleados que ganan más que el salario promedio de la empresa, calculando primero el promedio (consulta interna) y después usando ese valor para filtrar empleados (consulta externa).

Dado que el promedio es: (48 + 34 + 46 + 13 + 28) / 5 = 33.8, este es el resultado de la consulta:\

--id--|-salario-
--1---|---48----
--2---|---34----
--3---|---46----        */

-- DESAFIO

/* 
Tablas y columnas disponibles:
shop: price, quantity, category, list_date

Escribe una consulta para encontrar todos los artículos (selecciona todas las columnas) cuyo precio sea superior al precio promedio de todos los artículos.

Usa una subconsulta en la cláusula WHERE para calcular el precio promedio y, después, compara el precio de cada artículo con este promedio. */

SELECT *
FROM shop
WHERE price > (
    SELECT AVG(price)
    FROM shop
);



-- EJERCICIOS BASICOS

/* 1. Escribe una consulta para encontrar todos los empleados (todas las columnas) cuyo salario sea superior al salario promedio de todos los empleados. Usa una subconsulta en la cláusula WHERE.
   empleados (id_empleado, nombre, departamento, salario, fecha_contratacion) */

SELECT *
FROM empleados
WHERE salario > (
    SELECT AVG(salario)
    FROM empleados
);

/* 2. Escribe una consulta para encontrar todos los productos (todas las columnas) cuyo precio sea inferior al precio promedio de todos los productos. Usa una subconsulta en la cláusula WHERE.
   productos (id_producto, nombre, categoria, precio, stock) */

SELECT *
FROM productos
WHERE precio < (
    SELECT AVG(precio)
    FROM productos
);

/* 3. Escribe una consulta para encontrar todos los países (todas las columnas) cuya población sea superior a la población promedio de todos los países. Usa una subconsulta en la cláusula WHERE.
   paises (id_pais, nombre, continente, poblacion, pib_per_capita) */

SELECT *
FROM paises
WHERE poblacion > (
    SELECT AVG(poblacion)
    FROM paises
);

-- EJERCICIOS INTERMEDIOS

/* 1. Encuentra los empleados (nombre, departamento, salario) cuyo salario sea mayor al salario promedio de todos los empleados, y que además pertenezcan al departamento 'Ventas'.
   empleados (id_empleado, nombre, departamento, salario, fecha_contratacion) */

SELECT nombre, departamento, salario
FROM empleados
WHERE salario > (
    SELECT AVG(salario)
    FROM empleados
) AND departamento = 'Ventas';

/* 2. Encuentra los 3 productos con el precio más alto entre aquellos cuyo precio sea superior al precio promedio de todos los productos. Muestra nombre y precio.
   productos (id_producto, nombre, categoria, precio, stock) */

SELECT nombre, precio
FROM productos
WHERE precio > (
    SELECT AVG(precio)
    FROM productos
)
ORDER BY precio DESC
LIMIT 3;

/* 3. Agrupa los pedidos por cliente y muestra el cliente junto con la suma total de sus pedidos (monto_total), pero solo para aquellos clientes cuya suma total supere el monto promedio de todos los pedidos individuales.
   pedidos (id_pedido, cliente, monto, fecha_pedido, estado) */

SELECT cliente, SUM(monto) as monto_total
FROM pedidos
GROUP BY cliente
HAVING monto_total > (
    SELECT AVG(monto)
    FROM pedidos
);

/* 4. Encuentra los pedidos (todas las columnas) cuyo monto sea superior al monto promedio de todos los pedidos, y cuya fecha_pedido esté entre '2024-01-01' y '2024-06-30'.
   pedidos (id_pedido, cliente, monto, fecha_pedido, estado) */

SELECT *
FROM pedidos
WHERE monto > (
    SELECT AVG(monto)
    FROM pedidos
) AND fecha_pedido BETWEEN '2024-01-01' AND '2024-06-30';

-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, departamento, salario, fecha_contratacion) */
SELECT nombre, salario
FROM empleados
WHERE salario = MAX(salario);
/* razon del error 
    en la clausula WHERE no se puede utilizar agregacion integrada directamente, esto lo hacemos a travez de una subconsulta
    solucion:
SELECT nombre, salario
FROM empleados
WHERE salario = (SELECT MAX(salario) FROM empleados);
*/


/* 2. Esta query intenta encontrar los productos cuyo precio coincide con el precio promedio por categoría, pero al ejecutarla da un error. Explicá por qué falla y cómo corregirla.
   productos (id_producto, nombre, categoria, precio, stock) */
SELECT nombre, precio
FROM productos
WHERE precio = (
    SELECT AVG(precio)
    FROM productos
    GROUP BY categoria
);
/* razon del error 
    El error esta en que la categoria puede devolver varias filas las cuales se igualan a un unico valor con =

SELECT nombre, precio, categoria
FROM productos p
WHERE precio = (
    SELECT AVG(precio)
    FROM productos
    WHERE categoria = p.categoria
);
*/


/* 3. Esta query busca países cuya población supere el promedio de población de su propio continente, pero el resultado no es el esperado (compara contra el promedio general, no por continente). Explicá por qué falla conceptualmente y cómo corregirla.
   paises (id_pais, nombre, continente, poblacion, pib_per_capita) */
SELECT nombre, continente, poblacion
FROM paises
WHERE poblacion > (
    SELECT AVG(poblacion)
    FROM paises
);
/* razon del error 
    solucion: tema posterior subconsulta correlacional:

SELECT nombre, continente, poblacion
FROM paises p
WHERE poblacion > (
    SELECT AVG(poblacion)
    FROM paises
    WHERE continente = p.continente
);
*/