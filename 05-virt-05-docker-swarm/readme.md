# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1: Дайте письменые ответы на следующие вопросы:
* В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?

В режиме ``replication`` необходимо указывать число реплик (сервисов), которые будут распределены между устройствами кластера. В режиме ``global`` сервис автоматически запустится на всех доступных устройствах кластера.
* Какой алгоритм выбора лидера используется в Docker Swarm кластере?

RAFT.
* Что такое Overlay Network?


Распределенная сеть между множественными хостами Docker для использования сервисами. В Swarm по умолчанию используется сеть типа overlay с именем ingress для распределения нагрузки, а так же сеть типа bridge с названием docker_gwbridge для коммуникации самих Docker daemon. 


## Задача 2: Создать ваш первый Docker Swarm кластер в Яндекс.Облаке
Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
``` shell
docker node ls
```
После разворачивания конфига запускаем требуемую команду и получаем вывод:  
```shell
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
eu4j83n8b0n2jhgigw6wta7ir *   node01.netology.yc   Ready     Active         Reachable        20.10.10
su79x2tq21anlhhscnkj085c8     node02.netology.yc   Ready     Active         Leader           20.10.10
k44xt2t0kpuhkfmnfblmxkd5h     node03.netology.yc   Ready     Active         Reachable        20.10.10
5jz1gqmjjit4d6fbm5dl54n7x     node04.netology.yc   Ready     Active                          20.10.10
ms7xii4zr2u6lxe0xtnfkp2zv     node05.netology.yc   Ready     Active                          20.10.10
nyrgulv4j9k4m5pjng43l8wbj     node06.netology.yc   Ready     Active                          20.10.10
```

## Задача 3: Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.
Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:  
```
docker service ls
```
Вывод команды следующий:  
```shell 
[centos@node01 ~]$ sudo docker service ls
ID             NAME                            MODE         REPLICAS   IMAGE                                         PORTS
ui2wvqcz9zzd   swarm_monitoring_alertmanager   replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0   
ogvux3la3txx   swarm_monitoring_cadvisor       global       6/6        google/cadvisor:latest                        
86pjokmvieh1   swarm_monitoring_grafana        replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4     
```


## Задача 4: Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
(см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/)  
```
docker swarm update --autolock=true
```
Данная команда шифрует сертификаты всех нод дополнительным ключём. После ввода команды и синхронизации изменений между менеджерами в рое, в случае рестарта Docker Engine или менеджера целиком:  
```shell
[centos@node01 ~]$ sudo systemctl restart docker
[centos@node01 ~]$ sudo docker node ls
Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Please use "docker swarm unlock" to unlock it.
```
Docker демон не сможет после старта прочитать сертификат кластера и будет считаться не доступным для обработки задач кластера. После ввода команды ``docker swarm unlock`` на менеджере и ввода ключа (который генерируется при первом запуске ``docker swarm update --autolock=true``)  связь восстаналивается и менеджер снова становится доступным для деплоя на него сервисов.
