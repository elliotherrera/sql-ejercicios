
-- UNION BASICA PARTE 1

/* Hasta ahora, hemos abordado problemas de una sola tabla. Ahora examinaremos cómo trabajar con múltiples tablas.

Supongamos que tenemos las siguientes tablas:

courses

course_id--|--lecturer_id
-----1-----|-----1-------
-----2-----|-----1-------
-----3-----|-----2-------

profesores

lecturer_id--|--nombre
-------1-----|--Jhonas
-------2-----|--Malidos

La tarea es presentar cada curso con el nombre del lecturer correspondiente.

Hay dos formas de lograrlo. Para cada opción, hacemos coincidir cada row de una tabla con la otra. Comprobamos una condición que debe cumplirse y, si se cumple, combinamos las dos filas en una sola. El resultado deseado para both opciones:

course_id--|--lecturer_name

-----1-----|--Jhonas
-----2-----|--Jhonas
-----3-----|--Malidos

Opción 1: */

SELECT courses.course_id, lecturers.name AS lecturer_name
FROM courses, lecturers
WHERE courses.lecturer_id = lecturers.lecturer_id


/* Aquí escribimos dos tablas en la palabra clave FROM y, en la cláusula WHERE, solicitamos que el lecturer_id de ambos registros sea el mismo. En la cláusula SELECT, ahora escribimos table.column para que la base de datos sepa de dónde obtener la columna. */

/* Opción 2: */

SELECT courses.course_id, lecturers.name AS lecturer_name
FROM courses
JOIN lecturers ON courses.lecturer_id = lecturers.lecturer_id

/* En lugar de WHERE usamos JOIN table ON condition

Este tipo de combinación también se denomina combinación interna. */

-- DESAFIO

/* Tablas y columnas disponibles:
    grades: course_id, student_id, grade

students: id, name
Crea una consulta que obtenga student_name, course_id, student_id y grade en una sola tabla. Ordena el resultado por grade en orden ascendente. */

SELECT name as student_name, course_id, student_id, grade
FROM students, grades
WHERE students.id = grades.student_id
ORDER BY grade

