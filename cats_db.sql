-- 1. DDL: Создать все таблицы с явным id

DROP TABLE IF EXISTS vetvisit;
DROP TABLE IF EXISTS owner_cat;
DROP TABLE IF EXISTS catsurname;
DROP TABLE IF EXISTS cat;
DROP TABLE IF EXISTS catname;
DROP TABLE IF EXISTS owner;
DROP TABLE IF EXISTS home;

CREATE TABLE home (
    id INTEGER PRIMARY KEY,
    address TEXT NOT NULL
);

CREATE TABLE owner (
    id INTEGER PRIMARY KEY,
    fullname TEXT NOT NULL
);

CREATE TABLE catname (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE cat (
    id INTEGER PRIMARY KEY,
    catname_id INTEGER NOT NULL REFERENCES catname(id),
    home_id INTEGER REFERENCES home(id)
);

CREATE TABLE catsurname (
    id INTEGER PRIMARY KEY,
    cat_id INTEGER NOT NULL REFERENCES cat(id),
    surname TEXT NOT NULL
);

CREATE TABLE owner_cat (
    owner_id INTEGER NOT NULL REFERENCES owner(id),
    cat_id INTEGER NOT NULL REFERENCES cat(id),
    PRIMARY KEY (owner_id, cat_id)
);

CREATE TABLE vetvisit (
    id INTEGER PRIMARY KEY,
    cat_id INTEGER NOT NULL REFERENCES cat(id),
    visit_date DATE NOT NULL,
    description TEXT
);

-- 2. Вставка данных, все id ручные и согласованы

-- Дома
INSERT INTO home (id, address) VALUES
    (1, 'ул. Мурлыкина, д. 1'),
    (2, 'пр. Пушистый, д. 22');

-- Хозяева
INSERT INTO owner (id, fullname) VALUES
    (1, 'Иван Иванов'),
    (2, 'Екатерина Кошкина'),
    (3, 'Сергей Рыжкин');

-- Основные клички
INSERT INTO catname (id, name) VALUES
    (1, 'Барсик'),
    (2, 'Мурка'),
    (3, 'Визгун'),
    (4, 'Шерстяной');

-- Коты
INSERT INTO cat (id, catname_id, home_id) VALUES
    (1, 1, 1),   -- Барсик живёт на Мурлыкина
    (2, 2, 1),   -- Мурка живёт на Мурлыкина
    (3, 3, 2),   -- Визгун живёт на Пушистом
    (4, 4, NULL);-- Шерстяной бездомный

-- Альтернативные клички
INSERT INTO catsurname (id, cat_id, surname) VALUES
    (1, 1, 'Толстяк'),      -- Барсик
    (2, 1, 'Блохастый'),    -- Барсик
    (3, 2, 'Мышеловка'),    -- Мурка
    (4, 3, 'Крикливый');    -- Визгун
    -- Шерстяной не имеет альтернативных

-- Владение котами (owner_cat — многие ко многим)
INSERT INTO owner_cat (owner_id, cat_id) VALUES
    (1, 1),  -- Иван владеет Барсиком
    (1, 4),  -- Иван владеет бездомным Шерстяным
    (2, 2),  -- Екатерина владеет Муркой
    (2, 3),  -- Екатерина владеет Визгуном
    (3, 1);  -- Сергей тоже владеет Барсиком

-- Посещения ветеринара (vetvisit) — у каждого кота минимум одно
INSERT INTO vetvisit (id, cat_id, visit_date, description) VALUES
    (1, 1, '2025-01-16', 'Вакцинация'),    -- Барсик 1 посещение
    (2, 1, '2025-05-10', 'Осмотр'),        -- Барсик 2 посещение
    (3, 2, '2025-01-21', 'Лечение зубов'), -- Мурка
    (4, 3, '2025-02-15', 'Прививка'),      -- Визгун
    (5, 3, '2025-03-01', 'Проверка ушек'), -- Визгун — два посещения
    (6, 4, '2025-06-20', 'Травма лапки');  -- Шерстяной (бездомный тоже ходит к врачу)