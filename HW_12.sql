#1 Создание простого View
DROP VIEW IF EXISTS v_emp_1;
CREATE VIEW v_emp_1 AS
SELECT first_name, last_name FROM employees; 

#2 View с JOIN
DROP VIEW IF EXISTS v_emp_2;
CREATE VIEW v_emp_2 AS 
SELECT e.emp_no, e.first_name, e.last_name, s.salary FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01';
SELECT * from v_emp_2;

#3 View для агрегированных данных
DROP VIEW IF EXISTS v_salaries_3;
CREATE VIEW v_salaries_3 AS SELECT 
	de.dept_name, 
	AVG(s.salary) AS 'avg_salary' #посчитать среднюю ЗП по департаментам
FROM dept_emp d
JOIN departments de  #чтобы вместо номеров департаментов, были названия
ON d.dept_no = de.dept_no
JOIN salaries s
ON d.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01' AND d.to_date = '9999-01-01' #беру только текущие ЗП и департаменты
GROUP BY d.dept_no; #среднюю считаю по департаментам

SELECT * FROM v_salaries_3;

#4 Комбинированный View с JOIN и WHERE
DROP VIEW IF EXISTS v_info_4;
CREATE VIEW v_info_4 AS
SELECT 
	e.*, #в задании написано вывести информацию о сотрудниках, но я не уверена какую именно информацию, вывожу все данные 
    s.salary #и еще их ЗП, потому что в задании надо использовать JOIN
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01' #только текущие ЗП
AND e.emp_no IN ( #взять айди только из списка ниже
SELECT emp_no FROM dept_emp
WHERE 
	to_date = '9999-01-01' #нужны только текущие работники 
	AND dept_no IN (
		SELECT dept_no FROM departments
		WHERE dept_name = 'Sales') #возьму сотрудников только из отедла Sales
);

SELECT * FROM v_info_4;

