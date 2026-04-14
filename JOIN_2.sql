#1 Кол-во мужчин и женщин, вывести в убывающем порядке
SELECT
    gender,
    COUNT(*) AS employees_count
FROM employees
GROUP BY gender 
ORDER BY employees_count DESC;

#2 Средняя ЗП по должностям
DROP temporary table if exists average_salaries;
CREATE temporary table average_salaries #Создаю временную таблицу с должностями и ЗП
SELECT 
	t.emp_no, 
	t.title, 
    s.salary 
FROM titles t
JOIN salaries s
ON t.emp_no = s.emp_no
WHERE t.to_date = '9999-01-01' AND s.to_date = '9999-01-01'; #беру только актульные должность и ЗП

SELECT * FROM average_salaries;
SELECT 
	title, 
	ROUND(AVG(salary), 2) AS ave_salary 
FROM average_salaries #беру данные из временной таблицы
GROUP BY title #Считаю среднюю зарплату по каждой должности
ORDER BY ave_salary DESC; #сортирую по убыванию 

#3 Кол-во нанятых сотрудников по месяцам
SELECT 
	MONTH(hire_date) AS hire_month, #извлекаю номер месяца из даты найма
	COUNT(emp_no) AS empoyees_count FROM employees #считаю кол-во сотрудников в каждом месяце
GROUP BY hire_month #группирую результаты по месяцу найма
ORDER BY hire_month; #сортирую месяцы по возрастанию

#4 
SELECT 
	e.first_name, 
    e.last_name, 
    d.dept_no, 
    dep.dept_name, 
    t.title #
FROM employees e
JOIN dept_emp d
ON e.emp_no = d.emp_no #соединяю сотрудников с их департаментами
AND d.to_date = '9999-01-01' #беру только текущий департамент
JOIN departments dep
ON d.dept_no = dep.dept_no #соединяю номера департаментов с их названиями
JOIN titles t
ON e.emp_no = t.emp_no #соединяю сотрудников с должностями
AND t.to_date = '9999-01-01' ; #беру только текущие должности

#5
SELECT 
	e1.first_name, 
    e1.last_name, 
    e2.first_name, 
    e2.last_name
FROM employees e1
JOIN employees e2
on e1.last_name = e2.last_name #соединяю сотрудников, у которых совпадает фамилия
AND e1.emp_no <> e2.emp_no #чтобы сотрудник не соединялся сам с собой
AND e1.emp_no < e2.emp_no; #чтобы не было зеркальных
