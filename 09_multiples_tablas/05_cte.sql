
-- Simplificar consultas, palabra clave WITH

/* Usa WITH query_name AS (...) para crear subconsultas con nombre
   que se puedan reutilizar: */

WITH query1 AS (
    SELECT col5
    FROM table3
    WHERE (col1 AND col3)
       OR col2
),
query2 AS (
    SELECT col1
    FROM table2
    WHERE col3 + col2 > 3
      AND col5 LIKE '%test%'
      AND col6 IN (SELECT col5 FROM query1)
)
SELECT *
FROM table1
WHERE col2 IN (SELECT col1 FROM query2)
  AND col4 IN (SELECT col5 FROM query1);


-- DESAFIO

/* 
Tablas y columnas disponibles:

devices_specs: device_id, width, height, num_features, opinion
devices_score: device_id, score
escribe una consulta que:

Primero identifique los "dispositivos grandes" (dispositivos con width mayor que 200)
Después calcule la puntuación media de estos dispositivos grandes. Denomina esta columna average_score
Usa la cláusula WITH para resolver este problema. */

WITH large_devices AS (
    SELECT device_id
    FROM devices_specs
    WHERE width > 200
)
SELECT AVG(score) AS average_score
FROM devices_score
WHERE device_id IN (SELECT device_id FROM large_devices);


-- DESAFIO 2

/*
 Tablas y columnas disponibles:

devices_specs: device_id, width, height, num_features, opinion
devices_score: device_id, score

La calidad de un dispositivo se mide mediante (width/height)*num_features.

Queremos encontrar todos los dispositivos sobrevalorados. Obtén todos los dispositivos donde la opinion del dispositivo sea mayor que la calidad promedio y el score del dispositivo sea menor que la calidad promedio. Devuelve solo el device_id.

Para resolverlo, utiliza la cláusula WITH para crear una subconsulta que calcule la calidad promedio y reutilízala en la consulta principal.*/

-- Paso 1: nombra un conjunto de resultados temporal que contenga un solo valor promedio
WITH avg_quality AS (
    SELECT AVG((width/height)*num_features) AS avg_q
    FROM devices_specs
)
-- Paso 2: une las dos tablas de dispositivos, luego adjunta el conjunto de resultados temporal
SELECT dsp.device_id
FROM devices_specs dsp
INNER JOIN devices_score dsc ON dsp.device_id = dsc.device_id
INNER JOIN avg_quality aq
-- Paso 3: mantén los dispositivos que se sitúan en lados opuestos de ese promedio
WHERE dsp.opinion > aq.avg_q AND dsc.score < aq.avg_q;


-- BLOQUE 1: SETUP

DROP DATABASE IF EXISTS practica_CTE;
CREATE DATABASE practica_CTE;
USE practica_CTE;

-- ESQUEMA: BIBLIOTECAS
CREATE TABLE libros (
    id_libro INT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    genero VARCHAR(30) NOT NULL,
    paginas INT,
    anio_publicacion INT
);

INSERT INTO libros (id_libro, titulo, genero, paginas, anio_publicacion) VALUES
(1, 'Cien anios de soledad', 'Novela', 471, 1967),
(2, 'El Aleph', 'Cuento', 180, 1949),
(3, 'Rayuela', 'Novela', 635, 1963),
(4, 'Ficciones', 'Cuento', 174, 1944),
(5, 'Sapiens', 'Ensayo', 498, 2011),
(6, 'La sombra del viento', 'Novela', 400, 2001),
(7, 'Manual sin paginar', 'Ensayo', NULL, 2015);

CREATE TABLE prestamos (
    id_prestamo INT PRIMARY KEY,
    id_libro INT NOT NULL,
    id_socio INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE
);

INSERT INTO prestamos (id_prestamo, id_libro, id_socio, fecha_prestamo, fecha_devolucion) VALUES
(1, 1, 101, '2026-08-01', '2026-08-10'),
(2, 3, 102, '2026-08-05', '2026-08-19'),
(3, 5, 101, '2026-08-10', '2026-09-02'),
(4, 2, 103, '2026-08-15', NULL),
(5, 3, 104, '2026-09-01', '2026-09-30'),
(6, 6, 102, '2026-09-05', '2026-09-20'),
(7, 1, 105, '2026-09-10', '2026-09-12'),
(8, 5, 103, '2026-09-15', '2026-09-29');

-- ESQUEMA: RRHH
CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    area VARCHAR(30) NOT NULL,
    salario DECIMAL(10,2),
    fecha_ingreso DATE NOT NULL,
    id_jefe INT
);

INSERT INTO empleados (id_empleado, nombre, area, salario, fecha_ingreso, id_jefe) VALUES
(1, 'Marta Gomez', 'Direccion', 5200.00, '2015-03-01', NULL),
(2, 'Luis Perez', 'Sistemas', 3800.00, '2018-06-15', 1),
(3, 'Ana Torres', 'Sistemas', 4100.00, '2021-02-01', 2),
(4, 'Carlos Ruiz', 'Ventas', 2900.00, '2019-11-20', 1),
(5, 'Sofia Diaz', 'Ventas', 2900.00, '2022-05-10', 4),
(6, 'Pablo Lima', 'Sistemas', NULL, '2020-01-01', 2),
(7, 'Elena Vega', 'Ventas', 3300.00, '2017-09-30', 4),
(8, 'Jorge Sanz', 'Sistemas', 3500.00, '2019-12-31', 2);

-- ESQUEMA: INVENTARIO
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    categoria VARCHAR(30) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);

INSERT INTO productos (id_producto, nombre, categoria, precio, stock) VALUES
(1, 'Teclado mecanico', 'Perifericos', 85.00, 30),
(2, 'Mouse inalambrico', 'Perifericos', 25.50, 8),
(3, 'Monitor 24 pulgadas', 'Pantallas', 180.00, 5),
(4, 'Cable HDMI', 'Cables', 9.90, 120),
(5, 'Webcam HD', 'Perifericos', 45.00, 9),
(6, 'Hub USB', 'Cables', 22.00, 10),
(7, 'Soporte notebook', 'Accesorios', 30.00, 0);

CREATE TABLE movimientos (
    id_movimiento INT PRIMARY KEY,
    id_producto INT NOT NULL,
    tipo VARCHAR(10) NOT NULL,
    cantidad INT NOT NULL,
    fecha_movimiento DATE NOT NULL
);

INSERT INTO movimientos (id_movimiento, id_producto, tipo, cantidad, fecha_movimiento) VALUES
(1, 1, 'SALIDA', 10, '2026-09-01'),
(2, 1, 'SALIDA', 6, '2026-09-10'),
(3, 2, 'SALIDA', 15, '2026-09-03'),
(4, 3, 'SALIDA', 4, '2026-09-05'),
(5, 4, 'SALIDA', 20, '2026-09-07'),
(6, 4, 'ENTRADA', 100, '2026-09-08'),
(7, 5, 'ENTRADA', 30, '2026-09-12'),
(8, 6, 'SALIDA', 8, '2026-09-15');

-- ESQUEMA: PAISES
CREATE TABLE paises (
    id_pais INT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    continente VARCHAR(30) NOT NULL,
    poblacion BIGINT NOT NULL,
    pib DECIMAL(12,2)
);

INSERT INTO paises (id_pais, nombre, continente, poblacion, pib) VALUES
(1, 'Argentina', 'America del Sur', 46000000, 640.00),
(2, 'Brasil', 'America del Sur', 215000000, 1920.00),
(3, 'Chile', 'America del Sur', 19500000, 300.00),
(4, 'Japon', 'Asia', 125000000, 4200.00),
(5, 'India', 'Asia', 1400000000, 3400.00),
(6, 'Nigeria', 'Africa', 218000000, NULL),
(7, 'Alemania', 'Europa', 83000000, 4100.00),
(8, 'Uruguay', 'America del Sur', 3500000, 70.00);

CREATE TABLE ciudades (
    id_ciudad INT PRIMARY KEY,
    id_pais INT NOT NULL,
    nombre VARCHAR(60) NOT NULL,
    habitantes INT
);

INSERT INTO ciudades (id_ciudad, id_pais, nombre, habitantes) VALUES
(1, 1, 'Buenos Aires', 3100000),
(2, 1, 'Cordoba', 1500000),
(3, 2, 'Sao Paulo', 12300000),
(4, 4, 'Tokio', 13900000),
(5, 5, 'Bombay', 12400000),
(6, 7, 'Berlin', 3700000),
(7, 3, 'Santiago', 6200000),
(8, 6, 'Lagos', 15000000);



-- BLOQUE 2: EJERCICIOS

-- EJERCICIOS BASICOS

/* 1. Usá WITH para definir un conjunto llamado libros_largos con los libros de más de 400 páginas.
      Después, desde ese conjunto, devolvé el título y el género de cada uno.
      libros (id_libro, titulo, genero, paginas, anio_publicacion) */

WITH libros_largos AS (
	SELECT *
	FROM libros
	WHERE paginas > 400
)
SELECT titulo, genero
FROM libros_largos;

/* 2. Usá dos CTE encadenadas. La primera, area_sistemas, con los empleados del área 'Sistemas'.
      La segunda, sistemas_antiguos, tomada de la primera (no de la tabla original), con los que
      ingresaron antes del 2020-01-01. Devolvé el nombre y el salario de los que quedaron.
      empleados (id_empleado, nombre, area, salario, fecha_ingreso, id_jefe) */

WITH area_sistemas AS (
	SELECT *
	FROM empleados 
	WHERE area = 'Sistemas'
),
sistemas_antiguos AS (
	SELECT *
	FROM area_sistemas 
	WHERE fecha_ingreso < '2020-01-01'
)
SELECT nombre, salario
FROM sistemas_antiguos;


/* 3. Usá WITH para definir paises_ricos, con los países cuyo pib sea mayor a 1000.
      Luego devolvé el nombre y los habitantes de las ciudades que pertenecen a esos países.
      paises (id_pais, nombre, continente, poblacion, pib)
      ciudades (id_ciudad, id_pais, nombre, habitantes) */

WITH paises_ricos AS (
	SELECT *
	FROM paises
	WHERE pib > 1000
)
SELECT ci.nombre, ci.habitantes
FROM ciudades AS ci
JOIN paises_ricos AS pa
	ON ci.id_pais = pa.id_pais;


-- EJERCICIOS INTERMEDIOS

/* 1. Con una CTE llamada salidas_por_producto, calculá el total de unidades de los movimientos
      de tipo 'SALIDA' de cada producto. Luego mostrá el nombre del producto y ese total
      (como total_salidas) solo para los productos con más de 15 unidades, del mayor al menor.
      productos (id_producto, nombre, categoria, precio, stock)
      movimientos (id_movimiento, id_producto, tipo, cantidad, fecha_movimiento) */

WITH salidas_por_producto AS (
	SELECT id_producto, SUM(cantidad) AS total_salidas
	FROM movimientos 
	WHERE tipo = 'SALIDA'
	GROUP BY id_producto
)
SELECT p.nombre, total_salidas
FROM productos AS p
JOIN salidas_por_producto AS spp
	ON spp.id_producto = p.id_producto
WHERE total_salidas > 15
ORDER BY total_salidas DESC;


WITH salidas_por_producto AS (
	SELECT id_producto, SUM(cantidad) AS total_salidas
	FROM movimientos
	WHERE tipo = 'SALIDA'
	GROUP BY id_producto
	HAVING SUM(cantidad) > 15
)
SELECT p.nombre, spp.total_salidas
FROM productos AS p
JOIN salidas_por_producto AS spp
	ON spp.id_producto = p.id_producto
ORDER BY spp.total_salidas DESC;



/* 2. Con una CTE que calcule el pib promedio de todos los países (columna pib_prom), devolvé el
      nombre, el pib y la diferencia entre el pib y el promedio, redondeada a 1 decimal
      (columna diferencia), solo de los países que superan el promedio. Ordená de mayor a
      menor diferencia.
      paises (id_pais, nombre, continente, poblacion, pib) */

WITH promedio AS(
	SELECT AVG(pib) AS pib_prom
	FROM paises
)
SELECT nombre, pib, ROUND(pib - pib_prom, 1) AS diferencia
FROM paises
JOIN promedio
WHERE pib > pib_prom
ORDER BY diferencia DESC;

/* 3. Con una CTE llamada prestamos_largos, calculá los días que duró cada préstamo ya devuelto
      (usando TO_DAYS) y quedate solo con los que duraron más de 14 días. Luego mostrá el título
      del libro, el id_socio y los días, del préstamo más largo al más corto.
      libros (id_libro, titulo, genero, paginas, anio_publicacion)
      prestamos (id_prestamo, id_libro, id_socio, fecha_prestamo, fecha_devolucion) */

WITH prestamos_largos AS (
	SELECT id_libro,
		   id_socio,
		   TO_DAYS(fecha_devolucion) - TO_DAYS(fecha_prestamo) AS dias_prestamo
	FROM prestamos
	WHERE fecha_devolucion IS NOT NULL
	HAVING dias_prestamo > 14
)
SELECT titulo, id_socio, dias_prestamo
FROM libros AS li
JOIN prestamos_largos AS pl
	ON li.id_libro = pl.id_libro
ORDER BY dias_prestamo DESC;

/* 4. Con una CTE llamada empleado_jefe, relacioná a cada empleado con su jefe (autounión) y
      traé el nombre y el salario de ambos. Luego devolvé el nombre del empleado y el nombre
      de su jefe, solo de los empleados que ganan más que su jefe.
      empleados (id_empleado, nombre, area, salario, fecha_ingreso, id_jefe) */

WITH empleado_jefe AS (
	SELECT e1.nombre AS empleado, e1.salario AS salario_empleado,
		   e2.nombre AS jefe, e2.salario AS salario_jefe
	FROM empleados AS e1
	JOIN empleados AS e2
		ON e1.id_jefe = e2.id_empleado
)
SELECT empleado, jefe
FROM empleado_jefe
WHERE salario_empleado > salario_jefe;



-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
      productos (id_producto, nombre, categoria, precio, stock) */
WITH stock_bajo AS (
    SELECT id_producto, nombre
    FROM productos
    WHERE stock < 10
)
SELECT COUNT(*) AS cantidad
FROM stock_bajo;

SELECT nombre
FROM stock_bajo
ORDER BY nombre;
/* razon del error 
   Esta query falla porque las CTE no se guardan en memoria, el segundo SELECT es una query independiente y no arrastra los resultados de la CTE. solucion: generar otra CTE (o copiar) para la nueva consulta*/
WITH stock_bajo AS (
    SELECT id_producto, nombre
    FROM productos
    WHERE stock < 10
)
SELECT nombre
FROM stock_bajo
ORDER BY nombre;


/* 2. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
      empleados (id_empleado, nombre, area, salario, fecha_ingreso, id_jefe) */
WITH bien_pagados AS (
    SELECT id_empleado, nombre, salario
    FROM ventas_empleados
    WHERE salario > 3000
),
ventas_empleados AS (
    SELECT id_empleado, nombre, salario
    FROM empleados
    WHERE area = 'Ventas'
)
SELECT nombre
FROM bien_pagados;
/* razon del error 
   La primera CTE arrastra un FROM ventas_empleados que aun no existe, solucion cambiar el orden de las CTE:*/
WITH ventas_empleados AS (
    SELECT id_empleado, nombre, salario
    FROM empleados
    WHERE area = 'Ventas'
),
bien_pagados AS (
    SELECT id_empleado, nombre, salario
    FROM ventas_empleados
    WHERE salario > 3000
)
SELECT nombre
FROM bien_pagados;


/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
      paises (id_pais, nombre, continente, poblacion, pib) */
WITH promedio AS (
    SELECT AVG(pib) AS pib_prom
    FROM paises
)
SELECT nombre, pib
FROM paises
WHERE pib > promedio;
/* razon del error 
   la CTE existe pero no se llama en la consulta, en la comparacion WHERE no se detecta que es promedio, ademas promedio es la CTE (tabla temporal) y no una columna a comparar*/

WITH promedio AS (
    SELECT AVG(pib) AS pib_prom
    FROM paises
)
SELECT nombre, pib
FROM paises
JOIN promedio
WHERE pib > pib_prom;







