#1 Найдите всех сотрудников, которые работали как минимум в 2 департаментах
SELECT 
    e.first_name,
    e.last_name
FROM employees e
WHERE e.emp_no IN (
    SELECT d.emp_no
    FROM dept_emp d
    GROUP BY d.emp_no
    HAVING COUNT(DISTINCT d.dept_no) >= 2 #нахожу сотрудников, работавших в 2 или больше департаментах
)
ORDER BY e.first_name, e.last_name;

#2 Вывести имя, фамилию и зарплату самого высокооплачиваемого сотрудника
SELECT e.first_name, e.last_name, s.salary 
FROM employees e
JOIN salaries s #использую JOIN чтобы вывести и фамилию/имя и ЗП
ON e.emp_no = s.emp_no 
WHERE s.salary = (
	SELECT MAX(salary) FROM salaries) # нахожу самое большое число в колонке ЗП
	AND s.to_date = '9999-01-01'; #проверяю актуальность

#3 Выбирть названия всех отделов, в которых работает более 100 сотрудников
SELECT dept_name FROM departments
WHERE dept_no IN (
	SELECT dept_no FROM dept_emp
	GROUP BY dept_no #группирую данные по номерам отделов
	HAVING COUNT(distinct emp_no) > 100
); #оставляю только те отделы, где кол-во сотрудников больше 100

#4 Имена и фамилии всех сотрудников, которые никогда не были менеджерами
SELECT first_name, last_name FROM employees
WHERE emp_no NOT IN (
    SELECT emp_no FROM titles 
    WHERE title LIKE '%Manager%'
);

#5 для каждого отдела вывести сотрудников, получающих наибольшую зарплату в этом отделе
SELECT
    d.dept_name,
    e.first_name,
    e.last_name,
    s.salary
FROM departments d
JOIN dept_emp de
    ON d.dept_no = de.dept_no
    AND de.to_date = '9999-01-01'
JOIN salaries s
    ON de.emp_no = s.emp_no
    AND s.to_date = '9999-01-01'
JOIN employees e
    ON e.emp_no = de.emp_no
WHERE (de.dept_no, s.salary) IN (
    SELECT
        de2.dept_no,
        MAX(s2.salary)
    FROM dept_emp de2
    JOIN salaries s2
        ON de2.emp_no = s2.emp_no
    WHERE de2.to_date = '9999-01-01'
      AND s2.to_date = '9999-01-01'
    GROUP BY de2.dept_no
)
ORDER BY d.dept_name;

#6 названия отделов, где средняя ЗП выше общей средней ЗП по компании.
SELECT
    d.dept_name
FROM departments d
JOIN dept_emp de
    ON d.dept_no = de.dept_no
    AND de.to_date = '9999-01-01'
JOIN salaries s
    ON de.emp_no = s.emp_no
    AND s.to_date = '9999-01-01'
GROUP BY d.dept_name
HAVING AVG(s.salary) > (
    SELECT AVG(s2.salary)
    FROM salaries s2
    WHERE s2.to_date = '9999-01-01'
);