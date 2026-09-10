/*
REPASO: MODELOS DE CELULARES

DESAFIO

Tablas y columnas disponibles:
cellphones: (model, price, wifi_5g)

Obten todos los modelos de telefonos celulares que comiencen con la letra m y cuya 3ra letra sea o, cuyo rango de precios este entre 1000 y 1500, y que sean compatibles con wifi_5g
Devuelve unicamente el modelo del telefono celular y asignale el nombre id.
*/

SELECT model AS id
FROM cellphones
WHERE model LIKE 'm_o%' AND (price BETWEEN 1000 AND 1500) AND (wifi_5g IS TRUE);