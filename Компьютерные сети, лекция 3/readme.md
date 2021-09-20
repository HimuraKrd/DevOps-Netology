## 1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
``telnet route-views.routeviews.org``  
``Username: rviews``  
``show ip route x.x.x.x/32``  
``show bgp x.x.x.x/32``  
Т.е. предложенный ресурс не работал, мной был выбран ``route-server.dokom.net``. Результаты вывода программ представлены ниже:
![1_public_route](https://user-images.githubusercontent.com/68470186/134005316-91a61039-98b2-4cfd-8699-179fab415790.png)

## 2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
Насколько я понял - основная практическая цель применения dummy-интерфейсов заключается в том, что можно посмотреть, как ведёт себя траффик (к примеру), если потушить интерефейс, через который он ходит.  
![2_ip_route](https://user-images.githubusercontent.com/68470186/134005508-6ecc9e20-614a-4df4-9f11-91fce6654278.png)  
Как видно из скриншота выше, я добавил несколько машртутов через шлюз и через интерфейс.  
Интерфейсы добавлял командами :  
``echo "dummy" >> /etc/modules``  
``echo "options dummy numdummies=2" > /etc/modprobe.d/dummy.conf``  
После чего прописывал в ``/etc/network/interfaces`` нужные мне IP адреса:  
![2_network_int](https://user-images.githubusercontent.com/68470186/134005772-c4bdff5d-98c7-4808-b287-3b8fb6acf7c2.png)


## 3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
![3_tcp_listen](https://user-images.githubusercontent.com/68470186/134006442-94cf13dc-d648-41fa-bad2-3c68a702809b.png)


## 4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
![4_upd](https://user-images.githubusercontent.com/68470186/134006464-52504ded-fc63-4bfe-a549-ec50499a7a45.png)  

Суммарно порты можно посмотреть, используя команду ``netstat -ntulp``
![4_5_tcp_upd](https://user-images.githubusercontent.com/68470186/134006483-b88ca9ef-33ea-44fd-a91f-b6826d79d76d.png)  
Также задания 3-4 можно выполнить, используя разные команды:  
``sudo netstat -lp --inet``  
``sudo netstat -plut``  
и т.д.

## 5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.
![5_diagramm](https://user-images.githubusercontent.com/68470186/134006592-cfe5a7c8-1669-4262-9df4-763051043dee.png)  
Очень упрощённый пример, чтобы показать, что понял, как работать с ресурсом :-) 
