#1 Inner join
SELECT 
	m.emp_no, #номер сотрудника-менеджера
	m.dept_no, #номер департамента менеджера
	e.first_name, #имя менеджера
	e.last_name, #фамилия менджера
	e.hire_date #дата найма
FROM dept_manager m 
JOIN employees e #обьядиняю две таблицы
ON m.emp_no = e.emp_no; #связываю менеджера с его данными по номеру сотрудника

#2 Markovitch, который когда-то был менеджером департамента
SELECT 
	t.emp_no, 
	e.last_name
FROM titles t #беру таблицу с историей должностей так как нужно искать не текущих менеджеров а тех, кто когда-либо был менеджером
JOIN employees e #таблица с фамилиями сотрудников, чтобы найти фамилию Markovitch
ON t.emp_no = e.emp_no
WHERE t.title LIKE 'Manager' AND e.last_name = 'Markovitch'; #отбираем только должности "Manager" и с фамилией Markovitch

#3 текущая должность, имя начинается на М, а фамилия заканчивается на H
SELECT 
	e.emp_no,
	e.first_name, 
    e.last_name, 
    e.hire_date, 
    t.title
FROM employees e
JOIN titles t
ON e.emp_no = t.emp_no
WHERE (e.first_name LIKE 'M%' AND e.last_name LIKE '%N') 
AND t.to_date = '9999-01-01'; #беру только текущую должность

#4 max/min ЗП сотрудников
DROP temporary TABLE IF EXISTS salaries_temp; #чтобы избежать ошибки при создании новой
CREATE temporary table salaries_temp # создаю временную таблицу 
SELECT 
	emp_no, 
	MAX(salary) AS max_salary, #максимальная зп сотрудника
	MIN(salary) AS min_salary FROM salaries #минимальная зп сотрудника
GROUP BY emp_no; #группируем по сотруднику чтобы не искать общие max/min

SELECT e.emp_no, e.first_name, e.last_name, s.max_salary, s.min_salary
FROM employees e
JOIN salaries_temp s
ON e.emp_no = s.emp_no; #соединяем основную с временной таблицей
