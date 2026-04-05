DROP INDEX idx_hire_date ON employees; 

CREATE INDEX idx_hire_date
ON employees(hire_date);

SELECT * FROM employees 
WHERE hire_date> '2000-01-01';

SELECT * FROM employees
WHERE first_name = 'Georgi' AND last_name = 'Facello';

CREATE INDEX idx_name
ON employees(first_name, last_name);

DROP INDEX idx_name ON employees; 
