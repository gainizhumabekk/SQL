#1 hire_date в годах, и количество сотрудников, которых наняли в эти года
SELECT 
	YEAR(hire_date) AS hiring_year, 
	COUNT(*) AS hired_number
FROM employees
GROUP BY hiring_year
ORDER BY hiring_year; 

#2 dept_no и рядом количество сотрудников
SELECT 
	dept_no,
	COUNT(DISTINCT emp_no) AS employees_count 
FROM dept_emp
GROUP BY dept_no;

#3 birth_date и количество сотрудников, которые родились в эти дни
SELECT 
	birth_date, 
    COUNT(*) AS employees_count
FROM employees
GROUP BY birth_date
HAVING birth_date != '1952-02-13' AND employees_count > 60
ORDER BY employees_count DESC
LIMIT 20;

#4 
SELECT 
	first_name, 
	COUNT(*) AS employees_count 
FROM employees
WHERE first_name LIKE 'A%'
GROUP BY first_name
HAVING employees_count > 250
ORDER BY employees_count DESC
LIMIT 10; #Выдает только 8 сотрудников так как 9-ый имеет count 249

#5 Создать копию с именами на B
CREATE TABLE employees_copy
SELECT * FROM employees
WHERE first_name LIKE 'B%';

# Удалить имена на B в оригинальной таблице
DELETE FROM employees
WHERE first_name LIKE 'B%';

# Вставить имена обратно из копии
INSERT INTO employees
SELECT *
FROM employees_copy;

# очистить копию таблицы 
DELETE FROM employees_copy;

# удалить копию
DROP TABLE employees_copy;
