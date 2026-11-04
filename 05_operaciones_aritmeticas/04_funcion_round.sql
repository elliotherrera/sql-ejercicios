
-- FUNCION ROUND ()

/* La funcion ROUND() redondea un valor numerico a un numero especifico de posiciones decimales

ROUND(number, decimal_places)

    - number: El valor que se va a redondear.
    - decimal_places: (Opcional)
        - Omitido: Redondea al numero entero mas cercano
        - Positivo Redondea a ese numero de posiciones decimales
        - Negativo: Redondea a la izquierda de punto decimal.

Notas:

    - Devuelve un valor de punto flotante (REAL)
    - Si el digito posterior a la ultima posicion conservada es 5 o mayor, redondea hacia arriba.

Ejemplos:
*/

SELECT ROUND(3.7);         -- Devuelve 4.0
SELECT ROUND(3.14159, 2);  -- Devuelve 3.14
SELECT ROUND(3.145, 2);    -- Devuelve 3.15
SELECT ROUND(325.14, -2);  -- Devuelve 300


-- EJERCICIOS BASICOS

/* 1. Mostrá el nombre de cada producto junto con su precio redondeado a 0 decimales.
   productos (id_producto, nombre, precio, categoria) */

SELECT nombre, ROUND(precio)
FROM productos;

/* 2. Mostrá el nombre de cada empleado junto con su salario mensual (salario / 12),
   redondeado a 2 decimales.
   empleados (id_empleado, nombre, area, salario) */

SELECT nombre, ROUND((salario / 12), 2) AS salario_mensual
FROM empleados;

/* 3. Mostrá el nombre de cada país junto con su PIB per cápita (pib / poblacion),
   redondeado a 2 decimales.
   paises (id_pais, nombre, poblacion, area_km2, pib) */

SELECT nombre, ROUND((pib / poblacion), 2) AS pib_per_capita
FROM paises;


-- EJERCICIOS INTERMEDIOS

/* 1. Mostrá cliente y total de venta redondeado a 1 decimal, solo para las ventas
   con total mayor a 5000.
   ventas (id_venta, cliente, total, fecha_venta) */

SELECT cliente, ROUND(total, 1)
FROM ventas
WHERE total > 5000;

/* 2. Mostrá nombre y salario mensual (salario / 12) redondeado a 2 decimales,
   ordenado de mayor a menor por ese valor calculado.
   empleados (id_empleado, nombre, area, salario) */

SELECT nombre, ROUND((salario / 12), 2) AS salario_mensual
FROM empleados
ORDER BY salario_mensual DESC;

/* 3. Mostrá nombre y precio redondeado a 0 decimales de los productos cuya
   categoria empiece con "Elec", con precio entre 100 y 1000.
   productos (id_producto, nombre, precio, categoria) */

SELECT nombre, ROUND(precio)
FROM productos
WHERE (categoria LIKE 'Elec%') AND
    precio BETWEEN 100 AND 1000;

/* 4. Mostrá nombre y PIB per cápita (pib / poblacion) redondeado a 0 decimales,
   solo para los países cuyo nombre esté en una lista específica de 4 países
   a elección.
   paises (id_pais, nombre, poblacion, area_km2, pib) */

SELECT nombre, ROUND(pib / poblacion) AS pib_per_capita
FROM paises
WHERE nombre IN ('Peru', 'Argentina', 'Chile', 'Brasil');


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, area, salario) */
SELECT nombre, ROUND(salario / 12, 2) AS sueldo_mensual
FROM empleados
WHERE sueldo_mensual > 3000;
/* razon del error 
    WHERE se ejecuta antes que SELECT, no tiene mapeado el aliasin AS sueldo_mensual, 
    solucion:
    ser mas verboso ROUND(salario / 12, 2) > 3000;
*/


/* 2. Esta query pretende redondear el precio a la centena más cercana
   (por ejemplo, 1234 -> 1200). ¿Por qué no logra ese resultado? Explicá el
   motivo y cómo corregirla.
   productos (id_producto, nombre, precio, categoria) */
SELECT nombre, ROUND(precio, 2) AS precio_redondeado
FROM productos;
/* razon del error:
    ROUND(precio, 2) segundo argumento incorrecto, si queremos redondear del . a la izquierda debemos usar numeros negativos.
    solucion:
    ROUND(precio, -2)
*/


/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   paises (id_pais, nombre, poblacion, area_km2, pib) */
SELECT nombre, pib / poblacion AS pib_per_capita
FROM paises
ORDER BY ROUND(pib_per_capita, 2) DESC;
/* razon del error funciona bien
*/









