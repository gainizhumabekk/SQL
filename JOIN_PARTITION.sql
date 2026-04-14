#1 Определение наивысшей текущей зарплаты в каждом отделе 
SELECT 
	s.emp_no, 
    s.salary, 
    d.dept_no, 
    MAX(salary) OVER (PARTITION BY d.dept_no) AS max_salary_in_dept 
FROM salaries s
JOIN dept_emp d
ON s.emp_no = d.emp_no
WHERE s.to_date = '9999-01-01' AND d.to_date = '9999-01-01';

#2 Сравнение зарплаты каждого сотрудника с средней зарплатой в их отделе
SELECT 
	s.emp_no, 
    s.salary, 
    d.dept_no, 
    AVG(salary) OVER (PARTITION BY d.dept_no) AS avg_salary_in_dept
FROM salaries s
JOIN dept_emp d
ON s.emp_no = d.emp_no
WHERE s.to_date = '9999-01-01' AND d.to_date = '9999-01-01'; 

#3 Ранжирование сотрудников в отделе по стажу работы
SELECT 
	e.emp_no, 
    e.hire_date, 
    d.dept_no, 
    DENSE_RANK() OVER (PARTITION BY d.dept_no ORDER BY e.hire_date) AS 'experience_rank' 
FROM employees e
JOIN dept_emp d
ON e.emp_no = d.emp_no
WHERE d.to_date = '9999-01-01'; 

#4 Нахождение следующей должности каждого сотрудника
SELECT 
	emp_no, 
    title, 
    LEAD(title) OVER (PARTITION BY emp_no ORDER BY from_date) AS next_title 
FROM titles; 

#5 Определение начальной и последней зарплаты сотрудника
SELECT
    emp_no,
    salary,
    first_salary,
    last_salary
FROM (SELECT
        s.emp_no,
        c.salary AS salary,
        FIRST_VALUE(s.salary) OVER (PARTITION BY s.emp_no ORDER BY s.from_date) AS first_salary,
        LAST_VALUE(s.salary) OVER (PARTITION BY s.emp_no ORDER BY s.from_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_salary,
        ROW_NUMBER() OVER (PARTITION BY s.emp_no ORDER BY s.from_date DESC) AS r
    FROM salaries s
    JOIN salaries c
	ON s.emp_no = c.emp_no
	AND c.to_date = '9999-01-01'
) t
WHERE r = 1;

#6 Вычислить скользящее среднее ЗП для каждого сотрудника, основываясь на его последних трех зарплатах
SELECT 
	emp_no, 
    salary, 
    from_date, 
    AVG(salary) OVER (PARTITION BY emp_no ORDER BY from_date ROWS BETWEEN 2 PRECEDING AND 0 FOLLOWING) AS moving_avg_salary
FROM salaries
ORDER BY emp_no, from_date; 
