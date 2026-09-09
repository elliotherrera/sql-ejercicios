/*
VALORES UNICOS

Usa DISTINCT para obtener valores unicos de una columna:
*/
SELECT DISTINCT column_name
FROM table_name;

/*
Sin DISTINCT, se devolveran valores duplicados. Con DISTINCT, cada valor unico aparece solo uuna vez en el resultado.
*/

/*
DESAFIO

Tablas y columnas disponibles:
sales: (coin, amount)

Obten todas las monedas unicas que se utilizaron en la tabla sales
*/

SELECT DISTINCT coin
FROM sales;