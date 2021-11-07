# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1: Опишите своими словами основные преимущества применения на практике IaaC паттернов. Какой из принципов IaaC является основополагающим?
Внедрение практик IaaC позволяет упростить управление системой и поддерживать в актуальном состоянии как код, так и все ресурсы. Также IaaC уменьшает вероятность дрифта конфигурации.

## Задача 2: Чем Ansible выгодно отличается от других систем управление конфигурациями?  Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
Ansible прост для понимания, не требует для работы агента (работает по SSH), совместим с множеством технологий.  
У каждого из методов работы с конфигурацией есть свои плюсы и минусы. Самым оптимальным является комбинирование их в единой системе. Например, использование метода pull для разворачивания тестовых стендов и метода push для работы с продакшеном.

# Задача 3: Установить на личный компьютер:

* VirtualBox

``` shell
[Himura@fedora ~]$ virtualbox --help

Oracle VM VirtualBox VM Selector v6.1.28

(C) 2005-2021 Oracle Corporation

All rights reserved.



No special options.



If you are looking for --startvm and related options, you need to use VirtualBoxVM.
```
* Vagrant
```shell
[Himura@fedora ~]$ vagrant --version

Vagrant 2.2.16
```

* Ansible
```shell

[Himura@fedora ~]$ ansible --version

ansible 2.9.27

  config file = /etc/ansible/ansible.cfg

  configured module search path = ['/home/Himura/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']

  ansible python module location = /usr/lib/python3.10/site-packages/ansible

  executable location = /usr/bin/ansible

  python version = 3.10.0 (default, Oct  4 2021, 00:00:00) [GCC 11.2.1 20210728 (Red Hat 11.2.1-1)]
```

Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.

# Задача 4: Воспроизвести практическую часть лекции самостоятельно.

Создать виртуальную машину.
Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
``docker ps``
