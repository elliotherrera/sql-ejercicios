
-- AGREGACION INTEGRADA, PARTE 1

/* Las funciones de agregacion calculan valores sobre un campo. Funciones de agregacion comunes:

    - MAX - Devuelve el valor maximo de un campo
    - MIN - Devuelve el valor minimo de un campo
    - AVG - Devuelve el promedio de un campo
    - COUNT - Devuelve el numero total de registros
    - SUM - Devuelve la suma de todos los valores no nulos de un campo

Usa funciones de agregacion en las instrucciones SELECT */

SELECT MAX(col1), MIN(col2), AVG(col3)
FROM table_name;

/* Ejemplos*/

SELECT MAX(salary)
FROM employees;

SELECT MAX(Salary), MIN(Salary), AVG(Salary)
FROM employees;


-- DESAFIO

/*
Tablas y columnas disponibles:
sales: product_id, price_per_unit,  quantity

Escribe una consulta que devuelva:

    - El número total de transacciones de ventas
    - La cantidad promedio por venta
    - El precio máximo por unidad
    - Los ingresos totales (suma de quantity * price_per_unit)

El resultado debe tener estos nombres de columna exactos:

    total_transactions
    avg_quantity
    max_unit_price 
    total_revenue
*/

SELECT 
    COUNT(*) AS total_transactions,
    AVG(quantity) AS avg_quantity,
    MAX(price_per_unit) AS max_unit_price,
    SUM(quantity * price_per_unit) AS total_revenue
FROM sales;


-- EJERCICIOS BASICOS

/* 1. Obtené el salario máximo, el salario mínimo y el promedio de salario de todos los empleados.
   empleados (id_empleado, nombre, area, salario) */

SELECT 
    MAX(salario), 
    MIN(salario),
    AVG(salario)
FROM empleados;

/* 2. Contá cuántos productos hay cargados en total en el inventario.
   inventario (id_producto, nombre_producto, categoria, stock, precio) */

SELECT
    COUNT(*)
FROM inventario;

/* 3. Calculá la suma total de todas las ventas registradas.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

SELECT
    SUM(total)
FROM ventas;

-- EJERCICIOS INTERMEDIOS

/* 1. Calculá el promedio de población de los países cuyo nombre empiece con la letra "A".
   paises (id_pais, nombre, continente, poblacion, superficie) */

SELECT
    AVG(poblacion)
FROM paises
WHERE nombre LIKE 'A%';

/* 2. Obtené el precio máximo y el precio mínimo de los productos que pertenezcan a las categorías
   'Electrónica' o 'Hogar'.
   inventario (id_producto, nombre_producto, categoria, stock, precio) */

SELECT
    MAX(precio),
    MIN(precio)
FROM inventario
WHERE categoria IN ('Electrónica', 'Hogar');

/* 3. Contá cuántas ventas se realizaron entre el '2024-01-01' y el '2024-03-31'.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

SELECT
    COUNT(*)
FROM ventas
WHERE fecha_venta BETWEEN '2024-01-01' AND '2024-03-31';

/* 4. Calculá el salario promedio de los empleados del área 'Ventas', redondeado a 2 decimales.
   empleados (id_empleado, nombre, area, salario) */

SELECT
    ROUND(AVG(salario), 2)
FROM empleados
WHERE area = 'Ventas';


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, area, salario) */
SELECT nombre, MAX(salario)
FROM empleados;
/* razon del error 
    nombre, MAX(salario) al no tener GROUP BY colapsa a una sola fila.
    solucion:
SELECT nombre, salario
FROM empleados
ORDER BY salario DESC
LIMIT 1;

    solucion 2
SELECT nombre, salario
FROM empleados
WHERE salario = (SELECT MAX(salario) FROM empleados);

*/

/* 2. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */
SELECT cliente, total
FROM ventas
WHERE total = MAX(total);
/* razon del error 
    MySQL no permite usar funcion de agregacion MAX() dentro de un WHERE, las funciones de agregacion se calculas despues de que el WHERE filtra las FILAS, asi que en ese punto MAS(total) todavia no existe
    Solucion usar una subquery
SELECT cliente, total
FROM ventas
WHERE total = (SELECT MAX(total) FROM ventas);
*/

/* 3. Esta query corre sin error, pero el resultado no es el que Diego espera. ¿Por qué?
   clientes (id_cliente, nombre, email, telefono) */
SELECT COUNT(telefono) AS cantidad_clientes
FROM clientes;
/* razon del error 
    COUNT(telefono) solo trae los registros sin NULL, si quisieramos todos los registros tendriamos que reemplazarlo por COUNT(*).

*/

/* 4. Esta query corre sin error, pero el resultado no tiene sentido. ¿Por qué?
   inventario (id_producto, nombre_producto, categoria, stock, precio) */
SELECT AVG(nombre_producto) AS promedio_raro
FROM inventario;
/* razon del error 
    lo que pasa es que average AVG se calcula de numeros, no strings.
*/

/* Orden Logico de MySQL

    - FROM – determina de qué tabla(s) sale la data
    - WHERE – filtra filas individuales (todavía no hay agregación calculada)
    - GROUP BY – agrupa las filas que pasaron el filtro
    - Funciones de agregación (MAX, MIN, AVG, COUNT, SUM) – se calculan acá, una vez por grupo (o sobre toda la tabla si no hay GROUP BY)
    - HAVING – filtra los grupos ya agregados (es como un WHERE, pero para después de agrupar)
    - SELECT – arma las columnas/alias a mostrar
    - ORDER BY – ordena el resultado final (por eso podés usar alias del SELECT acá, como ya vimos)
    - LIMIT – recorta el resultado final
*/