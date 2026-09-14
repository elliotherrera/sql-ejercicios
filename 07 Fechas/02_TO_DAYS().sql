
-- MANEJO DE FECHAS, PARTE 2

/* Para realizar calculos con fechas, conviertelas en numeros mediante la funcion JULIANDAY: */

-- Funcion Unica en SQLite

SELECT JULIANDAY ('2023-02-20 12:00:00');

/* Esto devuelve el numero de dias desde el 1 de enero de 4713 a.C. Puedes restar los resultados de dos llamadas a JULIANDAY para encontrar la diferencia en dias entre dos fechas: */

SELECT JULIANDAY(end) - JULIANDAY(start)
FROM events;

-- DESAFIO 

/* 
Tablas y columnas disponibles:
events: (id, start, end) 

Obtén los IDs de todos los eventos que duran menos de tres días
*/

SELECT id
FROM events
WHERE (JULIANDAY(end) - JULIANDAY(start)) < 3 ;


-- Funcion equivalente en MySQL

/* MySQL si tiene una funcion que se llama literalmente TO_DAYS(), pero no es Julian Day real (no cuenta desde la misma epoca). Para trabajar con fechas lo mas comun es:*/

/* Diferencia en dias entre dos fechas (equivalente a restar dos julianday */
SELECT DATEDIFF('2026-09-12', '2026-01-01');

/* Numero de dias desde el año 0 (similar en concepto a julianday, pero otra epoca)*/
SELECT TO_DAYS('2026-09-12');


-- EJERCICIOS BASICOS

/* 1. Mostrar el nombre del empleado y la cantidad de días transcurridos desde el año 0
   hasta su fecha_ingreso, usando TO_DAYS(), con el alias dias_desde_ano_0.
   empleados (id_empleado, nombre, area, fecha_ingreso) */

SELECT nombre, TO_DAYS(fecha_ingreso) AS dias_desde_ano_0
FROM empleados;

/* 2. Mostrar el nombre del producto y el resultado de TO_DAYS() aplicado a su fecha_vencimiento,
   con el alias dias_vencimiento.
   inventario (id_producto, nombre, precio, fecha_vencimiento) */

SELECT nombre, TO_DAYS(fecha_vencimiento) AS dias_vencimiento
FROM inventario;

/* 3. Mostrar el cliente y el resultado de restar TO_DAYS(fecha_entrega) menos TO_DAYS(fecha_pedido),
   con el alias dias_totales.
   pedidos (id_pedido, cliente, fecha_pedido, fecha_entrega) */

SELECT cliente, TO_DAYS(fecha_entrega) - TO_DAYS(fecha_pedido) AS dias_totales
FROM pedidos;

-- EJERCICIOS INTERMEDIOS

/* 4. Mostrar nombre y fecha_ingreso de los empleados del área 'Ventas', junto con
   TO_DAYS(fecha_ingreso) con el alias antiguedad_dias. Ordenar de menor a mayor antiguedad_dias.
   empleados (id_empleado, nombre, area, fecha_ingreso) */

SELECT nombre, fecha_ingreso, TO_DAYS(fecha_ingreso) AS antiguedad_dias
FROM empleados
WHERE area = 'Ventas'
ORDER BY antiguedad_dias ASC;

/* 5. Calcular la diferencia en días entre fecha_entrega y fecha_pedido usando TO_DAYS()
   (TO_DAYS(fecha_entrega) - TO_DAYS(fecha_pedido)), con el alias dias_demora. Mostrar solo
   los pedidos donde esa diferencia sea mayor a 5.
   pedidos (id_pedido, cliente, fecha_pedido, fecha_entrega) */

SELECT id_pedido, TO_DAYS(fecha_entrega) - TO_DAYS(fecha_pedido) AS dias_demora
FROM pedidos
WHERE (TO_DAYS(fecha_entrega) - TO_DAYS(fecha_pedido)) > 5;

/* 6. Mostrar nombre y precio de los productos cuyo nombre contenga la palabra "Kit", junto con
   TO_DAYS(fecha_vencimiento) con el alias dias_vencimiento.
   inventario (id_producto, nombre, precio, fecha_vencimiento) */

SELECT nombre, precio, TO_DAYS(fecha_vencimiento) AS dias_vencimiento
FROM inventario
WHERE nombre LIKE '%kit%';

/* 7. Calcular cuántos días faltan para el vencimiento de cada producto, restando
   TO_DAYS(fecha_vencimiento) menos TO_DAYS(fecha_actual), con el alias dias_restantes,
   redondeado a 0 decimales. Mostrar solo los productos con stock entre 10 y 100.
   inventario (id_producto, nombre, precio, stock, fecha_vencimiento, fecha_actual) */

SELECT nombre, ROUND(TO_DAYS(fecha_vencimiento) - TO_DAYS(fecha_actual)) AS dias_restantes
FROM inventario
WHERE stock BETWEEN 10 AND 100;

-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   pedidos (id_pedido, cliente, fecha_pedido, fecha_entrega) */
SELECT cliente, TO_DAYS(fecha_entrega - fecha_pedido) AS dias_demora
FROM pedidos;
/* razon del error 
    falla porque la funcion TO_DAYS() solo alberga una fecha
    solucion:
    DATEDIFF(fecha_entrega, fecha_pedido) o TO_DAYS(fecha_entrega) - TO_DAYS(fecha_pedido)
*/

/* 2. Esta query se ejecuta sin errores, pero para los pedidos donde fecha_entrega es NULL
   (todavía no se entregaron), el resultado de dias_demora no aparece como se esperaría y
   además distorsiona el ORDER BY. Explicá por qué pasa esto y qué se podría hacer al respecto.
   pedidos (id_pedido, cliente, fecha_pedido, fecha_entrega) */
SELECT cliente, TO_DAYS(fecha_entrega) - TO_DAYS(fecha_pedido) AS dias_demora
FROM pedidos
ORDER BY dias_demora DESC;
/* razon del error 
    Toda operacion con NULL da como resultado otro NULL, ademas el NULL es el valor mas bajo y los resultados se ordenan de acuerdo a ello
    solucion: hacer un filtro para trabajar solo con resultados que no sean null

SELECT cliente, TO_DAYS(fecha_entrega) - TO_DAYS(fecha_pedido) AS dias_demora
FROM pedidos
WHERE fecha_entrega IS NOT NULL AND fecha_pedido IS NOT NULL
ORDER BY dias_demora DESC;

*/

/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, area, fecha_ingreso) */
SELECT nombre, fecha_ingreso
FROM empleados
WHERE TO_DAYS(fecha_ingreso) = '2020-01-15';
/* razon del error 
    En la clausula WEHERE se esta igualando TO_DAYS(fecha_ingreso) que resulta un numero entero a una fecha '2020-01-15'
    solucion: tendria mas sentido hacer esto

SELECT nombre, TO_DAYS(fecha_ingreso)
FROM empleados
WHERE fecha_ingreso = '2020-01-15';
*/