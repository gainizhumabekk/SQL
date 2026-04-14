CREATE DATABASE Customers_transactions;
UPDATE customers SET Gender = NULL WHERE Gender = "";
UPDATE customers SET Age = NULL WHERE Age = "";
ALTER TABLE customers MODIFY AGE INT NULL;

CREATE TABLE Transactions
(date_new DATE,
Id_check INT,
ID_client INT,
Count_products DECIMAL(10,3),
Sum_payment DECIMAL(10,2));

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TRANSACTIONS_final.csv"
INTO TABLE Transactions
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';

SELECT * FROM customers;
SELECT * FROM transactions;

# В таблице transactions в одном чеке есть несколько товаров и оны разделены на строки
# Создаю временную таблицу "whole_check", где все товары собираю в один чек с одной сторокой
# Но только за указанный в задании период
WITH whole_check AS (  
    SELECT
        t.ID_client,
        t.Id_check,
        DATE_FORMAT(t.date_new, '%Y-%m') AS check_ym,
        SUM(t.Sum_payment) AS check_amount
    FROM transactions t
    WHERE t.date_new >= '2015-06-01'
      AND t.date_new < '2016-06-01'
    GROUP BY
        t.ID_client,
        t.Id_check,
        DATE_FORMAT(t.date_new, '%Y-%m')
), 

# Также создаю временную таблицу, где будет информация по покупкам помесячно
monthly AS (
    SELECT
        ID_client,
        check_ym,
        SUM(check_amount) AS month_amount,
        COUNT(DISTINCT Id_check) AS monthly_checks
    FROM whole_check
    GROUP BY
        ID_client,
        check_ym
), 

# В самом конце мне нужно отобрать только те айдишки, которые непрервно 12 месяцев покупали
# Эту информацию вывожу в отдельной временной таблице "loyal_clients"
loyal_clients AS (
    SELECT
        ID_client
    FROM monthly
    GROUP BY ID_client
    HAVING COUNT(DISTINCT check_ym) = 12
)

SELECT
    lc.Id_client,
    ROUND(AVG(wc.check_amount), 2) AS avg_check,
    ROUND(SUM(wc.check_amount) / 12, 2) AS avg_month_amount,
    COUNT(DISTINCT wc.Id_check) AS total_operations
FROM loyal_clients lc
JOIN whole_check wc
    ON lc.ID_client = wc.ID_client
LEFT JOIN customers c
    ON lc.ID_client = c.Id_client
GROUP BY
    lc.Id_client
ORDER BY avg_month_amount DESC;

#Task 2, a-d)
WITH whole_check AS (  
    SELECT
        t.ID_client,
        t.Id_check,
        DATE_FORMAT(t.date_new, '%Y-%m') AS check_ym,
        SUM(t.Sum_payment) AS check_amount
    FROM transactions t
    GROUP BY
        t.ID_client,
        t.Id_check,
        check_ym
), 

monthly AS (
	SELECT 
		check_ym,
        COUNT(DISTINCT ID_client) AS users_count,
        COUNT(DISTINCT Id_check) AS operations_count,
        SUM(check_amount) AS total_amount,
        AVG(check_amount) AS avg_check
	FROM whole_check 
    GROUP BY check_ym
), 

yearly AS (
	SELECT 
		SUM(operations_count) AS yearly_operations, 
        SUM(total_amount) AS yearly_amount
	FROM monthly
)

SELECT 
	m.check_ym, 
    ROUND(m.avg_check, 2) AS avg_check,
    m.operations_count, 
    m.users_count,
    ROUND(m.operations_count / y.yearly_operations, 2) AS operations_share,
    ROUND(m.total_amount / y.yearly_amount, 2) AS amount_share
FROM monthly m
CROSS JOIN yearly y 
ORDER BY m.check_ym;

# Task 2, e)
WITH whole_check AS (  
    SELECT
        t.ID_client,
        t.Id_check,
        DATE_FORMAT(t.date_new, '%Y-%m') AS check_ym,
        SUM(t.Sum_payment) AS check_amount
    FROM transactions t
    GROUP BY
        t.ID_client,
        t.Id_check,
        check_ym
), 

gender_month AS (
	SELECT 
		wc.check_ym,
        COALESCE(c.Gender, "NA") AS gender, 
        SUM(wc.check_amount) AS amount,
        COUNT(DISTINCT wc.ID_client) AS users_count
	FROM whole_check wc
    LEFT JOIN customers c
		ON wc.ID_client = c.ID_client
	GROUP BY wc.check_ym, gender
), 

monthly AS (
	SELECT 
		check_ym, 
        SUM(amount) AS total_amount
	FROM gender_month
    GROUP BY check_ym
)
SELECT 
	g.check_ym, 
    g.gender,
    ROUND(g.users_count / SUM(g.users_count) OVER (PARTITION BY g.check_ym), 2) AS users_share,
    ROUND(g.amount / m.total_amount, 2) AS amount_share
FROM gender_month g
JOIN monthly m
	ON g.check_ym = m.check_ym
ORDER BY 
	g.check_ym, 
    g.gender;

# Task 3 - за весь период 
WITH whole_check AS (  
    SELECT
        t.ID_client,
        t.Id_check,
        CONCAT(YEAR(t.date_new), '-Q', QUARTER(t.date_new)) AS check_yq,
        SUM(t.Sum_payment) AS check_amount
    FROM transactions t
    GROUP BY
        t.ID_client,
        t.Id_check,
        check_yq
), 

client_groups AS (
	SELECT 
		c.Id_client,
        CASE 
			WHEN c.AGE IS NULL THEN 'NA'
            ELSE CONCAT(FLOOR(c.AGE/10)*10, '-', FLOOR(c.AGE/10)*10 + 9)
            END AS age_group
    FROM customers c
), 

whole_data AS (
	SELECT 
		wc.*,
        cg.age_group
    FROM whole_check wc
    LEFT JOIN client_groups cg
		ON wc.ID_client = cg.Id_client
), 

totals AS (
	SELECT 
		age_group, 
        SUM(check_amount) AS total_amount, 
        COUNT(DISTINCT Id_check) AS operations_count
    FROM whole_data 
    GROUP BY age_group
), 

quarters AS (
	SELECT 
		age_group, 
        check_yq, 
        AVG(check_amount) AS avg_check, 
        COUNT(DISTINCT Id_check) as operations_count, 
        SUM(check_amount) AS total_amount
    FROM whole_data
    GROUP BY age_group, check_yq
), 

quarter_totals AS (
	SELECT 
		check_yq, 
        SUM(total_amount) AS quarter_amount, 
        SUM(operations_count) AS quarter_operations
    FROM quarters 
    GROUP BY check_yq
)

SELECT 
    age_group,
    ROUND(total_amount, 2) AS total_amount,
    operations_count
FROM totals
ORDER BY age_group;


# Task 3, поквартально
WITH whole_check AS (  
    SELECT
        t.ID_client,
        t.Id_check,
        CONCAT(YEAR(t.date_new), '-Q', QUARTER(t.date_new)) AS check_yq,
        SUM(t.Sum_payment) AS check_amount
    FROM transactions t
    GROUP BY
        t.ID_client,
        t.Id_check,
        check_yq
), 

client_groups AS (
	SELECT 
		c.Id_client,
        CASE 
			WHEN c.AGE IS NULL THEN 'NA'
            ELSE CONCAT(FLOOR(c.AGE/10)*10, '-', FLOOR(c.AGE/10)*10 + 9)
            END AS age_group
    FROM customers c
), 

whole_data AS (
	SELECT 
		wc.*,
        cg.age_group
    FROM whole_check wc
    LEFT JOIN client_groups cg
		ON wc.ID_client = cg.Id_client
), 

totals AS (
	SELECT 
		age_group, 
        SUM(check_amount) AS total_amount, 
        COUNT(DISTINCT Id_check) AS operations_count
    FROM whole_data 
    GROUP BY age_group
), 

quarters AS (
	SELECT 
		age_group, 
        check_yq, 
        AVG(check_amount) AS avg_check, 
        COUNT(DISTINCT Id_check) as operations_count, 
        SUM(check_amount) AS total_amount
    FROM whole_data
    GROUP BY age_group, check_yq
), 

quarter_totals AS (
	SELECT 
		check_yq, 
        SUM(total_amount) AS quarter_amount, 
        SUM(operations_count) AS quarter_operations
    FROM quarters 
    GROUP BY check_yq
)

SELECT 
	q.age_group, 
    q.check_yq, 
    ROUND(q.avg_check, 2) AS avg_check, 
    q.operations_count, 
    q.total_amount,
    ROUND(q.total_amount / qt.quarter_amount, 4) AS amount_share, 
    ROUND(q.operations_count / qt.quarter_operations, 4) AS operations_share
FROM quarters q
JOIN quarter_totals qt
	ON q.check_yq = qt.check_yq
ORDER BY q.age_group, q.check_yq; 
