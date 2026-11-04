 -- DESAFIO - Elección parlamentaria

/*
Tablas y columnas disponibles:
ministers: (seat, is_next_gov, is_spoke_bad)

Todo ministro que ocupa un seat con número par en el gobierno se considera un ministro «seguro». Tu tarea es devolver todos los seats de los ministros «seguros» que quieren seguir prestando servicio en el próximo gobierno, excluyendo a cualquier ministro que haya pronunciado una mala palabra.

El resultado debe contener únicamente los seats relevantes.

Antes de comenzar a resolver el desafío, observa los datos de la tabla. No están limpios. Las columnas is_next_gov y is_spoke_bad contienen unos y ceros, y también yes y no. */

SELECT seat
FROM ministers
WHERE (seat % 2 = 0) AND
    (is_next_gov IN (1, 'yes')) AND
    (is_spoke_bad IN (0, 'no'));


-- DESAFIO - Detención policial de un criminal

/* Tablas y columnas disponibles:

police_report: (name, report, map, severe_score)

Obtén los 5 nombres de criminales más graves y ordénalos por severe_score en orden descendente
Un criminal grave es alguien que cumple todos los criterios siguientes:

report es null o report contiene una de las siguientes letras: g, b, G o B.
map es uno de los siguientes lugares: Caerleon, Dewsbury, Kirkwall, Findochty.
Nombra la columna como worst_criminals.
*/

SELECT name AS worst_criminals
FROM police_report
WHERE (report IS NULL OR report LIKE '%g%' OR report LIKE '%b%' OR report LIKE '%G%' OR report LIKE '%B%') AND
    map IN ('Caerleon', 'Dewsbury', 'Kirwall', 'Findochty')
ORDER BY severe_score DESC
LIMIT 5;


-- DESAFIO - Recipiente de bebida de bar

/* Tablas y columnas disponibles:

Tu bar tiene una gran variedad de zumos y necesitas identificar cuáles requieren atención. Identifica y ordena estos zumos según los siguientes criterios claros:

    1. Old Expired Juices
        - Zumos cuyo año de caducidad sea MÁS de 6 años anterior al año actual (current_year - expiration_year > 6)
        - Estos deben reciclarse inmediatamente
    2. Almost Expired Juices
        - Zumos que caducan en el año actual
        - O zumos que caducan el próximo año (expiration_year = current_year + 1)
        - Estos deben enviarse para su renovación

Sigue estos pasos:

- Extrae los identificadores de los zumos que cumplan cualquiera de estos criterios
- Cambia el nombre de la columna de identificadores a 'to_renew'
- Ordena los resultados según la prioridad de procesamiento:
    - Los más urgentes primero (los zumos caducados hace más tiempo)
    - Después, los zumos a punto de caducar
    - Usa (current_year - expiration_year) para ordenar
*/

SELECT id AS to_renew
FROM beverages
WHERE  (current_year - expiration_year > 6) OR (expiration_year = current_year + 1) OR (expiration_year = current_year)
ORDER BY current_year - expiration_year DESC;


-- DESAFIO - Ingeniería de nuevas columnas

/*
Tablas y columnas disponibles:

items: (id)

Se define una función cuártica:

f(x) = ax4+bx3+cx2+dx+e

Definamos los parámetros constantes:

a = 3
b = 5
c = 0.9
d = 2.2
e = 1

Obtén los identificadores y la función cuártica donde x es el identificador, y cambia el nombre de la columna a quartic
*/

SELECT id, (3*id*id*id*id + 5*id*id*id + 0.9*id*id +2.2*id + 1) AS quartic
FROM items;




