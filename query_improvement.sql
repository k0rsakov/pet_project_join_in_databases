EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
SELECT c.id, cn.name
FROM cat c
INNER JOIN catname cn ON c.catname_id = cn.id;

/* Индекс на внешний ключ кота (cat.catname_id) */
CREATE INDEX idx_cat_catname_id ON cat(catname_id);

/* Индекс на первичный ключ клички, если не создан (обычно создаётся с PRIMARY KEY автоматически, но можем показать явно) */
CREATE INDEX idx_catname_id ON catname(id);

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
SELECT c.id, cn.name
FROM cat c
INNER JOIN catname cn ON c.catname_id = cn.id;