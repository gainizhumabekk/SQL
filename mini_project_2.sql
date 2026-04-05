#Задание №1

#1 Количество уникальных пользователей
SELECT 
	COUNT(DISTINCT(user_id)) AS unique_users 
FROM users; 

#2 Посмотрел наибольшее количество объявлений
SELECT 
	user_id, 
    SUM(view_adverts) OVER (PARTITION BY user_id) AS adv_number 
FROM users
ORDER BY adv_number DESC
LIMIT 1;

#3 День с наибольшим ср количеством просмотренных рекламных объявлений на пользователя
SELECT 
	date, 
    SUM(view_adverts)/COUNT(DISTINCT user_id) avg_ads #я написала формулу, потому что функция AVG не учла бы повторяющихся пользователей, если они есть
FROM users 
GROUP BY date
HAVING COUNT(DISTINCT user_id) > 500
ORDER BY avg_ads DESC;

#4 Запрос возвращающий LT
SELECT 
	user_id, 
    timestampdiff(DAY, MIN(date), MAX(date)) AS lt
FROM users
GROUP BY user_id
ORDER BY lt DESC;

#5 Самое высокое сред кол-во просмотренной рекламы за день среди тех, кто был активен как минимум в 5 разных дней
SELECT 
    user_id, 
    AVG(view_ads) AS avg_daily_view
FROM
    (SELECT 
		user_id, 
        date, 
        SUM(view_adverts) AS view_ads
    FROM users
    GROUP BY user_id , date) t
GROUP BY user_id
HAVING COUNT(DISTINCT (date)) >= 5
ORDER BY avg_daily_view DESC
LIMIT 1;

#Задание №2

#Создайте новую базу данных mini_project
DROP DATABASE IF EXISTS mini_project; 
CREATE DATABASE mini_project; 

#Создаю таблицу 1
DROP TABLE IF EXISTS T_TAB1;
CREATE TABLE T_TAB1 (
ID INT AUTO_INCREMENT PRIMARY KEY,
GOODS_TYPE VARCHAR(12),
QUANTITY INT, 
AMOUNT INT, 
SELLER_NAME VARCHAR(4)
);

#Вставляю данные в таблицу 1
INSERT INTO T_TAB1 (GOODS_TYPE, QUANTITY, AMOUNT, SELLER_NAME) VALUES 
('MOBILE PHONE', 2, 400000, 'MIKE'),
('KEYBOARD', 1, 10000, 'MIKE'),
('MOBILE PHONE', 1, 50000, 'JANE'),
('MONITOR', 1, 110000, 'JOE'),
('MONITOR', 2, 80000, 'JANE'),
('MOBILE PHONE', 1, 130000, 'JOE'),
('MOBILE PHONE', 1, 60000, 'ANNA'),
('PRINTER', 1, 90000, 'ANNA'),
('KEYBOARD', 2, 10000, 'ANNA'),
('PRINTER', 1, 80000, 'MIKE');
SELECT * FROM T_TAB1;

#Создаю таблицу 2
DROP TABLE IF EXISTS T_TAB2;
CREATE TABLE T_TAB2 (
ID INT AUTO_INCREMENT PRIMARY KEY,
NAME VARCHAR(4),
SALARY INT, 
AGE INT
);

#Вставляю данные в таблицу 2
INSERT INTO T_TAB2 (NAME, SALARY, AGE) VALUES
('ANNA', 110000, 27), 
('JANE', 80000, 25),
('MIKE', 120000, 25),
('JOE', 70000, 24),
('RITA', 120000, 29); 
SELECT * FROM T_TAB2;

#1 Список уникальных категорий товаров
SELECT DISTINCT(GOODS_TYPE) FROM T_TAB1; #количество уникальных категорий товаров - 4

#2 Суммарное количество и суммарную стоимость проданных мобильных телефонов
SELECT 
	COUNT(*) AS 'Сумм кол-во', 
    SUM(AMOUNT) AS 'Сумм стоимость' 
FROM T_TAB1
WHERE GOODS_TYPE = 'MOBILE PHONE'; #Сумм кол-во - 4, Сумм стоимость - 640 000

#3 Список сотрудников с заработной платой > 100000
SELECT NAME FROM T_TAB2
WHERE SALARY > 100000; #кол-во сотрудников - 3

#4 Мин/макс возраст сотрудников, мин/макс ЗП
SELECT 
	MIN(AGE) AS min_age,
    MAX(AGE) AS max_age,
    MIN(SALARY) AS min_salary,
    MAX(SALARY) AS max_salary
FROM T_TAB2;

#5 Сред кол-во проданных клавиатур и принтеров
SELECT
    GOODS_TYPE,
    AVG(QUANTITY) AS avg_quantity
FROM T_TAB1
WHERE GOODS_TYPE IN ('KEYBOARD', 'PRINTER')
GROUP BY GOODS_TYPE;

#6 Имя сотрудника и суммарную стоимость проданных им товаров
SELECT 
	SELLER_NAME, 
    SUM(AMOUNT) AS 'Сумм стоимость' 
FROM T_TAB1
GROUP BY SELLER_NAME;

#7 Имя сотрудника, тип товара, кол-во товара, стоимость товара, заработную плату и возраст сотрудника MIKE
SELECT 
	a.SELLER_NAME AS 'Имя сотрудника', 
    a.GOODS_TYPE AS 'тип товара', 
    a.QUANTITY AS 'кол-во товара', 
    a.AMOUNT/a.QUANTITY AS 'стоимость товара', 
    b.SALARY AS 'Заработная плата',
    b.AGE AS 'Возраст сотрудника'
FROM T_TAB1 a
JOIN T_TAB2 b
ON a.SELLER_NAME = b.NAME
WHERE SELLER_NAME = 'Mike';

#8 Имя и возраст сотрудника, который ничего не продал
SELECT NAME, AGE FROM T_TAB2
WHERE NAME NOT IN (
SELECT SELLER_NAME FROM T_TAB1);

#9 Имя сотрудника и его ЗП с возрастом меньше 26 лет
SELECT NAME, SALARY FROM T_TAB2
WHERE AGE < 26; #таких 3 сотрудника

#10 Сколько строк вернёт следующий запрос
SELECT * FROM T_TAB1 t
JOIN T_TAB2 t2 
ON t2.name = t.seller_name
WHERE t2.name = 'RITA'; #Вернет 0 строк потому что RITA ничего не продала

#Задание №3

CREATE DATABASE test_db;

#1 Сколько пользователей добавили книгу 'Coraline', сколько пользователей прослушало больше 10%
SELECT
	'Добавили книгу' AS '',
    COUNT(DISTINCT c.user_id) AS users_count
FROM audio_cards c
JOIN audiobooks b
    ON c.audiobook_uuid = b.uuid
WHERE b.title = 'Coraline'

UNION 

SELECT
	'Прослушали > 10%',
	COUNT(DISTINCT c.user_id)
FROM audio_cards c
JOIN audiobooks b
    ON c.audiobook_uuid = b.uuid
WHERE b.title = 'Coraline'
AND c.progress > 0.1 * b.duration;

#2 По каждой операционной системе и названию книги выведите количество пользователей, сумму прослушивания в часах, не учитывая тестовые прослушивания
SELECT 
    l.os_name,
    b.title,
    COUNT(DISTINCT l.user_id) AS 'Кол-во пользователей',
    SUM(
        CASE 
            WHEN l.is_test = 0 
            THEN TIMESTAMPDIFF(HOUR, l.started_at, l.finished_at)
            ELSE 0
        END
    ) AS 'Сумма прослушивания'
FROM listenings l
JOIN audiobooks b
    ON l.audiobook_uuid = b.uuid
GROUP BY l.os_name, b.title;

#3 Найдите книгу, которую слушает больше всего людей
SELECT
    b.title,
    COUNT(DISTINCT l.user_id) AS user_count
FROM listenings l
JOIN audiobooks b
    ON l.audiobook_uuid = b.uuid
GROUP BY b.title
ORDER BY user_count DESC
LIMIT 1;

#4 Найдите книгу, которую чаще всего дослушивают до конца
SELECT 
	b.title, 
	COUNT(DISTINCT(user_id)) AS finish_count
FROM audio_cards c
JOIN audiobooks b
ON c.audiobook_uuid = b.uuid
WHERE c.state = 'finished'
AND c.progress = b.duration
GROUP BY b.title
ORDER BY finish_count DESC
LIMIT 1;


