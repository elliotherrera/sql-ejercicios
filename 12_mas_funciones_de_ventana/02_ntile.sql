/* =====================================================
   NTILE() - FUNCIÓN DE VENTANA EN MYSQL (8.0+)
   =====================================================

   CONCEPTO
   --------
   NTILE(n) divide las filas ordenadas en "n" grupos
   (cubetas) del mismo tamaño y le asigna a cada fila
   el número de su grupo (de 1 a n).

   Sirve para: cuartiles, deciles, percentiles,
   "top 20%", segmentar clientes, etc.

   SINTAXIS
   --------
   NTILE(n) OVER (
       [PARTITION BY columna]   -> opcional: reinicia por grupo
       ORDER BY columna         -> obligatorio: define el orden
   )
*/


/* =====================================================
   DATOS DE EJEMPLO: tabla empleados
   =====================================================

   +----------+--------+--------------+---------+
   | id       | nombre | departamento | salario |
   +----------+--------+--------------+---------+
   |    1     | Ana    | Ventas       |  5000   |
   |    2     | Beto   | TI           |  4500   |
   |    3     | Carla  | Ventas       |  4000   |
   |    4     | Diego  | TI           |  3800   |
   |    5     | Elena  | Ventas       |  3500   |
   |    6     | Fabio  | TI           |  3000   |
   |    7     | Gina   | Ventas       |  2800   |
   |    8     | Hugo   | TI           |  2500   |
   +----------+--------+--------------+---------+
*/


CREATE DATABASE practica_ntile;

CREATE TABLE empleados (
    id           INT PRIMARY KEY,
    nombre       VARCHAR(50),
    departamento VARCHAR(50),
    salario      DECIMAL(10,2)
);

INSERT INTO empleados VALUES
(1, 'Ana',   'Ventas', 5000),
(2, 'Beto',  'TI',     4500),
(3, 'Carla', 'Ventas', 4000),
(4, 'Diego', 'TI',     3800),
(5, 'Elena', 'Ventas', 3500),
(6, 'Fabio', 'TI',     3000),
(7, 'Gina',  'Ventas', 2800),
(8, 'Hugo',  'TI',     2500);


/* =====================================================
   EJEMPLO 1: DIVIDIR EN 4 GRUPOS (CUARTILES)
   =====================================================

   8 filas / 4 cubetas = 2 filas por cubeta.
   Ordenamos por salario DESC, así que:
   cuartil 1 = mejor pagados, cuartil 4 = peor pagados.

   RESULTADO:
   +--------+---------+---------+
   | nombre | salario | cuartil |
   +--------+---------+---------+
   | Ana    |  5000   |    1    |
   | Beto   |  4500   |    1    |
   +--------+---------+---------+
   | Carla  |  4000   |    2    |
   | Diego  |  3800   |    2    |
   +--------+---------+---------+
   | Elena  |  3500   |    3    |
   | Fabio  |  3000   |    3    |
   +--------+---------+---------+
   | Gina   |  2800   |    4    |
   | Hugo   |  2500   |    4    |
   +--------+---------+---------+
*/

SELECT nombre, salario,
       NTILE(4) OVER (ORDER BY salario DESC) AS cuartil
FROM empleados;


/* =====================================================
   EJEMPLO 2: ¿QUÉ PASA SI NO ES DIVISIBLE?
   =====================================================

   Con 10 filas y NTILE(4): 10 / 4 = 2 con resto 2.
   Las primeras cubetas reciben una fila extra
   (el resto se reparte desde la cubeta 1).

   Suponiendo 10 empleados (agregamos Irene 2000
   y Jorge 1800), el resultado sería:

   +--------+---------+---------+
   | nombre | salario | cubeta  |
   +--------+---------+---------+
   | Ana    |  5000   |    1    |
   | Beto   |  4500   |    1    |   <- cubeta 1: 3 filas
   | Carla  |  4000   |    1    |
   +--------+---------+---------+
   | Diego  |  3800   |    2    |
   | Elena  |  3500   |    2    |   <- cubeta 2: 3 filas
   | Fabio  |  3000   |    2    |
   +--------+---------+---------+
   | Gina   |  2800   |    3    |   <- cubeta 3: 2 filas
   | Hugo   |  2500   |    3    |
   +--------+---------+---------+
   | Irene  |  2000   |    4    |   <- cubeta 4: 2 filas
   | Jorge  |  1800   |    4    |
   +--------+---------+---------+

   Resumen de tamaños: 3 - 3 - 2 - 2

   NOTA: si hay MENOS filas que cubetas (ej. 3 filas
   con NTILE(5)), solo se usan las cubetas 1, 2 y 3.
*/

INSERT INTO empleados VALUES
(9,  'Irene', 'Ventas', 2000),
(10, 'Jorge', 'TI',     1800);

SELECT nombre, salario,
       NTILE(4) OVER (ORDER BY salario DESC) AS cubeta
FROM empleados;


/* =====================================================
   EJEMPLO 3: NTILE CON PARTITION BY
   =====================================================

   PARTITION BY reinicia el conteo en cada grupo.
   Aquí dividimos cada departamento en 2 mitades
   (usamos los 8 empleados originales).

   Ventas: Ana, Carla, Elena, Gina
   TI:     Beto, Diego, Fabio, Hugo

   RESULTADO:
   +--------+--------------+---------+--------+
   | nombre | departamento | salario | mitad  |
   +--------+--------------+---------+--------+
   | Ana    | Ventas       |  5000   |   1    |
   | Carla  | Ventas       |  4000   |   1    |
   | Elena  | Ventas       |  3500   |   2    |
   | Gina   | Ventas       |  2800   |   2    |
   +--------+--------------+---------+--------+
   | Beto   | TI           |  4500   |   1    |
   | Diego  | TI           |  3800   |   1    |
   | Fabio  | TI           |  3000   |   2    |
   | Hugo   | TI           |  2500   |   2    |
   +--------+--------------+---------+--------+

   Cada departamento tiene su propia cubeta 1 y 2.
*/

SELECT nombre, departamento, salario,
       NTILE(2) OVER (
           PARTITION BY departamento
           ORDER BY salario DESC
       ) AS mitad
FROM empleados
ORDER BY departamento DESC; -- no hay inconveniente en este ORDER BY


/* =====================================================
   EJEMPLO 4: FILTRAR EL TOP 25%
   =====================================================

   No se puede usar WHERE directamente sobre una
   función de ventana. Solución: un CTE (o subconsulta).

   Paso 1 (CTE ranking): se calcula el cuartil.
   +--------+---------+---------+
   | Ana    |  5000   |    1    |
   | Beto   |  4500   |    1    |
   | Carla  |  4000   |    2    |
   | ...    |  ...    |   ...   |
   +--------+---------+---------+

   Paso 2 (WHERE cuartil = 1): se filtra.
   RESULTADO FINAL:
   +--------+---------+---------+
   | nombre | salario | cuartil |
   +--------+---------+---------+
   | Ana    |  5000   |    1    |
   | Beto   |  4500   |    1    |
   +--------+---------+---------+
*/

WITH ranking AS (
    SELECT nombre, salario,
           NTILE(4) OVER (ORDER BY salario DESC) AS cuartil
    FROM empleados
)
SELECT *
FROM ranking
WHERE cuartil = 1;


/* =====================================================
   EJEMPLO 5: NTILE NO RESPETA EMPATES
   =====================================================

   NTILE reparte por CANTIDAD DE FILAS, no por valor.
   Si hay empates, filas con el MISMO salario pueden
   quedar en cubetas distintas.

   Tabla de prueba (4 filas, NTILE(2)):

   +--------+---------+--------+
   | nombre | salario | cubeta |
   +--------+---------+--------+
   | Ana    |  5000   |   1    |
   | Beto   |  4000   |   1    |  <- mismo salario...
   +--------+---------+--------+
   | Carla  |  4000   |   2    |  <- ...distinta cubeta
   | Diego  |  3000   |   2    |
   +--------+---------+--------+

   Beto y Carla ganan lo mismo, pero NTILE los separa.
   Si necesitas respetar empates, usa RANK, DENSE_RANK
   o PERCENT_RANK.
*/

WITH prueba AS (
    SELECT 'Ana'   AS nombre, 5000 AS salario UNION ALL
    SELECT 'Beto',  4000 UNION ALL
    SELECT 'Carla', 4000 UNION ALL
    SELECT 'Diego', 3000
)
SELECT nombre, salario,
       NTILE(2) OVER (ORDER BY salario DESC) AS cubeta
FROM prueba;


/* =====================================================
   COMPARACIÓN CON OTRAS FUNCIONES DE VENTANA
   =====================================================

   +--------------+----------------------------------------+
   | Función      | Qué hace                               |
   +--------------+----------------------------------------+
   | NTILE(n)     | Reparte filas en n grupos iguales      |
   | RANK()       | Posición, con saltos en empates        |
   | DENSE_RANK() | Posición, sin saltos en empates        |
   | PERCENT_RANK | Percentil exacto de cada fila (0 a 1)  |
   +--------------+----------------------------------------+
*/


-- DESAFIO

/*
Tablas y columnas disponibles:

creatures: creature_name, preference, has_legs (contiene 'YES' o 'NO')
En este desafío, tenemos criaturas que quieren encontrar a su media naranja. Tenemos que ayudarlas a encontrar pareja.

Cada criatura tiene una preferencia representada por un número. Si ambas criaturas tienen números lo suficientemente cercanos, podrían ser una buena pareja.

Divide las criaturas en 3 grupos según sus valores de preferencia, pero considera solo las criaturas que tienen patas (donde has_legs = 'YES'). Devuelve creature_name, preference y su group_number (1, 2 o 3). Ordena los resultados por preference en orden ascendente.
*/

SELECT 
    creature_name, preference,
    NTILE(3) OVER (ORDER BY preference) AS group_number
FROM creatures
WHERE has_legs = "YES";






-- BLOQUE 1: SETUP
DROP DATABASE IF EXISTS practica_ntile;
CREATE DATABASE practica_ntile;
USE practica_ntile;

-- ESQUEMA: VENTAS
CREATE TABLE ventas (
    id_venta    INT PRIMARY KEY,
    vendedor    VARCHAR(50),
    region      VARCHAR(30),
    monto       DECIMAL(10,2),
    fecha_venta DATE
);

INSERT INTO ventas (id_venta, vendedor, region, monto, fecha_venta) VALUES
(1, 'Paula',   'Norte',  1200.00, '2026-01-31'),
(2, 'Ramiro',  'Sur',     850.00, '2026-02-01'),
(3, 'Paula',   'Norte',  1500.00, '2026-02-14'),
(4, 'Gustavo', 'Centro',  850.00, '2026-03-10'),
(5, 'Ramiro',  'Sur',    2300.00, '2026-03-31'),
(6, 'Elena',   'Centro',  640.00, '2026-03-31'),
(7, 'Gustavo', 'Centro', 1750.00, '2026-04-01'),
(8, 'Paula',   'Norte',   980.00, '2026-03-05');

-- ESQUEMA: INVENTARIO
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre      VARCHAR(60),
    categoria   VARCHAR(30),
    precio      DECIMAL(10,2),
    stock       INT
);

INSERT INTO productos (id_producto, nombre, categoria, precio, stock) VALUES
(1, 'Teclado mecánico',     'Periféricos', 45.50,  30),
(2, 'Mouse inalámbrico',    'Periféricos', 22.00,   0),
(3, 'Monitor 24 pulgadas',  'Pantallas',  180.00,  12),
(4, 'Cable HDMI',           'Cables',       8.90, 150),
(5, 'Cable USB-C',          'Cables',       8.90,  90),
(6, 'Webcam HD',            'Periféricos', 39.99,  18),
(7, 'Soporte para monitor', 'Accesorios',  27.50,  25);

-- ESQUEMA: PAISES
CREATE TABLE paises (
    id_pais        INT PRIMARY KEY,
    nombre         VARCHAR(50),
    continente     VARCHAR(30),
    poblacion      BIGINT,
    superficie_km2 INT
);

INSERT INTO paises (id_pais, nombre, continente, poblacion, superficie_km2) VALUES
(1, 'Argentina',      'América', 46000000, 2780000),
(2, 'Chile',          'América', 19500000,  756000),
(3, 'Uruguay',        'América',  3400000,  176000),
(4, 'Francia',        'Europa',  68000000,  640000),
(5, 'Portugal',       'Europa',  10400000,   92000),
(6, 'Suiza',          'Europa',   8800000,   41000),
(7, 'Japón',          'Asia',   124000000,  378000),
(8, 'Nueva Zelanda',  'Oceanía',  5170000,  268000);

-- ESQUEMA: RRHH
CREATE TABLE departamentos (
    id_depto     INT PRIMARY KEY,
    nombre_depto VARCHAR(50)
);

INSERT INTO departamentos (id_depto, nombre_depto) VALUES
(1, 'Finanzas'),
(2, 'Operaciones'),
(3, 'Soporte'),
(4, 'Legales'),
(5, 'Marketing');

CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY,
    nombre      VARCHAR(50),
    id_depto    INT,
    salario     DECIMAL(10,2)
);

INSERT INTO empleados (id_empleado, nombre, id_depto, salario) VALUES
(1, 'Lucía',    1, 5200.00),
(2, 'Martín',   2, 4800.00),
(3, 'Sofía',    1, 4400.00),
(4, 'Tomás',    3, 4400.00),
(5, 'Valeria',  2, 4400.00),
(6, 'Nicolás',  3, 3900.00),
(7, 'Camila',   1, NULL),
(8, 'Joaquín',  2, 3100.00);




-- BLOQUE 2: EJERCICIOS
USE practica;

-- EJERCICIOS BASICOS

/* 1. Dividí las ventas en 4 grupos (cuartiles) según el monto, de mayor a menor.
      Devolvé vendedor, monto y el número de cuartil (el grupo 1 son los montos más altos).
      ventas (id_venta, vendedor, region, monto, fecha_venta) */

SELECT
	vendedor, monto,
	NTILE(4) OVER(
		ORDER BY monto DESC
	) AS cuartil
FROM ventas;

/* 2. Dividí los productos en 3 grupos según su precio, de menor a mayor.
      Devolvé nombre, precio y el número de grupo.
      productos (id_producto, nombre, categoria, precio, stock) */

SELECT
	nombre, precio,
	NTILE(3) OVER (
		ORDER BY precio
	) AS num_grupo
FROM productos;


/* 3. Dentro de cada continente, dividí los países en 2 mitades según su población,
      de mayor a menor. Devolvé nombre, continente, poblacion y el número de mitad.
      paises (id_pais, nombre, continente, poblacion, superficie_km2) */

SELECT
	nombre, continente, poblacion,
	NTILE(2) OVER (
		PARTITION BY continente
		ORDER BY poblacion DESC
	) AS mitad
FROM paises;

-- EJERCICIOS INTERMEDIOS

/* 1. Considerando solo las ventas realizadas entre el 2026-02-01 y el 2026-03-31
      (ambas fechas incluidas), dividilas en 3 grupos según el monto, de mayor a menor.
      Devolvé únicamente las ventas del grupo 1, con id_venta, vendedor, monto y fecha_venta.
      ventas (id_venta, vendedor, region, monto, fecha_venta) */

WITH grupo_ventas AS (
SELECT
	id_venta, vendedor, monto, fecha_venta,
	NTILE(3) OVER(
		ORDER BY monto DESC
	) AS grupo
FROM ventas
WHERE fecha_venta >= '2026-02-01' AND fecha_venta <= '2026-03-31'
)
SELECT id_venta, vendedor, monto, fecha_venta, grupo
FROM grupo_ventas
WHERE grupo = 1;

/* 2. Para los empleados que tienen salario cargado, dividilos en 4 grupos según su
      salario, de mayor a menor. Devolvé nombre, nombre_depto, salario y el número de grupo.
      Ordená el resultado por grupo y, dentro de cada grupo, por nombre.
      empleados (id_empleado, nombre, id_depto, salario)
      departamentos (id_depto, nombre_depto) */

SELECT 
	nombre, d.nombre_depto, salario,
	NTILE(4) OVER(
		ORDER BY salario DESC
	) AS grupo
FROM empleados AS e
JOIN departamentos AS d
	ON e.id_depto = d.id_depto
WHERE salario IS NOT NULL
ORDER BY grupo, nombre;

/* 3. Calculá el total vendido por cada vendedor, considerando solo a los que tienen
      al menos 2 ventas. Luego dividilos en 2 grupos según ese total, de mayor a menor.
      Devolvé vendedor, total_vendido y el número de grupo.
      ventas (id_venta, vendedor, region, monto, fecha_venta) */

WITH grupo_ventas AS (
SELECT 
	vendedor,
	SUM(monto) AS total_vendido
FROM ventas
GROUP BY vendedor
HAVING count(*) >= 2
)
SELECT 
	vendedor, total_vendido,
	NTILE(2) OVER (
		ORDER BY total_vendido DESC
	) AS grupo
FROM grupo_ventas; 


/* 4. Calculá la densidad de población de cada país (poblacion / superficie_km2),
      redondeada a 1 decimal. Devolvé nombre, la densidad, un grupo del 1 al 4 (NTILE)
      según la densidad de menor a mayor, y también su posición con DENSE_RANK según
      la misma densidad. Ordená por densidad ascendente.
      paises (id_pais, nombre, continente, poblacion, superficie_km2) */

WITH CTE_densidad_poblacion AS (
SELECT
	nombre, poblacion,
	ROUND ((poblacion / superficie_km2), 1) AS densidad
FROM paises
),
CTE_grupos AS (
SELECT 
	nombre, poblacion, densidad,
	NTILE(4) OVER (
		ORDER BY densidad
	) AS grupo
FROM CTE_densidad_poblacion
)
SELECT 
	nombre, densidad, grupo,
	DENSE_RANK() OVER (
		ORDER BY densidad 
	) AS posicion
FROM CTE_grupos
ORDER BY densidad;


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
      Se busca ver solo los empleados del cuartil 1 según su salario.
      empleados (id_empleado, nombre, id_depto, salario) */
SELECT nombre, salario,
       NTILE(4) OVER (ORDER BY salario DESC) AS cuartil
FROM empleados
WHERE cuartil = 1;
/* razon del error : las funciones de ventana se calculan despues de WHERE/GROUP By/ HAVING*/

WITH cuartil_empleados AS (
SELECT nombre, salario,
       NTILE(4) OVER (ORDER BY salario DESC) AS cuartil
FROM empleados
)
SELECT *
FROM cuartil_empleados 
WHERE cuartil = 1;


/* 2. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
      Se busca dividir las regiones en 2 grupos según el total vendido por región.
      ventas (id_venta, vendedor, region, monto, fecha_venta) */
SELECT region,
       SUM(monto) AS total_region,
       NTILE(2) OVER (ORDER BY monto DESC) AS grupo
FROM ventas
GROUP BY region;
/* razon del error: ORDER BY usa monto sin agregar, Y con GROUP BY region esa columna no existe a nivel de grupo  */

SELECT region,
       SUM(monto) AS total_region,
       NTILE(2) OVER (ORDER BY SUM(monto) DESC) AS grupo
FROM ventas
GROUP BY region;
