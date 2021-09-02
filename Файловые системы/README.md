## 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
Нет, т.к. жесткая ссылка полностью аналогична файлу, на который создана и включает те же разрешения, что выставлены на оригинальном файле.

## 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile содержимым из примера.
Готово.

## 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
Используем ``lsblk`` найдём нужные нам устройства, а потом при помощи ``fdisk /dev/sdb`` начнём творить магию :)   
![task4](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/4.png)  
При помощи ``w`` записываем изменения.

## 5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.
![task_5](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/5.png)

## 6. Соберите mdadm RAID1 на паре разделов 2 Гб.
Посмотрим информацию о устройствах:  
![task_6](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/6_1.png)  
Создадим RAID1 из нужных дисков:  
![task_6_2](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/6_2.png)

## 7. Соберите mdadm RAID0 на второй паре маленьких разделов.
![task_7](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/7.png)    
Посмотрим итоговый результат после выполнения задач 6 и 7:  
![task_7](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/7_1.png)

## 8. Создайте 2 независимых PV на получившихся md-устройствах.
![task_8](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/8.png)

## 9. Создайте общую volume-group на этих двух PV.
К сожалению, забыл сделать скриншот выполнения команды, поэтому просто напишу код тут:  
``vgcreate Volume_group /dev/md0 /dev/md1``  
Результат вывода можно посмотреть при помощи команды ``pvdisplay``

## 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
![task_10](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/10.png)

## 11. Создайте mkfs.ext4 ФС на получившемся LV.
Используя ``lvdisplay`` узнаем путь к созданному логическому тому и выполним задачу:  
![task_11](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/11.png)

## 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.
![task_12](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/12.png)

## 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.
![task_13](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/13.png)

## 14. Прикрепите вывод lsblk.
![task_14](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/14.png)

## 15. Протестируйте целостность файла:

``root@vagrant:~# gzip -t /tmp/new/test.gz``  
``root@vagrant:~# echo $?``  
``0``  
![task_15](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/15.png)

## 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
![task_16](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/16.png)

## 17. Сделайте --fail на устройство в вашем RAID1 md.
![task_17](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/17.png)

## 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
![task_18](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/18.png)

## 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
![task_19](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%A4%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D1%8B%D0%B5%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B/images/19.png)
