
-- MANEJO DE FECHAS, PARTE 1

/* Las fechas en SQL utilizan el formato YYYY-MM-DD (por ejemplo, 2011-09-24).
Consulta fechas utilizando operadores de comparacion (>, <, =)*/

SELECT *
FROM table1
WHERE col1 > '2011-01-13'

/* Usa BETWEEN para rangos de fechas: */

SELECT *
FROM table1
WHERE col1 BETWEEN '2010-01-01' AND '2010-02-25'


-- DESAFIO

/*
Tablas y columnas disponibles:
games: (id, date)

Obtén todos los identificadores de los juegos que no se juegan en invierno.
Las fechas de invierno son: 2022-12-21 - 2023-03-20. Solo estos días no deben incluirse.

Ordénalos por fecha en orden descendente y cambia el nombre de la columna a game.
*/

SELECT id AS game
FROM games
WHERE `date` NOT BETWEEN '2022-12-21' AND '2023-03-20'
ORDER BY `date` DESC;


-- EJERCICIOS BASICOS

/* 1. Mostrar el id_pedido y la fecha_entrega de todos los pedidos realizados en el año 2023.
   pedidos (id_pedido, cliente, fecha_entrega, monto) */

SELECT id_pedido, fecha_entrega
FROM pedidos
WHERE fecha_entrega BETWEEN '2023-01-01' AND '2023-12-31';

/* 2. Mostrar el nombre y fecha_ingreso de los empleados contratados entre el 2020-01-01 y el 2020-12-31.
   empleados (id_empleado, nombre, area, fecha_ingreso) */

SELECT nombre, fecha_ingreso
FROM empleados
WHERE fecha_ingreso BETWEEN '2020-01-01' AND '2020-12-31';

/* 3. Mostrar el id_vuelo y fecha_salida de todos los vuelos cuya fecha_salida sea posterior a '2024-06-01'.
   vuelos (id_vuelo, origen, destino, fecha_salida) */

SELECT id_vuelo, fecha_salida
FROM vuelos
WHERE fecha_salida > '2024-06-01';

-- EJERCICIOS INTERMEDIOS

/* 1. Mostrar cliente y fecha_entrega de los pedidos con monto mayor a 5000, realizados durante el año 2023, ordenados por fecha_entrega de forma descendente.
   pedidos (id_pedido, cliente, fecha_entrega, monto) */

SELECT cliente, fecha_entrega
FROM pedidos
WHERE monto > 5000 AND fecha_entrega BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY fecha_entrega DESC;

/* 2. Mostrar nombre y fecha_ingreso de los empleados del area 'Ventas' o 'Marketing' contratados antes del 2021-01-01.
   empleados (id_empleado, nombre, area, fecha_ingreso) */

SELECT nombre, fecha_ingreso
FROM empleados
WHERE area IN ('Ventas', 'Marketing') AND fecha_ingreso < '2021-01-01';

/* 3. Mostrar origen, destino y fecha_salida de los vuelos con destino 'Madrid' o 'Roma', cuya fecha_salida esté entre '2024-01-01' y '2024-06-30'.
   vuelos (id_vuelo, origen, destino, fecha_salida) */

SELECT origen, destino, fecha_salida
FROM vuelos
WHERE destino IN ('Madrid', 'Roma') AND fecha_salida BETWEEN '2024-01-01' AND '2024-06-30';

/* 4. Mostrar nombre de pais y fecha_independencia de los paises cuya poblacion sea mayor a 10000000 y cuya fecha_independencia sea anterior a '1900-01-01', ordenados por fecha_independencia ascendente.
   paises (id_pais, nombre, poblacion, fecha_independencia) */

SELECT nombre, fecha_independencia
FROM paises
WHERE poblacion > 10000000 AND fecha_independencia < '1900-01-01'
ORDER BY fecha_independencia ASC;

-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   pedidos (id_pedido, cliente, fecha_entrega, monto) */
SELECT id_pedido, cliente
FROM pedidos
WHERE fecha_entrega BETWEEN 2023-01-01 AND 2023-12-31;
/* razon del error 
    Falla porque las fechas estan sin comillas simples ''
    solucion:
    WHERE fecha_entrega BETWEEN '2023-01-01' AND '2023-12-31'
*/

/* 2. Esta query intenta traer los empleados contratados en el segundo semestre de 2022, pero devuelve resultados incorrectos (incluye fechas de otros años). ¿Por qué pasa esto y cómo se corrige?
   empleados (id_empleado, nombre, area, fecha_ingreso) */
SELECT nombre, fecha_ingreso
FROM empleados
WHERE fecha_ingreso > '2022-07-01' OR fecha_ingreso < '2022-12-31';
/* razon del error 
    trae resultados fuera del semestre, la razon la palabra clave OR, debemos reemplazarla por AND para encerrar el rango de fecha que se pide, ademas debe incluir la fecha de inicio del semestr haciendo la comparaciom >= y <=, la solucion mas limpia es usar un BETWEEN
    solucion 1:
    WHERE fecha_ingreso >= '2022-07-01' AND fecha_ingreso <= '2022-12-31'
    solucion 2:
    WHERE fecha_ingreso BETWEEN '2022-07-01' AND '2022-12-31'
*/

/* 3. ¿Por qué esta query no devuelve ninguna fila, aunque sabemos que hay vuelos con fecha_salida el mismo día '2024-03-15'?
   vuelos (id_vuelo, origen, destino, fecha_salida) */
SELECT id_vuelo, fecha_salida
FROM vuelos
WHERE fecha_salida NOT BETWEEN '2024-03-15' AND '2024-03-15';
/* razon del error 
    Error del enunciado, estofecha_salida NOT BETWEEN '2024-03-15' AND '2024-03-15'
    equivale a fecha_salida != '2024-03-15' y deberia mostrar todas las filas
*/