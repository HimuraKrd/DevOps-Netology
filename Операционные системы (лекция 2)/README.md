## 1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:
* поместите его в автозагрузку,
* предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron),
* удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.  

Установим NodeExporter согласно документации на сайте:  
``wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz``
``tar -xf node_exporter-1.2.2.linux-amd64.tar.gz``  
``cd node_exporter-1.2.2.linux-amd64``  
``./node_exporter``  
Создазим unit-файл, предварительно ознакомившись с документацией:  
``sudo nano node_exporter.service /etc/systemd/system/node_exporter.service``  
Ознакомившись с примером, будем скопируем папку в ``/usr/sbin/``:  
``sudo cp node_exporter /usr/sbin``  
Cоздаем файл с настройками:  
![task_1_opt](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/1_node_exporter_services.png)  
Помещаем в автозагрузку:  
![task_1_enable](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/1_node_exporter_enable.png)  
Создаём файл с опциями:  
![task_1_options](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/1_node_exporter_options.png)  
Добавляем в автозагрузку и проверяем:  
``sudo systemctl daemon-reload``  
``sudo systemctl enable --now node_exporter``  
``sudo systemctl status node_exporter`` 
![task_1_status](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/1_node_exporter_status.png)  
Перезагружаем систему и смотрим, что программа запускается при старте:  
![task_1_final](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/1_node_exporter_status_after_reboot.png)

## 2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
Основные метрики можно посмотреть на github, в разделе, посвящённом node_exporter. Для мониторинга я бы взял метрики ``--collector.cpu --collector.meminfo --collector.filesystem --collector.netdev --collector.diskstats``  

## 3. Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata).
После успешной установки:
* в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,  
* добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте ``vagrant reload``:  
* config.vm.network "forwarded_port", guest: 19999, host: 19999  
После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.  

Установим NetData Monitoring, используя команду ``bash <(curl -Ss https://my-netdata.io/kickstart.sh)``, добавим в автозагрузку и запустим сервис:  
``sudo systemctl start netdata``  
``sudo systemctl enable netdata``  
``sudo systemctl status netdata``
Изменим Vargantfile согласно заданию:  
![task_3_1](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/3_vagrant_file.png)  
После чего зайдём по адресу: ``http://localhost:19999/``:  
![task3_2](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/3_net_data_page.png)

## 4. Можно ли по выводу ``dmesg`` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
Думаю, достаточно будет сделать ``dmesg | grep virt`` и увидеть, что  
![task_4](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/4_dmesg.png)  
Система - ``virtualized system``.

## 5. Как настроен ``sysctl fs.nr_open`` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа ``(ulimit --help)``?
``vagrant@vagrant:~$ sysctl fs.nr_open``  
``fs.nr_open = 1048576``  
Погуглил ответ - параметр означает максимальное количество открытых файлов. Аналог - использование ``ulimit -n`` если я правильно понимаю вывод:  
![task_5](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/5_final.png)

## 6. Запустите любой долгоживущий процесс (не ``ls``, который отработает мгновенно, а, например, ``sleep 1h``) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под ``PID 1`` через ``nsenter``. Для простоты работайте в данном задании под ``root`` (``sudo -i``). Под обычным пользователем требуются дополнительные опции (``--map-root-user``) и т.д.

Запустим ``htop`` в новом неймспейсе, используя команду ``unshare -fp --mount-proc htop``(взято из примера по ``man unshare``).  
![task_6_unshare](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/6_unshare_namespace.png)  
Найдём через ``ps aux | grep htop`` наш процесс:  
![task_6_ps_aux](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/6_ps_aux.png)  
Используя команду ``nsenter -t 2104 -p --mount``, откроем новый нэймспейс и посмотрим, какие в нём есть процессы: 
![task_6_final](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/6_open_new_namespace.png)  
Вывод в ``htop`` также изменится и в нём появится ``bash``:  
![task_6_htop](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9E%D0%BF%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%202)/images/6_htop_output.png)

## 7. Найдите информацию о том, что такое ``:(){ :|:& };:``. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов ``dmesg`` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
Гугл подсказал, что ``:(){ :|:& };:`` - так называемая fork bomb - функция, которая вызывает сама себя и плодит процессы. Последней строкой в ``dmesg`` была информация, о том, что ``[ 4116.040020] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope``. Как я понимаю, здесь мы возвращаемся к параметрам из задания 5. Посмотрим на другие лимиты в системе, используя ``ulimit --help`` и среди них найдём параметр ``-u``, отвечающий за количество процессов. Гугл также подсказал, что изменить ограничения можно путём коррективки файла ``/etc/security/limits.conf file`` и его параметра ``nproc – max number of processes``.
