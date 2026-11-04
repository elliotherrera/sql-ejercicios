
-- AGRUPACION, PARTE 2

/* La palabra clave WHERE ejecuta una condicion en cada registro por separado. Por ejemplo: */

SELECT *
FROM table1
WHERE col1 > col2;

/* col1 > col2 se ejecutara en cada registro y comprobara si se cumple.
Pero que ocurre si queremos filtrar los resultados agregados? Por ejemplo: */

SELECT category, AVG(price)
FROM table1
WHERE AVG(price) > 40
GROUP BY category;

/* Esto no funcionara porque WHERE no puede comprobar ninguna agregacion. Para eso tenemos la palabra clave HAVINF. Filtra los datos segun la condicion agregada.*/

SELECT category, AVG(price)
FROM table1
GROUP BY category
HAVING AVG(price) > 40;

/* Esto filtrara todas las categorias cuyo precio promedio sea mayor que 40.
Si queremos combinar las clausulas HAVING y WHERE, escribiremos:*/

SELECT category, AVG(price)
FROM table1
WHERE price > 25
GROUP BY category
HAVING AVG(price) > 40;

/* Primero recorrera los registros uno por uno y filtrara todos aquellos cuyo precio sea mayor que 25, y solo despues ejecutara la clausula GROUP BY y filtrara cada categoria cuyo precio promedio sea mayor que 40. */

-- DESAFIO


/*
Tablas y columnas disponibles:
earthquakes: location, amplitude, period

- La escala de Richter es una escala logarítmica utilizada para medir la magnitud de los terremotos.
Necesitamos devolver la magnitud media de cada ubicación de todos los terremotos importantes.
Un terremoto importante se define como:

- La amplitud es mayor o igual que 1
- El período de las ondas es mayor o igual que 1 minuto
- Para este desafío, usaremos una fórmula diferente: M = (A/T)2 / T, que es equivalente a M = ((A/T)*(A/T)) / T.

Devuelve la ubicación y la magnitud media de cada ubicación, incluyendo únicamente los terremotos importantes (nombra la columna avg_magnitude). Incluye en el resultado únicamente las ubicaciones donde avg_magnitude sea mayor que 1.

Redondea los resultados a 2 decimales.
*/

SELECT 
    `location`, 
    ROUND(AVG(((amplitude/`period`)*(amplitude/`period`)) / `period`), 2) as avg_magnitude
FROM earthquakes
WHERE amplitude >= 1 AND `period` >= 1
GROUP BY `location`
HAVING avg_magnitude > 1;



-- EJERCICIOS BASICOS

/* 1. Mostrá cada categoría de producto junto con la suma total vendida (nombrala total_categoria), incluyendo únicamente las categorías cuya suma total sea mayor a 5000.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

SELECT 
    categoria,
    SUM(total) as total_categoria
FROM ventas
GROUP BY categoria
HAVING total_categoria > 5000;

/* 2. Mostrá cada departamento junto con el salario promedio de sus empleados (nombralo salario_promedio), incluyendo únicamente los departamentos donde ese promedio supere los 60000.
   empleados (id_empleado, nombre, departamento, salario) */

SELECT 
    departamento, 
    ROUND(AVG(salario), 2) as salario_promedio
FROM empleados
GROUP BY departamento
HAVING salario_promedio > 60000;

/* 3. Mostrá cada continente junto con la cantidad de países que tiene (nombrala cantidad_paises), incluyendo únicamente los continentes con más de 10 países.
   paises (id_pais, nombre, continente, poblacion, area) */

SELECT
    continente,
    COUNT(*) as cantidad_paises
FROM paises
GROUP BY continente
HAVING cantidad_paises > 10;


-- EJERCICIOS INTERMEDIOS

/* 1. Mostrá cada categoría de producto junto con el stock promedio (nombralo stock_promedio), pero considerando solo los productos con precio mayor a 100, y mostrando únicamente las categorías cuyo stock promedio sea menor a 50.
   productos (id_producto, nombre, categoria, precio, stock) */

SELECT 
    categoria,
    ROUND(AVG(stock), 2) as stock_promedio
FROM productos
WHERE precio > 100
GROUP BY categoria
HAVING stock_promedio < 50;

/* 2. Mostrá cada departamento junto con la cantidad de empleados cuyo nombre empiece con "A" (nombrala cantidad_a), incluyendo únicamente los departamentos con 3 o más empleados que cumplan esa condición.
   empleados (id_empleado, nombre, departamento, salario) */

SELECT
    departamento,
    COUNT(*) as cantidad_a
FROM empleados
WHERE nombre LIKE 'A%'
GROUP BY departamento
HAVING cantidad_a >= 3;

/* 3. Mostrá cada cliente junto con el total gastado (nombralo total_gastado), incluyendo únicamente los clientes cuyo total gastado sea mayor al total gastado promedio de todos los clientes.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

SELECT 
    cliente,
    SUM(total) as total_gastado
FROM ventas
GROUP BY cliente
HAVING total_gastado > (SELECT AVG(total) FROM ventas);

/* 4. Mostrá cada continente junto con la población promedio redondeada a 2 decimales (nombrala poblacion_promedio), incluyendo únicamente los continentes donde esa población promedio dividida por el área promedio del continente sea mayor a 50.
   paises (id_pais, nombre, continente, poblacion, area) */

SELECT
    continente,
    ROUND(AVG(poblacion), 2) as poblacion_promedio
FROM paises
GROUP BY continente
HAVING (poblacion_promedio / ROUND(AVG(area), 2)) > 50;
/* Esto funciona porque MySQL (a diferencia del estándar SQL) permite referenciar alias del SELECT dentro de HAVING. Es una extensión propia de MySQL — en otros motores (PostgreSQL, SQL Server) esto fallaría y tendrías que repetir la expresión completa (ROUND(AVG(poblacion), 2)) en el HAVING. Como estás trabajando en MySQL, tu query es válida, pero es bueno tenerlo presente si algún día migrás de motor.*/



-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */
SELECT categoria, SUM(total) AS total_categoria
FROM ventas
GROUP BY categoria
WHERE total_categoria > 5000;
/* razon del error 
    La clausula WHERE solo funciona en datos crudos, no en datos de agregacion
    solucion: usar having

SELECT categoria, SUM(total) AS total_categoria
FROM ventas
GROUP BY categoria
HAVING total_categoria > 5000;
*/


/* 2. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, departamento, salario) */
SELECT departamento, nombre, AVG(salario) AS salario_promedio
FROM empleados
GROUP BY departamento
HAVING salario_promedio > 60000;
/* razon del error 
    Los campos de SELECT y GROUP BY no coinciden, si l oque se busca es una combinacion, debemos agregar nombre a GROUP BY, y si solo necesitamos agrupar por departamento, debemos quitar nombre de SELECT.
*/

/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   paises (id_pais, nombre, continente, poblacion, area) */
SELECT continente, COUNT(*) AS cantidad_paises
FROM paises
HAVING cantidad_paises > 10
GROUP BY continente;
/* razon del error 
    Falla en el orden de la estructura de la query, HAVING se escribe despues de GROUP BY
    solucion
SELECT continente, COUNT(*) AS cantidad_paises
FROM paises
GROUP BY continente
HAVING cantidad_paises > 10;
*/

