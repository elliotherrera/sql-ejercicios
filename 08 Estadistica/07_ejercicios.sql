
-- TIENDA DE GANANCIAS TOTALES

/* Tablas y columnas disponibles:
    shop: price, quantity, category, list_date

Tu tarea es calcular los ingresos totales para cada categoría de artículos en una tienda entre el January 1, 2015 y el March 18, 2015. Debido a un error sistemático en el sistema de entrada de datos, todos los valores de precio de la base de datos son inferiores a lo que deberían por una cantidad fija.

Para corregir estos precios:

    1. Primero, calcula el precio promedio de todos los artículos dentro del intervalo de fechas especificado (2015-01-01 (1 de enero de 2015), hasta 2015-03-18 18 de marzo de 2015)
    2. Suma este precio promedio al precio original de cada artículo para obtener el valor de precio correcto
    3. Para cada categoría, calcula los ingresos totales multiplicando el precio corregido por la cantidad y sumando estos valores
    4. Presenta los resultados como pares (category, total_revenue), ordenados por ingresos totales en orden descendente */


-- Paso 2: agrupa las filas reconstruidas y totalízalas, las más grandes primero
SELECT category, sum(price * quantity) as total_revenue
FROM (
    -- Paso 1: reconstruye cada fila para que el valor corregido reemplace al original
    SELECT (SELECT AVG(price) FROM shop WHERE list_date BETWEEN '2015-01-01' AND '2015-03-18') + price AS price, quantity, category, list_date
    FROM shop
    WHERE list_date BETWEEN '2015-01-01' AND '2015-03-18'
) as new_shop
GROUP BY category
ORDER BY total_revenue DESC;


-- TIENDA SCOOTERS

/* Tablas y columnas disponibles:
    scooters: model, brand, has_lights, price

Como gerente de una tienda de scooters, has notado que muchos scooters no son originales, lo que significa que les falta un nombre de modelo. Además, los scooters defectuosos normalmente no tienen luces.

Tu tarea consta de dos pasos:

Primero, añade a todos los precios de los scooters de la tienda el precio promedio general.
Después, calcula el precio promedio de cada brand, considerando únicamente los scooters buenos y originales (es decir, scooters con un nombre de modelo y luces).
El resultado debe incluir brand y el precio promedio: avg_price. Ordena los resultados por el precio promedio en orden ascendente.
*/

-- Paso 2: filtra las filas reconstruidas, luego promedialas por grupo
SELECT brand, AVG(price) AS avg_price
FROM (
    -- Paso 1: reconstruye cada fila, reemplazando el valor con el ajustado
    SELECT model, brand, has_lights, (SELECT AVG(price) FROM scooters) + price AS price
    FROM scooters
) AS new_scooters
WHERE has_lights = 1 AND model IS NOT NULL
GROUP BY brand
ORDER BY avg_price;


-- CAFETERIA

/* Tablas y columnas disponibles:
    beans: brand, density, diameter_wide, shade

Eres el propietario de una cafetería. Hay muchos clientes esperando sus pedidos. Solo puedes usar un tipo de granos de café cada día.

Hay varios criterios para seleccionar qué granos usar. Primero, debemos filtrar los granos según estas condiciones:

    - Todos los granos deben tener un diámetro mayor que el diámetro promedio de todos los granos de la tabla
    - Para los granos claros: conservar solo aquellos cuya proporción entre densidad y diámetro sea mayor que 0.01
    -Para los granos oscuros: conservar todos
    -Para los granos semioscuros: excluirlos todos (se consideran inadecuados)

Para cada marca que cumpla estos criterios, calcula su densidad promedio. Conserva solo las marcas cuya densidad promedio sea menor que 0.8.

Devuelve el nombre de la marca y su densidad promedio (nombra la columna avg_density) redondeada a 3 decimales. Ordena los resultados por densidad promedio en orden ascendente. */


-- Filtra primero las filas individuales, luego agrúpalas, luego filtra los grupos
SELECT brand, ROUND(AVG(density), 3) AS avg_density
FROM beans
-- Dos condiciones a nivel de fila aquí: una sobre size, una que combina las reglas de type entre paréntesis
WHERE diameter_wide > (
    SELECT AVG(diameter_wide)
    FROM beans
)
  AND ((shade = 'light' AND (density/diameter_wide) > 0.01) OR (shade = 'dark') OR (shade != 'semi-dark'))
GROUP BY brand
HAVING avg_density < 0.8
ORDER BY avg_density;



