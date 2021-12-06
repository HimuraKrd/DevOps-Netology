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


## Задача 3
В данном задании вы научитесь:

* создавать бэкапы данных
* восстанавливать индексы из бэкапов

Задачи:
* Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.
* Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.
* Приведите в ответе запрос API и результат вызова API для создания репозитория.
* Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
* Создайте snapshot состояния кластера elasticsearch.
* Приведите в ответе список файлов в директории со snapshotами.
* Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
* Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.
* Приведите в ответе запрос к API восстановления и итоговый список индексов.

Подсказки: возможно вам понадобится доработать elasticsearch.yml в части директивы path.repo и перезапустить elasticsearch
