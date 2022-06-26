# Домашнее задание к занятию "13.3 работа с kubectl"
## Задание 1: проверить работоспособность каждого компонента
Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:
* сделайте запросы к бекенду;
* сделайте запросы к фронту;
* подключитесь к базе данных.

## Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

---

## Решение
### Задание 1
Пробросим доступ к нашему сервису через ``port-forward`` с локальной машины:
```bash
kubectl port-forward services/frontend 8080:8080
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
```
С неё же можно достучаться к сервису:
```bash
curl 127.0.0.1:8080                                           ✔  at 22:21:09   
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>%                                                                                 
```
Как и раньше, бэкэнд не отрабатывает... Возможно, ошибка в сборке докер-контейнера, но соединение сбрасывается:
```bash
Forwarding from 127.0.0.1:9000 -> 9000
Forwarding from [::1]:9000 -> 9000
Handling connection for 9000
E0626 22:24:38.450024 1746314 portforward.go:406] an error occurred forwarding 9000 -> 9000: error forwarding port 9000 to pod 48fafe492746e13537366ba7501eef0894278a1937c12b6a6ff391b73374459c, uid : exit status 1: 2022/06/26 19:24:38 socat[1614948] E connect(5, AF=2 127.0.0.1:9000, 16): Connection refused
E0626 22:24:38.450629 1746314 portforward.go:234] lost connection to pod
```
Для проверки работоспособности базы установим ``psql`` клиент через ``sudo apt-get install -y postgresql-client``, пробросим порт 5432 и попробуем достучаться в базу:
```bash
kubectl port-forward services/db 5432:5432
Forwarding from 127.0.0.1:5432 -> 5432
Forwarding from [::1]:5432 -> 5432
Handling connection for 5432

psql -h 127.0.0.1 -p 5432 -d news -U postgres -W            2 ✘  at 22:28:21   
Password: 
psql (14.3 (Ubuntu 14.3-0ubuntu0.22.04.1), server 13.7)
Type "help" for help.

news=# 
```

### Задание 2
Увеличим количество реплик до 3 при помощи ``kubectl -n prod scale deployment backend frontend --replicas 3``
```bash
backend-69c58946dd-lnc95    1/1     Running   0          12s
backend-69c58946dd-xpls4    1/1     Running   0          30m
backend-69c58946dd-zmtkv    1/1     Running   0          12s
frontend-5bd5db987b-7lwbk   1/1     Running   0          12s
frontend-5bd5db987b-bghmt   1/1     Running   0          12s
frontend-5bd5db987b-mbbfl   1/1     Running   0          30m
```
Уменьшим до 1:
```bash
kubectl -n prod get po                      ✔  at minikube ⎈  at 21:28:11   
NAME                        READY   STATUS        RESTARTS   AGE
backend-69c58946dd-lnc95    1/1     Terminating   0          93s
backend-69c58946dd-xpls4    1/1     Running       0          31m
backend-69c58946dd-zmtkv    1/1     Terminating   0          93s
frontend-5bd5db987b-7lwbk   1/1     Terminating   0          93s
frontend-5bd5db987b-bghmt   1/1     Terminating   0          93s
frontend-5bd5db987b-mbbfl   1/1     Running       0          31m
```
В итоге получим исходное число:
```bash
kubectl -n prod get po
NAME                        READY   STATUS    RESTARTS   AGE
backend-69c58946dd-xpls4    1/1     Running   0          32m
frontend-5bd5db987b-mbbfl   1/1     Running   0          32m
```