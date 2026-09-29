
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

