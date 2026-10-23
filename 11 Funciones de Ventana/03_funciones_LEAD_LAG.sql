
/* ============================================================
   MACHETE: LAG y LEAD (Window Functions en MySQL)
   ============================================================

   QUE HACEN
   ---------
   LAG(col)  -> trae el valor de la fila ANTERIOR
   LEAD(col) -> trae el valor de la fila SIGUIENTE

   "Anterior" y "siguiente" no significan nada hasta definir:
     ORDER BY     -> en que orden se alinean las filas
     PARTITION BY -> donde se corta la lista (el conteo se reinicia)

   SINTAXIS
   --------
   LAG(columna, n, valor_default) OVER (
       PARTITION BY columna_grupo
       ORDER BY columna_orden
   )

     n              -> cuantas filas retroceder/avanzar (default 1)
     valor_default  -> valor a devolver en vez de NULL cuando no hay fila
     PARTITION BY   -> opcional (sin el, todas las filas son un solo grupo)
     ORDER BY       -> necesario para que "anterior/siguiente" tenga sentido
   ============================================================ */


/* ------------------------------------------------------------
   TABLA DE EJEMPLO: ventas
   ------------------------------------------------------------
   +----------+-----+-------+
   | vendedor | mes | monto |
   +----------+-----+-------+
   | Ana      |  1  |  100  |
   | Ana      |  2  |  150  |
   | Ana      |  3  |  120  |
   | Luis     |  1  |  200  |
   | Luis     |  2  |  180  |
   +----------+-----+-------+
   ------------------------------------------------------------ */


/* ------------------------------------------------------------
   1) LAG SOLO CON ORDER BY (sin PARTITION BY)
   ------------------------------------------------------------
   Todas las filas se tratan como UNA sola lista larga.

   Resultado:
   +----------+-----+-------+----------------+
   | vendedor | mes | monto | monto_anterior |
   +----------+-----+-------+----------------+
   | Ana      |  1  |  100  | NULL           |
   | Ana      |  2  |  150  | 100            |
   | Ana      |  3  |  120  | 150            |
   | Luis     |  1  |  200  | 120            | <- ERROR: viene de Ana
   | Luis     |  2  |  180  | 200            |
   +----------+-----+-------+----------------+
   ------------------------------------------------------------ */
SELECT vendedor, mes, monto,
       LAG(monto) OVER (
           ORDER BY vendedor, mes
       ) AS monto_anterior
FROM ventas;


/* ------------------------------------------------------------
   2) LAG CON PARTITION BY + ORDER BY (lo correcto)
   ------------------------------------------------------------
   Cada vendedor tiene su propia lista y el conteo se reinicia.

   Resultado:
   +----------+-----+-------+----------------+
   | vendedor | mes | monto | monto_anterior |
   +----------+-----+-------+----------------+
   | Ana      |  1  |  100  | NULL           |
   | Ana      |  2  |  150  | 100            |
   | Ana      |  3  |  120  | 150            |
   | Luis     |  1  |  200  | NULL           | <- correcto: no hay fila previa
   | Luis     |  2  |  180  | 200            |
   +----------+-----+-------+----------------+
   ------------------------------------------------------------ */
SELECT 
	vendedor, mes, monto,
    LAG(monto) OVER (
	    PARTITION BY vendedor 
	    ORDER BY mes
    ) AS monto_anterior
FROM ventas;


/* ------------------------------------------------------------
   3) LEAD (fila siguiente)
   ------------------------------------------------------------
   Igual que LAG pero mirando hacia adelante.

   Resultado:
   +----------+-----+-------+----------------+
   | vendedor | mes | monto | monto_siguiente|
   +----------+-----+-------+----------------+
   | Ana      |  1  |  100  | 150            |
   | Ana      |  2  |  150  | 120            |
   | Ana      |  3  |  120  | NULL           |
   | Luis     |  1  |  200  | 180            |
   | Luis     |  2  |  180  | NULL           |
   +----------+-----+-------+----------------+
   ------------------------------------------------------------ */
SELECT 
	vendedor, mes, monto,
    LEAD(monto) OVER (
    	PARTITION BY vendedor 
    	ORDER BY mes
    ) AS monto_siguiente
FROM ventas;


/* ------------------------------------------------------------
   4) PARAMETROS EXTRA: n y valor_default
   ------------------------------------------------------------
   LAG(monto, 2, 0) -> retrocede 2 filas y devuelve 0 si no existe.

   Resultado:
   +----------+-----+-------+------------------+
   | vendedor | mes | monto | monto_hace_2     |
   +----------+-----+-------+------------------+
   | Ana      |  1  |  100  | 0                |
   | Ana      |  2  |  150  | 0                |
   | Ana      |  3  |  120  | 100              |
   | Luis     |  1  |  200  | 0                |
   | Luis     |  2  |  180  | 0                |
   +----------+-----+-------+------------------+
   ------------------------------------------------------------ */
SELECT 
	vendedor, mes, monto,
     LAG(monto, 2, 0) OVER (
	     PARTITION BY vendedor 
	     ORDER BY mes
     ) AS monto_hace_2
FROM ventas;


/* ------------------------------------------------------------
   5) USO TIPICO: variacion respecto al periodo anterior
   ------------------------------------------------------------
   monto actual - monto anterior

   Resultado:
   +----------+-----+-------+-----------+
   | vendedor | mes | monto | variacion |
   +----------+-----+-------+-----------+
   | Ana      |  1  |  100  | NULL      |
   | Ana      |  2  |  150  |  50       |
   | Ana      |  3  |  120  | -30       |
   | Luis     |  1  |  200  | NULL      |
   | Luis     |  2  |  180  | -20       |
   +----------+-----+-------+-----------+
   ------------------------------------------------------------ */
SELECT 
	vendedor, mes, monto,
    monto - LAG(monto) OVER (
    	PARTITION BY vendedor 
    	ORDER BY mes
    ) AS variacion
FROM ventas;


/* ------------------------------------------------------------
   COMO PENSARLO (resumen)
   ------------------------------------------------------------
   1. PARTITION BY -> separa en grupos independientes (mini tablas)
   2. ORDER BY     -> ordena las filas dentro de cada grupo
   3. LAG / LEAD   -> miran atras / adelante SOLO dentro del grupo

   NOTAS
   - Si el ORDER BY es DESC, LAG y LEAD se "invierten".
   - La primera fila de cada grupo en LAG da NULL (o el default).
   - La ultima fila de cada grupo en LEAD da NULL (o el default).
   ------------------------------------------------------------ */

-- Desafio

/*
Tablas y columnas disponibles:

air_conditioners: id, efficiency, strength, month
Compara la eficiencia de cada acondicionador de aire con la del anterior.

Escribe una consulta que muestre la eficiencia de cada acondicionador de aire junto con la eficiencia del acondicionador de aire anterior instalado (según id). Además, calcula la diferencia de eficiencia entre el acondicionador de aire actual y el anterior. Ordena el resultado por id y efficiency en orden ascendente.

Columnas esperadas de salida:

id
efficiency
previous_efficiency (usando LAG)
efficiency_difference (eficiencia actual - eficiencia anterior)
Finalmente, incluye la consulta en otra consulta y filtra la primera fila, cuyo previous_efficiency (y, por lo tanto, efficiency_difference) está vacía, es decir, es NULL:
*/

WITH CTE_resultado AS(
    SELECT
        id,
        efficiency,
        LAG (efficiency, 1) OVER (ORDER BY id) AS previous_efficiency,
        efficiency - (LAG (efficiency, 1) OVER (ORDER BY id)) AS efficiency_difference
    FROM air_conditioners
    ORDER BY id, efficiency
)
SELECT *
FROM CTE_resultado
WHERE previous_efficiency IS NOT NULL;


/*
Tablas y columnas disponibles:

air_conditioners: id, efficiency, strength, month
Queremos hacer un seguimiento de cómo cambia el rendimiento de los acondicionadores de aire con el tiempo. Tu tarea es encontrar los acondicionadores de aire cuyo rendimiento disminuyó entre meses.

Esto es lo que debes hacer:

Para cada acondicionador de aire en cada mes, calcula su proporción de rendimiento dividiendo la eficiencia promedio entre la resistencia promedio mediante AVG(efficiency)/AVG(strength), agrupando por id y month
Compara el rendimiento del mes actual de cada acondicionador de aire con su rendimiento dos meses después
Encuentra los casos en los que el rendimiento actual sea superior a la mitad del rendimiento futuro (proporción actual ÷ proporción futura > 0.5)
Devuelve el id del acondicionador de aire, el month y la proporción de comparación denominada ratio_two_months para estos casos
*/


WITH rendimiento_mensual AS (
    SELECT
        id,
        month,
        AVG(efficiency) / AVG(strength) AS performance
    FROM air_conditioners
    GROUP BY id, month
),
comparacion AS (
    SELECT
        id,
        month,
        performance / LEAD(performance, 2) OVER (PARTITION BY id ORDER BY month) AS ratio_two_months
    FROM rendimiento_mensual
)
SELECT id, month, ratio_two_months
FROM comparacion
WHERE ratio_two_months > 0.5;







-- BLOQUE 1: SETUP

DROP DATABASE IF EXISTS practica_lead_lag;
CREATE DATABASE practica_lead_lag;
USE practica_lead_lag;

-- ESQUEMA: TIENDAS
CREATE TABLE ingresos_mensuales (
    id_registro INT PRIMARY KEY,
    sucursal VARCHAR(30) NOT NULL,
    mes DATE NOT NULL,
    ingresos DECIMAL(10,2)
);

INSERT INTO ingresos_mensuales (id_registro, sucursal, mes, ingresos) VALUES
(1, 'Centro', '2026-01-01', 5320.00),
(2, 'Norte',  '2026-01-01', 3100.00),
(3, 'Centro', '2026-02-01', 4920.00),
(4, 'Norte',  '2026-02-01', NULL),
(5, 'Centro', '2026-03-01', 4920.00),
(6, 'Norte',  '2026-03-01', 2800.00),
(7, 'Centro', '2026-04-01', 7230.00),
(8, 'Norte',  '2026-04-01', 3500.00);

-- ESQUEMA: RRHH
CREATE TABLE cambios_salario (
    id_cambio INT PRIMARY KEY,
    empleado VARCHAR(40) NOT NULL,
    fecha_cambio DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL
);

INSERT INTO cambios_salario (id_cambio, empleado, fecha_cambio, salario) VALUES
(1, 'Ana',    '2023-01-15', 1000.00),
(2, 'Ana',    '2024-01-15', 1100.00),
(3, 'Bruno',  '2024-03-01',  900.00),
(4, 'Ana',    '2025-01-15', 1100.00),
(5, 'Bruno',  '2025-03-01',  950.00),
(6, 'Carla',  '2025-06-01', 1500.00),
(7, 'Ana',    '2026-01-15', 1250.00),
(8, 'Bruno',  '2026-03-01',  930.00);

-- ESQUEMA: INVENTARIO
CREATE TABLE lecturas_stock (
    id_lectura INT PRIMARY KEY,
    producto VARCHAR(40) NOT NULL,
    fecha_lectura DATE NOT NULL,
    unidades INT
);

INSERT INTO lecturas_stock (id_lectura, producto, fecha_lectura, unidades) VALUES
(1, 'Tornillo', '2026-09-01', 120),
(2, 'Martillo', '2026-09-01',  40),
(3, 'Taladro',  '2026-09-01',  15),
(4, 'Martillo', '2026-09-05', NULL),
(5, 'Tornillo', '2026-09-08',  90),
(6, 'Martillo', '2026-09-12',  35),
(7, 'Tornillo', '2026-09-20', 150),
(8, 'Taladro',  '2026-09-30',  20);

-- ESQUEMA: PAISES
CREATE TABLE paises (
    id_pais INT PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL,
    continente VARCHAR(30) NOT NULL
);

INSERT INTO paises (id_pais, nombre, continente) VALUES
(1, 'Peru',       'America'),
(2, 'Argentina',  'America'),
(3, 'Japon',      'Asia'),
(4, 'Kenia',      'Africa'),
(5, 'Islandia',   'Europa');

CREATE TABLE poblacion_paises (
    id_registro INT PRIMARY KEY,
    id_pais INT NOT NULL,
    anio INT NOT NULL,
    poblacion DECIMAL(6,2) NOT NULL
);

INSERT INTO poblacion_paises (id_registro, id_pais, anio, poblacion) VALUES
(1, 1, 2020,  33.00),
(2, 2, 2000,  37.00),
(3, 3, 2020, 126.10),
(4, 1, 2000,  26.00),
(5, 2, 2020,  45.40),
(6, 3, 2010, 128.10),
(7, 1, 2010,  29.40),
(8, 2, 2010,  41.20);



-- BLOQUE 2: EJERCICIOS

-- EJERCICIOS BASICOS

/* 1. Para cada sucursal, mostrá la sucursal, el mes, los ingresos y los ingresos
   del mes anterior de esa misma sucursal. Ordená por sucursal y mes.
   ingresos_mensuales (id_registro, sucursal, mes, ingresos) */

SELECT
	sucursal, mes, ingresos,
	LAG(ingresos) OVER(
		PARTITION BY sucursal
		ORDER BY mes
	) AS ingreso_mes_anterior
FROM ingresos_mensuales
ORDER BY sucursal, mes;

/* 2. Mostrá el empleado, la fecha del cambio, el salario y la diferencia entre
   ese salario y el del cambio anterior del mismo empleado. El primer registro
   de cada empleado debe quedar con la diferencia en NULL. Ordená por empleado
   y fecha_cambio.
   cambios_salario (id_cambio, empleado, fecha_cambio, salario) */

SELECT
	empleado, fecha_cambio, salario,
	salario - LAG(salario) OVER (
		PARTITION BY empleado 
		ORDER BY fecha_cambio
	) AS diferencia
FROM cambios_salario
ORDER BY empleado, fecha_cambio;


/* 3. Para cada lectura, mostrá el producto, la fecha, las unidades y las unidades
   registradas dos lecturas después del mismo producto. Ordená por producto y fecha.
   lecturas_stock (id_lectura, producto, fecha_lectura, unidades) */

SELECT
	producto, fecha_lectura, unidades,
	LEAD(unidades, 2) OVER(
		PARTITION BY producto
		ORDER BY fecha_lectura
	) AS dos_lecturas_despues
FROM lecturas_stock
ORDER BY producto, fecha_lectura;


-- EJERCICIOS INTERMEDIOS

/* 1. Mostrá la sucursal, el mes y la variación porcentual de los ingresos respecto
   al mes anterior de la misma sucursal (redondeada a 1 decimal), pero solo de los
   registros donde los ingresos cayeron.
   ingresos_mensuales (id_registro, sucursal, mes, ingresos) */

WITH CTE_mes_anterior AS (
SELECT
	sucursal, mes, ingresos,
	LAG(ingresos) OVER (
		PARTITION BY sucursal
		ORDER BY mes
	) AS mes_anterior
FROM ingresos_mensuales
)
SELECT
	sucursal, mes,
	ROUND(((ingresos / mes_anterior) - 1) * 100, 1) AS variacion_prc
FROM CTE_mes_anterior
WHERE ingresos < mes_anterior
ORDER BY sucursal, mes;


/* 2. Listá los empleados que recibieron al menos 2 aumentos, mostrando cuántos
   aumentos tuvo cada uno. Un aumento es un cambio cuyo salario es mayor al del
   cambio inmediatamente anterior del mismo empleado.
   cambios_salario (id_cambio, empleado, fecha_cambio, salario) */


/* 3. Para cada lectura, calculá cuántos días pasan hasta la siguiente lectura del
   mismo producto. Mostrá solo las lecturas en las que ese intervalo supera los
   7 días, con producto, fecha_lectura y dias_hasta_siguiente.
   lecturas_stock (id_lectura, producto, fecha_lectura, unidades) */


/* 4. Mostrá, para cada país (nombre y continente), su medición de población más
   reciente junto con la diferencia de población respecto a su medición anterior.
   paises (id_pais, nombre, continente)
   poblacion_paises (id_registro, id_pais, anio, poblacion) */


-- POR QUE NO FUNCIONA

/* 1. Se quiere mostrar cada cambio de salario junto al salario anterior del empleado,
   dejando afuera el primer registro de cada uno. ¿Por qué falla esta query?
   Explicá el motivo y cómo corregirla.
   cambios_salario (id_cambio, empleado, fecha_cambio, salario) */
SELECT empleado, fecha_cambio, salario,
       LAG(salario) OVER (PARTITION BY empleado ORDER BY fecha_cambio) AS salario_anterior
FROM cambios_salario
WHERE LAG(salario) OVER (PARTITION BY empleado ORDER BY fecha_cambio) IS NOT NULL;
/* razon del error */


/* 2. Se quiere ver cuánto cambiaron las unidades de cada producto respecto a su
   lectura anterior, pero algunos resultados no coinciden con lo esperado (no da
   error). ¿Por qué? Explicá el motivo y cómo corregirla.
   lecturas_stock (id_lectura, producto, fecha_lectura, unidades) */
SELECT producto, fecha_lectura, unidades,
       unidades - LAG(unidades) OVER (ORDER BY fecha_lectura) AS cambio_unidades
FROM lecturas_stock
ORDER BY producto, fecha_lectura;
/* razon del error */


/* 3. Se quiere mostrar los ingresos, los del mes anterior y la variación entre ambos
   para cada sucursal. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   ingresos_mensuales (id_registro, sucursal, mes, ingresos) */
SELECT sucursal, mes, ingresos,
       LAG(ingresos) OVER (PARTITION BY sucursal ORDER BY mes) AS anterior,
       ingresos - anterior AS variacion
FROM ingresos_mensuales;
/* razon del error */


/* 4. Se quiere traer la población de la medición anterior (por año) de cada país,
   pero los valores devueltos no son los esperados (no da error). ¿Por qué?
   Explicá el motivo y cómo corregirla.
   poblacion_paises (id_registro, id_pais, anio, poblacion) */
SELECT id_pais, anio, poblacion,
       LAG(poblacion) OVER (PARTITION BY id_pais) AS poblacion_anterior
FROM poblacion_paises
ORDER BY id_pais, anio;
/* razon del error */












 