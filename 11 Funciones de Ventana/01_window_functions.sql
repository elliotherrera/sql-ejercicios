
-- Funcion ROW_NUMBER()

/*
Que hace?
ROW_NUMBER asigna un numero secuencial unico (1,2,3...) a cada fila del resultado, siguiendo el orden y los grupos que tu definas. Es un funcion de ventana: calcula algo sobre un conjunto de filas relacionadas con la fila actual, sin colapsar como lo haria un GROUP BY

Agregacion vs Ventana
SUM() con GROUP BY devuelve una fila por grupo. SUM() OVER(...) devuelve todas las filas originales y agrega una columna con el calculo. */

SELECT columna1, columna2,
	   ROW_NUMBER() OVER(
	  	   [PARTITION BY columna_grupo]
	   	   [ORDER BY columna_orden]
	   ) AS row_num
FROM TABLE;

/*
Parte     | Funcion                    | Obligatoria?
-----------------------------------------------------
OVER      | Indica que es una funcion  | Si
		  | de ventana                 |
-----------------------------------------------------
PARTITION | Divide las filas en grupos;| No
BY        | la numeracion reinicia en 1|
		  |cada grupo                  |
-----------------------------------------------------
ORDER BY  | Define en que orden se     | No pero muy
		  | numeran las filas          | recomendada
 */


-- Ejemplos

-- 1. Numeracion simple

SELECT product_name, sale_date,
	   ROW_NUMBER() OVER() AS row_num
FROM sales;

/* Numera del 1 hasta el total de filas. Sin ORDER BY, el orden es arbitrario y puede cambiar entre ejecuciones. */


-- 2. Numeracion ordenada

SELECT product_name, sale_date,
	   ROW_NUMBER() OVER(ORDER BY sale_date) AS row_num
FROM sales;

/* La fila con la fecha mas antigua recibe el 1*/


-- 3. Numeracion por grupos

SELECT category, product_name, price,
       ROW_NUMBER() OVER (
           PARTITION BY category
           ORDER BY price DESC
       ) AS row_num
FROM products;

/*
category  | product_name | price | row_num
-----------------------------------------
Laptops   | Laptop Pro   | 1500  | 1
Laptops   | Laptop Air   | 1200  | 2
Laptops   | Laptop Mini  | 800   | 3
-----------------------------------------
Telefonos | Phone X      | 1000  | 1
Telefonos | Phone Lite   | 400   | 2

Dentro de cada categoria, el producto mas caro es el 1 y la numeracion reinicia en la siguiente categoria */

/* Casos de uso comunes

	- Top N por grupo: los 3 productos mas vendidos de cada categoria.
	- Eliminar duplicados: quedarte con una sola fila por registro (row_num = 1)
	- Paginacion: devolver las filas 21 a 30 de un resultado.
	- Encontrar la primera o ultima fila de cada grupo (primera compra de cada cliente)

Ejemplo practico: top 2 por categoria
No puedes filtrar por row_number directamente en el WHERE, porque la funcion de ventana se evalua despues de WHERE. Hay que envolver la  consulta en una CTE o subconsulta: */


WITH ranked AS (
	SELECT category, product_name, price,
		   ROW_NUMBER() Over(
		       PARTITION BY category
		       ORDER BY price DESC
		   ) AS row_num
	FROM products
)
SELECT *
FROM ranked 
WHERE row_num <= 2;

/*Puntos Clave
 	1. Siempre usa ORDER BY dentro de OVER si el orden importa; si no, el resultado no es tenerminista.
 	2. Los numeros nunca se repiten, incluso si hay empates: si dos filas tienen el mismo precio, una recibe el 1 y la otra el 2 (de forma arbitraria, salvo que añadas un criterio de desempate)
 	3. No se puede usar en WHERE: usa una CTE o subconsulta
 	4. En MySQL requiere la version 8.0 o superior


ROW_NUMBER vs RANK vs DENSE_RANK
 	
Funcion      | Resultado | Comportamiento con empates
-----------------------------------------------------
ROW_NUMBER() | 1, 2, 3   | Los desempata
             |           | arbitrariamente
-----------------------------------------------------
RANK()       | 1, 1, 3   | Mismo numero, salta
             |           | posiciones
-----------------------------------------------------
DENSE_RANK() | 1, 1, 2   | Mismo numero, sin saltos
 */

/*
Tablas y columnas disponibles:

liquids: id, density
Obtén todos los líquidos con una densidad superior a 5.677.

Numera el resultado (usa la función ROW_NUMBER()) y llama a esta columna row_num */

SELECT id, density, 
       ROW_NUMBER () OVER () as row_num
FROM liquids
WHERE density > 5.677;







-- BLOQUE 1: SETUP

DROP DATABASE IF EXISTS practica_row_number;
CREATE DATABASE practica_row_number;
USE practica_row_number;

-- ESQUEMA: VENTAS
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    cliente VARCHAR(50),
    categoria VARCHAR(30),
    total DECIMAL(10,2),
    fecha_venta DATE
);

INSERT INTO ventas (id_venta, cliente, categoria, total, fecha_venta) VALUES
(1, 'Lucia Gomez', 'Electronica', 1500.00, '2026-01-15'),
(2, 'Marcos Diaz', 'Hogar', 320.50, '2026-03-10'),
(3, 'Lucia Gomez', 'Hogar', 320.50, '2026-03-10'),
(4, 'Sofia Ruiz', 'Electronica', 1500.00, '2026-06-30'),
(5, 'Marcos Diaz', 'Ropa', 89.99, '2026-01-01'),
(6, 'Pablo Ledesma', 'Ropa', 210.00, '2026-07-01'),
(7, 'Lucia Gomez', 'Ropa', 89.99, '2025-12-31'),
(8, 'Marcos Diaz', 'Electronica', 740.00, '2026-01-01');

-- ESQUEMA: RRHH
CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50),
    area VARCHAR(30),
    salario DECIMAL(10,2),
    fecha_ingreso DATE
);

INSERT INTO empleados (id_empleado, nombre, area, salario, fecha_ingreso) VALUES
(1, 'Ana Torres', 'Ventas', 1200.00, '2022-03-01'),
(2, 'Bruno Perez', 'Ventas', 1200.00, '2021-07-15'),
(3, 'Carla Vega', 'Ventas', 950.00, '2023-01-10'),
(4, 'Diego Rios', 'Sistemas', 2000.00, '2020-05-20'),
(5, 'Elena Sosa', 'Sistemas', NULL, '2024-02-01'),
(6, 'Fabian Luna', 'Sistemas', 1800.00, '2022-03-01'),
(7, 'Gisela Mora', 'Legales', 1500.00, '2019-11-30'),
(8, 'Hugo Paz', 'Ventas', 800.00, '2025-08-18');

-- ESQUEMA: PAISES
CREATE TABLE paises (
    id_pais INT PRIMARY KEY,
    nombre VARCHAR(50),
    continente VARCHAR(30),
    poblacion BIGINT
);

INSERT INTO paises (id_pais, nombre, continente, poblacion) VALUES
(1, 'Argentina', 'America', 46000000),
(2, 'Brasil', 'America', 215000000),
(3, 'Chile', 'America', 19500000),
(4, 'Espana', 'Europa', 47400000),
(5, 'Francia', 'Europa', 68000000),
(6, 'Japon', 'Asia', 125000000),
(7, 'Peru', 'America', 33000000),
(8, 'Italia', 'Europa', 59000000);

CREATE TABLE ciudades (
    id_ciudad INT PRIMARY KEY,
    id_pais INT,
    nombre VARCHAR(50),
    poblacion INT
);

INSERT INTO ciudades (id_ciudad, id_pais, nombre, poblacion) VALUES
(1, 1, 'Buenos Aires', 3100000),
(2, 1, 'Cordoba', 1500000),
(3, 2, 'Sao Paulo', 12300000),
(4, 2, 'Rio de Janeiro', 6700000),
(5, 4, 'Madrid', 3300000),
(6, 4, 'Barcelona', 1600000),
(7, 5, 'Paris', 2100000),
(8, 5, 'Lyon', 520000);

-- ESQUEMA: INVENTARIO
CREATE TABLE deposito_norte (
    id_item INT PRIMARY KEY,
    sku VARCHAR(20),
    descripcion VARCHAR(50),
    stock INT,
    fecha_carga DATE
);

INSERT INTO deposito_norte (id_item, sku, descripcion, stock, fecha_carga) VALUES
(1, 'SKU-100', 'Tornillo 6mm', 500, '2026-09-01'),
(2, 'SKU-200', 'Tuerca 6mm', 300, '2026-09-05'),
(3, 'SKU-300', 'Arandela 10mm', 0, '2026-08-20'),
(4, 'SKU-400', 'Perno 8mm', 120, '2026-10-01'),
(5, 'SKU-500', 'Clavo 2in', NULL, '2026-09-15');

CREATE TABLE deposito_sur (
    id_item INT PRIMARY KEY,
    sku VARCHAR(20),
    descripcion VARCHAR(50),
    stock INT,
    fecha_carga DATE
);

INSERT INTO deposito_sur (id_item, sku, descripcion, stock, fecha_carga) VALUES
(1, 'SKU-100', 'Tornillo 6mm', 450, '2026-10-10'),
(2, 'SKU-300', 'Arandela 10mm', 80, '2026-09-12'),
(3, 'SKU-400', 'Perno 8mm', 60, '2026-09-20'),
(4, 'SKU-600', 'Remache 4mm', 900, '2026-10-02'),
(5, 'SKU-200', 'Tuerca 6mm', 300, '2026-09-05');



-- BLOQUE 2: EJERCICIOS

-- EJERCICIOS BASICOS

/* 1. Numerá todas las ventas de la de mayor a la de menor total. Ante empate de total, desempatá por id_venta ascendente. Mostrá id_venta, cliente, total y la numeración con el alias posicion.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

SELECT id_venta, cliente, total,
	   ROW_NUMBER() OVER(
	       ORDER BY total DESC, id_venta
	   ) AS posicion
FROM ventas;

/* 2. Numerá los empleados dentro de cada area, del que ingresó primero al que ingresó último. La numeración debe reiniciarse en 1 en cada area. Mostrá nombre, area, fecha_ingreso y la numeración con el alias orden_ingreso.
   empleados (id_empleado, nombre, area, salario, fecha_ingreso) */

SELECT nombre, area, fecha_ingreso,
	   ROW_NUMBER() OVER(
	       PARTITION BY area
	       ORDER BY fecha_ingreso
	   ) AS orden_ingreso
FROM empleados;

/* 3. Numerá los países dentro de cada continente, del más poblado al menos poblado. Mostrá nombre, continente, poblacion y la numeración con el alias puesto.
   paises (id_pais, nombre, continente, poblacion) */

SELECT nombre, continente, poblacion,
	   ROW_NUMBER() OVER(
	       PARTITION BY continente
	       ORDER BY poblacion DESC
	   ) AS puesto
FROM paises;


-- EJERCICIOS INTERMEDIOS

/* 1. Obtené los 2 empleados mejor pagos de cada area, ignorando a los que no tienen salario cargado. Ante empate de salario, ganá el de ingreso más antiguo. Mostrá nombre, area y salario.
   empleados (id_empleado, nombre, area, salario, fecha_ingreso) */

WITH mejor_pago AS (
	SELECT nombre, area, salario, fecha_ingreso,
		   ROW_NUMBER() OVER(
		       PARTITION BY area
		       ORDER BY salario DESC, fecha_ingreso
		   ) AS row_num
	FROM empleados
	WHERE salario IS NOT NULL
)
SELECT nombre, area, salario
FROM mejor_pago
WHERE row_num < 3;



/* 2. Obtené la primera compra de cada cliente considerando solo las ventas entre el 2026-01-01 y el 2026-06-30 (ambos inclusive). Ante empate de fecha, quedate con la de menor id_venta. Mostrá id_venta, cliente, total y fecha_venta.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

WITH primera_compra AS (
	SELECT id_venta, cliente, total, fecha_venta,
		   ROW_NUMBER() OVER(
		   PARTITION BY cliente
		   ORDER BY fecha_venta, id_venta
		   ) AS num_compra
	FROM ventas
	WHERE fecha_venta BETWEEN '2026-01-01' AND '2026-06-30'
)
SELECT id_venta, cliente, total, fecha_venta
FROM primera_compra
WHERE num_compra = 1;


/* 3. Obtené la ciudad más poblada de cada país, pero solo de los países de America y Europa. Mostrá el nombre del país, el nombre de la ciudad y la población de la ciudad, ordenado por población de la ciudad de mayor a menor.
   paises (id_pais, nombre, continente, poblacion)
   ciudades (id_ciudad, id_pais, nombre, poblacion) */

WITH ciudades_poblacion AS (
SELECT pa.nombre AS pais,
	   ci.nombre AS ciudad,
	   ci.poblacion AS ciudad_poblacion,
	   ROW_NUMBER() OVER(
	   PARTITION BY pa.nombre
	   ORDER BY ci.poblacion DESC
	   ) AS mas_poblada
FROM ciudades AS ci
JOIN paises AS pa
	ON ci.id_pais = pa.id_pais
WHERE pa.continente IN ('America', 'Europa')
)
SELECT pais, ciudad, ciudad_poblacion
FROM ciudades_poblacion
WHERE mas_poblada = 1
ORDER BY ciudad_poblacion DESC;


/* 4. Unificá ambos depósitos y devolvé una sola fila por sku: la de fecha_carga más reciente. Ante empate de fecha, quedate con la del deposito_norte. Mostrá sku, descripcion, stock, fecha_carga y de qué depósito viene la fila (alias origen).
   deposito_norte (id_item, sku, descripcion, stock, fecha_carga)
   deposito_sur (id_item, sku, descripcion, stock, fecha_carga) */

WITH unido AS (
	SELECT id_item, sku, descripcion, stock, fecha_carga, 'norte' AS origen
	FROM deposito_norte
	UNION ALL
	SELECT id_item, sku, descripcion, stock, fecha_carga, 'sur' AS origen
	FROM deposito_sur
),
fecha_reciente AS (
	SELECT id_item, sku, descripcion, stock, fecha_carga, origen,
		   ROW_NUMBER() OVER(
		       PARTITION BY sku
		       ORDER BY fecha_carga DESC, origen
		   ) AS reciente
	FROM unido
)
SELECT sku, descripcion, stock, fecha_carga, origen
FROM fecha_reciente
WHERE reciente = 1;


-- POR QUE NO FUNCIONA

/* 1. Se quería obtener los 2 empleados mejor pagos de cada area, pero la query falla. ¿Por qué? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, area, salario, fecha_ingreso) */
SELECT nombre, area, salario,
       ROW_NUMBER() OVER (PARTITION BY area ORDER BY salario DESC) AS fila
FROM empleados
WHERE fila <= 2;
/* razon del error 
   errro muy comun, el WHERE se ejecuta antes que SELECT por lo que no reconoce fila, una solucion que se me ocurre es generar una cte y luego pasar el filtro WHERE:*/

WITH mejor_pagos AS (
SELECT nombre, area, salario,
       ROW_NUMBER() OVER (
           PARTITION BY area 
           ORDER BY salario DESC
       ) AS fila
FROM empleados
)
SELECT *
FROM mejor_pagos
WHERE fila <= 2;


/* 2. Se quería obtener TODAS las ventas que alcanzan el mayor total de su categoría (si hay empate, deben aparecer todas las empatadas). La query se ejecuta sin errores pero el resultado no es el esperado. ¿Por qué? Explicá el motivo y cómo corregirla.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */
WITH numeradas AS (
    SELECT id_venta, categoria, total,
           ROW_NUMBER() OVER (
               PARTITION BY categoria 
               ORDER BY total DESC
           ) AS fila
    FROM ventas
)
SELECT id_venta, categoria, total
FROM numeradas
WHERE fila = 1;
/* razon del error 
   no es posible resolver esto con ROW_NUMBER, nos adelantamos un poco al tema de RANK() la estructura es la misma solo que cuando hay empate les asigna el mismo numero y se salta la cantidad de puestos equivalente a los numeros de empates, solucion: */
WITH numeradas AS (
    SELECT id_venta, categoria, total,
           RANK() OVER (
               PARTITION BY categoria 
               ORDER BY total DESC
           ) AS puesto
    FROM ventas
)
SELECT id_venta, categoria, total
FROM numeradas
WHERE puesto = 1;

/* 3. Se quería obtener las 2 ciudades más pobladas de cada país usando una subconsulta, pero la query falla. ¿Por qué? Explicá el motivo y cómo corregirla.
   ciudades (id_ciudad, id_pais, nombre, poblacion) */
SELECT id_ciudad, id_pais, nombre, poblacion
FROM (
    SELECT id_ciudad, id_pais, nombre, poblacion,
           ROW_NUMBER() OVER (
               PARTITION BY id_pais 
               ORDER BY poblacion DESC
           ) AS fila
    FROM ciudades
)
WHERE fila <= 2;
/* razon del error 
   a la subconsulta FROM le hace falta un aliasing AS, solucion: */

SELECT id_ciudad, id_pais, nombre, poblacion
FROM (
    SELECT id_ciudad, id_pais, nombre, poblacion,
           ROW_NUMBER() OVER (
               PARTITION BY id_pais 
               ORDER BY poblacion DESC
           ) AS fila
    FROM ciudades
) AS mas_pobladas
WHERE fila <= 2;





