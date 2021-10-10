# Домашнее задание к занятию "3.5. Файловые системы"

## 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
Нет, т.к. жесткая ссылка полностью аналогична файлу, на который создана и включает те же разрешения, что выставлены на оригинальном файле.

## 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile содержимым из примера.
Готово.

## 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
Используем ``lsblk`` найдём нужные нам устройства, а потом при помощи ``fdisk /dev/sdb`` начнём творить магию :)   
![4](https://user-images.githubusercontent.com/68470186/136692875-fe22f428-bf05-4aea-a795-14527c5bcbe8.png)

При помощи ``w`` записываем изменения.

## 5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.
![5](https://user-images.githubusercontent.com/68470186/136692877-b79a234e-118b-4cc0-a7d5-6e14d2d2dac0.png)


## 6. Соберите mdadm RAID1 на паре разделов 2 Гб.
Посмотрим информацию о устройствах:  
![6_1](https://user-images.githubusercontent.com/68470186/136692880-1416ea8d-8fc6-4145-97f0-32361bbbee0c.png)
Создадим RAID1 из нужных дисков:  
![6_2](https://user-images.githubusercontent.com/68470186/136692885-e5e533f2-ed4d-41ea-9efc-53c3e9634e33.png)


## 7. Соберите mdadm RAID0 на второй паре маленьких разделов.
![7](https://user-images.githubusercontent.com/68470186/136692888-2a687a5a-ffd7-4f9d-8563-ca649496ac1d.png)

Посмотрим итоговый результат после выполнения задач 6 и 7:  
![7_1](https://user-images.githubusercontent.com/68470186/136692889-43cb3e65-a4f6-49f4-804f-7863a53fa28c.png)

## 8. Создайте 2 независимых PV на получившихся md-устройствах.
![8](https://user-images.githubusercontent.com/68470186/136692891-e6019962-3515-4544-9466-f5e28981d9a1.png)


## 9. Создайте общую volume-group на этих двух PV.
К сожалению, забыл сделать скриншот выполнения команды, поэтому просто напишу код тут:  
``vgcreate Volume_group /dev/md0 /dev/md1``  
Результат вывода можно посмотреть при помощи команды ``pvdisplay``

## 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
![10](https://user-images.githubusercontent.com/68470186/136692894-e248a126-a029-4e0c-b7ba-b2c36228a000.png)


## 11. Создайте mkfs.ext4 ФС на получившемся LV.
Используя ``lvdisplay`` узнаем путь к созданному логическому тому и выполним задачу:  
![11](https://user-images.githubusercontent.com/68470186/136692900-b70cc474-5f05-4311-9d19-4b774cc5b59d.png)

## 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.
![12](https://user-images.githubusercontent.com/68470186/136692902-f3ca7370-454a-4953-b107-cd1091aab638.png)

## 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.
![13](https://user-images.githubusercontent.com/68470186/136692904-96151722-7b09-4b83-a3cd-0d122e8ec8a8.png)

## 14. Прикрепите вывод lsblk.
![14](https://user-images.githubusercontent.com/68470186/136692910-aab110bd-eb1d-462e-b040-2e6a99a23a16.png)

## 15. Протестируйте целостность файла:

``root@vagrant:~# gzip -t /tmp/new/test.gz``  
``root@vagrant:~# echo $?``  
``0``  
![15](https://user-images.githubusercontent.com/68470186/136692917-a4dcfcea-27ac-4e59-9610-5ec7169e00f8.png)

## 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
![16](https://user-images.githubusercontent.com/68470186/136692920-4de9c631-8a54-47e3-83e6-dcf1a0b8f0e7.png)

## 17. Сделайте --fail на устройство в вашем RAID1 md.
![17](https://user-images.githubusercontent.com/68470186/136692923-4058dc2f-9966-40a5-900f-40ff7f50745e.png)

## 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
![18](https://user-images.githubusercontent.com/68470186/136692926-65cd08f0-d68a-48a6-9699-591756402f59.png)

## 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
![19](https://user-images.githubusercontent.com/68470186/136692941-dee0531e-7b13-4df7-b5c6-64ec12ecb083.png)
