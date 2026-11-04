
-- AGRUPACION, PARTE 1

/* Hasta ahora hemos calculado datos para todo el campo, y ahora introduciremos la capacidad de calcular datos para grupos especificos

trabajadores

--id--|--area--|--edad--
--1---|---A----|---35---
--2---|---A----|---37---
--3---|---B----|---29---
--4---|---B----|---39---

SI escribimos:  */

SELECT AVG(age) as avg_age
FROM trabajadores;

/*  Solo recibiremos la edad promedio de todos los trabajadores en conjunto.
    ¿Que pasa si queremos calcular la edad promedio para cada area?
    Para eso, podemos usar las palabras clave GROUP BY 
    Al usar GROUP BY, debes incluir la columna de agrupacion en tu sentencia SELECT para identificar cada grupo*/

SELECT area, AVG(age) as avg_age
FROM trabajadores
GROUP BY area;

/*
--area--|-avg_age
---A----|---36---
---A----|---34---   

AHora sabemos que la edad promedio en el area A es 36 y la edad promedio en el area B es 34*/


-- DESAFIO

/*
Tablas y columnas disponibles:
foods: name, type, pH

Calcula, para cada tipo de alimento, el valor promedio de pH.
Nombra las columnas: type, ph_average.
Usa ROUND(value, 2) para redondear el promedio a dos decimales. */

SELECT type, ROUND(AVG(pH), 2) as ph_average
FROM foods
GROUP BY type;


-- EJERCICIOS BASICOS

/* 1. Muestra la cantidad de empleados que hay en cada departamento.
   Nombra la columna resultante como cantidad_empleados.
   empleados (id_empleado, nombre, departamento, salario, fecha_contratacion) */

SELECT departamento, COUNT(*) as cantidad_empleados
FROM empleados
GROUP BY departamento;

/* 2. Calcula el precio promedio de los productos, agrupado por categoria.
   Nombra la columna resultante como precio_promedio.
   productos (id_producto, nombre, categoria, precio, stock) */

SELECT categoria, ROUND(AVG(precio), 2) as precio_promedio
FROM productos
GROUP BY categoria;

/* 3. Calcula la poblacion total, agrupada por continente.
   Nombra la columna resultante como poblacion_total.
   paises (nombre, continente, poblacion, area_km2) */

SELECT continente, SUM(poblacion) as poblacion_total
FROM paises
GROUP BY continente;


-- EJERCICIOS INTERMEDIOS

/* 1. Filtra los pedidos con cantidad mayor a 5, y luego calcula el total
   gastado (cantidad * precio_unitario) por cada cliente.
   Nombra la columna resultante como total_gastado.
   pedidos (id_pedido, cliente, producto, cantidad, precio_unitario, fecha_pedido) */

SELECT cliente, SUM(cantidad * precio_unitario) as total_gastado
FROM pedidos
WHERE cantidad > 5
GROUP BY cliente;

/* 2. Calcula el salario promedio por departamento, ordena los resultados
   de mayor a menor promedio, y muestra solo los 2 departamentos con
   mayor salario promedio.
   empleados (id_empleado, nombre, departamento, salario, fecha_contratacion) */

SELECT departamento, ROUND(AVG(salario), 2) as salario_promedio
FROM empleados
GROUP BY departamento
ORDER BY salario_promedio DESC
LIMIT 2;

/* 3. Calcula, para cada categoria de producto, el valor promedio del
   precio con un 21% de impuesto aplicado (precio * 1.21), redondeado a
   2 decimales. Nombra la columna resultante como precio_con_iva.
   productos (id_producto, nombre, categoria, precio, stock) */

SELECT categoria, ROUND(AVG(precio * 1.21), 2) as precio_con_iva
FROM productos
GROUP BY categoria;

/* 4. Cuenta cuántos países hay por continente, considerando solo los
   países cuya poblacion esté entre 1000000 y 50000000.
   Nombra la columna resultante como cantidad_paises.
   paises (nombre, continente, poblacion, area_km2) */

SELECT continente, COUNT(*) as cantidad_paises
FROM paises
WHERE poblacion BETWEEN 1000000 AND 50000000
GROUP BY continente;


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, departamento, salario, fecha_contratacion) */
SELECT nombre, departamento, AVG(salario) as salario_promedio
FROM empleados
GROUP BY departamento;
/* razon del error 
    falto agregar nombre a GROUP BY, o quitar nombre de SELECT 
    solucion: dependiendo que es lo que se esta buscando, si queremos la agrupacion combinada sumamos en GROUP BY pero si es algo especifico de una columna, quitamos nombre de SELECT
SELECT nombre, departamento, AVG(salario) as salario_promedio
FROM empleados
GROUP BY nombre, departamento;
*/

/* 2. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   ventas (id_venta, vendedor, producto, cantidad, precio_unitario, fecha_venta) */
SELECT vendedor, SUM(cantidad * precio_unitario) as total_vendido
FROM ventas
WHERE SUM(cantidad * precio_unitario) > 10000
GROUP BY vendedor;
/* razon del error 
    en la clausula WHERE no puede haber una agregacion integrada
    solucion:
SELECT vendedor, SUM(cantidad * precio_unitario) as total_vendido
FROM ventas
GROUP BY vendedor
HAVING SUM(cantidad * precio_unitario) > 10000
*/

/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   inventario (id_producto, nombre, categoria, stock) */
SELECT *
FROM inventario
GROUP BY categoria;
/* razon del error 
    No se entiende que se quiere lograr, digamos que se quiere saber la suma del stock pro categoria:
SELECT categoria, SUM(stock)
FROM inventario
GROUP BY categoria;
*/


