# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1
Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume. Подключитесь к БД PostgreSQL используя psql. Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам. Найдите и приведите управляющие команды для:
* вывода списка БД

```postgresql

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```

* подключения к БД ``   \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}   connect to new database (currently "postgres")``
* вывода списка таблиц - `` \dt[S+] [PATTERN]      list tables``
* вывода описания содержимого таблиц - `` \d[S+]  NAME           describe table, view, sequence, or index``
* выхода из psql - ``\q        quit psql``


## Задача 2
* Используя psql создайте БД test_database.
* Изучите бэкап БД.
* Восстановите бэкап БД в test_database.
* Перейдите в управляющую консоль psql внутри контейнера.
* Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
* Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
* Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.

Восстановим бэкап, используя:
```postgresql
postgres@59762865240e:/$ psql -U postgres -d test_database < /backups/test_dump.sql 

SET
SET
SET
SET
SET
 set_config 
------------

(1 row)
SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```
Используя команду `` ANALYZE [ VERBOSE ] [ имя_таблицы [ ( имя_столбца [, ...] ) ] ] `` мы можем посмотреть на состояние таблиц и базы в целом:
```postgresql
test_database=# ANALYZE verbose orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE

test_database=# ANALYZE verbose;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
INFO:  analyzing "pg_catalog.pg_type"
INFO:  "pg_type": scanned 10 of 10 pages, containing 414 live rows and 0 dead rows; 414 rows in sample, 414 estimated total rows
INFO:  analyzing "pg_catalog.pg_foreign_table"
INFO:  "pg_foreign_table": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
INFO:  analyzing "pg_catalog.pg_authid"
INFO:  "pg_authid": scanned 1 of 1 pages, containing 9 live rows and 0 dead rows; 9 rows in sample, 9 estimated total rows
INFO:  analyzing "pg_catalog.pg_statistic_ext_data"
INFO:  "pg_statistic_ext_data": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
INFO:  analyzing "pg_catalog.pg_largeobject"
INFO:  "pg_largeobject": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
INFO:  analyzing "pg_catalog.pg_user_mapping"
INFO:  "pg_user_mapping": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
INFO:  analyzing "pg_catalog.pg_subscription"
INFO:  "pg_subscription": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
.........
```
Используя команду ``select * from pg_stats where tablename = 'orders';`` увидим следующий результат:  
![pg_stats](https://user-images.githubusercontent.com/68470186/144107761-70125753-eb69-4f4b-9cf6-9623faadd049.png)


## Задача 3
Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).  

* Предложите SQL-транзакцию для проведения данной операции.
* Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Создадим новую таблицу, подготовив её к разделению по графе ``price``:
```postgresql 
create table orders_new (
 id serial,
 title varchar (40),
 price integer
) partition by range (price);
```
Создадим две дочерние таблицы, завязанные на основной:
```postgresql
create table orders_1 
partition of orders_new 
for values from (0) to (500);

create table orders_2 
partition of orders_new 
for values from (500) to (maxvalue);
```
Добавим данные из основной таблицы в новую, которую мы подготовили для разделения: `` insert into orders_new (title, price) select o.title, o.price from orders o;``. Посмотрим наполнение созданных таблиц:  
![orders_1](https://user-images.githubusercontent.com/68470186/144302275-2a1eb89d-3a39-4849-bc6e-76025ac0efd7.png)  
![orders_2](https://user-images.githubusercontent.com/68470186/144302277-fb927aca-e34b-4e99-b309-96ff806b65e3.png)  
Я также поигрался с вставкой данных в таблицу (видно по таблице orders_1) и сбил индексы. Для восстановления последовательности использовал сочетание команд:
```postgresql
ALTER SEQUENCE orders_new_id_seq RESTART WITH 1; 
update orders_new set id = default;
```
Насколько я понял, автоматическое шардирование стандартными средставами не представляется возможным.

## Задача 4
* Используя утилиту pg_dump создайте бекап БД test_database.
* Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

Если сделать бэкап в формате .sql - его можно открыть любым текстовым редактором и отредактировать любые поля.
