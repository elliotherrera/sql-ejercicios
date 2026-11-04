/*
CONCEPTO

La palabra clave LIKE se utiliza para comprobar las similitudes entre cadenas. Por ejemplo, si queremos obtener todos los registros cuyo nombre comienza con la letra a, entonces usaremos la palabra clave LIKE.

Se utilizan 2 comodines principales:
% significa cualquier cantidad de caracteres
_ significa exactamente un caracter


EJEMPLOS

%a   significa cualquier cadena que termine con a
a%   significa cualquier cadena que empiece con a
%a%  significa cualquier cadena que contenga a
_a%  significa que la letra a es el segundo caracter de la cadena
%a__ significa que la cadena contiene a en el tercer lugar desde el final

Para usarlo escribiremos: 
*/

SELECT col1, col2 ...
FROM table1
WHERE col1 LIKE '%a__'

/*
DESAFIO

Tablas y columnas disponibles:
people(id, name)

Obten todas las personas cuyo nombre comienza con k (mayuscula) 
y termina con a (minuscula) y ordena los resultados por los nombres en orden descendente
*/

SELECT *
FROM people
WHERE `name` LIKE 'K%a'
ORDER BY `name` DESC;

-- EJERCICIOS BASICOS

/* 1. Mostrá los clientes cuyo nombre empiece con la letra "M".
   clientes (id_cliente, nombre, ciudad, email) */

SELECT *
FROM clientes
WHERE nombre LIKE 'M%';

/* 2. Mostrá los productos cuya descripción contenga la palabra "acero" en cualquier parte del texto.
   productos (id_producto, descripcion, categoria, precio, stock) */

SELECT *
FROM productos
WHERE descripcion LIKE '%acero%';

/* 3. Mostrá los empleados cuyo email termine en "@gmail.com".
   empleados (id_empleado, nombre, area, email, salario) */

SELECT *
FROM empleados
WHERE email LIKE '%@gmail.com';


-- EJERCICIOS INTERMEDIOS

/* 1. Mostrá los países cuyo nombre contenga la palabra "land" y cuya población sea mayor a 5000000.
   paises (id_pais, nombre, continente, poblacion, capital) */

SELECT *
FROM paises
WHERE nombre LIKE '%land%' AND poblacion > 5000000;

/* 2. Mostrá los productos cuya categoría empiece con "Elect" y ordená el resultado por precio de forma descendente.
   productos (id_producto, descripcion, categoria, precio, stock) */

SELECT *
FROM productos
WHERE categoria LIKE 'Elect%'
ORDER BY precio DESC;

/* 3. Mostrá los clientes cuya ciudad no contenga la letra "a" y cuyo email sea distinto de NULL.
   clientes (id_cliente, nombre, ciudad, email) */

SELECT *
FROM clientes
WHERE ciudad NOT LIKE '%a%' AND email IS NOT NULL;

/* 4. Mostrá los primeros 5 empleados cuyo nombre contenga una "z" y cuya área esté entre "Marketing" y "Ventas" alfabéticamente.
   empleados (id_empleado, nombre, area, email, salario) */

SELECT *
FROM empleados
WHERE nombre LIKE '%z%' AND (area BETWEEN 'Marketing' AND 'Ventas')
LIMIT 5;


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   clientes (id_cliente, nombre, ciudad, email) */
SELECT nombre, ciudad
FROM clientes
WHERE ciudad LIKE 'Buenos Aires';
/* razon del error: LIKE debe ir acompañado con un comodin % o _ de lo contrario solo esta igualando*/

/* 2. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   productos (id_producto, descripcion, categoria, precio, stock) */
SELECT descripcion, precio
FROM productos
WHERE descripcion LIKE %madera%;
/* razon del error La similitud debe ir entre ''*/

/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   paises (id_pais, nombre, continente, poblacion, capital) */
SELECT nombre, capital
FROM paises
WHERE nombre LIKE 'A_';
/* razon del error El comodin _ solo indica un solo saracter despues de la A, no conozco un pais que contenga 2 caracteres que empiece con la A, en este caso debio colocar 'A%' */