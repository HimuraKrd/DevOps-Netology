## 1. Работа c HTTP через телнет.
* Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80
* отправьте HTTP запрос  
``GET /questions HTTP/1.0``  
``HOST: stackoverflow.com``  
``[press enter]``  
``[press enter]``  
* В ответе укажите полученный HTTP код, что он означает?  
Результатом мы получим ответ страницы с кодом 301 ``HTTP/1.1 301 Moved Permanently`` - страница была перемещена на постоянной основе
![task_1](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9A%D0%BE%D0%BC%D0%BF%D1%8C%D1%8E%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B5%D1%82%D0%B8%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%201)/images/1.png)

## 2. Повторите задание 1 в браузере, используя консоль разработчика F12.
* откройте вкладку Network
* отправьте запрос http://stackoverflow.com
* найдите первый ответ HTTP сервера, откройте вкладку Headers
* укажите в ответе полученный HTTP код.
![task2_1](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9A%D0%BE%D0%BC%D0%BF%D1%8C%D1%8E%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B5%D1%82%D0%B8%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%201)/images/2_1.png)
* проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
* приложите скриншот консоли браузера в ответ.
![task_2_2](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9A%D0%BE%D0%BC%D0%BF%D1%8C%D1%8E%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B5%D1%82%D0%B8%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%201)/images/2_2.png)

## 3. Какой IP адрес у вас в интернете?
Я пользуюсь сервисом 2ip:  
![task_3](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9A%D0%BE%D0%BC%D0%BF%D1%8C%D1%8E%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B5%D1%82%D0%B8%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%201)/images/3.png)  

## 4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois
Результат вывода команды ``whois`` на скриншоте ниже:  
![task4](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9A%D0%BE%D0%BC%D0%BF%D1%8C%D1%8E%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B5%D1%82%D0%B8%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%201)/images/4.png)  
Провайдер B2B-Telecom, номер автономной системы AS58314

## 5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute
![task_5](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9A%D0%BE%D0%BC%D0%BF%D1%8C%D1%8E%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B5%D1%82%D0%B8%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%201)/images/5.png)

## 6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?
Вывод команды ``mtr`` на скриншоте ниже:  
![task_6](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9A%D0%BE%D0%BC%D0%BF%D1%8C%D1%8E%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B5%D1%82%D0%B8%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%201)/images/6.png)  
Наибольшая задержка после нескольких прогонов программы на участки ``172.253.65.82``.

## 7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig
![task_7](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9A%D0%BE%D0%BC%D0%BF%D1%8C%D1%8E%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B5%D1%82%D0%B8%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%201)/images/7.png)

## 8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig
![task_8](https://github.com/HimuraKrd/devops-netology/blob/main/%D0%9A%D0%BE%D0%BC%D0%BF%D1%8C%D1%8E%D1%82%D0%B5%D1%80%D0%BD%D1%8B%D0%B5%20%D1%81%D0%B5%D1%82%D0%B8%20(%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%201)/images/8.png)
