-- =====================================================================
-- FUNCIONES DE AGREGACIÓN COMO FUNCIONES DE VENTANA
-- =====================================================================
 
 
-- ---------------------------------------------------------------------
-- IDEA CLAVE
-- ---------------------------------------------------------------------
-- Las funciones de agregación (SUM, AVG, MAX, MIN, COUNT) pueden usarse
-- con OVER para calcular un valor SIN colapsar las filas, a diferencia
-- de GROUP BY. Cada fila conserva su detalle y recibe además el
-- resultado del cálculo.
--
-- Lo que cambia según el contenido de OVER (...):
--
-- +---------------------------------------+---------------------------------------------------------------+
-- | Sintaxis                              | Qué calcula cada fila                                         |
-- +---------------------------------------+---------------------------------------------------------------+
-- | OVER ()                               | La función sobre TODAS las filas (todas reciben el mismo      |
-- |                                       | valor)                                                        |
-- | OVER (ORDER BY col)                   | Un valor ACUMULADO: desde la primera fila hasta la fila       |
-- |                                       | actual, incluidos sus empates en col                          |
-- | OVER (PARTITION BY col)               | La función sobre todas las filas de CADA GRUPO                |
-- | OVER (PARTITION BY col ORDER BY col2) | Un valor acumulado que SE REINICIA en cada grupo              |
-- +---------------------------------------+---------------------------------------------------------------+

-- ---------------------------------------------------------------------
-- DATOS DE EJEMPLO (table1)
-- ---------------------------------------------------------------------
-- +-------+---------+--------+
-- | month | revenue | region |
-- +-------+---------+--------+
-- |   4   |   40    | East   |
-- |   5   |   20    | East   |
-- |   6   |   60    | West   |
-- |   7   |   55    | West   |
-- |   8   |   61    | East   |
-- +-------+---------+--------+
 
 
-- ---------------------------------------------------------------------
-- 1. SIN ORDER BY: el mismo valor para todas las filas
-- ---------------------------------------------------------------------

	SELECT 
		month, 
		revenue,
      	MAX(revenue) OVER () AS max_revenue
	FROM table1;

-- Resultado:
-- +-------+---------+-------------+
-- | month | revenue | max_revenue |
-- +-------+---------+-------------+
-- |   4   |   40    |     61      |
-- |   5   |   20    |     61      |
-- |   6   |   60    |     61      |
-- |   7   |   55    |     61      |
-- |   8   |   61    |     61      |
-- +-------+---------+-------------+
--
-- Es útil para comparar cada fila contra el total o el máximo global,
-- por ejemplo: revenue / MAX(revenue) OVER ()
 
 
-- ---------------------------------------------------------------------
-- 2. CON ORDER BY: máximo acumulado
-- ---------------------------------------------------------------------

	SELECT 
		month, 
		revenue,
		MAX(revenue) OVER (
			ORDER BY month ASC
		) AS max_revenue
	FROM table1;

-- Resultado:
-- +-------+---------+-------------+
-- | month | revenue | max_revenue |
-- +-------+---------+-------------+
-- |   4   |   40    |     40      |
-- |   5   |   20    |     40      |
-- |   6   |   60    |     60      |
-- |   7   |   55    |     60      |
-- |   8   |   61    |     61      |
-- +-------+---------+-------------+
--
-- Cada fila calcula el máximo de todas las filas desde la primera hasta
-- ella misma:
--   - Mes 5: el máximo de {40, 20} es 40.
--   - Mes 6: el máximo de {40, 20, 60} es 60.
--   - Mes 7: el máximo de {40, 20, 60, 55} sigue siendo 60, porque 55
--            no supera a 60.
--   - Mes 8: el máximo de todas es 61.
--
-- El resultado solo cambia cuando aparece un valor mayor que todos los
-- anteriores. No se "descarta" nada: la ventana simplemente crece fila
-- a fila.
 
 
-- ---------------------------------------------------------------------
-- 3. PROMEDIO ACUMULADO
-- ---------------------------------------------------------------------

	SELECT 
		month,
		revenue,
        AVG(revenue) OVER (
        	ORDER BY month ASC
        ) AS avg_revenue
	FROM table1;

-- Resultado:
-- +-------+---------+-------------+-----------------------+
-- | month | revenue | avg_revenue | Cálculo               |
-- +-------+---------+-------------+-----------------------+
-- |   4   |   40    |     40      | 40 / 1                |
-- |   5   |   20    |     30      | (40+20) / 2           |
-- |   6   |   60    |     40      | (40+20+60) / 3        |
-- |   7   |   55    |    43.75    | (40+20+60+55) / 4     |
-- |   8   |   61    |    47.2     | (40+20+60+55+61) / 5  |
-- +-------+---------+-------------+-----------------------+
 
 
-- ---------------------------------------------------------------------
-- 4. PARTITION BY: acumulado por grupo
-- ---------------------------------------------------------------------

	SELECT 
		month,
		revenue,
		region,
		MAX(revenue) OVER (
			PARTITION BY region 
			ORDER BY month ASC
		) AS max_revenue
	FROM table1
	ORDER BY month;


-- Resultado:
-- +-------+---------+--------+-------------+
-- | month | revenue | region | max_revenue |
-- +-------+---------+--------+-------------+
-- |   4   |   40    | East   |     40      |
-- |   5   |   20    | East   |     40      |
-- |   6   |   60    | West   |     60      |
-- |   7   |   55    | West   |     60      |
-- |   8   |   61    | East   |     61      |
-- +-------+---------+--------+-------------+
--
-- PARTITION BY divide las filas en grupos, y el cálculo corre de forma
-- independiente dentro de cada uno:
--   - East (meses 4, 5, 8): 40 -> 40 -> 61
--   - West (meses 6, 7):    60 -> 60
--
-- Fíjate en el mes 8: el 61 de East no se ve afectado por el 60 de
-- West, porque son particiones separadas.
--
-- NOTA: el ORDER BY month del final solo ordena el resultado visible.
-- El que está dentro de OVER define el orden del cálculo acumulado.
-- Son independientes.
 
 
-- ---------------------------------------------------------------------
-- 5. DETALLE IMPORTANTE: los empates en ORDER BY
-- ---------------------------------------------------------------------
-- Cuando varias filas tienen el mismo valor en el ORDER BY de OVER, la
-- ventana por defecto las trata TODAS JUNTAS, así que cada una incluye
-- a sus "pares". Se ve con un SUM si hay un mes repetido:

	SELECT 
		month, 
		revenue,
	    SUM(revenue) OVER (
	    	ORDER BY month
	    ) AS running_sum
	FROM table2;

-- Resultado:
-- +-------+---------+-------------+
-- | month | revenue | running_sum |
-- +-------+---------+-------------+
-- |   1   |   10    |     10      |
-- |   2   |   20    |     60      |
-- |   2   |   30    |     60      |
-- |   3   |    5    |     65      |
-- +-------+---------+-------------+
--
-- Las dos filas del mes 2 reciben 60 (10+20+30) porque son empates.
--
-- Si quieres un acumulado fila por fila, que no agrupe empates, define
-- la ventana explícitamente:
--
	SUM(revenue) OVER (
		ORDER BY month 
		ROWS UNBOUNDED PRECEDING
	)
--
-- Con ROWS, el resultado sería: 10, 30, 60, 65.
-- Para que sea determinista, añade un criterio de desempate al
-- ORDER BY (por ejemplo, un id).
 
 
-- ---------------------------------------------------------------------
-- RESUMEN RÁPIDO
-- ---------------------------------------------------------------------
--   - OVER () calcula sobre todo el conjunto.
--   - ORDER BY dentro de OVER produce un cálculo ACUMULADO.
--   - PARTITION BY separa el cálculo por GRUPOS.
--   - Con ORDER BY, la ventana por defecto es
--     RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW, que INCLUYE
--     empates.
--   - Para acumular estrictamente fila por fila, usa ROWS.


-- DESAFIO

-- Tablas y columnas disponibles:
-- 
-- books: book, page, words
-- Para cada libro, muestra el nombre del libro, el total de páginas, la cantidad de palabras en cada página y calcula:
-- 
-- La cantidad máxima de palabras encontrada en cualquier página de ese libro
-- La cantidad promedio de palabras por página de todo el libro
-- La diferencia entre las palabras de la página actual y el promedio de palabras por página del libro
-- Muestra los resultados ordenados por libro y número de página.
-- 
-- Devuelve las siguientes columnas:
-- 
-- book
-- page
-- words
-- max_words_in_book
-- avg_words_per_page
-- diff_from_avg

SELECT
    book,
    page,
    words,
    MAX(words) OVER (
        PARTITION BY book
    ) AS max_words_in_book,
    AVG(words) OVER (
        PARTITION BY book
    ) AS avg_words_per_page,
    words - AVG(words) OVER (
        PARTITION BY book
    ) AS diff_from_avg
FROM books;



-- BLOQUE SETUP

DROP DATABASE IF EXISTS practica;
CREATE DATABASE practica;
USE practica;

-- ESQUEMA: VENTAS
CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY,
    cliente VARCHAR(50) NOT NULL,
    canal VARCHAR(20) NOT NULL,
    monto DECIMAL(10,2),
    fecha_pedido DATE NOT NULL
);

INSERT INTO pedidos (id_pedido, cliente, canal, monto, fecha_pedido) VALUES
(1, 'Lucía',  'Web',    1500.00, '2026-01-05'),
(2, 'Marcos', 'Tienda',  800.00, '2026-01-12'),
(3, 'Lucía',  'Tienda', 1000.00, '2026-01-12'),
(4, 'Sofía',  'Web',    2500.00, '2026-01-20'),
(5, 'Marcos', 'Web',     800.00, '2026-02-01'),
(6, 'Tomás',  'Tienda',    NULL, '2026-02-01'),
(7, 'Sofía',  'Tienda', 1000.00, '2026-02-14'),
(8, 'Tomás',  'Web',    2500.00, '2026-02-14');

-- ESQUEMA: RRHH
CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    area VARCHAR(30) NOT NULL,
    salario DECIMAL(12,2),
    fecha_ingreso DATE NOT NULL
);

INSERT INTO empleados (id_empleado, nombre, area, salario, fecha_ingreso) VALUES
(1, 'Ana',    'Ventas',         900000.00,  '2023-03-01'),
(2, 'Bruno',  'Ventas',         750000.00,  '2023-03-01'),
(3, 'Carla',  'Ventas',         750000.00,  '2024-01-15'),
(4, 'Diego',  'Sistemas',      1200000.00,  '2022-06-10'),
(5, 'Elena',  'Sistemas',      1100000.00,  '2022-06-10'),
(6, 'Fabián', 'Sistemas',            NULL,  '2024-05-20'),
(7, 'Gloria', 'Gerencia',      2000000.00,  '2020-01-02'),
(8, 'Hugo',   'Administracion', 600000.00,  '2021-09-30');

-- ESQUEMA: INVENTARIO
CREATE TABLE movimientos_stock (
    id_mov INT PRIMARY KEY,
    producto VARCHAR(40) NOT NULL,
    deposito VARCHAR(20) NOT NULL,
    cantidad INT NOT NULL,
    fecha_mov DATE NOT NULL
);

INSERT INTO movimientos_stock (id_mov, producto, deposito, cantidad, fecha_mov) VALUES
(1, 'Tornillo', 'Norte',  100, '2026-03-01'),
(2, 'Tuerca',   'Norte',   50, '2026-03-02'),
(3, 'Tornillo', 'Sur',    -30, '2026-03-05'),
(4, 'Tuerca',   'Norte',  -40, '2026-03-06'),
(5, 'Tuerca',   'Sur',    -25, '2026-03-06'),
(6, 'Tornillo', 'Norte',  -80, '2026-03-10'),
(7, 'Arandela', 'Norte',  200, '2026-03-10'),
(8, 'Tuerca',   'Norte',   20, '2026-03-15');

-- ESQUEMA: PAISES
CREATE TABLE paises (
    id_pais INT PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL,
    continente VARCHAR(20) NOT NULL,
    poblacion BIGINT NOT NULL,
    pib DECIMAL(10,2)
);

INSERT INTO paises (id_pais, nombre, continente, poblacion, pib) VALUES
(1, 'Argentina', 'America',   46000000,  640.00),
(2, 'Brasil',    'America',  214000000, 1900.00),
(3, 'Chile',     'America',   19500000,  330.00),
(4, 'Uruguay',   'America',    3400000,     NULL),
(5, 'Francia',   'Europa',    68000000, 2900.00),
(6, 'Alemania',  'Europa',    83000000, 4100.00),
(7, 'Italia',    'Europa',    59000000, 2900.00),
(8, 'Japon',     'Asia',     125000000, 4200.00);



-- BLOQUE EJERCICIOS

-- EJERCICIOS BASICOS

/* 1. Mostrá id_pedido, cliente y monto de cada pedido, junto con el monto
      máximo y el monto promedio de todos los pedidos (sin colapsar filas).
      pedidos (id_pedido, cliente, canal, monto, fecha_pedido) */

SELECT
	id_pedido,
	cliente,
	monto,
	MAX(monto) OVER () AS monto_maximo,
	AVG(monto) OVER () AS monto_promedio
FROM pedidos;


/* 2. Mostrá id_pedido, fecha_pedido y monto de cada pedido, junto con la
      suma acumulada de monto ordenada por fecha_pedido.
      pedidos (id_pedido, cliente, canal, monto, fecha_pedido) */

SELECT 
	id_pedido,
	fecha_pedido,
	monto,
	SUM(monto) OVER (
		ORDER BY fecha_pedido 
	) AS sum_acumulada
FROM pedidos;


/* 3. Mostrá nombre y continente de cada país, junto con la cantidad total de
      países de su continente y la cantidad de países de su continente que
      tienen pib informado.
      paises (id_pais, nombre, continente, poblacion, pib) */

SELECT 
	nombre,
	continente,
	COUNT(*) OVER (
		PARTITION BY continente
	) AS n_paises,
	COUNT(pib) OVER (
		PARTITION BY continente
	) AS n_paises_con_pib
FROM paises;

-- EJERCICIOS INTERMEDIOS

/* 1. Para los empleados que no son del área 'Gerencia', mostrá nombre, area,
      salario y qué porcentaje representa su salario sobre el total salarial
      de su área, redondeado a 2 decimales.
      empleados (id_empleado, nombre, area, salario, fecha_ingreso) */

SELECT 
	nombre,
	area,
	salario,
	ROUND (salario *100 / SUM(salario) OVER (PARTITION BY area) , 2) AS prc_salario_area
FROM empleados
WHERE area != 'Gerencia';


/* 2. Usando una CTE, calculá el total de monto por cliente. Luego mostrá
      cliente, total_cliente, el acumulado de esos totales ordenados de mayor
      a menor, y el porcentaje que representa cada total sobre el total
      general, redondeado a 1 decimal.
      pedidos (id_pedido, cliente, canal, monto, fecha_pedido) */

WITH CTE_total_cliente AS (
SELECT 
	cliente,
	SUM(monto) AS total_cliente
FROM pedidos
GROUP BY cliente
)
SELECT 
	cliente,
	total_cliente,
	SUM(total_cliente) OVER (
		ORDER BY total_cliente DESC
	) AS total_acumulado,
	ROUND((total_cliente / SUM(total_cliente) OVER () * 100),1) AS prc_total
FROM CTE_total_cliente;


/* 3. Calculá el stock acumulado de cada producto, movimiento por movimiento,
      en orden cronológico (desempatando por id_mov). Mostrá solo los
      movimientos después de los cuales el stock acumulado del producto
      quedó negativo. Columnas: id_mov, producto, fecha_mov, cantidad,
      stock_acumulado.
      movimientos_stock (id_mov, producto, deposito, cantidad, fecha_mov) */

WITH CTE_movimientos_acumulados AS (
SELECT 
	id_mov, 
	producto, 
	fecha_mov, 
	cantidad,
	SUM(cantidad) OVER (
		PARTITION BY producto 
		ORDER BY fecha_mov, id_mov
	) AS stock_acumulado
FROM movimientos_stock
)
SELECT 
	id_mov, 
	producto, 
	fecha_mov, 
	cantidad,
	stock_acumulado
FROM CTE_movimientos_acumulados
WHERE stock_acumulado < 0;


/* 4. Considerando solo los países con población entre 10 millones y 100
      millones (inclusive), mostrá nombre, continente, pib, el ranking de pib
      dentro de su continente (de mayor a menor; los empates comparten puesto
      y el siguiente puesto se saltea) y el pib promedio de su continente
      calculado sobre esos países.
      paises (id_pais, nombre, continente, poblacion, pib) */

SELECT
	nombre,
	continente,
	pib,
	RANK() OVER (
		PARTITION BY continente 
		ORDER BY pib DESC
	) AS ranking_pib,
	AVG(pib) OVER (
		PARTITION BY continente
	) AS promedio_pib
FROM paises
WHERE poblacion BETWEEN 10000000 AND 100000000;
	

-- POR QUE NO FUNCIONA

/* 1. Se quiere listar los empleados cuyo salario supera el promedio de su
      área, pero la query falla. ¿Por qué? Explicá el motivo y cómo corregirla.
      empleados (id_empleado, nombre, area, salario, fecha_ingreso) */
SELECT nombre, area, salario
FROM empleados
WHERE salario > AVG(salario) OVER (PARTITION BY area);
/* razon del error no se puede generar una funcion de ventana dentro de un filtro WHERE porque WHERE no lo reconoce y no lo puede ejecutar, Se soluciona modulando el problema y luego aplicarle el filtro WHERE a algo ya definido con subconsulta o CTE. Tener en cuenta que hay areas con un solo salario, el enunciado pide superar por esa razon > las descarta*/

WITH CTE_salarios_promediados_por_area AS (
SELECT 
	nombre, 
	area, 
	salario,
	AVG(salario) OVER (PARTITION BY area) AS promedio_salario
FROM empleados
)
SELECT 
	nombre, 
	area, 
	salario
FROM CTE_salarios_promediados_por_area
WHERE salario > promedio_salario;
	
	
/* 2. Se quiere el salario acumulado por área, empleado por empleado, según
      fecha_ingreso. La query se ejecuta sin errores, pero algunos valores
      no son los esperados. ¿Por qué? Explicá el motivo y cómo corregirla.
      empleados (id_empleado, nombre, area, salario, fecha_ingreso) */
SELECT
    nombre,
    area,
    fecha_ingreso,
    salario,
    SUM(salario) OVER (
        PARTITION BY area
        ORDER BY fecha_ingreso
    ) AS salario_acumulado
FROM empleados;
/* razon del error En el area sistemas hay 3 registros, pero hay un empate por fecha 2022-06-10 y por esta razon el salario_acumulado empieza sumando estos 2 registros de golpe y no muestra uno por uno como se pide. La solucion es generar un desempate, en este caso usare nombre*/

SELECT
    nombre,
    area,
    fecha_ingreso,
    salario,
    SUM(salario) OVER (
        PARTITION BY area
        ORDER BY fecha_ingreso, nombre
    ) AS salario_acumulado
FROM empleados;

/* 3. Se quiere mostrar qué porcentaje de la población de su continente
      representa cada país, pero la query falla. ¿Por qué? Explicá el motivo
      y cómo corregirla.
      paises (id_pais, nombre, continente, poblacion, pib) */
SELECT
    nombre,
    continente,
    poblacion,
    SUM(poblacion) OVER (PARTITION BY continente) AS pob_continente,
    ROUND(poblacion * 100 / pob_continente, 2) AS porcentaje
FROM paises;
/* razon del error el aliasing pob_continente se declara en el select y se llama dentro del mismo ambito, para solucionar esto debemos ser explicitos en el llamado,, la otra opcion es modularlo por separado con subquerys o CTE, en este caso se usa la solucion explicita*/

SELECT
    nombre,
    continente,
    poblacion,
    SUM(poblacion) OVER (PARTITION BY continente) AS pob_continente,
    ROUND(poblacion * 100 / SUM(poblacion) OVER (PARTITION BY continente), 2) AS porcentaje
FROM paises;























