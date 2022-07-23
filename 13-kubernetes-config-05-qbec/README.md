# Домашнее задание к занятию "13.5 поддержка нескольких окружений на примере Qbec"
Приложение обычно существует в нескольких окружениях. Для удобства работы следует использовать соответствующие инструменты, например, Qbec.

## Задание 1: подготовить приложение для работы через qbec
Приложение следует упаковать в qbec. Окружения должно быть 2: stage и production. 

Требования:
* stage окружение должно поднимать каждый компонент приложения в одном экземпляре;
* production окружение — каждый компонент в трёх экземплярах;
* для production окружения нужно добавить endpoint на внешний адрес.

---

## Решение

Перенесём код в один компонент. В данной работе он назван "netologyQbec". Опишем состояние окружений в папке "environment". Укажем куда подключаться в qbec.yaml.  
Предварительно создадим два ns для работы qbec:
```bash
kubectl create ns stage
kubectl create ns prod
```
Сделаем валидацию кода в prod окружении:
```bash
qbec validate prod                                      
setting cluster to minikube
setting context to minikube
cluster metadata load took 22ms
[warn] component nginx included from prod is already included by default
2 components evaluated in 4ms
✔ deployments backend -n prod (source netologyQbec) is valid
✔ persistentvolumeclaims front-pvc-prod -n prod (source netologyQbec) is valid
✔ services backend -n prod (source netologyQbec) is valid
✔ services frontend -n prod (source netologyQbec) is valid
✔ statefulsets db -n prod (source netologyQbec) is valid
✔ persistentvolumes back-pv-prod (source netologyQbec) is valid
✔ persistentvolumes front-pv-prod (source netologyQbec) is valid
✔ deployments frontend -n prod (source netologyQbec) is valid
✔ deployments nginx-deployment -n prod (source nginx) is valid
✔ persistentvolumeclaims back-pvc-prod -n prod (source netologyQbec) is valid
✔ services db -n prod (source netologyQbec) is valid
---
stats:
  valid: 11

command took 140ms
```
Повторим для stage окружения:
```bash
qbec validate stage                                    
setting cluster to minikube
setting context to minikube
cluster metadata load took 26ms
2 components evaluated in 4ms
✔ deployments backend -n stage (source netologyQbec) is valid
✔ persistentvolumeclaims front-pvc-stage -n stage (source netologyQbec) is valid
✔ services backend -n stage (source netologyQbec) is valid
✔ services frontend -n stage (source netologyQbec) is valid
✔ deployments frontend -n stage (source netologyQbec) is valid
✔ persistentvolumes front-pv-stage (source netologyQbec) is valid
✔ services db -n prod (source netologyQbec) is valid
✔ statefulsets db -n stage (source netologyQbec) is valid
✔ persistentvolumes back-pv-stage (source netologyQbec) is valid
✔ persistentvolumeclaims back-pvc-stage -n stage (source netologyQbec) is valid
✔ deployments nginx-deployment -n stage (source nginx) is valid
---
stats:
  valid: 11

command took 150ms
```
Установим prod окружение:
```bash
qbec apply prod                                      
setting cluster to minikube
setting context to minikube
cluster metadata load took 24ms
[warn] component nginx included from prod is already included by default
2 components evaluated in 5ms

will synchronize 11 object(s)

Do you want to continue [y/n]: y
[warn] component nginx included from prod is already included by default
2 components evaluated in 7ms
create persistentvolumes back-pv-prod (source netologyQbec)
W0724 02:13:00.769669  449400 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
create persistentvolumes front-pv-prod (source netologyQbec)
I0724 02:13:01.909730  449400 request.go:665] Waited for 1.125946498s due to client-side throttling, not priority and fairness, request: GET:https://192.168.49.2:8443/api/v1/nodes?labelSelector=qbec.io%2Fapplication%3DnetologyQbec%2Cqbec.io%2Fenvironment%3Dprod%2C%21qbec.io%2Ftag&limit=1000
create persistentvolumeclaims back-pvc-prod -n prod (source netologyQbec)
create persistentvolumeclaims front-pvc-prod -n prod (source netologyQbec)
create deployments backend -n prod (source netologyQbec)
create deployments frontend -n prod (source netologyQbec)
create deployments nginx-deployment -n prod (source nginx)
create statefulsets db -n prod (source netologyQbec)
create services backend -n prod (source netologyQbec)
create services frontend -n prod (source netologyQbec)
create services db -n prod (source netologyQbec)
server objects load took 1.806s
---
stats:
  created:
  - persistentvolumes back-pv-prod (source netologyQbec)
  - persistentvolumes front-pv-prod (source netologyQbec)
  - persistentvolumeclaims back-pvc-prod -n prod (source netologyQbec)
  - persistentvolumeclaims front-pvc-prod -n prod (source netologyQbec)
  - deployments backend -n prod (source netologyQbec)
  - deployments frontend -n prod (source netologyQbec)
  - deployments nginx-deployment -n prod (source nginx)
  - statefulsets db -n prod (source netologyQbec)
  - services backend -n prod (source netologyQbec)
  - services frontend -n prod (source netologyQbec)
  - services db -n prod (source netologyQbec)

waiting for readiness of 4 objects
  - deployments backend -n prod
  - deployments frontend -n prod
  - deployments nginx-deployment -n prod
  - statefulsets db -n prod

  0s    : statefulsets db -n prod :: 1 of 3 updated
  0s    : deployments frontend -n prod :: 0 of 3 updated replicas are available
  0s    : deployments nginx-deployment -n prod :: 0 of 2 updated replicas are available
  0s    : deployments backend -n prod :: 0 of 3 updated replicas are available
  6s    : statefulsets db -n prod :: 2 of 3 updated
  7s    : deployments frontend -n prod :: 1 of 3 updated replicas are available
  8s    : deployments frontend -n prod :: 2 of 3 updated replicas are available
  9s    : deployments backend -n prod :: 1 of 3 updated replicas are available
  10s   : deployments backend -n prod :: 2 of 3 updated replicas are available
✓ 12s   : statefulsets db -n prod :: 3 new pods updated (3 remaining)
  23s   : deployments nginx-deployment -n prod :: 1 of 2 updated replicas are available
✓ 25s   : deployments backend -n prod :: successfully rolled out (2 remaining)
✓ 27s   : deployments nginx-deployment -n prod :: successfully rolled out (1 remaining)
✓ 29s   : deployments frontend -n prod :: successfully rolled out (0 remaining)

✓ 29s: rollout complete
command took 34.3s
```
Внутрь добавил тестовый POD с nginx для отработки задания 3.  
Проверим статус деплоя:
```bash
kubectl -n prod get all                1 ✘  at minikube ⎈  at 02:20:47   
NAME                                   READY   STATUS    RESTARTS   AGE
pod/backend-6fd954d848-7rsc6           1/1     Running   0          7m47s
pod/backend-6fd954d848-7v5xp           1/1     Running   0          7m47s
pod/backend-6fd954d848-qzjj9           1/1     Running   0          7m47s
pod/db-0                               1/1     Running   0          7m47s
pod/db-1                               1/1     Running   0          7m40s
pod/db-2                               1/1     Running   0          7m34s
pod/frontend-69c7c559d9-9qmtq          1/1     Running   0          7m47s
pod/frontend-69c7c559d9-mmp9h          1/1     Running   0          7m47s
pod/frontend-69c7c559d9-r8jh8          1/1     Running   0          7m47s
pod/nginx-deployment-8d545c96d-54zrw   1/1     Running   0          7m47s
pod/nginx-deployment-8d545c96d-p7qdh   1/1     Running   0          7m47s

NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/backend    ClusterIP   10.107.169.232   <none>        9000/TCP   7m47s
service/db         ClusterIP   10.109.65.33     <none>        5432/TCP   7m46s
service/frontend   ClusterIP   10.110.94.235    <none>        8080/TCP   7m47s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/backend            3/3     3            3           7m47s
deployment.apps/frontend           3/3     3            3           7m47s
deployment.apps/nginx-deployment   2/2     2            2           7m47s

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/backend-6fd954d848           3         3         3       7m47s
replicaset.apps/frontend-69c7c559d9          3         3         3       7m47s
replicaset.apps/nginx-deployment-8d545c96d   2         2         2       7m47s

NAME                  READY   AGE
statefulset.apps/db   3/3     7m47s

kubectl -n prod get endpoints          
NAME       ENDPOINTS                                                  AGE
backend    10.244.120.77:9000,10.244.120.79:9000,10.244.120.86:9000   8m16s
db         10.244.120.83:5432,10.244.120.84:5432,10.244.120.87:5432   8m15s
frontend   10.244.120.80:80,10.244.120.81:80,10.244.120.85:80         8m16s
```
Удалим созданное окружение при помощи ``qbec delete prod``:
```bash
qbec delete prod                                        
setting cluster to minikube
setting context to minikube
cluster metadata load took 21ms
[warn] component nginx included from prod is already included by default
2 components evaluated in 7ms
waiting for deletion list to be returned
W0724 02:22:18.890587  460682 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
server objects load took 1.024s

will delete 11 object(s)

Do you want to continue [y/n]: y
delete services frontend -n prod
delete services db -n prod
delete services backend -n prod
delete statefulsets db -n prod
delete deployments nginx-deployment -n prod
delete deployments frontend -n prod
delete deployments backend -n prod
delete persistentvolumeclaims front-pvc-prod -n prod
delete persistentvolumeclaims back-pvc-prod -n prod
delete persistentvolumes front-pv-prod
delete persistentvolumes back-pv-prod
---
stats:
  deleted:
  - services frontend -n prod
  - services db -n prod
  - services backend -n prod
  - statefulsets db -n prod
  - deployments nginx-deployment -n prod
  - deployments frontend -n prod
  - deployments backend -n prod
  - persistentvolumeclaims front-pvc-prod -n prod
  - persistentvolumeclaims back-pvc-prod -n prod
  - persistentvolumes front-pv-prod
  - persistentvolumes back-pv-prod

command took 2.42s
```
Проверим состояние неймспейса:
```bash
kubectl -n prod get all                 
NAME                           READY   STATUS        RESTARTS   AGE
pod/backend-6fd954d848-7rsc6   1/1     Terminating   0          9m47s
pod/backend-6fd954d848-7v5xp   1/1     Terminating   0          9m47s
pod/backend-6fd954d848-qzjj9   1/1     Terminating   0          9m47s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/backend   0/3     0            0           9m47s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/backend-6fd954d848   3         0         0       9m47s
```
Увидим процесс удаления компонентов. Повторим через пару секунд:
```bash
kubectl -n prod get all                
No resources found in prod namespace.
```
Таким образом qbec позволяет быстро деплоить окружения. 
---
