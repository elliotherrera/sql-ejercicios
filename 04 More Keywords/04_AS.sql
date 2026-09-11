
-- LA PALABRA CLAVE AS

/* Para cambiar los nombres de las columnas, usa la palabra AS: */

SELECT col1 AS firstColumn, col2 AS secondColumn
FROM table1;

/*
DESAFIO

Tablas y columnas disponibles:
kitchen_items: (cutlery, amount)

Obten todos los articulos de cocina cuya amount sea inferior a 3 articulos. Cambia el nombre de la columna de cubiertos a silverware
*/

SELECT cutlery AS silverware, amount
FROM kitchen_items
WHERE amount < 3;

-- EJERCICIOS BASICOS

/* 1. Mostrar el nombre del producto y el precio unitario, pero renombrando las columnas como "Producto" y "Precio".
   ventas (id_venta, producto, categoria, precio_unitario, cantidad, fecha) */

SELECT producto AS Producto, precio_unitario AS Precio
FROM ventas;

/* 2. Mostrar todos los datos de la tabla empleados, pero usando un alias de tabla "emp" en la cláusula FROM.
   empleados (id_empleado, nombre, apellido, departamento, salario, fecha_contratacion) */

SELECT emp.*
FROM empleados AS emp;

/* 3. Calcular el valor total del stock (precio * stock) para cada producto y mostrar el resultado con el alias "valor_inventario".
   productos (id_producto, nombre, stock, precio, proveedor) */

SELECT nombre, (precio * stock) AS valor_inventario
FROM productos;


-- EJERCICIOS INTERMEDIOS

/* 1. Mostrar el nombre, apellido y salario anual (salario * 12) de los empleados del departamento 'Ventas', renombrando la columna calculada como "salario_anual".
   empleados (id_empleado, nombre, apellido, departamento, salario, fecha_contratacion) */

SELECT nombre, apellido, (salario * 12) AS salario_anual
FROM empleados
WHERE departamento = 'Ventas';

/* 2. Mostrar el nombre del producto, la categoría y la ganancia (precio_unitario * cantidad) de cada venta, renombrando la ganancia como "ingreso". Ordenar los resultados de mayor a menor ingreso.
   ventas (id_venta, producto, categoria, precio_unitario, cantidad, fecha) */

SELECT producto, categoria, (precio_unitario * cantidad) AS ingreso
FROM ventas
ORDER BY ingreso DESC;

/* 3. Listar el nombre del país y su población, renombrando la columna población como "habitantes". Filtrar solo los países cuyo continente esté en ('Europa', 'Asia').
   paises (id_pais, nombre, continente, poblacion, superficie) */

SELECT nombre, poblacion AS habitantes
FROM paises
WHERE continente IN ('Europa', 'Asia');


/* 4. Mostrar el nombre del producto, el proveedor y el stock, renombrando la tabla productos como "p" en la cláusula FROM. Filtrar solo aquellos productos cuyo nombre comience con 'A'.
   productos (id_producto, nombre, stock, precio, proveedor) */

SELECT p.nombre, p.proveedor, p.stock
FROM productos AS p
WHERE p.nombre LIKE 'A%';


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, apellido, departamento, salario) */
SELECT nombre, salario AS sueldo
FROM empleados
WHERE sueldo > 30000;
/* razon del error Error en el orden logico, primero ocurre le WHERE antes del SELECT, por lo que HWERE no reconoce sueldo, en este caso tendriamos que colocar salario > 30000*/

/* 2. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   ventas (id_venta, producto, categoria, precio_unitario, cantidad, fecha) */
SELECT v.producto, v.categoria
FROM ventas AS v
WHERE v.fecha > '2025-01-01'
ORDER BY ventas.precio_unitario DESC;
/* razon del error  La parte que no funciona es ventas.precio_unitario, debe ser v.precio_unitario*/

/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   productos (id_producto, nombre, stock, precio, proveedor) */
SELECT nombre AS producto, stock AS existencia
FROM productos
WHERE existencia < 10
   AND precio > 100;
/* razon del error Igual que en la 1, el orden logico es incorrecto, deberiamos poner WHERE stock < 10 AND precio > 100*/

-- Orden Logico FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

-- Dato extra que te puede servir: esta regla tiene una excepción parcial en MySQL: el ORDER BY sí puede usar alias del SELECT (porque se ejecuta después), y el HAVING también los acepta en MySQL (aunque no es estándar SQL). El WHERE es el que nunca los acepta, en ningún motor.