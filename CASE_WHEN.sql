#1 Статус сотрудника
SELECT 
	emp_no, 
	first_name, 
	timestampdiff(YEAR, hire_date, curdate()) AS 'Years of work',
	IF(timestampdiff(YEAR, hire_date, curdate()) > 30, 'Veteran Employee', 'New Employee') AS 'status'
FROM employees;

#2 Возраст сотрудников
SELECT 
	first_name, 
	last_name,
    timestampdiff(YEAR, birth_date, curdate()) AS 'Current age',
	IF(timestampdiff(YEAR, birth_date, curdate()) > 63, 'Пенсионер', 'Активный сотрудник') AS 'status'
FROM employees;

#3 CASE WHEN
SELECT 
	first_name, 
	last_name,
    timestampdiff(YEAR, birth_date, curdate()) AS 'Current age',
	CASE 
		WHEN timestampdiff(YEAR, birth_date, curdate()) > 50 THEN 'старший'
		WHEN timestampdiff(YEAR, birth_date, curdate()) > 30 THEN 'средний'
		ELSE 'молодой'
    END AS 'Age classification'
FROM employees;

#4 Первая буква A или B
SELECT * FROM employees
WHERE first_name REGEXP '^[AB]';

#5 IFNULL salary
SELECT 
	first_name, 
	department_id, 
	ifnull(salary, 'Unknown') AS 'salary' 
FROM employees; 

#6 COALESCE
SELECT 
	first_name, 
	department_id, 
	COALESCE(salary, default_salary, 25000) AS 'salary' 
FROM employees; 
