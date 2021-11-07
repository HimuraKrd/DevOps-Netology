# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1: Сценарий выполения задачи:

* создайте свой репозиторий на https://hub.docker.com;
* выберете любой образ, который содержит веб-сервер Nginx;
* создайте свой fork образа;
* реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:

``` html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.  
  
Для теста использовал следующие команды:  
* скачал официальный образ, используя docker pull nginx
* создал html страницу, с указанным кодом
* запусил контейнер, используя команду ``[Himura@fedora task1]$ sudo docker run -d -p 8080:80 --name nginx_netology -v $PWD:/usr/share/nginx/html nginx``

После того, как проверил, что задача реализована приступил к сборке простого docker image:  
```dockerfile 
FROM nginx
COPY . /usr/share/nginx/html
ENTRYPOINT ["nginx", "-g", "daemon off;"]
```  
Т.к. нужно прокинуть лишь один файл, то использовал `` . `` в коде. Полученный образ залил на докер хаб : [доступ по ссылке](https://hub.docker.com/r/mbagirov/nginx-netology)

## Задача 2: Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?" Детально опишите и обоснуйте свой выбор.
  
--
  
Сценарий:  
* Высоконагруженное монолитное java веб-приложение;

Для данного сценария я бы предпочёл использовать физическую машину, чтобы уменьшить число слоёв и ускорить работу системы.
* Nodejs веб-приложение;

Для данного сценария подойдут все 3 варианта, но полная виртуализация кажется мне избыточной. Но самый простой и локаничный - использование Docker контейнеров.

* Мобильное приложение c версиями для Android и iOS;
Для данного сценария, как и для предыдущего, полная виртуализация избыточна. Поэтому подойдёт вариант docker и виртуальная машина. Также контейнеры позволят достичь идемпотентности, что отлично подойдёт для тестирования.

* Шина данных на базе Apache Kafka;

Гугл подсказал, что реализация через Docker контейнеры более чем жизнеспособна, поэтому варианты с виртуальной машиной и docker-образами подойдут. Также для этого решения имеет смысл задумываться о быстрой масштабируемости и оркестрации.
* Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;

Для данного сценария отлично подойдёт Docker-контейнерезация
* Мониторинг-стек на базе Prometheus и Grafana;

Для данного сценария отлично подойдёт Docker-контейнерезация
* MongoDB, как основное хранилище данных для java-приложения;

Для работы баз данных лучше подойдёт полная виртуализация для улучшения производительности
* Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Для данного сценария возможны все 3 варианта, но лучше использовать докер образы. 
## Задача 3: Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера; Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера; Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data; Добавьте еще один файл в папку /data на хостовой машине; Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
  
Запустим два контейнера:  
``` shell
[Himura@fedora data]$ sudo docker run -it -d -v $PWD:/data centos
50db1be9a028c33137ed175b117977fa090e67ac2daa93eae66b3bf88d11af91
[Himura@fedora data]$ sudo docker run -it -d -v $PWD:/data debian
0ce6beedd935d6397e3e524dd650380d713ae310c633f5e895d38918f693840b
[Himura@fedora data]$ pwd
/home/Himura/05-virt-03-docker/task3/data
```
Проверим их статус:  
```shell
[Himura@fedora data]$ sudo docker ps
CONTAINER ID   IMAGE                     COMMAND                  CREATED          STATUS          PORTS                                   NAMES
eb8bf1a356a5   centos                    "/bin/bash"              8 seconds ago    Up 5 seconds                                            angry_shamir
11f11f04aa89   debian                    "bash"                   20 seconds ago   Up 19 seconds                                           interesting_khorana
142f427c6bc7   mbagirov/nginx-netology   "nginx -g 'daemon of…"   4 hours ago      Up 4 hours      0.0.0.0:8080->80/tcp, :::8080->80/tcp   nginx_netology_repack
```
Выполним последовательно поставленные задачи:  
В Centos:  
```shell
[Himura@fedora data]$ sudo docker exec -it angry_shamir /bin/bash
[root@eb8bf1a356a5 /]# cd /data
[root@eb8bf1a356a5 data]# echo "this is file from centos" >> file_from_centos.txt 
[root@eb8bf1a356a5 data]# ls
file_from_centos.txt
```
В хостовой машине:  
```shell
[Himura@fedora data]$ echo "I have created this file from host machine" >> file_from_host.txt
[Himura@fedora data]$ ll
итого 8
-rw-r--r--. 1 root   root   25 ноя  7 06:18 file_from_centos.txt
-rw-rw-r--. 1 Himura Himura 43 ноя  7 06:20 file_from_host.txt
```
Зайдём в машину с Debian и проверим наличие и содержание файлов:  
```shell
[Himura@fedora data]$ sudo docker exec -it interesting_khorana /bin/bash
root@11f11f04aa89:/# cd /data
root@11f11f04aa89:/data# ls
file_from_centos.txt  file_from_host.txt
root@11f11f04aa89:/data# cat file_from_centos.txt 
this is file from centos
root@11f11f04aa89:/data# cat file_from_host.txt   
I have created this file from host machine
root@11f11f04aa89:/data# 
```

## Задача 4: Воспроизвести практическую часть лекции самостоятельно. Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
Используя следующий код в Dockerfile, собрал образ и залил в [репозиторий](https://hub.docker.com/r/mbagirov/netology-docker-ansible):
```Dockerfile
FROM alpine:3.14

RUN CARGO_NET_GIT_FETCH_WITH_CLI=1 && \
    apk --no-cache add \
       sudo python3 py3-pip openssl ca-certificates sshpass openssh-client rsync git && \
    apk --no-cache add \
        --virtual build-dependencies python3-dev libffi-dev musl-dev gcc cargo openssl-dev \
         libressl-dev \
         build-base && \
    pip install --upgrade pip wheel && \
    pip install --upgrade cryptography cffi && \
    pip install ansible==2.9.24 && \
    pip install mitogen ansible-lint jmespath && \
    pip install --upgrade pywinrm && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.cargo

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version"]
```
