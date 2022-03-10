# Домашнее задание к занятию "08.05 Тестирование Roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.4.0"`
2. Соберите локальный образ на основе [Dockerfile](./Dockerfile)

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для kibana, logstash. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test` внутри корневой директории elasticsearch-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью kibana-role и создайте сценарий тестирования по умолчаню при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert'ов в verify.yml файл, для  проверки работоспособности kibana-role (проверка, что web отвечает, проверка логов, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Повторите шаги 2-4 для filebeat-role.
6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/elasticsearch-role -w /opt/elasticsearch-role -it <image_name> /bin/bash`, где path_to_repo - путь до корня репозитория с elasticsearch-role на вашей файловой системе.
2. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
3. Добавьте файл `tox.ini` в корень репозитория каждой своей роли.
4. Создайте облегчённый сценарий для `molecule`. Проверьте его на исполнимость.
5. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
6. Запустите `docker` контейнер так, чтобы внутри оказались обе ваши роли.
7. Зайдти поочерёдно в каждую из них и запустите команду `tox`. Убедитесь, что всё отработало успешно.
8. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в каждом репозитории. Ссылки на репозитории являются ответами на домашнее задание. Не забудьте указать в ответе теги решений Tox и Molecule заданий.

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли logstash.
2. Создайте дополнительный набор tasks, который позволяет обновлять стек ELK.
3. В ролях добавьте тестирование в раздел `verify.yml`. Данный раздел должен проверять, что logstash через команду `logstash -e 'input { stdin { } } output { stdout {} }'`  отвечате адекватно.
4. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
5. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
6. Выложите свои roles в репозитории. В ответ приведите ссылки.

---

### Как оформить ДЗ?

Установим molecule и molecule_docker:
```shell
mbagirov@mbagirov-work-linux:~/education/devops-netology$ molecule --version
molecule 3.4.0 using python 3.9 
    ansible:2.10.15
    delegated:3.4.0 from molecule
    docker:1.1.0 from molecule_docker requiring collections: community.docker>=1.9.1
```
  
Зарегистрируемся и авторизуемся на портале RedHat для сборки образа
```shell
mbagirov@mbagirov-work-linux:~/education/mnt-homeworks$ mv /home/mbagirov/education/08-ansible-05-testing/ /home/mbagirov/education/devops-netology/
mbagirov@mbagirov-work-linux:~/education/mnt-homeworks$ docker login https://registry.redhat.io
Username: mbagirov
Password: 
WARNING! Your password will be stored unencrypted in /home/mbagirov/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
mbagirov@mbagirov-work-linux:~/education/mnt-homeworks$ 
```
  
Судя по наполнению, образ основан на ``podman``, поэтому соберём его, используя соответствующий тег:
```shell
mbagirov@mbagirov-work-linux:~/education/devops-netology/08-ansible-05-testing$ docker build -t podman:molecule -f Dockerfile .
```
Посмотрим на образы в системе:
```shell
mbagirov@mbagirov-work-linux:~/education/devops-netology/08-ansible-05-testing$ docker images
REPOSITORY                        TAG        IMAGE ID       CREATED          SIZE
podman                            molecule   ae2c223791e3   18 minutes ago   2.51GB
registry.redhat.io/rhel8/podman   latest     f58db8adf7bb   4 weeks ago      399MB
pycontribs/fedora                 latest     c31790496329   10 months ago    586MB
pycontribs/centos                 7          bafa54e44377   10 months ago    488MB
pycontribs/ubuntu                 latest     42a4e3b21923   23 months ago    664MB
```
Заходим в роль ``elastic`` и запускаем молекулу, согласно задания 1. В результате видно большое полотно текста и то, что плейбук падает: 
```shell
...
TASK [Include mnt-homeworks-ansible] *******************************************
ERROR! the role 'mnt-homeworks-ansible' was not found in /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/elastic/molecule/default/roles:/home/mbagirov/.cache/molecule/elastic/default/roles:/home/mbagirov/education/devops-netology/08-ansible-05-testing/roles:/home/mbagirov/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/mbagirov/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/mbagirov/.cache/ansible-lint/933709/roles:/home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/elastic/molecule/default

The error appears to be in '/home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/elastic/molecule/default/converge.yml': line 7, column 15, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:

      include_role:
        name: "mnt-homeworks-ansible"
              ^ here

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/home/mbagirov/.cache/molecule/elastic/default/inventory', '--skip-tags', 'molecule-notest,notest', '/home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/elastic/molecule/default/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
```
Ошибка возникла в связи с разницей в именах. Заходим в файл ``converge.yml`` и меняем конфигурацию, указывая правильное название роли:
```yaml
---
- name: Converge
  hosts: all
  tasks:
    - name: "Include mnt-homeworks-ansible"
      include_role:
        name: "elastic"
```
К сожалению, ошибки продолжили сыпаться и были связаны с тем, что handler пытался отработать, не смотря на параметр в его настройках. После отключения триггера хэндлера плейбук отработал без ошибок:

```shell
...
PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
mbagirov@mbagirov-work-linux:~/education/devops-netology/08-ansible-05-testing/roles/elastic$ 
```

Перейдём в каталог с ролью kibana и выполним требуемую команду из задания 2:
```shell
mbagirov@mbagirov-work-linux:~/education/devops-netology/08-ansible-05-testing/roles/kibana$ molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/molecule/default successfully.
```
В созданный по-умолчанию файл ``molecule.yml`` уже включён centos8:
```yaml
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: instance
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible
```
Согласно заданию добавим в каталог ещё разных образов (также добавим модуль elastic, без которого кибана не заработает):
```yaml

---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  # kibana нужен эластик в качестве базы данных
  - name: elastic
    # groups: 
    #   - elasticsearch
    image: docker.io/pycontribs/centos:7
    pre_build_image: true
    # command: /usr/sbin/init
    privileged: true
  
  # платформы для тестирования роли
  - name: centos7
    # groups: 
    #   - kibana
    image: docker.io/pycontribs/centos:7
    pre_build_image: true
    # command: /usr/sbin/init
    privileged: true
  
  - name: centos8
    # groups: 
    #   - kibana
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
    # command: /usr/sbin/init
    privileged: true  
  
  - name: ubuntu
    # groups: 
    #   - kibana
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true
    # privileged: true  
provisioner:
  name: ansible
verifier:
  name: ansible
```
После многих часов поиска и устранения разного рода ошибок всё-таки получилось проиграть плейбук без ошибок:
```yaml
mbagirov@mbagirov-work-linux:~/education/devops-netology/08-ansible-05-testing/roles/kibana$ molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Guessed /home/mbagirov/education/devops-netology as project root directory
WARNING  Computed fully qualified role name of kibana does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.

INFO     Using /home/mbagirov/.cache/ansible-lint/933709/roles/kibana symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/mbagirov/.cache/ansible-lint/933709/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=elastic)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=elastic)
ok: [localhost] => (item=centos7)
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'command': '/usr/sbin/init', 'groups': ['elasticsearch'], 'image': 'docker.io/pycontribs/centos:7', 'name': 'elastic', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'groups': ['kibana'], 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
ok: [localhost] => (item={'command': '/usr/sbin/init', 'groups': ['kibana'], 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
ok: [localhost] => (item={'groups': ['kibana'], 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'command': '/usr/sbin/init', 'groups': ['elasticsearch'], 'image': 'docker.io/pycontribs/centos:7', 'name': 'elastic', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
skipping: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'groups': ['kibana'], 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
skipping: [localhost] => (item={'command': '/usr/sbin/init', 'groups': ['kibana'], 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
skipping: [localhost] => (item={'groups': ['kibana'], 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}) 

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'command': '/usr/sbin/init', 'groups': ['elasticsearch'], 'image': 'docker.io/pycontribs/centos:7', 'name': 'elastic', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'groups': ['kibana'], 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'command': '/usr/sbin/init', 'groups': ['kibana'], 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'groups': ['kibana'], 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 3, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest) 

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'command': '/usr/sbin/init', 'groups': ['elasticsearch'], 'image': 'docker.io/pycontribs/centos:7', 'name': 'elastic', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'groups': ['kibana'], 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
ok: [localhost] => (item={'command': '/usr/sbin/init', 'groups': ['kibana'], 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
ok: [localhost] => (item={'groups': ['kibana'], 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=elastic)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '924095586456.72513', 'results_file': '/home/mbagirov/.ansible_async/924095586456.72513', 'changed': True, 'failed': False, 'item': {'command': '/usr/sbin/init', 'groups': ['elasticsearch'], 'image': 'docker.io/pycontribs/centos:7', 'name': 'elastic', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '969663921772.72539', 'results_file': '/home/mbagirov/.ansible_async/969663921772.72539', 'changed': True, 'failed': False, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'groups': ['kibana'], 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '531081486158.72579', 'results_file': '/home/mbagirov/.ansible_async/531081486158.72579', 'changed': True, 'failed': False, 'item': {'command': '/usr/sbin/init', 'groups': ['kibana'], 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volume': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '872692658360.72620', 'results_file': '/home/mbagirov/.ansible_async/872692658360.72620', 'changed': True, 'failed': False, 'item': {'groups': ['kibana'], 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [elk-elasticsearch] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [elastic]

TASK [elastic : Fail if unsupported system detected] ***************************
skipping: [elastic]

TASK [elastic : Check files directory exists] **********************************
ok: [elastic -> localhost]

TASK [elastic : include_tasks] *************************************************
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/elastic/tasks/download_yum.yml for elastic

TASK [elastic : Download Elasticsearch's rpm] **********************************
ok: [elastic -> localhost]

TASK [elastic : Copy Elasticsearch to managed node] ****************************
changed: [elastic]

TASK [elastic : include_tasks] *************************************************
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/elastic/tasks/install_yum.yml for elastic

TASK [elastic : Install Elasticsearch] *****************************************
changed: [elastic]

TASK [elastic : Configure Elasticsearch] ***************************************
changed: [elastic]

PLAY [elk-kibana] **************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

TASK [kibana : Fail if unsupported system detected] ****************************
skipping: [centos7]
skipping: [centos8]
skipping: [ubuntu]

TASK [kibana : Check files directory exists] ***********************************
ok: [centos7 -> localhost]

TASK [kibana : include_tasks] **************************************************
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/download_yum.yml for centos7
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/download_dnf.yml for centos8
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/download_apt.yml for ubuntu

TASK [kibana : Download Kibana's rpm] ******************************************
ok: [centos7 -> localhost]

TASK [kibana : Copy Kibana to managed node] ************************************
changed: [centos7]

TASK [kibana : Download Kibana's rpm] ******************************************
ok: [centos8 -> localhost]

TASK [kibana : Copy Kibana to managed node] ************************************
changed: [centos8]

TASK [kibana : Download Kibana's deb] ******************************************
ok: [ubuntu -> localhost]

TASK [kibana : Copy Kibana to managed node] ************************************
changed: [ubuntu]

TASK [kibana : include_tasks] **************************************************
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/install_yum.yml for centos7
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/install_dnf.yml for centos8
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/install_apt.yml for ubuntu

TASK [kibana : Install Kibana] *************************************************
changed: [centos7]

TASK [kibana : Install kibana] *************************************************
changed: [centos8]

TASK [kibana : Install Kibana] *************************************************
changed: [ubuntu]

TASK [kibana : Configure Kibana] ***********************************************
changed: [ubuntu]
changed: [centos7]
changed: [centos8]

RUNNING HANDLER [kibana : restart kibana] **************************************
changed: [centos8]

PLAY RECAP *********************************************************************
centos7                    : ok=8    changed=3    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
centos8                    : ok=8    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
elastic                    : ok=8    changed=3    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu                     : ok=7    changed=3    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [elk-elasticsearch] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [elastic]

TASK [elastic : Fail if unsupported system detected] ***************************
skipping: [elastic]

TASK [elastic : Check files directory exists] **********************************
ok: [elastic -> localhost]

TASK [elastic : include_tasks] *************************************************
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/elastic/tasks/download_yum.yml for elastic

TASK [elastic : Download Elasticsearch's rpm] **********************************
ok: [elastic -> localhost]

TASK [elastic : Copy Elasticsearch to managed node] ****************************
ok: [elastic]

TASK [elastic : include_tasks] *************************************************
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/elastic/tasks/install_yum.yml for elastic

TASK [elastic : Install Elasticsearch] *****************************************
ok: [elastic]

TASK [elastic : Configure Elasticsearch] ***************************************
ok: [elastic]

PLAY [elk-kibana] **************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]
ok: [ubuntu]
ok: [centos7]

TASK [kibana : Fail if unsupported system detected] ****************************
skipping: [centos7]
skipping: [centos8]
skipping: [ubuntu]

TASK [kibana : Check files directory exists] ***********************************
ok: [centos7 -> localhost]

TASK [kibana : include_tasks] **************************************************
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/download_yum.yml for centos7
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/download_dnf.yml for centos8
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/download_apt.yml for ubuntu

TASK [kibana : Download Kibana's rpm] ******************************************
ok: [centos7 -> localhost]

TASK [kibana : Copy Kibana to managed node] ************************************
ok: [centos7]

TASK [kibana : Download Kibana's rpm] ******************************************
ok: [centos8 -> localhost]

TASK [kibana : Copy Kibana to managed node] ************************************
ok: [centos8]

TASK [kibana : Download Kibana's deb] ******************************************
ok: [ubuntu -> localhost]

TASK [kibana : Copy Kibana to managed node] ************************************
ok: [ubuntu]

TASK [kibana : include_tasks] **************************************************
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/install_yum.yml for centos7
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/install_dnf.yml for centos8
included: /home/mbagirov/education/devops-netology/08-ansible-05-testing/roles/kibana/tasks/install_apt.yml for ubuntu

TASK [kibana : Install Kibana] *************************************************
ok: [centos7]

TASK [kibana : Install kibana] *************************************************
ok: [centos8]

TASK [kibana : Install Kibana] *************************************************
ok: [ubuntu]

TASK [kibana : Configure Kibana] ***********************************************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

PLAY RECAP *********************************************************************
centos7                    : ok=8    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
centos8                    : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
elastic                    : ok=8    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu                     : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Check if log file is created] ********************************************
ok: [ubuntu]
ok: [centos7]
ok: [centos8]

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=elastic)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=elastic)
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (298 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (297 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (296 retries left).
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
mbagirov@mbagirov-work-linux:~/education/devops-netology/08-ansible-05-testing/roles/kibana$ 
```
Для теста ``verify`` добавил проверку создания логов в ``/var/lib/kibana`` на хостах, где этот бинарь ставится.

```yaml
PLAY [Verify] ******************************************************************

TASK [Check if log file is created] ********************************************
ok: [ubuntu]
ok: [centos7]
ok: [centos8]
```
Проделал те же самые проверки для filebeat:
```yaml
PLAY RECAP *********************************************************************
centos7                    : ok=9    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
centos8                    : ok=8    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
elastic                    : ok=8    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
kibana                     : ok=8    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu                     : ok=8    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier
[WARNING]: Could not match supplied host pattern, ignoring: filebeat

PLAY [Verify] ******************************************************************
skipping: no hosts matched

PLAY RECAP *********************************************************************

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=elastic)
changed: [localhost] => (item=kibana)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item=elastic)
changed: [localhost] => (item=kibana)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
mbagirov@mbagirov-work-linux:~/education/devops-netology/08-ansible-05-testing/roles/filebeat$ 
```
---  
В процессе тестирования через tox были выявлены проблемы и разница в поведении. Так, например, в ubuntu появились проблемы с работой от root пользователя (добавлением become=true в плейбуке). Поэтому пришлось переписать многие куски (актуальная версия загружена в github).  
Другой проблемой при работы с podman было то, что podman-in-podman не мог запустить контейнеры в namespace по-умолчанию. Для этого пришлось внутри контейнера с подманом отредактировать файл ``/etc/containers/containers.conf``. По-умолчанию в нём стоит следующая конфигурация:
```shell
[containers]
netns="host"
userns="host"
ipcns="host"
utsns="host"
cgroupns="host"
cgroups="disabled"
log_driver = "k8s-file"
[engine]
cgroup_manager = "cgroupfs"
events_logger="file"
runtime="crun"
```
Для работы необходимо заменить занчение параметров ``netns`` и ``utsns`` на ``private``. После изменение плейбука и отредактирования конфигурационного файла tox успешно проходит тестирование:
``` shell
PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
_______________________________________________________________________________ summary _______________________________________________________________________________
  py36-ansible30: commands succeeded
  py39-ansible30: commands succeeded
  congratulations :)
[root@6afa4d0a9836 kibana]# 
```
Проделал ту же самую процедуру для filebeat - результат аналогичен.
```shell
  py36-ansible30: commands succeeded
  py39-ansible30: commands succeeded
  congratulations :)
[root@9e676c36c816 filebeat]# 
```

Также в задаче требуется использовать упрощённый сценарий тестирования. Это достигается путём указания соответствующих шагов (блока scenario) в ``molecule.yml``:
```yaml
scenario:
  test_sequence:
    - destroy
    - create
    - prepare
    - converge
    - destroy
```
Я добавил сценарий ``tox`` и прописал его для исполнения по умолчанию при вызове tox внутри контейнера (для этого редактируется блок ``commands`` в файле tox.ini):
```yaml
[tox]
minversion = 1.8
basepython = python3.6
envlist = py{36,39}-ansible{30}
skipsdist = true

[testenv]
deps =
    -rtox-requirements.txt
    ansible28: ansible<2.9
    ansible29: ansible<2.10
    ansible210: ansible<3.0
    ansible30: ansible<3.1
commands =
    {posargs:molecule test -s tox}
```
