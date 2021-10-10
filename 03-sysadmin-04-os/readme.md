# Домашнее задание к занятию "3.4. Операционные системы, лекция 2

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
![1_node_exporter_services](https://user-images.githubusercontent.com/68470186/136692590-bd2fd9ad-337d-4aeb-89b8-79c6632d9c8d.png)

Помещаем в автозагрузку:  
![1_node_exporter_enable](https://user-images.githubusercontent.com/68470186/136692603-1c7a5a3f-a452-4da7-b82f-dad49af47e55.png)
 
Создаём файл с опциями:  
![1_node_exporter_options](https://user-images.githubusercontent.com/68470186/136692607-dca3eab2-3d90-4123-acc4-2054e18a65ff.png)

Добавляем в автозагрузку и проверяем:  
``sudo systemctl daemon-reload``  
``sudo systemctl enable --now node_exporter``  
``sudo systemctl status node_exporter`` 
![1_node_exporter_status](https://user-images.githubusercontent.com/68470186/136692611-14007ec4-ffb3-42d6-93a6-6da69d795164.png)

Перезагружаем систему и смотрим, что программа запускается при старте:  
![1_node_exporter_status_after_reboot](https://user-images.githubusercontent.com/68470186/136692613-97085d9b-ba47-4aa0-a7b4-93cc78fcd51d.png)


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
![3_vagrant_file](https://user-images.githubusercontent.com/68470186/136692621-5ae27bda-78ed-4923-91bc-79d79beeee4f.png)
  
После чего зайдём по адресу: ``http://localhost:19999/``:  
![3_net_data_page](https://user-images.githubusercontent.com/68470186/136692626-ef7db38f-fea8-4f48-8921-7050b710c1f4.png)


## 4. Можно ли по выводу ``dmesg`` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
Думаю, достаточно будет сделать ``dmesg | grep virt`` и увидеть, что  
![4_dmesg](https://user-images.githubusercontent.com/68470186/136692628-c9d77815-e690-45e2-b924-5f5cf5062264.png)

Система - ``virtualized system``.

## 5. Как настроен ``sysctl fs.nr_open`` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа ``(ulimit --help)``?
``vagrant@vagrant:~$ sysctl fs.nr_open``  
``fs.nr_open = 1048576``  
Погуглил ответ - параметр означает максимальное количество открытых файлов. Аналог - использование ``ulimit -n`` если я правильно понимаю вывод:  
![5_final](https://user-images.githubusercontent.com/68470186/136692630-90063d13-8451-4b50-b009-fdb15246b458.png)


## 6. Запустите любой долгоживущий процесс (не ``ls``, который отработает мгновенно, а, например, ``sleep 1h``) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под ``PID 1`` через ``nsenter``. Для простоты работайте в данном задании под ``root`` (``sudo -i``). Под обычным пользователем требуются дополнительные опции (``--map-root-user``) и т.д.

Запустим ``htop`` в новом неймспейсе, используя команду ``unshare -fp --mount-proc htop``(взято из примера по ``man unshare``).  
![6_unshare_namespace](https://user-images.githubusercontent.com/68470186/136692636-2c004c73-89e4-4e42-8fb2-90dcf7179096.png)
 
Найдём через ``ps aux | grep htop`` наш процесс:  
![6_ps_aux](https://user-images.githubusercontent.com/68470186/136692637-15f59e35-21c0-49f4-9b17-c875898f14c0.png)
 
Используя команду ``nsenter -t 2104 -p --mount``, откроем новый нэймспейс и посмотрим, какие в нём есть процессы: 
![6_open_new_namespace](https://user-images.githubusercontent.com/68470186/136692639-38cbb1fe-8de3-436f-b905-58d7533683a6.png)

Вывод в ``htop`` также изменится и в нём появится ``bash``:  
![6_htop_output](https://user-images.githubusercontent.com/68470186/136692642-ffc41441-635d-475f-8898-8d72e9441afb.png)


## 7. Найдите информацию о том, что такое ``:(){ :|:& };:``. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов ``dmesg`` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
Гугл подсказал, что ``:(){ :|:& };:`` - так называемая fork bomb - функция, которая вызывает сама себя и плодит процессы. Последней строкой в ``dmesg`` была информация, о том, что ``[ 4116.040020] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope``. Как я понимаю, здесь мы возвращаемся к параметрам из задания 5. Посмотрим на другие лимиты в системе, используя ``ulimit --help`` и среди них найдём параметр ``-u``, отвечающий за количество процессов. Гугл также подсказал, что изменить ограничения можно путём коррективки файла ``/etc/security/limits.conf file`` и его параметра ``nproc – max number of processes``.
