-- ----------------
-- Clausula IN
-- ----------------

-- CONCEPTO

-- Cuando necesitamos encontrar filas donde una columna coincida con cualquiera de varios valores posibles, podemos escribirlo usando multiples condiciones OR por ejemplo, la siguiente consulta es muy larga:

SELECT *
FROM table1
WHERE col1 -'a' OR col1 = 'b' OR col1 = 'c' OR col1 = 'd' OR col1 = 'e' OR 
    col1 = 'f';

-- Podemos simplicarlo utilizando la palabra clave IN en esta forma:

SELECT *
FROM table1
WHERE col1 IN ('a', 'b', 'c', 'd', 'e', 'f');

-- Esta version mas corta hace exactamente lo mismo: devuelve las filas donde col1 es igual a cualquiera de los valores listados en los parentesis.


-- DESAFIO

-- Tablas y columnas disponibles
-- countries: (location_x, location_y, country)

-- Devuleve todos los registros de los siguientes paises: 
-- Oman, Nicaragua, Bhutan, Senegal, Belarus

SELECT *
FROM countries
WHERE country IN ('Oman', 'Nicaragua', 'Bhutan', 'Senegal', 'Belarus');


-- EJERCICIOS EXTRA


-- Ejercicio 1
-- Devuelve todos los registros de los siguientes países:
-- France, Germany, Italy, Spain, Portugal

SELECT *
FROM countries
WHERE country IN ('France', 'Germany', 'Italy', 'Spain', 'Portugal');

-- Ejercicio 2
-- Devuelve todos los registros donde el país sea uno de estos:
-- Japan, China, South Korea, Vietnam

SELECT *
FROM countries
WHERE country IN ('Japan', 'China', 'South Korea', 'Vietnam');

-- Ejercicio 3
-- Reescribe la siguiente consulta usando IN en vez de múltiples OR:
-- SELECT * FROM countries WHERE country = 'Chile' OR country = 'Peru' OR country = 'Bolivia' OR country = 'Ecuador';

SELECT * 
FROM countries 
WHERE country IN ('Chile', 'Peru', 'Bolivia', 'Ecuador');

-- Ejercicio 4
-- Devuelve todos los registros donde el país NO sea ninguno de estos
-- (pista: investiga cómo se combina IN con NOT):
-- Canada, Mexico, Brazil

SELECT * 
FROM countries 
WHERE country NOT IN ('Canada', 'Mexico', 'Brazil');


-- Ejercicio 5
-- Devuelve todos los registros donde el país sea alguno de estos 7 países africanos:
-- Kenya, Nigeria, Ghana, Ethiopia, Morocco, Egypt, Tanzania

SELECT * 
FROM countries 
WHERE country IN ('Kenya', 'Nigeria', 'Ghana', 'Ethiopia', 'Morocco', 'Egypt', 'Tanzania');





