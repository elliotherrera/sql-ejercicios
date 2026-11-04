
-- Criterio ORDER BY

/* Una de las opciones de OVER() es ORDER BY Por ejemplo: */

ROW_NUMBER() OVER(
	ORDER BY YEAR DESC
) AS row_num

/* Esto generara una columna que numerara las filas siguiendo el orden descendente de los años*/

-- DESAFIO

/*
Tablas y columnas disponibles:

plants: id, hue, rough

Selecciona todas las plantas con un hue mayor que 0.34 y añade dos columnas de numeración:

row_num_hue que numerará las filas según hue en orden ascendente

row_num_score que numerará las filas mediante la siguiente fórmula: rough*hue en orden descendente

Devuelve solo id y las dos columnas de numeración. Ordena el resultado por el id de la planta en orden ascendente */

SELECT id,
       ROW_NUMBER() OVER(
           ORDER BY hue
       ) AS row_num_hue,
       ROW_NUMBER() OVER(
           ORDER BY (rough*hue) DESC
       ) AS row_num_score
FROM plants
WHERE hue > 0.34
ORDER BY id;




-- SETUP

DROP DATABASE IF EXISTS practica_wf_order;
CREATE DATABASE practica_wf_order;
USE practica_wf_order;

-- ESQUEMA: TIENDA
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    ciudad VARCHAR(40) NOT NULL
);

INSERT INTO clientes (id_cliente, nombre, ciudad) VALUES
(1, 'Lucía Fernández', 'Rosario'),
(2, 'Martín Gómez', 'Córdoba'),
(3, 'Sofía Ibarra', 'Buenos Aires'),
(4, 'Tomás Peralta', 'Rosario'),
(5, 'Valeria Ocampo', 'Mendoza'),
(6, 'Julián Ríos', 'Córdoba');

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    fecha_pedido DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

INSERT INTO pedidos (id_pedido, id_cliente, total, fecha_pedido) VALUES
(1, 1, 3200.00, '2026-02-28'),
(2, 1, 1800.00, '2026-03-01'),
(3, 2, 2500.00, '2026-03-15'),
(4, 2, 2600.50, '2026-03-31'),
(5, 3, 4000.00, '2026-04-01'),
(6, 3, 3500.00, '2026-03-10'),
(7, 3, 1200.00, '2026-03-31'),
(8, 4, 1200.00, '2026-03-20');

-- ESQUEMA: RRHH
CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    area VARCHAR(40) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    id_jefe INT NULL,
    fecha_ingreso DATE NOT NULL,
    FOREIGN KEY (id_jefe) REFERENCES empleados(id_empleado)
);

INSERT INTO empleados (id_empleado, nombre, area, salario, id_jefe, fecha_ingreso) VALUES
(1, 'Carolina Vega', 'Gerencia', 950000.00, NULL, '2018-05-14'),
(2, 'Ramiro Soto', 'Ventas', 620000.00, 1, '2020-03-02'),
(3, 'Paula Medina', 'Ventas', 580000.00, 2, '2021-07-19'),
(4, 'Esteban Cruz', 'Sistemas', 700000.00, 1, '2019-11-25'),
(5, 'Nadia Lopez', 'Sistemas', 720000.00, 4, '2022-01-10'),
(6, 'Hugo Barrios', 'Administracion', 450000.00, 1, '2020-03-02'),
(7, 'Irene Salas', 'Administracion', 480000.00, 6, '2023-06-05'),
(8, 'Mateo Quiroga', 'Sistemas', 720000.00, 4, '2024-02-12');

-- ESQUEMA: INVENTARIO
CREATE TABLE stock_norte (
    id_producto INT PRIMARY KEY,
    producto VARCHAR(60) NOT NULL,
    cantidad INT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL
);

INSERT INTO stock_norte (id_producto, producto, cantidad, precio_unitario) VALUES
(1, 'Taladro inalambrico', 15, 85000.00),
(2, 'Martillo carpintero', NULL, 12000.00),
(3, 'Destornillador set', 40, 9500.00),
(4, 'Sierra circular', 8, 120000.00),
(5, 'Cinta metrica', 25, 3500.00),
(6, 'Nivel laser', 5, 120000.00);

CREATE TABLE stock_sur (
    id_producto INT PRIMARY KEY,
    producto VARCHAR(60) NOT NULL,
    cantidad INT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL
);

INSERT INTO stock_sur (id_producto, producto, cantidad, precio_unitario) VALUES
(1, 'Martillo carpintero', 22, 12000.00),
(2, 'Taladro inalambrico', 10, 85000.00),
(3, 'Lijadora orbital', 12, 65000.00),
(4, 'Pinza universal', 30, 9500.00),
(5, 'Nivel laser', 7, 120000.00);

-- ESQUEMA: PAISES
CREATE TABLE paises (
    id_pais INT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    continente VARCHAR(30) NOT NULL,
    poblacion BIGINT NOT NULL,
    superficie INT NOT NULL
);

INSERT INTO paises (id_pais, nombre, continente, poblacion, superficie) VALUES
(1, 'Argentina', 'America', 46000000, 2780400),
(2, 'Brasil', 'America', 215000000, 8515767),
(3, 'Chile', 'America', 19500000, 756102),
(4, 'Uruguay', 'America', 3400000, 176215),
(5, 'Espana', 'Europa', 47400000, 505990),
(6, 'Portugal', 'Europa', 10300000, 92212),
(7, 'Japon', 'Asia', 125000000, 377975);


-- EJERCICIOS BASICOS

/* 1. Mostrá el nombre, la poblacion y una columna ranking_poblacion que
   numere los países de mayor a menor población.
   paises (id_pais, nombre, continente, poblacion, superficie) */

SELECT nombre, poblacion,
	   ROW_NUMBER() OVER(
	       ORDER BY poblacion DESC
	   ) AS ranking_poblacion
FROM paises;


/* 2. Mostrá el nombre, la fecha_ingreso y una columna nro_antiguedad que
   numere a los empleados desde el más antiguo hasta el más reciente según su
   fecha de ingreso. Si dos empleados ingresaron el mismo día, desempatá por
   id_empleado de menor a mayor.
   empleados (id_empleado, nombre, area, salario, id_jefe, fecha_ingreso) */

SELECT nombre, fecha_ingreso,
	   ROW_NUMBER() OVER(
	       ORDER BY fecha_ingreso, id_empleado
	   ) AS nro_antiguedad
FROM empleados;

/* 3. Mostrá el producto, la cantidad y una columna nro_stock que numere los
   productos de menor a mayor cantidad en stock.
   stock_norte (id_producto, producto, cantidad, precio_unitario) */

SELECT producto, cantidad,
	   ROW_NUMBER() OVER(
	       ORDER BY cantidad
	   ) AS nro_stock
FROM stock_norte
WHERE cantidad IS NOT NULL;

-- EJERCICIOS INTERMEDIOS

/* 1. Calculá cuánto gastó en total cada cliente (por id_cliente) y quedate
   solo con los que gastaron más de 5000. Agregá una columna nro_cliente que
   numere a esos clientes de mayor a menor gasto total. Devolvé id_cliente,
   gasto_total y nro_cliente.
   pedidos (id_pedido, id_cliente, total, fecha_pedido) */

WITH total_cliente AS (
	SELECT id_cliente, SUM(total) AS suma_total
	FROM pedidos
	GROUP BY id_cliente
)
SELECT *,
	   ROW_NUMBER() OVER(
	       ORDER BY suma_total DESC
	   ) AS nro_cliente
FROM total_cliente
WHERE suma_total > 5000;

/* 2. Mostrá los pedidos realizados durante marzo de 2026 (ambos extremos del
   mes incluidos) con el nombre del cliente, el total y la fecha_pedido.
   Agregá una columna nro_pedido que numere los pedidos de mayor a menor total;
   si hay empate de total, desempatá por fecha_pedido de la más antigua a la
   más reciente. Ordená el resultado final por nro_pedido.
   clientes (id_cliente, nombre, ciudad)
   pedidos (id_pedido, id_cliente, total, fecha_pedido) */


SELECT c.nombre,
	   total,
	   fecha_pedido,
	   ROW_NUMBER() OVER(
	   ORDER BY total DESC, fecha_pedido
	   ) AS nro_pedido
FROM pedidos AS p
JOIN clientes AS c
	ON p.id_cliente = c.id_cliente
WHERE fecha_pedido >= '2026-03-01' AND fecha_pedido < '2026-04-01';



/* 3. Listá a los empleados que ganan más que su jefe directo. Mostrá el nombre
   del empleado, el nombre de su jefe y la diferencia de salario (salario del
   empleado menos salario del jefe) como diferencia_salarial. Agregá una
   columna nro_diferencia que numere las filas de mayor a menor diferencia
   salarial; si hay empate, desempatá por nombre del empleado de la A a la Z.
   empleados (id_empleado, nombre, area, salario, id_jefe, fecha_ingreso) */

WITH empleado_jefe AS (
	SELECT e1.nombre AS empleado,
		   e2.nombre AS jefe,
		   e1.salario - e2.salario AS diferencia_salarial
	FROM empleados AS e1
	JOIN empleados AS e2
		ON e1.id_jefe = e2.id_empleado
)
SELECT empleado, jefe, diferencia_salarial,
	   ROW_NUMBER() OVER(
	   ORDER BY diferencia_salarial DESC, empleado
	   ) AS nro_diferencia
FROM empleado_jefe
WHERE diferencia_salarial > 0;

/* 4. Usando un CTE, juntá (conservando todas las filas) los productos de ambos
   depósitos con sus precios. Numerá las filas de mayor a menor precio_unitario,
   desempatando por producto de la A a la Z. Devolvé producto, precio_unitario y
   el número asignado (nro_precio), pero solo de las filas cuyo número sea
   múltiplo de 3.
   stock_norte (id_producto, producto, cantidad, precio_unitario)
   stock_sur (id_producto, producto, cantidad, precio_unitario) */

WITH CTE_union AS (
	SELECT producto, precio_unitario
	FROM stock_norte
	UNION ALL
	SELECT producto, precio_unitario
	FROM stock_sur
),
orden_productos AS (
	SELECT producto, precio_unitario,
		   ROW_NUMBER() OVER(
		   ORDER BY precio_unitario DESC, producto
		   ) AS nro_producto
	FROM CTE_union
)
SELECT *
FROM orden_productos
WHERE nro_producto % 3 = 0;

-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   paises (id_pais, nombre, continente, poblacion, superficie) */
SELECT nombre,
       poblacion,
       ROW_NUMBER() OVER(
           ORDER BY poblacion DESC
       ) AS posicion
FROM paises
WHERE posicion <= 3;
/* razon del error 
   falla porque el WHERE se ejecuta antes que SEELCT, en este momento WHERE no conoce el aliasing de posicion que se definio. Una solucion que se me ocurre es generar una CTE y luego aplicar el WHERE*/
WITH pos_paises AS (
	SELECT nombre,
	       poblacion,
	       ROW_NUMBER() OVER(
	           ORDER BY poblacion DESC
	       ) AS posicion
	FROM paises
)
SELECT *
FROM pos_paises
WHERE posicion <= 3;


/* 2. Quiero que ranking_salario vaya de 1 (el salario más alto) hacia abajo,
   pero la numeración no sigue ese orden. ¿Por qué pasa? Explicá el motivo y
   cómo corregirla.
   empleados (id_empleado, nombre, area, salario, id_jefe, fecha_ingreso) */
SELECT nombre,
       salario,
       ROW_NUMBER() OVER() AS ranking_salario
FROM empleados
ORDER BY salario DESC;
/* razon del error la herramienta para un raning es RANK() en lugar de ROW_NUMBER, ademas de eso colocar el ORDER BY fuera de OVER da resultados erroneos, hay que incluirla dentro. solucion:*/
SELECT nombre,
       salario,
       RANK() OVER(
           ORDER BY salario DESC
       ) AS ranking_salario
FROM empleados;

/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   pedidos (id_pedido, id_cliente, total, fecha_pedido) */
SELECT id_pedido,
       total * 1.21 AS total_con_iva,
       ROW_NUMBER() OVER(
           ORDER BY total_con_iva DESC
       ) AS nro
FROM pedidos;
/* razon del error 
   El lenguaje SQL lleva un orden logico de ejecucion, no se puede generar un aliasing y pretender que en el mism oSELECT donde se creo sea capaz de detectarlo, para ello fragmentamos en pasos a travez de una CTE*/

WITH iva_aplicado AS (
	SELECT id_pedido,
	       total * 1.21 AS total_con_iva
	FROM pedidos
)
SELECT *,
	   ROW_NUMBER() OVER(
           ORDER BY total_con_iva DESC
       ) AS nro
FROM iva_aplicado;




















