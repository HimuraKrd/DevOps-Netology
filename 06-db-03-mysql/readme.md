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


Предоставьте привелегии пользователю test на операции SELECT базы test_db.  
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.

## Задача 3
* Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.
* Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.

Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе на:
* MyISAM
* InnoDB


## Задача 4
Изучите файл my.cnf в директории /etc/mysql. Измените его согласно ТЗ (движок InnoDB):
* Скорость IO важнее сохранности данных
* Нужна компрессия таблиц для экономии места на диске
* Размер буффера с незакомиченными транзакциями 1 Мб
* Буффер кеширования 30% от ОЗУ
* Размер файла логов операций 100 Мб
* Приведите в ответе измененный файл my.cnf.
