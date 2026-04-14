#1 Объединение сотрудников и менеджеров
SELECT emp_no FROM employees
WHERE gender = 'M' #только сотрудники мужского пола
UNION #если сотрудник мужчина и менеджер, он будет показан только один раз
SELECT emp_no FROM dept_manager;

#2 Список уникальных должностей и отделов
SELECT DISTINCT(title) AS 'titles and deps' FROM titles #уникальные названия должностей
UNION #без дубликатов
SELECT DISTINCT(dept_name) AS 'titles and deps' FROM departments; #уникальные названия отделов

#3 Сотрудники с зарплатами выше и ниже среднего
SELECT e.first_name, s.salary FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
WHERE s.salary > 60000 AND s.to_date = '9999-01-01' #беру только текущую ЗП и выше 60К
UNION
SELECT e.first_name, s.salary FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
WHERE s.salary < 40000 AND s.to_date = '9999-01-01'; ##беру только текущую ЗП и ниже 40К

#4 Объединение текущих и бывших сотрудников
SELECT first_name, last_name, 'Текущий' AS status FROM employees
WHERE emp_no IN (
SELECT emp_no FROM salaries
WHERE to_date = '9999-01-01') #берем только тех, у кого текущая ЗП
UNION
SELECT first_name, last_name, 'Бывший' AS status FROM employees
WHERE emp_no NOT IN ( #берет тех, у кого нет текущей ЗП, значит бывшие сотрудники
SELECT emp_no FROM salaries
WHERE to_date = '9999-01-01'); 

#5 Сравнение зарплат менеджеров и обычных сотрудников
SELECT 'Мендежер' AS type, AVG(salary) AS 'avg_salary' FROM salaries
WHERE emp_no IN ( #беру только сотрудников из таблицы менеджеров
	SELECT emp_no FROM dept_manager) 
	AND to_date = '9999-01-01' #беру только текущие ЗП
GROUP BY type
UNION
SELECT 'Обычный сотрудник' AS type, AVG(salary) AS 'avg_salary'FROM salaries
WHERE emp_no NOT IN ( #беру всех сотрудников кроме менеджеров
	SELECT emp_no FROM dept_manager) 
    AND to_date = '9999-01-01' #беру только текущие ЗП
GROUP BY type; 

