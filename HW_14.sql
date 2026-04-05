#1 Создать процедуру, где мы получим список сотрудников, у которых средняя ЗП больше p_salary и когда-то работали в департаменте p_dept.
DROP PROCEDURE IF EXISTS salary_dept;
DELIMITER $$
CREATE PROCEDURE salary_dept (IN p_salary INT, p_dept VARCHAR(30))
BEGIN
	SELECT e.emp_no, e.first_name, e.gender FROM employees e #беру айди, имя и пол сотрудника
    WHERE e.emp_no IN( #беру только тех сотрудников, где департамент соответствует моему запросу
		SELECT d.emp_no FROM dept_emp d
		WHERE d.dept_no IN( #так как мой запрос дает название департамента, а не номер, нужно заменить номер на название
			SELECT de.dept_no FROM departments de
			WHERE de.dept_name = p_dept))
	AND e.emp_no IN( #беру только тех сотрудников, у которых средняя ЗП выше моего запроса
    SELECT s.emp_no FROM salaries s
    GROUP BY s.emp_no
    HAVING AVG(s.salary) > p_salary);
END $$

DELIMITER ;

CALL salary_dept(80000,'Development')

#2 максимальная ЗП среди сотрудников с именем f_name
DROP FUNCTION IF EXISTS max_salary
DELIMITER $$
CREATE FUNCTION max_salary(f_name VARCHAR(30)) RETURNS INT
DETERMINISTIC READS SQL DATA
BEGIN
	DECLARE m_salary INT; #сюда запишу максимальную зарплату
    SELECT MAX(salary) INTO m_salary
    FROM salaries
	WHERE emp_no IN( #сортирую ЗП по сотрудникам, чьи имена такие же как в запросе
		SELECT emp_no FROM employees
		WHERE first_name = f_name)
	AND to_date = '9999-01-01';  
    RETURN m_salary;
END $$

DELIMITER ;

SELECT max_salary('Georgi');

#3 Посчитайте количество городов в каждой стране, где IndepYear = 1991 (Independence Year)
SELECT 
    c.Name, #вывожу название страны
    COUNT(ci.ID) AS city_count #кол-во городов в каждой стране
FROM country c
JOIN city ci #присоединяю таблицу городов
    ON c.Code = ci.CountryCode
WHERE c.IndepYear = 1991 #оставляю только страны, где независимость в 1991 году
GROUP BY c.Code, c.Name; #группирую по стране, чтобы COUNT считался отдельно для каждой

#4 Какая численность населения и средняя продолжительность жизни людей в Аргентине
SELECT 
	SUM(Population) AS 'Численность населения', 
    AVG(LifeExpectancy) AS 'Ср Продолжительность жизни' 
FROM country
WHERE Name = 'Argentina';

#5 В какой стране самая высокая продолжительность жизни?
SELECT 
    Name,
    AVG(LifeExpectancy)
FROM country
GROUP BY Name
ORDER BY AVG(LifeExpectancy) DESC
LIMIT 1;

#6 Перечислите все языки, на которых говорят в регионе «Southeast Asia».
SELECT 
	DISTINCT(Language) AS All_Languages #выбираю все языки без повторений
FROM countrylanguage
WHERE CountryCode IN( #беру языки только региона Southeast Asia
	SELECT Code FROM country
	WHERE Region = 'Southeast Asia'
);

#7 Посчитайте сумму SurfaceArea для каждого континента
SELECT Continent, SUM(SurfaceArea) AS total_SA FROM country
GROUP BY Continent;

