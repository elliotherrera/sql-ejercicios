
-- AGREGACION INTEGRADA, PARTE 2

/* A veces necesitamos usar funciones de agregacion de formas mas complejas, como comparar cada fila con un valor agregado. Aqui es donde las consultas anidadas resultan utiles.
Cuando quieras realizar calculos que combinen filas individuales con valores agregados, necesitas usar una consulta anidada. He aqui porque:

Esto no te dara el resultado por fila que quieres: ❌*/

SELECT valor + MIN(valor)
FROM table1;

/*La razon es que las funciones de agregacion operan en toda la columna, mientras que la referencia a 'valor' intenta operar fila por fila.

Para resolverlo, usamos una consulta anidada: ✔️*/

SELECT valor + (SELECT MIN(valor) FROM table1)
FROM Table1l;

/* Esto funciona porque la consulta anidada (SELECT MIN(valor) FROM table1) se ejecuta primero y devuelve un unico valor, que despues se puede utilizar en la consulta principal para cada fila.

Casos de uso comunes para agregaciones anidadas:
    1. Comparar cada valor con el promedio
    2. Calculo del porcentaje total
    3. Encontrar diferencias con respecto a los valores maaximos o minimos
*/

-- DESAFIO

/*
Tablas y columnas disponibles:
items: id, price

Calcula cuánto supera el precio de cada elemento al precio promedio de todos los elementos. Muestra el ID del elemento, su precio y la diferencia con respecto al promedio. Nombra la columna de diferencia como diff_from_avg.

Ordena los resultados por la diferencia en orden descendente.
*/

SELECT 
    id,
    price, 
    price - (SELECT AVG(price) FROM items) AS diff_from_avg
FROM items
ORDER BY diff_from_avg DESC;


-- EJERCICIOS BASICOS

/* 1. Para cada venta, mostrá id_venta, total y la diferencia entre su total y el promedio de todos los totales. Nombra la columna diff_from_avg.
   ventas (id_venta, total) */

SELECT
    id_venta,
    total,
    total - (SELECT AVG(total) FROM ventas) as diff_from_avg
FROM ventas;

/* 2. Para cada empleado, mostrá id_empleado, salario y la diferencia entre su salario y el salario máximo de la empresa. Nombra la columna diff_from_max.
   empleados (id_empleado, salario) */

SELECT 
    id_empleado,
    salario,
    salario - (SELECT MAX(salario) FROM empleados) as diff_from_max
FROM empleados;

/* 3. Para cada producto, mostrá id_producto, stock y el porcentaje que su stock representa sobre el stock total. Nombra la columna pct_total.
   inventario (id_producto, stock) */

SELECT 
    id_producto,
    stock,
    stock / (SELECT SUM(stock) FROM inventario) * 100 as pct_total
FROM inventario;

-- EJERCICIOS INTERMEDIOS

/* 1. Mostrá las ventas de tecnología realizadas en 2024. Para cada una, incluí id_venta, total, fecha_venta y la diferencia con el promedio general de ventas. Ordená por diferencia descendente y limitá a 5.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

SELECT
    id_venta,
    total,
    fecha_venta,
    total - (SELECT AVG(total) FROM ventas) as dif_prom
FROM ventas
WHERE categoria = 'tecnología' AND
    (fecha_venta BETWEEN '2024-01-01' AND '2024-12-31')
ORDER BY dif_prom DESC
LIMIT 5;

/* 2. De empleados, mostrá nombre, área y salario de quienes trabajan en áreas que empiezan con 'Ventas'. Agregá una columna con la diferencia entre su salario y el salario promedio de toda la empresa. Ordená de mayor a menor diferencia.
   empleados (id_empleado, nombre, area, salario, fecha_ingreso) */

SELECT 
    nombre,
    area,
    salario,
    salario - (SELECT AVG(salario) FROM empleados) as dif_salario
FROM empleados
WHERE area LIKE 'Ventas%'
ORDER BY dif_salario DESC;

/* 3. En inventario, mostrá los productos cuyo stock sea mayor al stock promedio. Para cada uno, mostrá id_producto, nombre, stock y el porcentaje que su stock representa sobre el stock total, redondeado a 2 decimales. Ordená por porcentaje descendente.
   inventario (id_producto, nombre, categoria, stock, precio) */

SELECT 
    id_producto,
    nombre,
    stock,
    ROUND((stock / (SELECT SUM(stock) FROM inventario) * 100), 2) as prc_stock
FROM inventario
WHERE stock > (SELECT AVG(stock) FROM inventario)
ORDER BY prc_stock DESC;

/* 4. De países, mostrá nombre, continente, población y la diferencia con la población promedio de todos los países. Filtrá los que tengan población entre 10 y 100 millones, ordená por diferencia descendente y mostrá solo 3.
   paises (id_pais, nombre, continente, poblacion, area) */

SELECT 
    nombre,
    continente,
    poblacion,
    poblacion - (SELECT AVG(poblacion) FROM paises) as dif_poblacion
FROM paises
WHERE poblacion BETWEEN 10000000 AND 100000000
ORDER BY dif_poblacion DESC
LIMIT 3;


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, area, salario) */
SELECT nombre, salario - AVG(salario) AS diff
FROM empleados;
/* razon del error 
    El error esta en tratar de restra un agregacion integrada al valor de fila, es como restar el resultado de una columna a una fila, es incompatible
    solucion:
    Usar un subconsulta:
SELECT 
    nombre, 
    salario - (SELECT AVG(salario) FROM empleados) AS diff
FROM empleados;
*/

/* 2. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   ventas (id_venta, cliente, total) */
SELECT id_venta, total
FROM ventas
WHERE total > AVG(total);
/* razon del error 
    El filtro WHERE no acepta agregaciones integradas, igualmente se corrige con una subconsulta.
    solucion:
SELECT id_venta, total
FROM ventas
WHERE total > (SELECT AVG(total) FROM ventas);
*/


/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   inventario (id_producto, nombre, stock) */
SELECT id_producto, nombre, stock - (SELECT AVG(stock) FROM inventario) AS diff
FROM inventario
WHERE diff > 100;
/* razon del error 
    WHERE se ejecuta antes que SELECT por lo que no resconoce el aliasing de diff, la solucion es volver la consulta mas verbosa de esta manera
    solucion:
SELECT id_producto, nombre, stock - (SELECT AVG(stock) FROM inventario) AS diff
FROM inventario
WHERE (stock - (SELECT AVG(stock) FROM inventario)) > 100;
*/


/* 4. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   paises (id_pais, nombre, poblacion) */
SELECT nombre, poblacion - (SELECT AVG(poblacion), MIN(poblacion) FROM paises) AS diff
FROM paises;
/* razon del error 
    poblacion - (SELECT AVG(poblacion), MIN(poblacion) FROM paises) se le esta restando a un numero un una subconsulta escalar, para darle mas sentido a esto, hagamos las cuentas separadas
    solucion:
SELECT 
    nombre, 
    poblacion - (SELECT AVG(poblacion) FROM paises) AS diff_promedio,
    poblacion - (SELECT MIN(poblacion) FROM paises) AS diff_minimo
FROM paises;
*/