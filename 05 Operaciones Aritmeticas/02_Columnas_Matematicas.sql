
-- COLUMNAS MATEMATICAS

/* Puedes combinar varias columnas y numeros en expresiones complejas utilizando operadores aritmeticos.*/


SELECT (price * quantity) + shipping_cost AS final_price
FROM orders;

/* Usa parentesis para controlar el orden de las operaciones */


SELECT (base_salary + bonus) * (1 - tax_rate) AS net_pay
FROM payroll;

-- DESAFIO

/* 
Tablas y columnas disponibles:
    producs: (id, price, quantity)

Crea una consulta que calcule lo siguiente:
    1. Una columna llamada total_value que multiplique el precio por cantidad y añada un coste fijo de envio de 15
    2. Una columna llamada dicounted_value que:
        - Primero multiplique el precio por la cantidad
        - Despues aplique un descuento del 20% (multiplique por 0.8)
        - Finalmente añade un coste fijo de envio de 10
Intenta usar parentesis adecuadamente para asegurarte de que los calculos se realicen en el orden correcto
*/

SELECT price * quantity + 15 AS total_value, 
    (price * quantity) * 0.8 + 10  AS discounted_value
FROM productos;


-- EJERCICIOS BASICOS

/* 1. Mostrá el id_venta, el total y el costo_envio de cada venta, junto con
   una columna calculada llamada ganancia_neta que sea total menos costo_envio.
   ventas (id_venta, cliente, total, costo_envio, fecha_venta) */

SELECT id_venta, total, costo_envio, total - costo_envio AS ganancia_neta
FROM ventas;

/* 2. Mostrá el nombre de cada empleado junto con una columna calculada
   llamada salario_anual, que sea el salario mensual multiplicado por 12.
   empleados (id_empleado, nombre, area, salario) */

SELECT nombre, salario * 12 AS salario_anual
FROM empleados;

/* 3. Mostrá el nombre de cada producto junto con una columna calculada
   llamada precio_descuento, que sea el precio original menos un 10% de
   descuento (precio - (precio * 0.10)).
   productos (id_producto, nombre, categoria, precio, stock) */

SELECT nombre, precio * 0.9 AS precio_descuento
FROM productos;


-- EJERCICIOS INTERMEDIOS

/* 1. Mostrá el nombre y una columna calculada llamada densidad, que sea
   poblacion dividido superficie, de los países cuya superficie esté
   entre 100000 y 500000.
   paises (id_pais, nombre, poblacion, superficie, continente) */

SELECT nombre, (poblacion * 1.0 / superficie) AS densidad
FROM paises
WHERE superficie BETWEEN 100000 AND 500000;

/* 2. Mostrá el nombre de cada empleado junto con su salario_anual
   (salario * 12), ordenado de mayor a menor salario_anual.
   empleados (id_empleado, nombre, area, salario) */

SELECT nombre, salario * 12 AS salario_anual
FROM empleados
ORDER BY salario_anual DESC;

/* 3. Mostrá cliente, total, costo_envio y una columna calculada llamada
   ganancia_neta (total - costo_envio), solo de las ventas cuyo cliente
   esté en la lista ('Rodriguez', 'Gomez', 'Fernandez'), ordenado por
   ganancia_neta de forma descendente, limitando a 5 resultados.
   ventas (id_venta, cliente, total, costo_envio, fecha_venta) */

SELECT cliente, total, costo_envio, total - costo_envio AS ganancia_neta
FROM ventas
WHERE cliente IN ('Rodriguez', 'Gomez', 'Fernandez')
ORDER BY ganancia_neta DESC
LIMIT 5;

/* 4. Mostrá el nombre y una columna calculada llamada precio_descuento
   (precio - (precio * 0.10)), de los productos cuyo nombre empiece con
   la letra "A".
   productos (id_producto, nombre, categoria, precio, stock) */

SELECT nombre, precio - (precio * 0.10) AS precio_descuento
FROM productos
WHERE nombre LIKE 'A%';


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   ventas (id_venta, cliente, total, costo_envio, fecha_venta) */
SELECT total, costo_envio, (total - costo_envio) AS ganancia_neta
FROM ventas
WHERE ganancia_neta > 100;
/* razon del error 
    WHERE se ejecuta antes que SELECT por lo que no reconoce el aliasing, para aplicar el filtro debe realizarse con los datos en crudo osea poner (total - costo_envio) > 100 */
SELECT total, costo_envio, (total - costo_envio) AS ganancia_neta
FROM ventas
WHERE (total - costo_envio) > 100;


/* 2. ¿Por qué esta query puede devolver resultados inesperados (columnas
   con NULL) para algunos países, aunque no haya ningún error de sintaxis?
   Explicá el motivo y cómo lo solucionarías.
   paises (id_pais, nombre, poblacion, superficie, continente) */
SELECT nombre, poblacion / superficie AS densidad
FROM paises
ORDER BY densidad DESC;
/* razon del error 
    En MySQL una division por 0 no tira error, devuelve NULL silenciosamente. Lo mismo pasa si poblacion o superficie son NULL en algun registro, cualquier operacion aritmetica con NULL da NULL como resultado.
    NULL es el valor "mas bajo" en MySQL y si lo ordenamos DESC estarian escondidos
*/


/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, area, salario) */
SELECT nombre + ', salario: ' + salario AS descripcion
FROM empleados;
/* razon del error 
    error en sintaxis, se intenta sumar cadena de texto con numeros.
    La solucion es usar CONCAT(valor1, valor2, ...)
    es uan funcion que une (concatena) dos o mas strings en uno solo, sin importar si son texto o numeros*/

SELECT CONCAT(nombre, ', salario:', salario) AS descripcion
FROM empleados;