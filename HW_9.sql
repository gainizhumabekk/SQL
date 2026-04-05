#1
SELECT
    r.Name_ru AS region,
    CONCAT(p.Last_name, ' ', p.First_name,  ' ', p.Second_name) AS full_name,
    CASE #меняем пол в слова
        WHEN p.gender = 0 THEN 'Мужской'
        WHEN p.gender = 1 THEN 'Женский'
    END AS gender,
    COUNT(s.id) AS service_count
FROM Patients p
JOIN Region r
ON p.Id_region = r.id
LEFT JOIN Service s #если у пациента нет услуги, он всё равно попадёт в список
ON p.code_service = s.code
WHERE p.dt_reg BETWEEN '2024-01-01' AND '2024-05-31' #фильтр по дате регистрации
GROUP BY r.Name_ru, p.id, p.First_name, p.Second_name, p.Last_name, p.gender
ORDER BY r.Name_ru, full_name;

#2a Сколько записей из t1 есть в t2 по IIN
SELECT COUNT(*) AS matched_records
FROM table1 t1
JOIN table2 t2
ON t1.IIN = t2.IIN;

#2b сколько ИИН дублируются и по сколько раз
#table1
SELECT IIN, COUNT(*) AS cnt
FROM table1
GROUP BY IIN
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

#table2
SELECT IIN, COUNT(*) AS cnt
FROM table2
GROUP BY IIN
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

#2c вытащить людей с возрастом 30–70 лет
SELECT 
    IIN,
    birth_date,
    TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age
FROM table2
WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) BETWEEN 30 AND 70
ORDER BY age;


