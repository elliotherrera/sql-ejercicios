
-- OPERADOR MODULO

/* El operador modulo % devuelve el resto despues de la division: dividendo % divisor

Usos comunes:
    - Comprobar si es par o impar:
        number % 2 = 0 (par)
        number % 2 = 1 (impar)
    - Recorrer valores ciclicamente:
        numer % 12 devuelve 0-11
    - Agrupar elementos:
        item_numer % 5 crea grupos del 0 al 4

Ejemplos: */

/* Encontrar filas con numeros pares*/
SELECT * 
FROM `table`
WHERE id % 2 = 0;
/* Agrupar elementos en conjuntos de 5*/
SELECT item_numer % 5 AS group_number
FROM inventory;


-- DESAFIO

/*
Tablas y columnas disponibles:
    producs: (id, price, quantity)

Crea una consulta que:
    1. Muestre el ID del producto
    2. Asige cada producto a uno de tres equipos de control de calidad (0, 1 o 2) segun el ID del producto mediante el operador modulo; llama a esta columna quality_control
    3. Incluya unicamente los productos cuya columna quantity contenga un numero impar (por ejemplo 1, 3, 5, 7, ...)
*/

SELECT id, id % 3 AS quality_control
FROM products
WHERE quantity % 2 = 1;


-- EJERCICIOS BASICOS

/* 1. Mostrá el id_venta y la cantidad de las ventas cuya cantidad sea un número par.
   ventas (id_venta, cliente, producto, cantidad, precio_unitario, fecha_venta) */

SELECT id_venta, cantidad
FROM ventas
WHERE cantidad % 2 = 0;

/* 2. Obtené el id_empleado y el nombre de los empleados cuyo id_empleado sea impar.
   empleados (id_empleado, nombre, area, salario, anios_experiencia) */

SELECT id_empleado, nombre
FROM empleados
WHERE id_empleado % 2 = 1;


/* 3. Mostrá el nombre_producto y el stock de los productos cuyo stock NO sea múltiplo de 5.
   inventario (id_producto, nombre_producto, categoria, stock, precio) */

SELECT nombre_producto, stock
FROM inventario
WHERE stock % 5 != 0;


-- EJERCICIOS INTERMEDIOS

/* 1. Mostrá las ventas cuya cantidad sea múltiplo de 3, ordenadas por precio_unitario
   de forma descendente.
   ventas (id_venta, cliente, producto, cantidad, precio_unitario, fecha_venta) */

SELECT *
FROM ventas
WHERE cantidad % 3 = 0
ORDER BY precio_unitario DESC;

/* 2. Para los empleados del área 'Ventas', calculá el resto de dividir el salario por
   1000 y mostralo con el alias resto_salario, junto con el nombre del empleado.
   empleados (id_empleado, nombre, area, salario, anios_experiencia) */

SELECT nombre, (salario % 1000) AS resto_salario
FROM empleados
WHERE area = 'Ventas';

/* 3. Mostrá los países cuya población sea un número par y cuya superficie_km2 esté
   entre 100000 y 1000000.
   paises (id_pais, nombre, poblacion, superficie_km2, continente) */

SELECT *
FROM paises
WHERE (poblacion % 2 = 0) AND
    (superficie_km2 BETWEEN 100000 AND 1000000);

/* 4. Mostrá los productos cuyo nombre_producto comience con 'A', que pertenezcan a
   las categorías 'Electronica' u 'Hogar', y cuyo stock sea múltiplo de 4.
   inventario (id_producto, nombre_producto, categoria, stock, precio) */

SELECT *
FROM inventario
WHERE (nombre_producto LIKE 'A%') AND 
    (categoria IN('Electronica', 'Hogar')) AND
    (stock % 4 = 0);


-- POR QUE NO FUNCIONA

/* 1. Se buscaba traer únicamente las ventas con cantidad par, pero la consulta no
   logra ese objetivo. Explicá por qué falla y cómo corregirla.
   ventas (id_venta, cliente, producto, cantidad, precio_unitario, fecha_venta) */
SELECT id_venta, cantidad
FROM ventas
WHERE cantidad / 2 = 0;
/* razon del error 
    El operador es el equivocado, debemos usar modulo % en lugar de /
*/


/* 2. Se buscaba el resto de dividir cantidad por 3, pero la condición nunca se
   cumple para ningún valor esperado. Explicá por qué falla y cómo corregirla.
   ventas (id_venta, cliente, producto, cantidad, precio_unitario, fecha_venta) */
SELECT id_venta, cantidad
FROM ventas
WHERE cantidad % 2 + 1 = 0;
/* razon del error 
    cantidad % 2 + 1 esto calcula modulo 2 + 1 el orden de la operacion es incorrecto, se puede solucionar directamente colocando % 3 o encapsulandolo en una parentesis cantidad % (2 + 1) = 0
*/


/* 3. Esta consulta no devuelve ningún resultado, aun cuando existen empleados con
   salario % 2 = 0. Explicá por qué falla y cómo corregirla.
   empleados (id_empleado, nombre, area, salario, bono_grupo) */
SELECT nombre, salario
FROM empleados
WHERE salario % bono_grupo = 0;
/* razon del error 
    Falla porque limita mucho las posibilidades de que ambos sean pares y multiplos exactos, si lo que se desea es saber si los sueldos son un numero par entonces basta con poner salario % 2 = 0
*/


/* 4. Se quiso reutilizar el alias resto_stock definido en el SELECT dentro del
   WHERE, pero la query falla. Explicá por qué falla y cómo corregirla.
   inventario (id_producto, nombre_producto, categoria, stock, precio) */
SELECT nombre_producto, stock % 5 AS resto_stock
FROM inventario
WHERE resto_stock = 0;
/* razon del error 
    WHERE no reconoce ese aliasing porque ocurre antes del select, la solucion es traer la expresion completa a WHERE stock % 5 = 0
*/