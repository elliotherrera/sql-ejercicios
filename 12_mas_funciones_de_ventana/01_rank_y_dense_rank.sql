
-- Funciones RANK y DENSE RANK

/* Junto con ROW_NUMBER(), son las tres funciones de clasificacion (ranking) de SQL. Las tres numeran lasa filas segun un criterio definido en ORDER BY. Lo que cambia es como tratan los empaques:
 
 +----------------+--------------------------------+-------------------------+
| Función        | ¿Qué hace con los empates?     | ¿Deja huecos?           |
+----------------+--------------------------------+-------------------------+
| ROW_NUMBER()   | No hay empates: número único   | No                      |
|                | para cada fila                 |                         |
| RANK()         | Mismo número para empatadas    | SÍ: salta los números   |
|                |                                | "ocupados" por el empate|
| DENSE_RANK()   | Mismo número para empatadas    | NO: numeración          |
|                |                                | consecutiva             |
+----------------+--------------------------------+-------------------------+
 
 Ejemplo
  
  Tabla: table1

  id | nivel
  ---+------
   1 |  5
   2 |  6
   3 |  6
   4 |  7
   5 |  7
   6 |  5
  
 Consulta:
 */

SELECT 
	id,
	ROW_NUMBER() OVER (ORDER BY nivel) AS row_num,
	RANK()       OVER (ORDER BY nivel) AS row_rank,
	DENSE_RANK() OVER (ORDER BY nivel) AS row_dense_rank
FROM table1;
	
/*

Resultado:

  id | nivel | row_num | row_rank | row_dense_rank
  ---+-------+---------+----------+---------------
   1 |   5   |    1    |    1     |      1
   6 |   5   |    2    |    1     |      1
   2 |   6   |    3    |    3     |      2
   3 |   6   |    4    |    3     |      2
   4 |   7   |    5    |    5     |      3
   5 |   7   |    6    |    5     |      3
 
 
Explicacion paso a paso:
 
* ROW_NUMBER(): siempre devuelve valores únicos (1, 2, 3, 4, 5, 6),
  aunque haya empates. Entre filas empatadas (como id 1 e id 6) el
  orden es arbitrario. Si necesitas un resultado reproducible, agrega
  un criterio de desempate: ORDER BY nivel, id

* RANK(): las filas empatadas comparten posición y SE SALTAN los
  números siguientes.
    - nivel 5 (2 filas) -> ambas rango 1 (el 2 se omite)
    - nivel 6 (2 filas) -> ambas rango 3 (el 4 se omite)
    - nivel 7 (2 filas) -> ambas rango 5

* DENSE_RANK(): igual que RANK(), pero SIN saltos.
    - nivel 5 -> rango 1
    - nivel 6 -> rango 2
    - nivel 7 -> rango 3


Cuando usar cada una

* ROW_NUMBER(): cuando necesitas exactamente una fila por posición
  (ej.: eliminar duplicados o quedarte con la primera fila de cada
  grupo).

* RANK(): ranking "tipo competencia". Si dos personas empatan en el
  1.er lugar, la siguiente queda en el 3.er lugar.

* DENSE_RANK(): niveles consecutivos, por ejemplo "el 2.º nivel más
  alto", sin importar cuántas filas empaten antes.
  
  
 Extra: CON PARTITION BY
 
 Las tres funciones aceptan PARTITION BY para reiniciar la numeración
 en cada grupo:
*/

  SELECT id, categoria, nivel,
         DENSE_RANK() OVER (PARTITION BY categoria
                            ORDER BY nivel DESC) AS ranking
  FROM table1;

 
-- DESAFIO
  
  /*
  
Tablas y columnas disponibles:

medals: region, medal_color, medal_count
Crea una consulta que muestre la región, el recuento total de medallas (la suma de todas las medals, independientemente del color) y dos tipos de clasificaciones:

Un regular_rank (con espacios) sobre la suma de medals
Un dense_rank (sin espacios) sobre la suma de medals
Ordena el resultado por:
  
  */

WITH CTE_region_agrupada AS (
    SELECT
        region,
        SUM(medal_count) AS total_medals
    FROM medals
    GROUP BY region
)
SELECT
    region,
    total_medals,
    RANK() OVER(ORDER BY total_medals DESC) AS regular_rank,
    DENSE_RANK() OVER(ORDER BY total_medals DESC) AS dense_rank
FROM CTE_region_agrupada;



-- SETUP

DROP DATABASE IF EXISTS practica_rank_y_dense_rank;
CREATE DATABASE practica_rank_y_dense_rank;
USE practica_rank_y_dense_rank;

-- ESQUEMA: RRHH
CREATE TABLE empleados (
    id_empleado   INT PRIMARY KEY,
    nombre        VARCHAR(50) NOT NULL,
    area          VARCHAR(30) NOT NULL,
    salario       DECIMAL(10,2) NOT NULL,
    fecha_ingreso DATE NOT NULL
);

INSERT INTO empleados (id_empleado, nombre, area, salario, fecha_ingreso) VALUES
(1, 'Lucía Gómez',     'Ventas',       850000.00,  '2019-03-15'),
(2, 'Martín Pérez',    'Ventas',       850000.00,  '2021-07-01'),
(3, 'Sofía Ramírez',   'Sistemas',     1200000.00, '2020-01-10'),
(4, 'Javier Torres',   'Sistemas',     1200000.00, '2022-05-20'),
(5, 'Carla Núñez',     'Sistemas',     950000.00,  '2023-02-01'),
(6, 'Pablo Díaz',      'Contabilidad', 700000.00,  '2018-11-30'),
(7, 'Valeria Ibarra',  'Contabilidad', 780000.00,  '2024-01-15'),
(8, 'Hugo Salas',      'Ventas',       900000.00,  '2020-09-09');

-- ESQUEMA: INVENTARIO
CREATE TABLE categorias (
    id_categoria     INT PRIMARY KEY,
    nombre_categoria VARCHAR(40) NOT NULL
);

INSERT INTO categorias (id_categoria, nombre_categoria) VALUES
(1, 'Lácteos'),
(2, 'Bebidas'),
(3, 'Limpieza'),
(4, 'Snacks'),
(5, 'Panadería');

CREATE TABLE productos (
    id_producto  INT PRIMARY KEY,
    nombre       VARCHAR(50) NOT NULL,
    id_categoria INT NOT NULL,
    precio       DECIMAL(10,2) NOT NULL,
    stock        INT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

INSERT INTO productos (id_producto, nombre, id_categoria, precio, stock) VALUES
(1, 'Leche entera',   1, 1200.00, 40),
(2, 'Yogur natural',  1, 800.00,  25),
(3, 'Queso cremoso',  1, 3500.00, NULL),
(4, 'Gaseosa cola',   2, 1500.00, 60),
(5, 'Agua mineral',   2, 800.00,  60),
(6, 'Jugo de naranja',2, 1500.00, 15),
(7, 'Detergente',     3, 2200.00, 30),
(8, 'Papas fritas',   4, 1800.00, 30);

-- ESQUEMA: PAISES
CREATE TABLE paises (
    id_pais       INT PRIMARY KEY,
    nombre        VARCHAR(50) NOT NULL,
    continente    VARCHAR(30) NOT NULL,
    poblacion     BIGINT NOT NULL,
    pib_millones  DECIMAL(12,2) NULL
);

INSERT INTO paises (id_pais, nombre, continente, poblacion, pib_millones) VALUES
(1, 'Argentina', 'América', 46000000,  640000.00),
(2, 'Brasil',    'América', 215000000, 1900000.00),
(3, 'México',    'América', 126000000, 1300000.00),
(4, 'Nigeria',   'África',  215000000, 470000.00),
(5, 'Egipto',    'África',  104000000, 400000.00),
(6, 'Kenia',     'África',  54000000,  NULL),
(7, 'Alemania',  'Europa',  83000000,  4200000.00),
(8, 'Francia',   'Europa',  68000000,  2900000.00);

-- ESQUEMA: VENTAS
CREATE TABLE ventas (
    id_venta    INT PRIMARY KEY,
    vendedor    VARCHAR(40) NOT NULL,
    region      VARCHAR(20) NOT NULL,
    monto       DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL
);

INSERT INTO ventas (id_venta, vendedor, region, monto, fecha_venta) VALUES
(1, 'Ana',    'Norte', 1500.00, '2026-01-05'),
(2, 'Bruno',  'Sur',   2000.00, '2026-03-31'),
(3, 'Ana',    'Norte', 500.00,  '2026-03-31'),
(4, 'Carlos', 'Sur',   3000.00, '2026-02-14'),
(5, 'Diana',  'Este',  800.00,  '2025-12-31'),
(6, 'Diana',  'Este',  1200.00, '2026-01-01'),
(7, 'Bruno',  'Sur',   700.00,  '2026-04-01'),
(8, 'Elena',  'Norte', 1500.00, '2026-02-20');


-- EJERCICIOS

-- EJERCICIOS BASICOS

/* 1. Mostrá el nombre, el salario y la posición de cada empleado según su
      salario, del más alto al más bajo. Si dos empleados empatan, deben
      compartir posición y la siguiente posición debe saltarse.
   empleados (id_empleado, nombre, area, salario, fecha_ingreso) */

SELECT
	nombre, salario,
	RANK() OVER(
		ORDER BY salario DESC
	) AS posicion
FROM empleados;

/* 2. Mostrá el nombre, el precio y la posición de cada producto del más
      barato al más caro. Si hay precios iguales, deben compartir posición
      y la numeración no debe tener huecos.
   productos (id_producto, nombre, id_categoria, precio, stock) */

SELECT
	nombre, precio,
	DENSE_RANK() OVER(
		ORDER BY precio
	) AS posicion
FROM productos;

/* 3. Mostrá la región, el vendedor, el monto y la posición de cada venta
      dentro de su propia región, de mayor a menor monto. La numeración debe
      reiniciarse en cada región y no debe tener huecos ante empates.
   ventas (id_venta, vendedor, region, monto, fecha_venta) */

SELECT
	region, vendedor, monto,
	DENSE_RANK() OVER(
		PARTITION BY region 
		ORDER BY monto DESC
	) AS posicion
FROM ventas;

-- EJERCICIOS INTERMEDIOS

/* 1. Considerando solo las ventas del primer trimestre de 2026 (del 1 de
      enero al 31 de marzo, ambos incluidos), calculá el total vendido por
      cada vendedor y mostrá únicamente a los que estén dentro de las 3
      primeras posiciones del ranking (sin huecos ante empates). Mostrá
      vendedor, total y posición.
   ventas (id_venta, vendedor, region, monto, fecha_venta) */

WITH ventas_trimestre AS (
	SELECT 
		vendedor,
		SUM(monto) AS total
	FROM ventas
	WHERE fecha_venta >= '2026-01-01' AND fecha_venta <= '2026-03-31'
	GROUP BY vendedor
),
CTE_ventas_posicion AS (
SELECT
	vendedor,
	total,
	DENSE_RANK() OVER(
		ORDER BY total DESC
	) AS posicion
FROM ventas_trimestre
)
SELECT *
FROM CTE_ventas_posicion
WHERE posicion < 4;


/* 2. Mostrá el nombre, el área y el salario de los empleados que tienen el
      segundo salario más alto de su propia área. Si en un área varios
      empatan en el primer lugar, el segundo salario más alto es el
      siguiente valor distinto.
   empleados (id_empleado, nombre, area, salario, fecha_ingreso) */

WITH CTE_posicion_salario AS (
SELECT
	nombre,
	area,
	salario,
	DENSE_RANK() OVER(
		PARTITION BY area
		ORDER BY salario DESC
	) AS posicion
FROM empleados
)
SELECT 
	*
FROM CTE_posicion_salario
WHERE posicion = 2;


/* 3. Mostrá el nombre de la categoría, el nombre del producto, el stock y
      la posición del producto dentro de su categoría según el stock, de
      mayor a menor (con saltos ante empates). Ordená el resultado por
      nombre de categoría y luego por posición. Solo deben aparecer los
      productos que pertenecen a una categoría existente.
   categorias (id_categoria, nombre_categoria)
   productos (id_producto, nombre, id_categoria, precio, stock) */

SELECT 
	nombre_categoria, nombre AS nombre_producto, stock, precio,
	RANK() OVER(
		PARTITION BY nombre_categoria
		ORDER BY stock DESC
	) AS posicion
FROM productos AS p
JOIN categorias AS c
	ON p.id_categoria = c.id_categoria
WHERE nombre_categoria IS NOT NULL
ORDER BY nombre_categoria, posicion;


/* 4. Calculá el PIB per cápita de cada país (pib_millones expresado en
      unidades, dividido la población), redondeado a 2 decimales, y mostrá
      el país, el continente, el PIB per cápita y su posición dentro de su
      continente de mayor a menor PIB per cápita (sin huecos). Los países
      sin PIB informado deben aparecer igual, al final de su continente.
   paises (id_pais, nombre, continente, poblacion, pib_millones) */

WITH paises_calculado AS (
	SELECT
		nombre AS pais,
		continente,
		ROUND((pib_millones * 1000000 / poblacion), 2) AS PIB_per_capita
	FROM paises
)
SELECT
	pais, continente, PIB_per_capita,
	DENSE_RANK() OVER(
		PARTITION BY continente
		ORDER BY PIB_per_capita DESC
	) AS posicion
FROM paises_calculado;


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
      La idea es mostrar solo los 3 empleados con mayor salario.
   empleados (id_empleado, nombre, area, salario, fecha_ingreso) */
SELECT nombre, salario
FROM empleados
WHERE RANK() OVER (ORDER BY salario DESC) <= 3;
/* razon del error el where se ejecuta antes que el select y no hay forma de detectar aunque este en una expresion total, primero debemos generar la columna ranking para luego filtrarla, lo hacemos con una CTE*/

WITH mejores_salarios AS (
	SELECT nombre, salario,
		RANK() OVER (ORDER BY salario DESC) AS posicion
	FROM empleados
)
SELECT *
FROM mejores_salarios
WHERE posicion <=3;


/* 2. ¿Por qué esta query no devuelve lo esperado? La idea es rankear los
      productos de cada categoría del más caro al más barato. Explicá el
      motivo y cómo corregirla.
   productos (id_producto, nombre, id_categoria, precio, stock) */
SELECT nombre, id_categoria, precio,
       RANK() OVER (PARTITION BY id_categoria) AS posicion
FROM productos;
/* razon del error falla porque falta el ORDER BY que es el que hace las comparaciones y genera el ranking de precios, ademas colocarle el ordes DESC esta es la solucion:*/
SELECT nombre, id_categoria, precio,
       RANK() OVER (PARTITION BY id_categoria ORDER BY precio DESC) AS posicion
FROM productos;

/* 3. ¿Por qué falla esta query? La idea es rankear a los vendedores según
      su total vendido. Explicá el motivo y cómo corregirla.
   ventas (id_venta, vendedor, region, monto, fecha_venta) */
SELECT vendedor,
       SUM(monto) AS total,
       RANK() OVER (ORDER BY monto DESC) AS posicion
FROM ventas
GROUP BY vendedor;
/* razon del error : se esta ordenando sin antes hacer la agrupacion, yo primero haria una CTE agrupando a los vendedores y su suma total de ventas para luego egenrar el ranking*/

WITH total_ventas AS (
	SELECT vendedor,
	       SUM(monto) AS total
	FROM ventas
	GROUP BY vendedor
)
SELECT 
	*,
    RANK() OVER (ORDER BY total DESC) AS posicion
FROM total_ventas;


/* 4. ¿Por qué esta query no devuelve lo esperado? La idea es obtener el
      segundo país con más población. Explicá el motivo y cómo corregirla.
   paises (id_pais, nombre, continente, poblacion, pib_millones) */
SELECT nombre, poblacion
FROM (
    SELECT nombre, poblacion,
           RANK() OVER (ORDER BY poblacion DESC) AS posicion
    FROM paises
) AS ranking
WHERE posicion = 2;
/* razon del error : el error es que no existe una posicion 2, debido a RANK se salta la posicion 2, si quieremos exactamente l;a posicion 2 debemos elegir el funcion DENSE_RANK*/

SELECT nombre, poblacion
FROM (
    SELECT nombre, poblacion,
           DENSE_RANK() OVER (ORDER BY poblacion DESC) AS posicion
    FROM paises
) AS ranking
WHERE posicion = 2;





