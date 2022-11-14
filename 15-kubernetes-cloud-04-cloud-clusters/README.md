# Домашнее задание к занятию 15.4 "Кластеры. Ресурсы под управлением облачных провайдеров"

Организация кластера Kubernetes и кластера баз данных MySQL в отказоустойчивой архитектуре.
Размещение в private подсетях кластера БД, а в public - кластера Kubernetes.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Настроить с помощью Terraform кластер баз данных MySQL:
- Используя настройки VPC с предыдущих ДЗ, добавить дополнительно подсеть private в разных зонах, чтобы обеспечить отказоустойчивость 
- Разместить ноды кластера MySQL в разных подсетях
- Необходимо предусмотреть репликацию с произвольным временем технического обслуживания
- Использовать окружение PRESTABLE, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб
- Задать время начала резервного копирования - 23:59
- Включить защиту кластера от непреднамеренного удаления
- Создать БД с именем `netology_db` c логином и паролем

2. Настроить с помощью Terraform кластер Kubernetes
- Используя настройки VPC с предыдущих ДЗ, добавить дополнительно 2 подсети public в разных зонах, чтобы обеспечить отказоустойчивость
- Создать отдельный сервис-аккаунт с необходимыми правами 
- Создать региональный мастер kubernetes с размещением нод в разных 3 подсетях
- Добавить возможность шифрования ключом из KMS, созданного в предыдущем ДЗ
- Создать группу узлов состояющую из 3 машин с автомасштабированием до 6
- Подключиться к кластеру с помощью `kubectl`
- *Запустить микросервис phpmyadmin и подключиться к БД, созданной ранее
- *Создать сервис типы Load Balancer и подключиться к phpmyadmin. Предоставить скриншот с публичным адресом и подключением к БД

Документация
- [MySQL cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster)
- [Создание кластера kubernetes](https://cloud.yandex.ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create)
- [K8S Cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster)
- [K8S node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
--- 
## Задание 2. Вариант с AWS (необязательное к выполнению)

1. Настроить с помощью terraform кластер EKS в 3 AZ региона, а также RDS на базе MySQL с поддержкой MultiAZ для репликации и создать 2 readreplica для работы:
- Создать кластер RDS на базе MySQL
- Разместить в Private subnet и обеспечить доступ из public-сети c помощью security-group
- Настроить backup в 7 дней и MultiAZ для обеспечения отказоустойчивости
- Настроить Read prelica в кол-ве 2 шт на 2 AZ.

2. Создать кластер EKS на базе EC2:
- С помощью terraform установить кластер EKS на 3 EC2-инстансах в VPC в public-сети
- Обеспечить доступ до БД RDS в private-сети
- С помощью kubectl установить и запустить контейнер с phpmyadmin (образ взять из docker hub) и проверить подключение к БД RDS
- Подключить ELB (на выбор) к приложению, предоставить скрин

Документация
- [Модуль EKS](https://learn.hashicorp.com/tutorials/terraform/eks)

---
Задача 1:  
Согласно требованию добавил ресурсы, получив следующую итоговую картину:  
![image](https://user-images.githubusercontent.com/68470186/201770332-2cdb8472-4cc4-449b-a0df-f07de27289be.png)  
Параметры кластера MySQL следующие:  
![image](https://user-images.githubusercontent.com/68470186/201770484-d117c505-306b-4b72-98f8-2a7f5adbdd3d.png)  
Отказоустойчивость обеспечивается за счёт разнесения узлов в разные гео-зоны:  
![image](https://user-images.githubusercontent.com/68470186/201770622-5455feea-5fd5-4d3b-815e-a410ae46ad14.png)  
База данных развёрнута и для подключения к ней требует следующих значений:  
![image](https://user-images.githubusercontent.com/68470186/201770733-2db5a347-4c2d-421d-8294-4bb9c67c4c18.png)  
Эта информация будет использована в процессе разворачивания кластера K8S.  
Дополнительные настройки кластера, включающие в себя защиту от удаления, представлены на скриншоте ниже:  
![image](https://user-images.githubusercontent.com/68470186/201770894-461ef145-53a0-47e8-ba69-af1f40755ae8.png)
---
Задача 2:  
Был развёрнут следующий кластер K8S:  
![image](https://user-images.githubusercontent.com/68470186/201771064-5d7fb9bc-3bf5-448c-beb7-36e9bc7dcb99.png)  
Для его работы была также создан сервисный аккаунт, имеющий необходимые права:  
![image](https://user-images.githubusercontent.com/68470186/201771229-377e86a8-12b2-4c5d-b98b-32763a7d7292.png)  
Узлы размещены в разных зонах согласно настройкам node group:  
![image](https://user-images.githubusercontent.com/68470186/201771366-b74f65c6-d526-439a-947b-991a641fdab1.png)  
  
Для подключения к узлам необходимо добавить информацию о кластере в kubeconfig
```
yc managed-kubernetes cluster get-credentials k8s-cluster --external --force

Context 'yc-k8s-cluster' was added as default to kubeconfig '/home/himura/.kube/config'.
Check connection to cluster using 'kubectl cluster-info --kubeconfig /home/himura/.kube/config'.

Note, that authentication depends on 'yc' and its config profile 'default'.
To access clusters using the Kubernetes API, please use Kubernetes Service Account.
There is a new yc version '0.98.0' available. Current version: '0.94.0'.
See release notes at https://cloud.yandex.ru/docs/cli/release-notes
You can install it by running the following command in your shell:
        $ yc components update
```
Проверим состояние кластера и узлов:
```
kubectl cluster-info
Kubernetes control plane is running at https://51.250.7.116
CoreDNS is running at https://51.250.7.116/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

kubectl get nodes -o wide
NAME                        STATUS   ROLES    AGE     VERSION   INTERNAL-IP     EXTERNAL-IP      OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
cl18ivr7riseiovccb60-emyn   Ready    <none>   3m17s   v1.22.6   192.168.10.29   84.201.173.125   Ubuntu 20.04.4 LTS   5.4.0-117-generic   containerd://1.6.6
cl18ivr7riseiovccb60-okad   Ready    <none>   3m24s   v1.22.6   192.168.10.22   84.201.173.180   Ubuntu 20.04.4 LTS   5.4.0-117-generic   containerd://1.6.6
cl18ivr7riseiovccb60-ukyw   Ready    <none>   3m33s   v1.22.6   192.168.10.30   84.201.175.92    Ubuntu 20.04.4 LTS   5.4.0-117-generic   containerd://1.6.6
```
Для выполнения задания со звёздочкой воспользуемся манифестом ``php-my-admin.yml``, находящемся в папке ``kuber``.
```
kubectl apply -f php-my-admin.yml
deployment.apps/phpmyadmin-deployment created
service/phpmyadmin-service created

kubectl get svc,deployment
NAME                         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
service/kubernetes           ClusterIP      10.96.128.1     <none>          443/TCP        14m
service/phpmyadmin-service   LoadBalancer   10.96.187.188   62.84.126.252   80:31265/TCP   22s

NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/phpmyadmin-deployment   2/2     2            2           22s
```
Зайдём на узел балансировщика (http://62.84.126.252/):  
![image](https://user-images.githubusercontent.com/68470186/201774642-8857b595-b4ab-49e1-96ca-257b665124bb.png)  
И откроем php-my-admin, используя данные из конфигурационных файлов терраформ:
![image](https://user-images.githubusercontent.com/68470186/201775008-3350cd78-0917-4218-85b3-ead9416d5d92.png)
