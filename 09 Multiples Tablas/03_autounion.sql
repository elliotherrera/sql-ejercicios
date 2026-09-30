
-- AUTOUNION

/* Las autocombinaciones son un tipo diferente de combinacion. Hasta ahora, hemos
hablado de combinaciones de varias tablas, pero las autocombinaciones se realizan
con la misma tabla. Un ejemplo clasico seria una tabla de empleados 

employee_id--|--employee_name--|--manager_id
------1------|------Minke------|-----2------
------2------|------Temur------|-----3------
------3------|-----Tatjana-----|-----4------
------4------|-----Marinela----|------------ 

Cada empleado tiene un manager excepto el manager de mas alto nivel, y cada
manager tambien es un empleado

El problema: Para cada empleado queremos conocer el nombre del manager*/

SELECT e2.employee_id, e2.employee_name, e1.employee_name as manager_name
FROM employees as e1
JOIN employees as e2 
    ON e1.employee_id = e2.manager_id

/* Hacemos una union entre la misma tabla, excepto que una vez la llamamos e1
y la segunda vez es e2. La union se realiza entre los campos 
employee_id y manager_id. El resultado:

employee_id--|--employee_name--|--manager_name--
------1------|------Minke------|-----Temur------
------2------|------Temur------|----Tatjana-----
------3------|-----Tatjana-----|----Marinela----  */


-- DESAFIO

/*  Tablas y columnas disponibles:
    friends: id, name, friend_id

Encuentra pares de amigos que sean amigos mutuos (existe amistad mutua 
cuando el friend_id de la persona A apunta a la persona B Y el friend_id 
de la persona B apunta a la persona A). Muestra los nombres de ambos amigos
en una sola fila. Nombra las columnas friend1 y friend2.

Nota: Incluye en la cláusula WHERE el criterio friend1.id < friend2.id para
que no incluya pares duplicados 

friends:

id	name	    friend_id
15	Alkeides	17
16	Hardwin	    26
17	Myles	    15
18	Davinia	    24
19	Janina	    22
20	Sizwe	    29
21	Ryu	        20
22	Celmente	18
23	Alda	    20
24	Benja	    26
25	Valeria	    17
26	Urmas	    27
27	Fikri	    26
28	Dulcie	    16
29	Janis	    20   */


SELECT f1.name AS friend1, f2.name AS friend2
FROM friends AS f1
JOIN friends AS f2 
    ON f1.friend_id = f2.id
-- Mantén solo los pares que se apuntan mutuamente
WHERE f1.id = f2.friend_id AND f1.id < f2.id;


/*
Para cada persona de la tabla friends, encuentra todas las conexiones de amigos de
amigos que tenga. Una conexión de amigo de un amigo ocurre cuando la persona A es 
amiga de la persona B, que a su vez es amiga de la persona C. Enumera estas conexiones 
en tres columnas:

friend1: la persona inicial
friend2: su amiga directa
friend3: la amiga de su amiga
Reglas:

No incluyas los casos en los que friend3 sea la misma persona que friend1
Ordena los resultados por el nombre de friend1 en orden descendente
Ejemplo: si Alice es amiga de Bob y Bob es amigo de Carol, entonces Alice-Bob-Carol 
sería una conexión válida de amigo de un amigo.

friends:

id	name	  friend_id
15	Alkeides  25
16	Hardwin	  20
17	Myles	  15
18	Davinia	  19
19	Janina	  18
20	Sizwe	  29
21	Ryu	      20
22	Celmente  18
23	Alda	  20
24	Benja	  26
25	Valeria	  26
26	Urmas	  25
27	Fikri	  19
28	Dulcie	  29
29	Janis	  20   */


SELECT f1.name AS friend1, f2.name AS friend2, f3.name AS friend3
FROM friends AS f1
JOIN friends AS f2
    ON f1.friend_id = f2.id
JOIN friends AS f3
    ON f2.friend_id = f3.id
WHERE f1.name != f3.name
ORDER BY friend1 DESC;




-- EJERCICIOS BASICOS

/* 1. Mostrá el nombre de cada empleado junto al nombre de su jefe directo.
   Nombrá las columnas empleado y jefe.
   empleados (id_empleado, nombre, area, salario, id_jefe) */

SELECT e1.nombre AS empleado, e2.nombre AS jefe
FROM empleados AS e1
JOIN empleados AS e2
    ON e1.id_jefe = e2.id_empleado;

/* 2. Mostrá cada subcategoría con el nombre de su categoría padre.
   Nombrá las columnas subcategoria y categoria_padre.
   categorias (id_categoria, nombre, id_categoria_padre) */

SELECT c1.nombre AS subcategoria, c2.nombre AS categoria_padre
FROM categorias AS c1
JOIN categorias AS c2
    ON c1.id_categoria_padre = c2.id_categoria;

/* 3. Mostrá el nombre de cada cliente junto al nombre del cliente que lo refirió.
   Nombrá las columnas cliente y referente.
   clientes (id_cliente, nombre, pais, id_referente, fecha_alta) */

SELECT c1.nombre AS cliente, c2.nombre AS referente
FROM clientes AS c1
JOIN clientes AS c2
    ON c1.id_referente = c2.id_cliente;


-- EJERCICIOS INTERMEDIOS

/* 1. Encontrá los empleados que ganan más que su jefe directo. Mostrá el nombre
   del empleado, su salario, el nombre del jefe, el salario del jefe y la
   diferencia entre ambos salarios (nombrala diferencia). Ordená por diferencia
   de mayor a menor.
   empleados (id_empleado, nombre, area, salario, id_jefe) */

SELECT 
    e1.nombre AS empleado,
    e1.salario AS salario_empleado, 
    e2.nombre AS jefe, 
    e2.salario AS salario_jefe, 
    (e1.salario - e2.salario) AS diferencia
FROM empleados AS e1
JOIN empleados AS e2
    ON e1.id_jefe = e2.id_empleado
WHERE e1.salario > e2.salario
ORDER BY diferencia DESC;

/* 2. Listá las categorías padre que tengan 2 o más subcategorías directas.
   Mostrá el nombre de la categoría padre y la cantidad de subcategorías
   (nombrala cant_subcategorias). Ordená por cantidad de mayor a menor.
   categorias (id_categoria, nombre, id_categoria_padre) */

SELECT
    p.nombre AS nombre_padre,
    COUNT(*) AS cant_subcategorias
FROM categorias AS h
JOIN categorias AS p
    ON h.id_categoria_padre = p.id_categoria
GROUP BY p.id_categoria, p.nombre
HAVING COUNT(*) >= 2
ORDER BY cant_subcategorias DESC;

/* 3. Encontrá los pares de clientes del mismo país que se dieron de alta con
   30 días o menos de diferencia entre sí. Mostrá ambos nombres, el país y
   la cantidad de días de diferencia (nombrala dias_diferencia). Evitá pares
   repetidos y clientes emparejados consigo mismos.
   clientes (id_cliente, nombre, pais, id_referente, fecha_alta) */

SELECT
    c1.nombre AS cliente1,
    c2.nombre AS cliente2,
    c1.pais,
    ABS(c2.fecha_alta - c1.fecha_alta) AS dias_diferencia
FROM clientes AS c1
JOIN clientes AS c2
    ON c1.pais = c2.pais
WHERE c1.id_cliente < c2.id_cliente AND 
    ABS(c2.fecha_alta - c1.fecha_alta) <= 30
ORDER BY dias_diferencia;

/* 4. Encontrá las conexiones con una escala: un vuelo de A a B seguido de un
   vuelo de B a C, donde C sea distinto de A y la duración total sea menor a
   300 minutos. Mostrá origen, escala, destino y la duración total (nombrala
   duracion_total). Ordená por duración total de mayor a menor y quedate con
   las 5 primeras.
   vuelos (id_vuelo, origen, destino, duracion_min, aerolinea) */

SELECT
    v1.origen as origen,
    v1.destino as escala,
    v2.destino as destino,
    (v1.duracion_min + v2.duracion_min) as duracion_total
FROM vuelos as v1
JOIN vuelos as v2
    ON v1.destino = v2.origen
WHERE v1.origen != v2.destino AND
    (v1.duracion_min + v2.duracion_min) < 300
ORDER BY duracion_total DESC
LIMIT 5;


-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, area, salario, id_jefe) */
SELECT nombre, nombre
FROM empleados
JOIN empleados
    ON id_jefe = id_empleado;
/* razon del error 
    Le hace falta los aliasing, este problema cae en ambiguedad. la solucion:
SELECT e1.nombre, e2.nombre
FROM empleados as e1
JOIN empleados as e2
    ON e1.id_jefe = e2.id_empleado;
*/


/* 2. Esta query se ejecuta sin errores, pero no devuelve lo que se pidió
   (cada subcategoría con su categoría padre). ¿Qué devuelve realmente?
   Explicá el motivo y cómo corregirla.
   categorias (id_categoria, nombre, id_categoria_padre) */
SELECT c.nombre AS subcategoria, p.nombre AS categoria_padre
FROM categorias AS c
JOIN categorias AS p
    ON c.id_categoria = p.id_categoria_padre;
/* razon del error 
    EN ON los roles padre-hijo estan invertidos, solucion:
SELECT c.nombre AS subcategoria, p.nombre AS categoria_padre
FROM categorias AS c
JOIN categorias AS p
    ON c.id_categoria_padre = p.id_categoria ;
*/


/* 3. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   clientes (id_cliente, nombre, pais, id_referente, fecha_alta) */
SELECT c.nombre AS cliente, r.nombre AS referente
FROM clientes AS c
JOIN clientes AS r
    ON c.id_referente = r.id_cliente
WHERE referente = 'Lucia';
/* razon del error 
    El Where se aplica antes del SELECT pro lo que no reconoce el aliasing, solucion:
SELECT c.nombre AS cliente, r.nombre AS referente
FROM clientes AS c
JOIN clientes AS r
    ON c.id_referente = r.id_cliente
WHERE r.nombre = 'Lucia';
*/


/* 4. Se quieren obtener los pares de clientes del mismo país, sin repetir.
   La query corre, pero devuelve cada par duplicado. ¿Por qué pasa?
   Explicá el motivo y cómo corregirla.
   clientes (id_cliente, nombre, pais, id_referente, fecha_alta) */
SELECT c1.nombre AS cliente1, c2.nombre AS cliente2, c1.pais
FROM clientes AS c1
JOIN clientes AS c2
    ON c1.pais = c2.pais
WHERE c1.id_cliente != c2.id_cliente;
/* razon del error 
    la comparacion por id debemos calcularla con un < para que no se repita
SELECT c1.nombre AS cliente1, c2.nombre AS cliente2, c1.pais
FROM clientes AS c1
JOIN clientes AS c2
    ON c1.pais = c2.pais
WHERE c1.id_cliente < c2.id_cliente;
*/













