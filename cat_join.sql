/*
1. Исследование исходных данных: базовые выборки из таблиц.
Позволяет понять структуру таблицы и состав всех записей.

Выводит всех котиков из таблицы cat.
*/
SELECT * FROM cat;

/*
Аналогично — просмотр всех основных кличек котиков.
*/
SELECT * FROM catname;

/*
Смотрим всех альтернативные клички котов.
*/
SELECT * FROM catsurname;

/*
Выводим список всех домов.
*/
SELECT * FROM home;

/*
Выводим список всех владельцев.
*/
SELECT * FROM owner;

/*
Смотрим ассоциации кот-владелец (кто каким котом владеет).
*/
SELECT * FROM owner_cat;

/*
Смотрим информацию о всех посещениях ветклиники.
*/
SELECT * FROM vetvisit;

--------------------------------------------------------------------------------

/*
2. Простые JOIN-запросы: соединение двух таблиц.

Пример INNER JOIN: получаем имя кота и его основную кличку.
Только те коты, к которым имя указано корректно.
*/
SELECT c.id, cn.name
FROM cat c
INNER JOIN catname cn ON c.catname_id = cn.id;

--------------------------------------------------------------------------------

/*
Пример LEFT JOIN: получаем имена котиков и их адреса домов, если дом есть.
Если дом не указан — возвращается NULL.
*/
SELECT c.id, cn.name, h.address AS home_address
FROM cat c
INNER JOIN catname cn ON c.catname_id = cn.id
LEFT JOIN home h ON c.home_id = h.id;

--------------------------------------------------------------------------------

/*
Пример RIGHT JOIN: получаем список адресов домов и имена тех котиков, которые там живут.
Если в доме нет кота — возвращается NULL для имени кота.
*/
SELECT h.id, h.address, cn.name
FROM home h
RIGHT JOIN cat c ON h.id = c.home_id
INNER JOIN catname cn ON c.catname_id = cn.id;

--------------------------------------------------------------------------------

/*
3. JOIN более чем двух таблиц.
Пример: получаем имена котов, их основные клички, альтернативные клички, и адрес дома.
*/
SELECT c.id, cn.name AS main_name, s.surname AS alt_name, h.address AS home_address
FROM cat c
INNER JOIN catname cn ON c.catname_id = cn.id
LEFT JOIN catsurname s ON c.id = s.cat_id
LEFT JOIN home h ON c.home_id = h.id;

--------------------------------------------------------------------------------

/*
Более сложная цепочка JOIN-ов: показываем всех владельцев и их котиков.
*/
SELECT o.fullname AS owner_name, cn.name AS cat_name
FROM owner o
INNER JOIN owner_cat oc ON o.id = oc.owner_id
INNER JOIN cat c ON oc.cat_id = c.id
INNER JOIN catname cn ON c.catname_id = cn.id;

--------------------------------------------------------------------------------

/*
4. Краевые случаи и работа с NULL: коты без альтернативных кличек.
Показываем котов, у которых нет ни одной альтернативной клички.
*/
SELECT c.id, cn.name
FROM cat c
INNER JOIN catname cn ON c.catname_id = cn.id
LEFT JOIN catsurname s ON c.id = s.cat_id
WHERE s.id IS NULL;

--------------------------------------------------------------------------------

/*
Краевой случай: коты, у которых нет дома (home_id IS NULL).
Показываем таких котов и их основную кличку.
*/
SELECT c.id, cn.name
FROM cat c
INNER JOIN catname cn ON c.catname_id = cn.id
WHERE c.home_id IS NULL;

--------------------------------------------------------------------------------

/*
Краевой случай: дома, в которых никто не живёт — если бы такие были,
запрос бы их показал (можно использовать для демонстрации типа JOIN,
даже если данных нет).
*/
SELECT h.id, h.address
FROM home h
LEFT JOIN cat c ON h.id = c.home_id
WHERE c.id IS NULL;

--------------------------------------------------------------------------------

/*
5. JOIN для фильтрации (anti-join):
Показываем котов, у которых нет альтернативных кличек.
*/
SELECT c.id, cn.name
FROM cat c
INNER JOIN catname cn ON c.catname_id = cn.id
LEFT JOIN catsurname s ON c.id = s.cat_id
WHERE s.id IS NULL;

--------------------------------------------------------------------------------

/*
Другой вариант фильтрации JOIN — владельцы, у которых больше одного котика
(агрегация и фильтрация).
*/
SELECT o.fullname, COUNT(oc.cat_id) AS num_cats
FROM owner o
INNER JOIN owner_cat oc ON o.id = oc.owner_id
GROUP BY o.fullname
HAVING COUNT(oc.cat_id) > 1;

--------------------------------------------------------------------------------

/*
Ищем всех котов, владельцы которых — Иван.
*/
SELECT c.id, cn.name, o.fullname
FROM cat c
INNER JOIN catname cn ON c.catname_id = cn.id
INNER JOIN owner_cat oc ON c.id = oc.cat_id
INNER JOIN owner o ON oc.owner_id = o.id
WHERE o.fullname LIKE '%Иван%';

--------------------------------------------------------------------------------

/*
Полный OUTER JOIN — показываем всех котов и все дома, смежно, если связь есть.
Если кот без дома — home_address станет NULL. Если бы был дом без кота — появится кот с NULL.
*/
SELECT c.id AS cat_id, cn.name AS cat_name, h.id AS home_id, h.address AS home_address
FROM cat c
FULL OUTER JOIN home h ON c.home_id = h.id
LEFT JOIN catname cn ON c.catname_id = cn.id;