-- ------------------------
-- Palabra clave BETWEEN
-- ------------------------

-- CONCEPTO

-- Hasta ahora hemos aprendido a usar mayor que > y menor que < para exigir un rango en un campo. Pero hay otra forma.

-- En lugar de escribir:

WHERE col1 >= 5 AND col1 <= 10

-- Podemos escribir

WHERE col1 BETWEEN 5 AND 10

-- El operador BETWEEN es inclusivo, lo que significa que incluye los valores  (en este caso, 5 y 10) en los resultados. Esto hace que tus consultas SQL sean mas limpias y legibles, especialmente cuando se trabaja con rangos de fechas o intervalos numericos.


-- DESAFIO

-- data (value)
-- Obten todos los registros donde la columna value este entre 7 y 13.

SELECT *
FROM `data`
WHERE `value` BETWEEN 7 AND 13;


-- EJERCICIOS BASICOS

-- 1. Mostrá los datos de las ventas cuyo precio unitario esté entre 500 y 1500.
-- ventas (id_venta, producto, categoria, precio, cantidad, fecha_venta)

SELECT *
FROM ventas
WHERE precio BETWEEN 500 AND 1500;

-- 2. Listá los empleados cuyo salario esté entre 300000 y 600000.
-- empleados (id_empleado, nombre, departamento, salario, fecha_contratacion)

SELECT nombre
FROM empleados
WHERE salario BETWEEN 300000 AND 600000;

-- 3. Obtené los países cuya población esté entre 5000000 y 50000000.
-- paises (id_pais, nombre, continente, poblacion, superficie, pib_per_capita)

SELECT nombre
FROM paises
WHERE poblacion BETWEEN 5000000 AND 50000000;

-- EJERCICIOS INTERMEDIOS

--4. (BETWEEN + ORDER BY)
--Mostrá los productos con stock entre 10 y 100 unidades, ordenados de mayor a menor precio unitario.
--productos (id_producto, nombre, categoria, stock, precio_unitario, fecha_ingreso)

SELECT nombre
FROM productos
WHERE stock BETWEEN 10 AND 100
ORDER BY precio_unitario DESC;

--5. (BETWEEN + JOIN)
--Listá las ventas realizadas entre el '2024-01-01' y el '2024-06-30' junto con el nombre y la ciudad del cliente que las hizo.
--ventas (id_venta, id_cliente, producto, precio, cantidad, fecha_venta)
--clientes (id_cliente, nombre, ciudad, fecha_registro)

SELECT cantidad
FROM ventas AS v
LEFT JOIN clientes AS c
    ON  v.id_cliente = c.id_cliente
WHERE fecha_venta BETWEEN '2024-01-01' AND '2024-06-30';

--6. (BETWEEN + GROUP BY / funciones de agregación)
--Para cada departamento, mostrá la cantidad de empleados y el salario promedio, considerando solo a los empleados cuyo salario esté entre 250000 y 800000.
--empleados (id_empleado, nombre, id_departamento, salario, fecha_contratacion)



--7. (BETWEEN + LIKE / IN)
--Obtené los países cuyo nombre empiece con la letra "A" y cuya superficie esté entre 100000 y 2000000 km².
--paises (id_pais, nombre, continente, poblacion, superficie, pib_per_capita)


