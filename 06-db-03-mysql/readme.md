# Домашнее задание к занятию "6.3. MySQL"

##  Задача 1
* Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.  
* Изучите бэкап БД и восстановитесь из него.  
* Перейдите в управляющую консоль mysql внутри контейнера.  
* Используя команду \h получите список управляющих команд.  
* Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.  
* Подключитесь к восстановленной БД и получите список таблиц из этой БД.  
* Приведите в ответе количество записей с price > 300.  

В следующих заданиях мы будем продолжать работу с данным контейнером.  

Создадим .yml файл:  
``` yml
version: '3.7'
services:
  db:
    image: mysql:8
    restart: always
    environment:
      MYSQL_DATABASE: 'netology'
      MYSQL_USER: 'himura'
      MYSQL_PASSWORD: 'password'
      MYSQL_ROOT_PASSWORD: 'password'
    volumes:
      - my-db:/var/lib/mysql
volumes:
  my-db:
```
Скопируем имеющийся бэкап в `` /var/lib/docker/volumes/[volume_name]/_data``, тем самым пробросив его в контейнер.  
Запустим образ, после чего подключимся к нему, используя `` sudo docker exec -it [container_name] bash`` и восстановим данные из бэкапа: `` mysql -u himura -p netology < /var/lib/mysql/test_dump.sql``. Подключимся к базе, используя `` mysql -u himura -p `` и проверим данные из задания: 
``` mysql
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| netology           |
+--------------------+
2 rows in set (0.00 sec)

mysql> \u netology 
Database changed
mysql> SHOW TABLES FROM netology;
+--------------------+
| Tables_in_netology |
+--------------------+
| orders             |
+--------------------+
1 row in set (0.00 sec)

mysql> \s

--------------
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)
Connection id:		13
Current database:	netology
Current user:		mbagirov@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.27 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			35 min 55 sec

Threads: 5  Questions: 109  Slow queries: 0  Opens: 255  Flush tables: 3  Open tables: 173  Queries per second avg: 0.050
--------------
```
Выведем все столбцы из базы: 
```mysql
mysql> SELECT * FROM orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)
```
И используем запрос `` SELECT * from orders o where o.price > 300; `` для вывода нужного нам результата:  
![task_1_price_more_300](https://user-images.githubusercontent.com/68470186/143934586-81573aa3-f0af-4da0-b498-667b5cc5b8fe.png)


## Задача 2
Создайте пользователя test в БД c паролем test-pass, используя:
* плагин авторизации mysql_native_password
* срок истечения пароля - 180 дней
* количество попыток авторизации - 3
* максимальное количество запросов в час - 100

аттрибуты пользователя:
* Фамилия "Pretty"
* Имя "James"

Создадим пользователя, используя команду:
```mysql 
CREATE USER 
'test'@'localhost' IDENTIFIED WITH mysql_native_password by 'test-pass'
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 3
PASSWORD HISTORY 100
ATTRIBUTE '{"fname": "James","lname": "Pretty"}'; 
```

Предоставьте привелегии пользователю test на операции SELECT базы test_db.  
Выполним требуемую задачу:  
```mysql 
GRANT SELECT ON netology.* to 'test'@'localhost';
```
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.  
```mysql
mysql> SELECT * from INFORMATION_SCHEMA.USER_ATTRIBUTES where USER = 'test';

+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3
* Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.

```mysql 
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
mysql> DROP TABLE IF EXISTS t1;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> SHOW PROFILES;

+----------+------------+----------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                |
+----------+------------+----------------------------------------------------------------------+
|        1 | 0.01576925 | DROP TABLE IF EXISTS t1                                                                  |
|        1 | 0.00046725 | SELECT * from INFORMATION_SCHEMA.USER_ATTRIBUTES where USER = 'test' |
|        2 | 0.00021350 | SELECT * FROM orders                                                 |
|        3 | 0.00023775 | SELECT * FROM orders WHERE price > 300                               |
+----------+------------+----------------------------------------------------------------------+
4 rows in set, 1 warning (0.00 sec)
```

* Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.

```mysql
mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'netology';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)
```

Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе на:
* MyISAM
* InnoDB

```mysql 
mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'netology';

+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyIsam;
Query OK, 5 rows affected (0.09 sec)
Records: 5  Duplicates: 0  Warnings: 0


mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'netology';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | MyISAM |
+------------+--------+
1 row in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.11 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'netology';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)
```
Ответ на вторую часть вопроса: 
```mysql
mysql> SHOW PROFILES;
+----------+------------+------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                    |
+----------+------------+------------------------------------------------------------------------------------------+
|        2 | 0.00046725 | SELECT * from INFORMATION_SCHEMA.USER_ATTRIBUTES where USER = 'test'                     |
|        3 | 0.00021350 | SELECT * FROM orders                                                                     |
|        4 | 0.00023775 | SELECT * FROM orders WHERE price > 300                                                   |
|        5 | 0.00087925 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'netology' |
|        6 | 0.09245425 | ALTER TABLE orders ENGINE = MyIsam                                                       |
|        7 | 0.00089075 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'netology' |
|        8 | 0.11460800 | ALTER TABLE orders ENGINE = InnoDB                                                       |
|        9 | 0.00083100 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'netology' |
|       10 | 0.00005500 | SHOW PROFILIES                                                                           |
|       11 | 0.00005850 | SHOW PROFILES QUERY 3                                                                    |
|       12 | 0.00005950 | SHOW PROFILES FOR QUERY 3                                                                |
|       13 | 0.00068200 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'netology' |
|       14 | 0.00006500 | ALTER TABLE orders ENGINE = MyISAAM                                                      |
|       15 | 0.08200825 | ALTER TABLE orders ENGINE = MyISAM                                                       |
|       16 | 0.00033400 | SELECT * from orders o where o.price > 300                                               |
+----------+------------+------------------------------------------------------------------------------------------+

15 rows in set, 1 warning (0.00 sec)

mysql> SHOW PROFILE FOR QUERY 4;

+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000065 |
| Executing hook on transaction  | 0.000003 |
| starting                       | 0.000006 |
| checking permissions           | 0.000005 |
| Opening tables                 | 0.000033 |
| init                           | 0.000005 |
| System lock                    | 0.000007 |
| optimizing                     | 0.000008 |
| statistics                     | 0.000016 |
| preparing                      | 0.000013 |
| executing                      | 0.000033 |
| end                            | 0.000003 |
| query end                      | 0.000002 |
| waiting for handler commit     | 0.000007 |
| closing tables                 | 0.000005 |
| freeing items                  | 0.000010 |
| cleaning up                    | 0.000020 |
+--------------------------------+----------+
17 rows in set, 1 warning (0.01 sec)

mysql> SHOW PROFILE FOR QUERY 16;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000067 |
| Executing hook on transaction  | 0.000003 |
| starting                       | 0.000006 |
| checking permissions           | 0.000005 |
| Opening tables                 | 0.000029 |
| init                           | 0.000004 |
| System lock                    | 0.000008 |
| optimizing                     | 0.000008 |
| statistics                     | 0.000012 |
| preparing                      | 0.000013 |
| executing                      | 0.000063 |
| end                            | 0.000008 |
| query end                      | 0.000005 |
| closing tables                 | 0.000006 |
| freeing items                  | 0.000078 |
| cleaning up                    | 0.000020 |
+--------------------------------+----------+
16 rows in set, 1 warning (0.00 sec)

```

## Задача 4
Изучите файл my.cnf в директории /etc/mysql. Измените его согласно ТЗ (движок InnoDB):
* Скорость IO важнее сохранности данных
* Нужна компрессия таблиц для экономии места на диске
* Размер буффера с незакомиченными транзакциями 1 Мб
* Буффер кеширования 30% от ОЗУ
* Размер файла логов операций 100 Мб
* Приведите в ответе измененный файл my.cnf.

Стандартный вывод файла конфигурации:
```mysql 
root@56e82a3b08d5:/# cat /etc/mysql/my.cnf
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/
```
Добавим требуемые параметры через `` echo [param] >> /etc/mysql/my.cnf ``.  
Перезапустим контейнер и проверим, что параметры применились: 
```mysql
mysql> SELECT * FROM performance_schema.global_variables WHERE
    -> Variable_name LIKE 'innodb_buffer_pool_size' OR
    -> Variable_name LIKE 'innodb_log_file_size' OR
    -> Variable_name LIKE 'innodb_log_buffer_size' OR
    -> Variable_name LIKE 'innodb_file_per_table' OR
    -> Variable_name LIKE 'innodb_io_capacity' OR
    -> Variable_name LIKE 'innodb_flush_log_at_trx_commit';
+--------------------------------+----------------+
| VARIABLE_NAME                  | VARIABLE_VALUE |
+--------------------------------+----------------+
| innodb_buffer_pool_size        | 671088640      |
| innodb_file_per_table          | ON             |
| innodb_flush_log_at_trx_commit | 2              |
| innodb_io_capacity             | 200            |
| innodb_log_buffer_size         | 1048576        |
| innodb_log_file_size           | 104857600      |
+--------------------------------+----------------+
6 rows in set (0.01 sec)
```
