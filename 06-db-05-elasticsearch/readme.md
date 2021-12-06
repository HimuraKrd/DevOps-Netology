# Домашнее задание к занятию "6.5. Elasticsearch"
## Задача 1
В этом задании вы потренируетесь в:
* установке elasticsearch
* первоначальном конфигурировании elastcisearch
* запуске elasticsearch в docker


Используя докер образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:
* составьте Dockerfile-манифест для elasticsearch
* соберите docker-образ и сделайте push в ваш docker.io репозиторий
* запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины

``sudo docker run -d -p 9200:9200 -p 9300:9300 -v "$(pwd)":/var/lib/elasticsearch -v "$(pwd)"/elasticsearch.yml:/var/lib/elasticsearch.yml --name elastic mbagirov/elastic:7.15.2
``

Долго пытался поймать ошибку, ибо логи были слишком короткие. Через ``sudo watch docker logs container_name`` поймал следующую ошибку:
```shell
ERROR: [1] bootstrap checks failed. You must address the points described in the following [1] lines before starting Elasticsearch.
bootstrap check failure [1] of [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```
После увеличения до рекомендованного значения при помощи команды ``sudo sysctl -w vm.max_map_count=262144``, проблема ушла. 

Требования к elasticsearch.yml:
* данные path должны сохраняться в /var/lib
* имя ноды должно быть netology_test


В ответе приведите:
* текст Dockerfile манифеста
* [ссылку](https://hub.docker.com/r/mbagirov/elastic) на образ в репозитории dockerhub
* ответ elasticsearch на запрос пути / в json виде

Подсказки:
* возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
* при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
* при некоторых проблемах вам поможет docker директива ulimit
* elasticsearch в логах обычно описывает проблему и пути ее решения


Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2
В этом задании вы научитесь:

* создавать и удалять индексы
* изучать состояние кластера
* обосновывать причину деградации доступности данных


Ознакомтесь с документацией и добавьте в elasticsearch 3 индекса, в соответствии со таблицей:

| Имя           | Количество реплик  | Количество шард |
|:------------- |:------------------:| ---------------:|
| ind-1         | 0                  |    1            |
| ind-2         | 1                  |    2            |
| ind-3         | 2                  |    4            |

Задачи:
* Получите список индексов и их статусов, используя API и приведите в ответе на задание.
* Получите состояние кластера elasticsearch, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?  
Удалите все индексы.  

**Важно**  
При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.  

К сожалению, практическая часть в вебинаре не обсуждалась и приходится по крупицам собирать информацию из интернета, т.к. даже официальный сайт не богат на инфу..
Проверял состояние работоспособности службы, используя ``curl -X GET "localhost:9200/_cat/nodes?v=true&pretty"``:
```shell
[Himura@fedora 06-db-05-elasticsearch]$ curl -X GET "localhost:9200/_cat/nodes?v=true&pretty"
ip         heap.percent ram.percent cpu load_1m load_5m load_15m node.role   master name
172.17.0.2            7          97   6    0.44    0.16     0.14 cdfhilmrstw *      netology_test
```
Запрашиваем через ``curl`` для создания индексов (хотя вариант с kibana был бы предпочтительней...):
``` curl
curl -XPUT -H "Content-Type: application/json" http://localhost:9200/ind-[#]?pretty -d '{
  "settings": {
    "index": {
      "number_of_shards": [#],
      "number_of_replicas": [#]
    }
  }
}'
```
Один раз я ошибся и запрос продублировал :-) Поэтому в итоге у меня получилось 4 индекса:
```shell
[Himura@fedora 06-db-05-elasticsearch]$ curl -X GET "localhost:9200/_cat/indices/ind-*?v&s=index&pretty"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 ou968wQlSdea7dPd15ZJeA   1   0          0            0       208b           208b
yellow open   ind-2 8B7Mdwt_SMiK_Ei6v8zMSw   2   1          0            0       416b           416b
green  open   ind-3 -F3lZyGBTEOOsxnHvqdxUQ   1   0          0            0       208b           208b
yellow open   ind-4 ex0BWiITTMeB2aWpjZAexA   4   2          0            0       832b           832b
```
Cостояние ``green`` только у первого индекса (и 3, введённого по ошибке). У ind-2 и ind-3 статус yellow, т.к. в созданном ранее кластере всего одна нода с одним шардом, реплики отсутствуют. Для изменения состояния "здоровья" других индексов надо увеличивать количество нод.  
Удаляются все индексы при помощи ``curl -XDELETE localhost:9200/_all``.


## Задача 3
В данном задании вы научитесь:

* создавать бэкапы данных
* восстанавливать индексы из бэкапов

Задачи:
* Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.

``path.repo: /elasticsearch-7.15.2/snapshots`` после чего перезагрузим контейнер, чтоб он взял настройки.
* Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.
* Приведите в ответе запрос API и результат вызова API для создания репозитория.


```shell
curl -X PUT "localhost:9200/_snapshot/snapshot_repository?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/elasticsearch-7.15.2/snapshots/netology_backup/",
    "compress": true
  }
}
'
```
* Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.

```shell
curl -XPUT -H "Content-Type: application/json" http://localhost:9200/test?pretty -d '{
  "settings": {
    "index": {
      "number_of_shards": 1,
      "number_of_replicas": 0
    }
  }
}'

[Himura@fedora 06-db-05-elasticsearch]$ curl -X GET "localhost:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases xjNnxnDdRKytNHdiBYm7qQ   1   0         43            0     40.9mb         40.9mb
green  open   test             WTCvUNTGS8mmLNy0hocJUQ   1   0          0            0       208b           208b
```

* Создайте snapshot состояния кластера elasticsearch.

``` shell 
[Himura@fedora 06-db-05-elasticsearch]$ curl -X PUT "localhost:9200/_snapshot/snapshot_repository/snapshot_1?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "snapshot_1",
    "uuid" : "VecvAFdLQsaBBi3wCnoujA",
    "repository" : "snapshot_repository",
    "version_id" : 7150299,
    "version" : "7.15.2",
    "indices" : [
      "test",
      ".geoip_databases"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2021-12-06T21:19:45.364Z",
    "start_time_in_millis" : 1638825585364,
    "end_time" : "2021-12-06T21:19:46.765Z",
    "end_time_in_millis" : 1638825586765,
    "duration_in_millis" : 1401,
    "failures" : [ ],
    "shards" : {
      "total" : 2,
      "failed" : 0,
      "successful" : 2
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
```
* Приведите в ответе список файлов в директории со snapshotами.

Зайдём на контейнер, используя ``sudo docker exec -it elastic bash`` и посмотрим файлы в подключённом репозитории:
```shell
[elasticsearch@aa73aef2ae1e /]$ ll /elasticsearch-7.15.2/snapshots/netology_backup/
total 24
-rw-r--r--. 1 elasticsearch elasticsearch  828 Dec  6 21:19 index-0
-rw-r--r--. 1 elasticsearch elasticsearch    8 Dec  6 21:19 index.latest
drwxr-xr-x. 1 elasticsearch elasticsearch   88 Dec  6 21:19 indices
-rw-r--r--. 1 elasticsearch elasticsearch 9387 Dec  6 21:19 meta-VecvAFdLQsaBBi3wCnoujA.dat
-rw-r--r--. 1 elasticsearch elasticsearch  351 Dec  6 21:19 snap-VecvAFdLQsaBBi3wCnoujA.dat
```

* Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.

```shell
[elasticsearch@aa73aef2ae1e /]$ curl -X DELETE "localhost:9200/test?pretty"
{
  "acknowledged" : true
}
[elasticsearch@aa73aef2ae1e /]$ 

#создадим второй индекс
curl -XPUT -H "Content-Type: application/json" http://localhost:9200/test-2?pretty -d '{
  "settings": {
    "index": {
      "number_of_shards": 1,
      "number_of_replicas": 0
    }
  }
}'

[Himura@fedora 06-db-05-elasticsearch]$ curl -X GET "localhost:9200/_cat/indices?v"
health status index            uuid                    pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2            7sDS_7-BTJqYxfK7BDNwBg   1   0          0            0       208b           208b
green  open   .geoip_databases  xjNnxnDdRKytNHdiBYm7qQ   1   0         43            0     40.9mb         40.9mb
```
* Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.
* Приведите в ответе запрос к API восстановления и итоговый список индексов.

```shell

curl -H 'Content-Type: application/json' -X POST "localhost:9200/_snapshot/snapshot_repository/snapshot_1/_restore" -d '{"include_global_state": true}'

[Himura@fedora 06-db-05-elasticsearch]$ curl -X GET "localhost:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases s_iuiPjBRdqCOdYlrboNhQ   1   0         43            0     35.1mb         35.1mb
green  open   test-2           7sDS_7-BTJqYxfK7BDNwBg   1   0          0            0       208b           208b
green  open   test-1           rzVwDfy5QCOfsZuW394j7A   1   0          0            0       208b           208b

```

Подсказки: возможно вам понадобится доработать elasticsearch.yml в части директивы path.repo и перезапустить elasticsearch
