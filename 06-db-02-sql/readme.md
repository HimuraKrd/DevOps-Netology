# Домашнее задание к занятию "6.2. SQL"

## Задача 1
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.  
Приведите получившуюся команду или docker-compose манифест.

## Задача 2
В БД из задачи 1:
* создайте пользователя test-admin-user и БД test_db
* в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
* предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
* создайте пользователя test-simple-user
* предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Создаём пользователя test-admin-user и БД test_db команами:  
```
create user test-admin-user;
create database test_db;
```
Создаём таблицы, используя следующие команды:
```
create table orders 
(
	ID serial primary key,
	name VARCHAR(50),
	price integer
);

create table clients
(
	ID serial primary key,
	surname VARCHAR(50),
	country VARCHAR(50),
	order_id integer references orders(id)
);
```
Предоставляем права на все операции пользователю админской учётке:  
``grant all on DATABASE test_db to "test-admin-user"; ``  
![check test-admin-user rights](https://user-images.githubusercontent.com/68470186/143777088-36e4048f-b2ef-4da4-9396-bbee58e94011.png)  
  
Создаём пользователя test-simple-user:  
`` create user 'test-simple-user' ``  
И выдаём ему необходимые права:  
`` GRANT select,insert,update,delete ON orders, clients TO "test-simple-user"; ``

Таблица orders:
* id (serial primary key)
* наименование (string)
* цена (integer)


Таблица clients:
* id (serial primary key)
* фамилия (string)
* страна проживания (string, index)
* заказ (foreign key orders)

Приведите:
* итоговый список БД после выполнения пунктов выше
```
postgres=# \l
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges        
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
(4 rows)
```

* описание таблиц (describe)


![table description](https://user-images.githubusercontent.com/68470186/143777971-d63d73c3-5580-4aba-9507-fbe16cab99f7.png)

* SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
``` 
SELECT table_catalog, grantee, table_schema, table_name, privilege_type
FROM information_schema.table_privileges;
```
* список пользователей с правами над таблицами test_db
![user list with rights for test_db](https://user-images.githubusercontent.com/68470186/143778309-b07f640a-0f1a-4759-97f5-3212a827f7f7.png)



## Задача 3
Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:  

Таблица orders:

Наименование  | Цена
------------- | -------------
Шоколад       | 10
Принтер       | 3000
Книга	      | 500
Монитор	      | 7000
Гитара	      | 4000

```
insert into orders (name, price) values 
('Шоколад', 10),
('Принтер', 3000),
('Книга', 500),
('Монитор', 7000),
('Гитара', 4000);
```

Таблица clients
ФИО                  | Страна проживания
Иванов Иван Иванович | USA
Петров Петр Петрович | Canada
Иоганн Себастьян Бах | Japan
Ронни Джеймс Дио     | Russia
Ritchie Blackmore    | Russia
Иванов Иван Иванович | USA

```
insert into clients (surname, country) values 
('Иванов Иван Иванович', 'USA'),
('Петров Петр Петрович', 'Canada'),
('Иоганн Себастьян Бах', 'Japan'),
('Ронни Джеймс Дио', 'Russia'),
('Ritchie Blackmore', 'Russia'),
('Иванов Иван Иванович', 'USA');
```
Используя SQL синтаксис: вычислите количество записей для каждой таблицы.  
Приведите в ответе:
* запросы

```
select count(*) from clients c  ;
select count(*) from orders o  ;
```
* результаты их выполнения


![clients count](https://user-images.githubusercontent.com/68470186/143778654-3544a5b4-ad98-4baa-99f0-fc55096046cd.png)


## Задача 4
Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

ФИО	Заказ
Иванов Иван Иванович	Книга
Петров Петр Петрович	Монитор
Иоганн Себастьян Бах	Гитара
Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

Подсказк - используйте директиву UPDATE.

Задача 5
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

Задача 6
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.
