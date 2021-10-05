## 1. Есть скрипт:
``` python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```
* Какое значение будет присвоено переменной c?  
Python попытается сложить две переменные разных типов ``int`` (a) и ``str`` (b) и выдаст ошибку: ``TypeError: unsupported operand type(s) for +: 'int' and 'str'``.  

* Как получить для переменной c значение 12?  
```python
>>> c = str(a)+b
>>> print(c)
12
```

* Как получить для переменной c значение 3?
```python
>>> c =a+int(b)
>>> print(c)
3
```


## 2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

Скрипт не работал из-за ``break`` в конце. Доработал скрипт таким образом, что он отслеживает файлы в состояниях ``new``, ``modified``, ``untracked``:  
```python
#!/usr/bin/env python3
import os

bash_command = ["cd ~/git/devops-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
full_path = os.popen('pwd').read()
print('Рабочая директория: ' + full_path)
print('Изменённые файлы:\n')
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
print('\nНовые файлы:\n')
for result in result_os.split('\n'):
    if result.find('new file') != -1:
        prepare_result = result.replace('\tnew file:   ', '')
        print(prepare_result)
print('\nНеотслеживаемые файлы:\n')
for result in result_os.split('\n'):
 if result.find('Untracked files:') != -1:
  pos = result_os.split('\n').index("Untracked files:")
  prepare_result= result_os.split('\n')[pos:]
  del prepare_result[0]
  del prepare_result[0]
  prepare_result.pop()
  prepare_result.pop()
  for i in prepare_result:
   print(i)
```
Результат будет следующий:  
![task_2_output](https://user-images.githubusercontent.com/68470186/135931311-f05f615d-572c-4bff-8708-2d990f1c6633.png)  
При этом ``git`` выдаёт следующий результат:  
![task_2_git](https://user-images.githubusercontent.com/68470186/135931365-6330a737-ea01-4f82-a7ac-70356d73b2ff.png)


## 3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.
```python
#!/usr/bin/env python3
import os
import sys
import subprocess

new_dir = 'cd ' + sys.argv[1]

bash_command = [new_dir, "git status"]

result_os = os.popen(' && '.join(bash_command)).read()
print('Основной каталог: ' + os.getcwd() )
print('Рабочая директория: ' + sys.argv[1])
print('Изменённые файлы:\n')
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
print('\nНовые файлы:\n')
for result in result_os.split('\n'):
    if result.find('new file') != -1:
        prepare_result = result.replace('\tnew file:   ', '')
        print(prepare_result)
print('\nНеотслеживаемые файлы:\n')
for result in result_os.split('\n'):
 if result.find('Untracked files:') != -1:
  pos = result_os.split('\n').index("Untracked files:")
  prepare_result= result_os.split('\n')[pos:]
  del prepare_result[0]
  del prepare_result[0]
  prepare_result.pop()
  prepare_result.pop()
  for i in prepare_result:
   print(i)
```


## 4. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.
```python
dns_names = [("drive.google.com","0"), ("mail.google.com", "0"), ("google.com", "0")] # список тьюплов

a = 1 # для первой итерации, чтобы не выдавало ошибку


while (True):
  for i in dns_names: # получаем поочерёдно все тьюплы
    pos = dns_names.index(i) # получаем индекс конкретного тьюпла в списке, чтобы потом его подменять
    ip_add = socket.gethostbyname(i[0])
    if str(i[1]) == str(ip_add) or a == 1: 
      print(f'{i[0]}: {i[1]}')
    else:
      print(f'[ERROR] {i[0]} IP mismatch: {i[1]} {ip_add}')
    dns_names[pos] = (i[0], ip_add) # подменяем элемент по индексу на новый с актуальным айпишником
  print('\n')
  a=a+1
  sleep(1) 
```
Результат выполнения программы:  
