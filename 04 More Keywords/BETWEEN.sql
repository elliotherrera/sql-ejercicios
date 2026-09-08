-- ----------------
-- Palabra clave BEETWEEN
-- ----------------

-- CONCEPTO

-- Hasta ahora hemos aprendido a usar mayor que > y menor que < para exigir un rango en un campo. Pero hay otra forma.

-- En lugar de escribir:

WHERE col1 >= 5 AND col1 <= 10

-- Podemos escribir

WHERE col1 BETWEEN 5 AND 10

-- El operador BETWEEN es inclusivo, lo que significa que incluye los valores  (en este caso, 5 y 10) en los resultados. Esto hace que tus consultas SQL sean mas limpias y legibles, especialmente cuando se trabaja con rangos de fechas o intervalos numericos.



