#1 Вывести всю информацию из таблицы employees
SELECT * FROM employees;

#2 Вывести всех мужчин из таблицы employees
SELECT * FROM employees
WHERE gender = 'M';

#3 Вывести всех сотрудников по имени Elvis
SELECT * FROM employees
WHERE first_name = 'Elvis';

#4 Вывести уникальные/различные названия должностей
SELECT DISTINCT title FROM titles; 

#5 Вывести всех сотрудников, кто был трудоустроен в 2000 году 
SELECT * FROM employees
WHERE YEAR(hire_date) = 2000;

#6 Вывести всех сотрудников, кому больше 60 лет на данный момент 
SELECT * FROM employees 
WHERE timestampdiff(YEAR, birth_date, CURDATE()) > 60;

#7 Вывести количество строк в таблице salaries
SELECT count(*) FROM salaries;

#8 Вывести количество строк в таблице salaries, где зарплата > 100.000$
SELECT count(*) AS 'количество строк' FROM salaries
WHERE salary > 100000;
