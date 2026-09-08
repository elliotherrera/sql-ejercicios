-- Timmy & Sarah think they are in love, but around where they live, they will only know once they pick a flower each. If one of the flowers has an even number of petals and the other has an odd number of petals it means they are in love.

-- Write a function that will take the number of petals of each flower and return true if they are in love and false if they aren't.

-- # write your SQL statement here: you are given a table 'love' with columns 'flower1' and 'flower2', return a table with columns ('flower1' and 'flower2') and your result in a column named 'res

SELECT table1, table2, (table1 % 2 != table2 % 2) AS res
FROM love;