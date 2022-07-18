# Домашнее задание к занятию "13.4 инструменты для упрощения написания конфигурационных файлов. Helm и Jsonnet"
В работе часто приходится применять системы автоматической генерации конфигураций. Для изучения нюансов использования разных инструментов нужно попробовать упаковать приложение каждым из них.

## Задание 1: подготовить helm чарт для приложения
Необходимо упаковать приложение в чарт для деплоя в разные окружения. Требования:
* каждый компонент приложения деплоится отдельным deployment’ом/statefulset’ом;
* в переменных чарта измените образ приложения для изменения версии.

## Задание 2: запустить 2 версии в разных неймспейсах
Подготовив чарт, необходимо его проверить. Попробуйте запустить несколько копий приложения:
* одну версию в namespace=app1;
* вторую версию в том же неймспейсе;
* третью версию в namespace=app2.

## Задание 3 (*): повторить упаковку на jsonnet
Для изучения другого инструмента стоит попробовать повторить опыт упаковки из задания 1, только теперь с помощью инструмента jsonnet.

---

## Решение.
Для начала подготовим NS для разворачивания в них манифестов.
```shell
kubectl create ns app1
kubectl create ns app2
```
Перенесём в папку манифесты из прошлых работ (task2). Изменим значения, чтоб получить пользу от инструмента helm.  
Установим первый чарт в неймспейс app1:
```bash
helm install helm-app-1 netology
NAME: helm-app-1
LAST DEPLOYED: Mon Jul 18 21:51:41 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```
Проверим состояние компонентов:
```bash
kubectl -n app1 get po,sts,deployments,svc

kubectl -n app1 get po,sts,deployments,svc
NAME                            READY   STATUS    RESTARTS   AGE
pod/backend-69c58946dd-j92b2    1/1     Running   0          115s
pod/backend-69c58946dd-m78vp    1/1     Running   0          115s
pod/frontend-5bd5db987b-6lm8b   1/1     Running   0          115s
pod/frontend-5bd5db987b-cx95r   1/1     Running   0          115s

NAME                  READY   AGE
statefulset.apps/db   0/2     115s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/backend    2/2     2            2           115s
deployment.apps/frontend   2/2     2            2           115s

NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/backend    ClusterIP   10.100.189.4    <none>        9000/TCP   115s
service/db         ClusterIP   10.110.96.190   <none>        5432/TCP   115s
service/frontend   ClusterIP   10.111.11.112   <none>        8080/TCP   115s
```
Запустим этот же чарт, но в неймспейсе app2, для этого передадим на вход другой неймспейс при помощи ``--set``. Помимо изменения namespace изменим также ``pv`` и ``pvc``:
```bash
helm install helm-app-2 netology --set metadata.pv.name=pv-prod2,metadata.pvc.name=pvc-prod2,namespace=app2
NAME: helm-app-2
LAST DEPLOYED: Mon Jul 18 21:55:31 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```
Проверим состояние обоих неймспейсов:
```bash
helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
helm-app-1      default         1               2022-07-18 21:51:41.626588147 +0300 MSK deployed        netology-0.1.0  1.16.0     
helm-app-2      default         1               2022-07-18 21:55:31.335804643 +0300 MSK deployed        netology-0.1.0  1.16.0 
```
Установим ещё один чарт в app2, согласно задаче.
```bash
helm install helm-app-3 netology --set namespace=app2
NAME: helm-app-3
LAST DEPLOYED: Mon Jul 18 22:56:44 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```
Проверим итоговое значение:
```bash
helm list                                      ✔  at minikube ⎈  at 22:56:44   
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
helm-app-1      default         1               2022-07-18 22:56:32.801829008 +0300 MSK deployed        netology-0.1.0  1.16.0     
helm-app-2      default         1               2022-07-18 22:56:38.36143147 +0300 MSK  deployed        netology-0.1.0  1.16.0     
helm-app-3      default         1               2022-07-18 22:56:44.14066891 +0300 MSK  deployed        netology-0.1.0  1.16.0  
```
Данный чарт составлен таким образом, что изменение его имени будет изменять и название POD-ов, сервисов и т.д. в рамках указанного неймспейса. Если не выносить так много параметров в переменные - необходимо использовать ключ ``--set`` чтобы избежать конфликтов. 
---
