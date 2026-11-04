/*
OPERADORES MATEMATICOS

SQL admite operaciones aritmeticas directamente con los valores de las columnas mediante estos operadores

+ Suma
- Resta
* Multiplicacion
/ Division

Puedes realizar calculos y asignar alias a los resultados:
*/

SELECT price + 10 AS increased_price, 
    price / 2 AS half_price
FROM products;

/*
Nota sobre la division: La division de enteros trunca el resultado. Para obtener resultados decimales, asegurate de que al menos uno de los operandos sea un numero de coma flotante

- 7 / 2 = 3 (Division de eneteros)
- 7 / 2.0 = 3.5 (Division de coma flotante)


DESAFIO

Tablas y columnas disponibles:
products: (id, price, quantity)

Crea dos columnas calculadas:

1. Primera columna llamada high_mix_op:
    Toma la columna de precio
    Multiplícala por 2
    Resta 20 al resultado
2. Segunda columna llamada low_mix:
    Toma la columna de cantidad
    Divídela entre 1.5
    Suma 5 al resultado
*/

SELECT price * 2 - 20 AS high_mix_op, 
    quantity / 1.5 + 5 AS low_mix
FROM products;


-- EJERCICIOS BASICOS

/* 1. Mostrá el nombre y el salario de cada empleado, junto con una columna
   adicional que muestre el salario aumentado un 15%.
   empleados (id_empleado, nombre, area, salario) */

SELECT nombre, salario, (salario * 1.15)
FROM empleados;

/* 2. Mostrá el nombre de cada producto junto con el valor total de su stock
   (precio multiplicado por la cantidad en stock).
   productos (id_producto, nombre, categoria, precio, stock) */

SELECT nombre, (precio * stock)
FROM productos;

/* 3. Mostrá el nombre de cada país junto con su densidad poblacional
   (población dividida por superficie).
   paises (id_pais, nombre, poblacion, superficie, continente) */

SELECT nombre, (poblacion * 1.0 / superficie)
FROM paises;

-- EJERCICIOS INTERMEDIOS

/* 1. Mostrá el id de pedido, el cliente y el total real de cada pedido
   (cantidad por precio unitario, menos el descuento), pero solo para los
   pedidos donde ese total supere los 5000.
   pedidos (id_pedido, cliente, cantidad, precio_unitario, descuento, fecha_pedido) */

SELECT id_pedido, cliente, (cantidad * precio_unitario - descuento)
FROM pedidos
WHERE (cantidad * precio_unitario - descuento) > 5000;


/* 2. Mostrá el nombre y el salario de los 3 empleados con mayor salario
   proyectado (salario + un bono fijo de 20000), ordenados de mayor a menor.
   empleados (id_empleado, nombre, area, salario) */

SELECT nombre, salario
FROM empleados
ORDER BY (salario + 20000) DESC
LIMIT 3;


/* 3. Mostrá el nombre y el precio con impuesto (precio + 21% de IVA) de los
   productos cuyo precio con impuesto esté entre 1000 y 5000.
   productos (id_producto, nombre, categoria, precio, stock) */

SELECT nombre, (precio*1.21)
FROM productos
WHERE (precio*1.21) BETWEEN 1000 AND 5000;

/* 4. Mostrá el nombre y la densidad poblacional (población / superficie) de
   los países cuyo nombre de continente empiece con "A".
   paises (id_pais, nombre, poblacion, superficie, continente) */

SELECT nombre, (poblacion * 1.0 / superficie)
FROM paises
WHERE continente LIKE 'A%';


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   productos (id_producto, nombre, categoria, precio, stock) */
SELECT nombre, precio, precio * 1.21 AS precio_con_iva
FROM productos
WHERE precio_con_iva > 1000;
/* razon del error  WHERE se ejecuta antes que SELECT, no tiene mapeado el aliasing por eso ocurre el error, en WHERE debemos colocar precio*1.21 > 1000*/


/* 2. Esta query no devuelve lo esperado: en vez de unir nombre y área en un
   solo texto, devuelve una columna numérica llena de ceros o NULLs.
   Explicá por qué pasa esto y cómo se soluciona en MySQL.
   empleados (id_empleado, nombre, area, salario) */
SELECT nombre + area AS nombre_completo
FROM empleados;
/* razon del error no es uan funcion de operadores matematicos, los textos no se concatenan con numeros*/


/* 3. Esta query calcula mal el total del pedido: multiplica el descuento por
   la cantidad antes de sumarlo, en vez de calcular primero el subtotal.
   Explicá por qué el resultado da distinto de lo esperado y cómo corregirla.
   pedidos (id_pedido, cliente, cantidad, precio_unitario, descuento, fecha_pedido) */
SELECT id_pedido, cliente, cantidad * precio_unitario - descuento * cantidad AS total
FROM pedidos;
/* razon del error debe ser cantidad * precio_unitario - descuento AS TOTAL*/