
-- UNION

/* UNION combina tablas apilandolas verticalmente. A diferencia de las uniones, las uniones no usan condiciones: simplemente se añaden unas tablas encima de otras. 
Sintaxis basica de UNION: */

SELECT col1, col2, ... FROM table1
UNION
SELECT col1, col2, ... FROM table2;

/*
Reglas de UNION:
    - El numero de campos debe ser igual
    - El orden es importante
    - Las columnas en la misma posicion deben tener tipos de datos coincidentes

UNION frente a UNION ALL
    - UNION devuelve solo valores distintos
    - UNION ALL devuelve todos los registros, incluidos los duplicados. */

SELECT name FROM germany_people
UNION
SELECT name FROM england_people;

SELECT name FROM germany_people
UNION ALL
SELECT name FROM england_people;


/* Puedes usar UNION ALL dentro de una subconsulta y despues aplicar GROUP BY, ORDER BY y funciones de agregacion al resultado combinado.*/

SELECT name, COUNT(*) AS total
FROM (
    SELECT name FROM germany_people
    UNION ALL
    SELECT name FROM england_people
) AS all_people
GROUP BY name
ORDER BY total DESC;

/* Esto cuenta cuantas veces aparece cada nombre en ambas tablas, incluidos los duplicados*/


-- DESAFIO

/*
Tablas y columnas disponibles:

sales_2009: product_id, quantity_sold
sales_2010: product_id, quantity_sold
sales_2011: product_id, quantity_sold

Hay 3 tablas de ventas.

    - Encuentra la suma de las ventas de cada producto de todas las tablas en conjunto.
    - El resultado debe incluir el product_id y las ventas totales.
    - Asigna a esta columna el nombre total_sales.
    - Ordena los resultados por las ventas totales en orden descendente. */


SELECT product_id, SUM(quantity_sold) AS total_sales
FROM (
    SELECT product_id, quantity_sold FROM sales_2009
    UNION ALL
    SELECT product_id, quantity_sold FROM sales_2010
    UNION ALL
    SELECT product_id, quantity_sold FROM sales_2011
) AS ventas
GROUP BY product_id
ORDER BY total_sales DESC;




-- BLOQUE 1: SETUP

DROP DATABASE IF EXISTS practica_union;
CREATE DATABASE practica_union;
USE practica_union;

-- ESQUEMA: VENTAS
CREATE TABLE ventas_web (
    id_venta INT PRIMARY KEY,
    cliente VARCHAR(50),
    categoria VARCHAR(30),
    total DECIMAL(10,2),
    fecha_venta DATE
);

INSERT INTO ventas_web (id_venta, cliente, categoria, total, fecha_venta) VALUES
(1, 'Lucía Gómez', 'Electrónica', 1500.00, '2026-02-28'),
(2, 'Marcos Díaz', 'Hogar', 320.50, '2026-03-01'),
(3, 'Lucía Gómez', 'Hogar', 89.99, '2026-03-15'),
(4, 'Tomás Ruiz', 'Deportes', 450.00, '2026-03-31'),
(5, 'Ana Pérez', NULL, 210.00, '2026-04-01'),
(6, 'Marcos Díaz', 'Electrónica', 999.90, '2026-03-20'),
(7, 'Tomás Ruiz', 'Hogar', 450.00, '2026-03-10');

CREATE TABLE ventas_local (
    id_venta INT PRIMARY KEY,
    cliente VARCHAR(50),
    categoria VARCHAR(30),
    total DECIMAL(10,2),
    fecha_venta DATE
);

INSERT INTO ventas_local (id_venta, cliente, categoria, total, fecha_venta) VALUES
(1, 'Ana Pérez', 'Hogar', 150.00, '2026-03-05'),
(2, 'Lucía Gómez', 'Deportes', 450.00, '2026-03-31'),
(3, 'Julián Soto', 'Electrónica', 1200.00, '2026-02-15'),
(4, 'Marcos Díaz', 'Hogar', 320.50, '2026-03-01'),
(5, 'Julián Soto', 'Hogar', 75.25, '2026-03-22'),
(6, 'Tomás Ruiz', 'Deportes', NULL, '2026-03-18');

-- ESQUEMA: RRHH
CREATE TABLE empleados_actuales (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50),
    area VARCHAR(30),
    salario DECIMAL(10,2),
    fecha_ingreso DATE
);

INSERT INTO empleados_actuales (id_empleado, nombre, area, salario, fecha_ingreso) VALUES
(1, 'Carla Mendez', 'Ventas', 850000.00, '2021-04-12'),
(2, 'Jorge Silva', 'Soporte', 620000.00, '2022-08-01'),
(3, 'Lorena Paz', 'Ventas', NULL, '2024-01-15'),
(4, 'Martín Vega', 'Sistemas', 1100000.00, '2019-11-30'),
(5, 'Ana Ríos', 'Soporte', 620000.00, '2023-05-20'),
(6, 'Pablo Núñez', 'Sistemas', 980000.00, '2020-02-10'),
(7, 'Sara Lima', 'Ventas', 900000.00, '2025-03-03');

CREATE TABLE empleados_ex (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50),
    area VARCHAR(30),
    salario DECIMAL(10,2),
    fecha_ingreso DATE
);

INSERT INTO empleados_ex (id_empleado, nombre, area, salario, fecha_ingreso) VALUES
(1, 'Jorge Silva', 'Soporte', 580000.00, '2018-06-01'),
(2, 'Carla Mendez', 'Ventas', 850000.00, '2021-04-12'),
(3, 'Ricardo Fox', 'Sistemas', 1000000.00, '2017-09-09'),
(4, 'Lorena Paz', 'Ventas', 700000.00, '2016-01-10'),
(5, 'Elena Cruz', 'Marketing', NULL, '2019-07-07'),
(6, 'Hugo Barrios', 'Soporte', 540000.00, '2020-10-19');

-- ESQUEMA: INVENTARIO
CREATE TABLE almacen_norte (
    id_producto INT PRIMARY KEY,
    producto VARCHAR(50),
    categoria VARCHAR(30),
    stock INT,
    precio_unitario DECIMAL(10,2)
);

INSERT INTO almacen_norte (id_producto, producto, categoria, stock, precio_unitario) VALUES
(1, 'Teclado', 'Periféricos', 40, 15000.00),
(2, 'Mouse', 'Periféricos', 55, 8000.00),
(3, 'Monitor 24"', 'Pantallas', 12, 120000.00),
(4, 'Cable HDMI', 'Cables', 80, 3500.00),
(5, 'Webcam', 'Periféricos', NULL, 22000.00);

CREATE TABLE almacen_sur (
    id_producto INT PRIMARY KEY,
    producto VARCHAR(50),
    categoria VARCHAR(30),
    stock INT,
    precio_unitario DECIMAL(10,2)
);

INSERT INTO almacen_sur (id_producto, producto, categoria, stock, precio_unitario) VALUES
(1, 'Teclado', 'Periféricos', 30, 15000.00),
(2, 'Monitor 27"', 'Pantallas', 8, 180000.00),
(3, 'Cable HDMI', 'Cables', 60, 3500.00),
(4, 'Auriculares', 'Audio', 25, 18000.00),
(5, 'Mouse', 'Periféricos', 20, 8000.00),
(6, 'Parlante', 'Audio', 15, 25000.00);

CREATE TABLE almacen_este (
    id_producto INT PRIMARY KEY,
    producto VARCHAR(50),
    categoria VARCHAR(30),
    stock INT,
    precio_unitario DECIMAL(10,2)
);

INSERT INTO almacen_este (id_producto, producto, categoria, stock, precio_unitario) VALUES
(1, 'Cable USB-C', 'Cables', 70, 2800.00),
(2, 'Monitor 24"', 'Pantallas', 10, 120000.00),
(3, 'Auriculares', 'Audio', 30, 18000.00),
(4, 'Teclado', 'Periféricos', 30, 15000.00);

-- ESQUEMA: PAISES
CREATE TABLE paises_europa (
    id_pais INT PRIMARY KEY,
    nombre VARCHAR(50),
    poblacion_millones DECIMAL(6,1),
    idioma_oficial VARCHAR(30)
);

INSERT INTO paises_europa (id_pais, nombre, poblacion_millones, idioma_oficial) VALUES
(1, 'Francia', 68.2, 'Francés'),
(2, 'Alemania', 84.5, 'Alemán'),
(3, 'Turquía', 85.3, 'Turco'),
(4, 'Rusia', 144.0, 'Ruso'),
(5, 'Georgia', 3.7, 'Georgiano'),
(6, 'Mónaco', NULL, 'Francés');

CREATE TABLE paises_asia (
    id_pais INT PRIMARY KEY,
    nombre VARCHAR(50),
    poblacion_millones DECIMAL(6,1),
    idioma_oficial VARCHAR(30)
);

INSERT INTO paises_asia (id_pais, nombre, poblacion_millones, idioma_oficial) VALUES
(1, 'Japón', 123.9, 'Japonés'),
(2, 'Turquía', 85.3, 'Turco'),
(3, 'Rusia', 144.0, 'Ruso'),
(4, 'Georgia', 3.8, 'Georgiano'),
(5, 'India', 1428.6, 'Hindi'),
(6, 'Tailandia', 71.8, 'Tailandés');



-- BLOQUE 2: EJERCICIOS

-- EJERCICIOS BASICOS

/* 1. Obtené una lista de todos los clientes que hicieron compras, ya sea
      por el canal web o en el local, sin que ningún cliente aparezca repetido.
      ventas_web (id_venta, cliente, categoria, total, fecha_venta)
      ventas_local (id_venta, cliente, categoria, total, fecha_venta) */

SELECT cliente FROM ventas_web
UNION
SELECT cliente FROM ventas_local;

/* 2. Obtené el nombre y el área de todos los empleados actuales y de todos
      los ex empleados, conservando todas las filas aunque haya repeticiones.
      empleados_actuales (id_empleado, nombre, area, salario, fecha_ingreso)
      empleados_ex (id_empleado, nombre, area, salario, fecha_ingreso) */

SELECT nombre, area FROM empleados_actuales
UNION ALL
SELECT nombre, area FROM empleados_ex;

/* 3. Obtené el nombre y la población (en millones) de los países de ambas
      tablas, sin que se repitan filas idénticas.
      paises_europa (id_pais, nombre, poblacion_millones, idioma_oficial)
      paises_asia (id_pais, nombre, poblacion_millones, idioma_oficial) */

SELECT nombre, poblacion_millones FROM paises_europa
UNION
SELECT nombre, poblacion_millones FROM paises_asia;

-- EJERCICIOS INTERMEDIOS

/* 1. Listá el id_venta, el cliente y el total de todas las ventas (web y
      local) realizadas entre el 2026-03-01 y el 2026-03-31, conservando
      todas las filas. Ordená el resultado por total de mayor a menor.
      ventas_web (id_venta, cliente, categoria, total, fecha_venta)
      ventas_local (id_venta, cliente, categoria, total, fecha_venta) */

SELECT id_venta, cliente, total
FROM ventas_web 
WHERE fecha_venta BETWEEN '2026-03-01' AND '2026-03-31'
UNION ALL
SELECT id_venta, cliente, total
FROM ventas_local
WHERE fecha_venta BETWEEN '2026-03-01' AND '2026-03-31'
ORDER BY total DESC;


SELECT id_venta, cliente, total
FROM (
	 SELECT id_venta, cliente, total, fecha_venta FROM ventas_web 
	 UNION ALL
	 SELECT id_venta, cliente, total, fecha_venta FROM ventas_local 
) AS ventas_todo
WHERE fecha_venta BETWEEN '2026-03-01' AND '2026-03-31'
ORDER BY total DESC;


/* 2. Calculá el stock total por categoría sumando los tres almacenes, y
      mostrá solo las categorías con más de 70 unidades en total. Ordená
      de mayor a menor stock total.
      almacen_norte (id_producto, producto, categoria, stock, precio_unitario)
      almacen_sur (id_producto, producto, categoria, stock, precio_unitario)
      almacen_este (id_producto, producto, categoria, stock, precio_unitario) */

SELECT categoria, SUM(stock) AS stock_total
FROM (
	 SELECT categoria, stock FROM almacen_norte
	 UNION ALL
	 SELECT categoria, stock FROM almacen_sur
	 UNION ALL
	 SELECT categoria, stock FROM almacen_este
) AS almacen_todo
GROUP BY categoria
HAVING stock_total > 70
ORDER BY stock_total DESC;


/* 3. Listá el nombre, el área y una columna llamada situacion (con el
      valor 'Actual' o 'Ex' según corresponda) de las personas de las áreas
      Ventas o Soporte que tengan salario cargado (no nulo), combinando
      empleados actuales y ex empleados.
      empleados_actuales (id_empleado, nombre, area, salario, fecha_ingreso)
      empleados_ex (id_empleado, nombre, area, salario, fecha_ingreso) */

SELECT nombre, area, situacion
FROM (
	 SELECT nombre, area, salario, 'Actual' AS situacion FROM empleados_actuales
	 UNION ALL
	 SELECT nombre, area, salario, 'Ex' AS situacion FROM empleados_ex
) AS empleados_todo
WHERE area IN ('Ventas','Soporte')
	  AND salario IS NOT NULL;

/* 4. Listá, sin repetir filas, el nombre y la población de los países de
      ambas tablas cuya población supere el promedio de población de los
      países de paises_europa. Ordená alfabéticamente por nombre.
      paises_europa (id_pais, nombre, poblacion_millones, idioma_oficial)
      paises_asia (id_pais, nombre, poblacion_millones, idioma_oficial) */

SELECT nombre, poblacion_millones
FROM (
	 SELECT nombre, poblacion_millones FROM paises_europa
	 UNION
	 SELECT nombre, poblacion_millones FROM paises_asia
) AS paises_todo
WHERE poblacion_millones > (SELECT AVG(poblacion_millones) FROM paises_europa)
ORDER BY nombre;


-- POR QUE NO FUNCIONA

/* 1. Se quiere un listado con id_producto, producto y stock de los
      almacenes norte y sur, sin perder ninguna fila. La query no devuelve
      lo esperado. ¿Por qué? Explicá el motivo y cómo corregirla.
      almacen_norte (id_producto, producto, categoria, stock, precio_unitario)
      almacen_sur (id_producto, producto, categoria, stock, precio_unitario) */
SELECT id_producto, producto, stock FROM almacen_norte
UNION ALL
SELECT id_producto, stock, producto FROM almacen_sur;
/* razon del error:
   Una regla basica de UNION es que el orden de los campos debe coincidir
   Solucion: */
SELECT id_producto, producto, stock FROM almacen_norte
UNION ALL
SELECT id_producto, producto, stock FROM almacen_sur;


/* 2. Se quiere saber cuántas compras hizo cada cliente entre ambos
      canales en total. ¿Por qué el resultado no es el esperado? Explicá el
      motivo y cómo corregirla.
      ventas_web (id_venta, cliente, categoria, total, fecha_venta)
      ventas_local (id_venta, cliente, categoria, total, fecha_venta) */
SELECT cliente, COUNT(*) AS compras
FROM (
    SELECT cliente FROM ventas_web
    UNION
    SELECT cliente FROM ventas_local
) AS todas
GROUP BY cliente;
/* razon del error 
   La UNION y agrupado por cliente solo muestra la cantidad de clientes distintos entre ambas tablas, si queremos conservar cada registro debemos usar UNION ALL
   Solucion:*/
SELECT cliente, COUNT(*) AS compras
FROM (
     SELECT cliente FROM ventas_web
     UNION ALL
     SELECT cliente FROM ventas_local
) AS todas
GROUP BY cliente;


/* 3. Se quiere ver los países de ambas tablas ordenados por población de
      mayor a menor. ¿Por qué falla esta query? Explicá el motivo y cómo
      corregirla.
      paises_europa (id_pais, nombre, poblacion_millones, idioma_oficial)
      paises_asia (id_pais, nombre, poblacion_millones, idioma_oficial) */
SELECT nombre, poblacion_millones FROM paises_europa
ORDER BY poblacion_millones DESC
UNION
SELECT nombre, poblacion_millones FROM paises_asia;
/* razon del error 
   Falla en el orden logico, ORDER BY va despues de la UNION
   Solucion:*/
SELECT nombre, poblacion_millones FROM paises_europa
UNION
SELECT nombre, poblacion_millones FROM paises_asia
ORDER BY poblacion_millones DESC;


/* 4. Se quiere el nombre y el salario de todas las personas del área
      Ventas, tanto actuales como ex empleados. ¿Por qué el resultado no es
      el esperado? Explicá el motivo y cómo corregirla.
      empleados_actuales (id_empleado, nombre, area, salario, fecha_ingreso)
      empleados_ex (id_empleado, nombre, area, salario, fecha_ingreso) */
SELECT nombre, salario FROM empleados_actuales
UNION
SELECT nombre, salario FROM empleados_ex
WHERE area = 'Ventas';
/* razon del error 
   EL WHERE solo afecta al segundo SELECT, se debe repetir en cada lado, ademas debe mostrar TODOS los datos asi que utilizamos UNION ALL
   Solucion:*/
SELECT nombre, salario FROM empleados_actuales
WHERE area = 'Ventas'
UNION ALL
SELECT nombre, salario FROM empleados_ex
WHERE area = 'Ventas';
