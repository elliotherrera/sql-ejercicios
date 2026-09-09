/*
QUE ES UNA BASE DE DATOS

Las bases de datos almacenan datos en tablas organizadas con columnas y filas. SQL se utiliza para gestionar y manipular datos en bases de datos.
Para extraer datos de una tabla de base de datos, utiliza la instruccion SELECT con la clausula FROM:
*/

SELECT column1, column2, column3
FROM table_name;

/*
DESAFIO

Tablas y columnas disponibles:
workers: (firstname, lastname, age, exp_years, gender)

Escribe una consulta para extraer toda la tabla (todas las columnas) de la base de datos.
Usa SELECT * o enumera explicitamente todas las columnas para recuperar cada columna de la tabla workers.
*/

SELECT *
FROM workers;
-- o
SELECT firstname, lastname, age, exp_years, gender
FROM workers;