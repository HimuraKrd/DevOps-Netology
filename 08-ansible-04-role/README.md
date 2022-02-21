# Домашнее задание к занятию "8.4 Работа с Roles"

## Подготовка к выполнению
1. Создайте два пустых публичных репозитория в любом своём проекте: kibana-role и filebeat-role.
2. Добавьте публичную часть своего ключа к своему профилю в github.

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для elastic, kibana, filebeat и написать playbook для использования этих ролей. Ожидаемый результат: существуют два ваших репозитория с roles и один репозиторий с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:
   ```yaml
   ---
     - src: git@github.com:netology-code/mnt-homeworks-ansible.git
       scm: git
       version: "2.0.0"
       name: elastic 
   ```
2. При помощи `ansible-galaxy` скачать себе эту роль.
3. Создать новый каталог с ролью при помощи `ansible-galaxy role init kibana-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Создать новый каталог с ролью при помощи `ansible-galaxy role init filebeat-role`.
7. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
8. Перенести нужные шаблоны конфигов в `templates`.
9. Описать в `README.md` обе роли и их параметры.
10. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию.
11. Добавьте roles в `requirements.yml` в playbook.
12. Переработайте playbook на использование roles.
13. Выложите playbook в репозиторий.
14. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли logstash.
2. Создайте дополнительный набор tasks, который позволяет обновлять стек ELK.
3. Убедитесь в работоспособности своего стека: установите logstash на свой хост с elasticsearch, настройте конфиги logstash и filebeat так, чтобы они взаимодействовали друг с другом и elasticsearch корректно.
4. Выложите logstash-role в репозиторий. В ответ приведите ссылку.

---

## Результат

Также как и в прошлом задании я решил начать с провижининга виртуальных машин при помощи терраформ:  
![image](https://user-images.githubusercontent.com/68470186/154982904-bfdd3e44-0d0e-46ab-8870-7b9574895e24.png)  
Так как в лекции обсуждалась возможность работы с разными пакетными менеджерами, решил сделать одну машину на базе убунты, чтоб проверить работу ``apt``. 
  
Задания были выполнены в соответствии с требованиями. В результате получил следующую картину:
```shell
....
TASK [filebeat : Load Kibana Dashboard] *******************************************************************************************************************************
skipping: [filebeat]

PLAY RECAP ************************************************************************************************************************************************************
elastic                    : ok=8    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
filebeat                   : ok=9    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
kibana                     : ok=8    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```
Для запуска плейбука необходимо выполнить команду ``ansible-playbook -i inventory/lab site.yaml``.  
Внутри папки ``roles`` есть 3 каталога с всеми директорами, созданными при помощи команды ``ansible-galaxy init [role_name]``. Внутри каждой расположены соответствующие компоненты (таски, хэндлеры, темплейты и т.д.).  
В результате прогона плейбука поднимается стек из ElasticSearch, Kibana и Filebeat. Сервисы работают:  
![image](https://user-images.githubusercontent.com/68470186/154984021-224588da-2114-457b-b89c-83a7e80502be.png)  
  
Пример "разбивания" плейбука на роли:
```shell
# файл configure.yml для filebeat из роли filebeat.
---
- name: configure filebeat
  become: true
  template:
    src: filebeat.yml.j2
    mode: 0644
    dest: /etc/filebeat/filebeat.yml
  notify: restart_filebeat

- name: set filebeat systemwork
  become: true
  command:
    cmd: filebeat modules enable system
    chdir: /usr/share/filebeat/bin
  register: filebeat_modules
  changed_when: filebeat_modules.stdout != 'Module system is alreade enabled'
    
- name: enable filebeat service
  become: true
  service:
    name: filebeat
    state: started
    enabled: yes

- name: Load Kibana Dashboard
  become: true
  command:
    cmd: filebeat setup
    chdir: /usr/share/filebeat/bin
  register: filebeat_setup
  changed_when: filebeat_setup
  until: filebeat_setup is succeeded
```
Данный плейбук будет выполняться на следующих дистрибьютивах:  
```yaml
supported_systems: ['CentOS', 'Red Hat Enterprise Linux', 'Ubuntu', 'Debian']```
---
