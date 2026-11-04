
-- MANEJO DE FECHAS EN MySQL

/* Fecha actual*/
SELECT CURDATE();          -- Solo fecha actual
SELECT CURRENT_DATE();     -- Igual que CURDATE()
SELECT DATE(NOW());        -- Extrae la fecha de la fecha-hora actual

/* Convertir cadena en fecha / extraer parte de fecha */
SELECT DATE('2023-05-15 13:45:00');        -- Devuelve: 2023-05-15

/* Extraer partes de una fecha con DATE_FORMAT() */

SELECT DATE_FORMAT('2023-05-15', '%Y');    -- Devuelve: 2023
SELECT DATE_FORMAT('2023-05-15', '%m')     -- Devuelve: 05
SELECT DATE_FORMAT('2023-05-15', '%d');    -- Devuelve: 15
SELECT DATE_FORMAT('2023-05-15', '%Y:%d'); -- Devuelve: 2023:15

/*  MySQL	Descripción
    %Y	    Año (4 dígitos)
    %m	    Mes (01-12)
    %d	    Día del mes (01-31)
    %H	    Hora (00-23)
    %i	    Minuto (00-59)
    %s o %S	Segundo (00-59)   */


-- EJERCICIOS BASICOS

/* 1. Mostrar el nombre de cada empleado junto con el año de su fecha de contratación,
      usando DATE_FORMAT().
   empleados (id_empleado, nombre, area, salario, fecha_contratacion) */

SELECT nombre, DATE_FORMAT(fecha_contratacion, '%Y')
FROM empleados;

/* 2. Mostrar el nombre de cada producto junto con el mes (numérico) de su fecha de ingreso.
   inventario (id_producto, nombre_producto, stock, fecha_ingreso) */

SELECT nombre_producto, DATE_FORMAT(fecha_ingreso, '%m')
FROM inventario;

/* 3. Mostrar el cliente y el día del mes en que se realizó cada venta.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

SELECT cliente, DATE_FORMAT(fecha_venta, '%d')
FROM ventas;

-- EJERCICIOS INTERMEDIOS

/* 1. Mostrar nombre y año de contratación (formateado) de los empleados del área 'Ventas'.
   empleados (id_empleado, nombre, area, salario, fecha_contratacion) */

SELECT nombre, DATE_FORMAT(fecha_contratacion, '%Y')
FROM empleados
WHERE area = 'Ventas';

/* 2. Mostrar cliente, total y fecha de venta formateada como 'DD/MM/YYYY',
      ordenado por el total de mayor a menor.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */

SELECT cliente, total, DATE_FORMAT(fecha_venta, '%d/%m/%Y')
FROM ventas
ORDER BY total DESC;

/* 3. Mostrar los productos cuyo nombre empiece con 'A', junto con el año de ingreso.
   inventario (id_producto, nombre_producto, stock, fecha_ingreso) */

SELECT nombre_producto, DATE_FORMAT(fecha_ingreso, '%Y')
FROM inventario
WHERE nombre_producto LIKE 'A%';

/* 4. Mostrar nombre y año de independencia (formateado) de los países cuyo continente
      esté en ('América', 'Europa').
   paises (id_pais, nombre, continente, poblacion, fecha_independencia) */

SELECT nombre, DATE_FORMAT(fecha_independencia, '%Y')
FROM paises
WHERE continente IN('América', 'Europa');

-- POR QUE NO FUNCIONA

/* 1. ¿Por qué falla esta query? Explicá el motivo y cómo corregirla.
   empleados (id_empleado, nombre, area, salario, fecha_contratacion) */
SELECT nombre, fecha_contratacion
FROM empleados
WHERE fecha_contratacion = NOW();
/* razon del error 
    el filtro WHERE fecha_contratacion = NOW(); hace que fecha de contratacion se iguale a la fecha-hora actual que es demasiado especifico, para encontrar alguna coincidencia tendria que contratarse a alguien y justo en ese mismo milisegundo activar la query. La solucion no la se, no se que se esta buscando.
*/

/* 2. Esta query corre sin error, pero el orden que devuelve es incorrecto.
      Explicá por qué y cómo corregirla.
   ventas (id_venta, cliente, categoria, total, fecha_venta) */
SELECT cliente, fecha_venta
FROM ventas
ORDER BY DATE_FORMAT(fecha_venta, '%d-%m-%Y');
/* razon del error 
    se invieerte el formato de busqueda YYYY-MM-DD por DD-MM-YYYY y los ordena por los dias de forma ascendente, el orden natural siempre es primero anio, luego mes y finalmente dia
    solucion, mostrar la columna en el formato deseado pero ordenarlo en el formato natural cronologico
SELECT cliente, DATE_FORMAT(fecha_venta, '%d-%m-%Y')
FROM ventas
ORDER BY fecha_venta DESC; dependiendo si quieren ver los registros mas recientes, sino cambiar a ASC
*/

/* 3. Esta query siempre devuelve cero filas, aunque hay productos ingresados en mayo.
      Explicá por qué y cómo corregirla.
   inventario (id_producto, nombre_producto, stock, fecha_ingreso) */
SELECT nombre_producto, fecha_ingreso
FROM inventario
WHERE DATE_FORMAT(fecha_ingreso, '%M') = 5;
/* razon del error 
    en el filtro WHERE DATE_FORMAT(fecha_ingreso, '%M') = 5; se esta igualanndo a un 5 numerico pero la funcion realmente devuelve un string
    solucion: cambiar 5 por '5' y cambiar '%M' por '%m'
*/





