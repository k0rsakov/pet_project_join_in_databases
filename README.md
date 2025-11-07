# `JOIN` – что это, зачем это, как это?

## О видео

## О проекте
Пример того как может выглядеть ER-модель:
```mermaid
erDiagram
    CAT ||--|| CATNAME : has
    CAT ||--o| HOME : lives_in
    OWNER }o--o{ CAT : owns
    CAT ||--o{ CATSURNAME : has_surname
    CAT ||--|{ VETVISIT : visited

    CAT {
        int id
        int home_id
        int catname_id
    }
    CATNAME {
        int id
        string name
    }
    HOME {
        int id
        string address
    }
    OWNER {
        int id
        string fullname
    }
    CATSURNAME {
        int id
        int cat_id
        string surname
    }
    VETVISIT {
        int id
        int cat_id
        date visit_date
        string description
    }
```

Больше информации про ER-моделирование можно узнать по [ссылке](https://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model?ysclid=mhn2d1h6ax723269151).

Шпаргалка по аннотациям связей:

![](https://avatars.mds.yandex.net/get-lpc/1520633/9346286d-22db-439a-9ced-422fc163c2cd/width_1920_q80)

Данные в базе данных выглядят примерно так как в таблице `cat`:

| id | catname_id | home_id |
|----|------------|---------|
| 1  | 1          | 1       |
| 2  | 2          | 1       |
| 3  | 3          | 2       |
| 4  | 4          |         |

Но мы как дата-инженеры и исследователи данных хотим понимать что значат эти данные, поэтому без `JOIN` никак. Ниже показаны возможности `JOIN`.


\# Пример 1: Множество котиков (A) и множество владельцев (B). `INNER JOIN` выбирает пары на пересечении:

```mermaid
flowchart LR
  subgraph Owners
    O1("Иван")
    O2("Екатерина")
    O3("Сергей")
  end

  subgraph Cats
    C1("Барсик")
    C4("Шерстяной")
    C2("Мурка")
    C3("Визгун")
  end

  O1-->|Владеет|C1
  O1-->|Владеет|C4
  O2-->|Владеет|C2
  O2-->|Владеет|C3
  O3-->|Владеет|C1
```

\# Пример 2: Для `LEFT JOIN` — коты всегда есть, дома могут быть, могут не быть:

```mermaid
flowchart LR
  subgraph Cats
    C1("Барсик")
    C2("Мурка")
    C3("Визгун")
    C4("Шерстяной (нет дома)")
  end
  subgraph Homes
    H1("ул. Мурлыкина, 1")
    H2("пр. Пушистый, 22")
  end

  C1-->|Живёт|H1
  C2-->|Живёт|H1
  C3-->|Живёт|H2
  C4-->|Без дома|X[ ]
```

\# Пример 3: Для `INNER JOIN` — выбирает только тех котов, у которых есть дом. "Бездомные" пропадают из результата:

```mermaid
flowchart LR
  subgraph Cats
    C1("Барсик")
    C2("Мурка")
    C3("Визгун")
    %% C4("Шерстяной (нет дома)") пропущен!
  end
  subgraph Homes
    H1("ул. Мурлыкина, 1")
    H2("пр. Пушистый, 22")
  end

  C1-->|Живёт|H1
  C2-->|Живёт|H1
  C3-->|Живёт|H2
  %% C4-->|Без дома|X[ ] (Нет строки)
```

### Поднятие инфраструктуры

Для запуска инфраструктуры:

```bash
docker compose up -d
```

Для воссоздания БД:

```bash
docker exec -i my_postgres psql -U postgres -d postgres < cats_db.sql
```
