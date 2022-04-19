# Домашнее задание к занятию "10.04. ELK"

## Дополнительные ссылки

При выполнении задания пользуйтесь вспомогательными ресурсами:

- [поднимаем elk в докер](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-docker.html)
- [поднимаем elk в докер с filebeat и докер логами](https://www.sarulabs.com/post/5/2019-08-12/sending-docker-logs-to-elasticsearch-and-kibana-with-filebeat.html)
- [конфигурируем logstash](https://www.elastic.co/guide/en/logstash/current/configuration.html)
- [плагины filter для logstash](https://www.elastic.co/guide/en/logstash/current/filter-plugins.html)
- [конфигурируем filebeat](https://www.elastic.co/guide/en/beats/libbeat/5.3/config-file-format.html)
- [привязываем индексы из elastic в kibana](https://www.elastic.co/guide/en/kibana/current/index-patterns.html)
- [как просматривать логи в kibana](https://www.elastic.co/guide/en/kibana/current/discover.html)
- [решение ошибки increase vm.max_map_count elasticsearch](https://stackoverflow.com/questions/42889241/how-to-increase-vm-max-map-count)

В процессе выполнения задания могут возникнуть также не указанные тут проблемы в зависимости от системы.

Используйте output stdout filebeat/kibana и api elasticsearch для изучения корня проблемы и ее устранения.

## Задание повышенной сложности

Не используйте директорию [help](./help) при выполнении домашнего задания.

## Задание 1

Вам необходимо поднять в докере:
- elasticsearch(hot и warm ноды)
- logstash
- kibana
- filebeat

и связать их между собой.

Logstash следует сконфигурировать для приёма по tcp json сообщений.

Filebeat следует сконфигурировать для отправки логов docker вашей системы в logstash.

В директории [help](./help) находится манифест docker-compose и конфигурации filebeat/logstash для быстрого 
выполнения данного задания.

Результатом выполнения данного задания должны быть:
- скриншот `docker ps` через 5 минут после старта всех контейнеров (их должно быть 5)
- скриншот интерфейса kibana
- docker-compose манифест (если вы не использовали директорию help)
- ваши yml конфигурации для стека (если вы не использовали директорию help)

## Задание 2

Перейдите в меню [создания index-patterns  в kibana](http://localhost:5601/app/management/kibana/indexPatterns/create)
и создайте несколько index-patterns из имеющихся.

Перейдите в меню просмотра логов в kibana (Discover) и самостоятельно изучите как отображаются логи и как производить 
поиск по логам.

В манифесте директории help также приведенно dummy приложение, которое генерирует рандомные события в stdout контейнера.
Данные логи должны порождать индекс logstash-* в elasticsearch. Если данного индекса нет - воспользуйтесь советами 
и источниками из раздела "Дополнительные ссылки" данного ДЗ.
 
---

### Решение
К сожалению, мой ноутбук слишком слабый и начинает очень сильно тормозить уже через минуту после запуска стэка. Поэтому часть скриншотов из WSL, а часть из Linux (Kubuntu). Интерфейс Kibana выглядит так:  
![image](https://user-images.githubusercontent.com/68470186/163961633-265af631-4fa2-4a17-8971-8305e33dfd90.png)  
Все сервисы запущены:  
![image](https://user-images.githubusercontent.com/68470186/163961795-7cf74e0b-e16d-4ae8-ba62-87c093189974.png)  
Очень долго боролся с тем, что данные в Elasticsearch не подтягивались и появлялось вот такое окно:  
![image](https://user-images.githubusercontent.com/68470186/163961876-0974005c-9ef5-487b-a265-4326117a83f5.png)  
Проблека оказалась в неправильном подключении ``volume`` в сервис Logstash. После исправления данные появились:  
![image](https://user-images.githubusercontent.com/68470186/163962023-a61351e5-c55f-47c4-9879-b38c3a281ae6.png)  
Создал индекс и увидел по нему вот такую статистику:  
![image](https://user-images.githubusercontent.com/68470186/163962086-5aeddf67-e347-408c-94bb-44022ad87ade.png)  
![image](https://user-images.githubusercontent.com/68470186/163962124-a9281dfb-a3bf-4fa2-aa83-24c44dd4f48d.png)


---

 
