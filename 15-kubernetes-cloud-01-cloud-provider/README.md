# Домашнее задание к занятию "15.1. Организация сети"

Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако и дополнительной части в AWS по желанию. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. 

Перед началом работ следует настроить доступ до облачных ресурсов из Terraform используя материалы прошлых лекций и [ДЗ](https://github.com/netology-code/virt-homeworks/tree/master/07-terraform-02-syntax ). А также заранее выбрать регион (в случае AWS) и зону.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать VPC.
- Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 192.168.10.0/24.
- Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1
- Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 192.168.20.0/24.
- Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
- Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и убедиться что есть доступ к интернету

Resource terraform для ЯО
- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet)
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table)
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance)
---
## Решение.
Создал конфигурационные манифесты для терраформ (программу установил при помощи зеркала яндекс). В результате запуска получил следующую картину:  

Созданные виртуальные машины:  
![image](https://user-images.githubusercontent.com/68470186/187047396-16df596b-430f-49fa-a4a6-b13151b6e9f0.png)  
  
Созданная VPC:  
![image](https://user-images.githubusercontent.com/68470186/187047413-1915f8aa-e1ab-49a9-8c91-914b0cf16a37.png)  

Созданные подсети:  
![image](https://user-images.githubusercontent.com/68470186/187047422-c6ae4a6f-8698-416d-ae17-29d8fef7d475.png)  

Созданная таблица маршрутизации:  
![image](https://user-images.githubusercontent.com/68470186/187047431-13459dbd-44a5-4362-99eb-8e2282955613.png)

В результате смог подключиться к виртуальной машине по ssh, используя пользователя ``ubuntu``, заданного в инструкции ``metadata``, для проброса SSH ключей:
```bash
ssh ubuntu@62.84.118.103
Welcome to Ubuntu 18.04.1 LTS (GNU/Linux 4.15.0-29-generic x86_64) 

* Documentation:  https://help.ubuntu.com 
* Management:     https://landscape.canonical.com 
* Support:        https://ubuntu.com/advantage 

New release '20.04.4 LTS' available. 
Run 'do-release-upgrade' to upgrade to it. 



################################################################# 
This instance runs Yandex.Cloud Marketplace product 
Please wait while we configure your product... 

Documentation for Yandex Cloud Marketplace images available at https://cloud.yand
ex.ru/docs 

################################################################# 

Last login: Sat Aug 27 20:11:32 2022 from 45.130.173.21 
To run a command as administrator (user "root"), use "sudo <command>". 
See "man sudo_root" for details. 
ubuntu@fhm0ver39jtpi4nuoi7b:~$
```
При помощи scp разместил закрытый файл ключа на машине, имеющей публичный IP адрес. Это было необходимо, чтобы с неё иметь возможность достучаться по SSH к машине, в закрытом контуре.

```bash
ubuntu@fhm0ver39jtpi4nuoi7b:~$ ssh ubuntu@192.168.20.6 
Welcome to Ubuntu 18.04.1 LTS (GNU/Linux 4.15.0-29-generic x86_64) 

* Documentation:  https://help.ubuntu.com 
* Management:     https://landscape.canonical.com 
* Support:        https://ubuntu.com/advantage 

Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your I
nternet connection or proxy settings 



################################################################# 
This instance runs Yandex.Cloud Marketplace product 
Please wait while we configure your product... 

Documentation for Yandex Cloud Marketplace images available at https://cloud.yand
ex.ru/docs 

################################################################# 

Last login: Sat Aug 27 20:11:36 2022 from 192.168.10.7 
To run a command as administrator (user "root"), use "sudo <command>". 
See "man sudo_root" for details. 

ubuntu@fhm5bk3l657lij1vhdfe:~$ ping 8.8.8.8 
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data. 
64 bytes from 8.8.8.8: icmp_seq=1 ttl=59 time=19.5 ms 
64 bytes from 8.8.8.8: icmp_seq=2 ttl=59 time=18.1 ms 
64 bytes from 8.8.8.8: icmp_seq=3 ttl=59 time=18.2 ms 
64 bytes from 8.8.8.8: icmp_seq=4 ttl=59 time=18.3 ms 
^C 
--- 8.8.8.8 ping statistics --- 
5 packets transmitted, 4 received, 20% packet loss, time 4006ms 
rtt min/avg/max/mdev = 18.196/18.581/19.515/0.542 ms 
ubuntu@fhm5bk3l657lij1vhdfe:~$ logout 
Connection to 192.168.20.6 closed. 
ubuntu@fhm0ver39jtpi4nuoi7b:~$ logout 
Connection to 62.84.118.103 closed.
```
Если менять правило маршрутизации (например изменить на 0.0.0.0/24) - пинг 8.8.8.8 становится невозможным. 

---
## Задание 2*. AWS (необязательное к выполнению)

1. Создать VPC.
- Cоздать пустую VPC с подсетью 10.10.0.0/16.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 10.10.1.0/24
- Разрешить в данной subnet присвоение public IP по-умолчанию. 
- Создать Internet gateway 
- Добавить в таблицу маршрутизации маршрут, направляющий весь исходящий трафик в Internet gateway.
- Создать security group с разрешающими правилами на SSH и ICMP. Привязать данную security-group на все создаваемые в данном ДЗ виртуалки
- Создать в этой подсети виртуалку и убедиться, что инстанс имеет публичный IP. Подключиться к ней, убедиться что есть доступ к интернету.
- Добавить NAT gateway в public subnet.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 10.10.2.0/24
- Создать отдельную таблицу маршрутизации и привязать ее к private-подсети
- Добавить Route, направляющий весь исходящий трафик private сети в NAT.
- Создать виртуалку в приватной сети.
- Подключиться к ней по SSH по приватному IP через виртуалку, созданную ранее в публичной подсети и убедиться, что с виртуалки есть выход в интернет.

Resource terraform
- [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)
