## 1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```json
{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip : 71.78.22.43
        }
    ]
}
```
Нужно найти и исправить все ошибки, которые допускает наш сервис.  
Исправленный синтаксис ниже:  
```json
{ "info" : "Sample JSON output from our service\\t", #пропущено экранирование специального символа \t
    "elements" :[
        { 
          "name" : "first",
          "type" : "server",
          "ip" : 7175
        },
        {
          "name" : "second",
          "type" : "proxy",
          "ip" : "71.78.22.43" #пропущены закрывающие кавычки и экранирование IP адреса
        }
    ]
}
```

## 2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

В прошлом модуле я решал задачу через объявление массива тьюплов. К сожаленю, ни JSON, ни YML не могут с ним нормально взаимодействовать. Оптимальным вариантом для работы с языками разметки является тип словарь (dict), имеющий структуру ``{'key':"value"}``. С учётом замечаний, полученных в результате выполнения прошлого задания переписал код и добавил в него поддержку JSON и YML:  
```python
#!/usr/bin/env python3

import socket
from time import sleep
import json
import yaml


dns_list = {"drive.google.com":"0", "mail.google.com":"0", "google.com":"0"}

iteration = 1

while (1 == 1):
  for dns_name, address in dns_list.items():
    ip = socket.gethostbyname(dns_name)
    if str(address) == str(ip) or iteration == 1: #сравниваем старый IP из словаря 'dns_list' с новым (кроме 1й итерации)
      print(f'{dns_name}: {ip}')
    else:
      print(f'[ERROR] {dns_name} IP mismatch: {dns_list[dns_name]} {ip}')
    dns_list[dns_name] = ip #записываем новое значение IP
  print('\n')
#дополнение для работы с json-начало
  with open('task_2_obj.json', 'w') as json_file:
    json.dump(dns_list, json_file)
#дополнение для работы с yml-начало
  with open('task_2_obj.yml', 'w') as yaml_file:
    yaml.dump(dns_list, yaml_file, default_flow_style=False)
  iteration=iteration+1
  sleep(1) #делаем паузу
```  
Формат, который получал при работе с тьюплами и YML на скриншоте ниже:  
![yuples_in_YML](https://user-images.githubusercontent.com/68470186/136691147-f442f33a-77cd-4994-bd7b-8e35d119fb2a.png)  
Формат, который получал при работе с тьюплами и JSON на скриншоте ниже: 
![yuples_in_JSON](https://user-images.githubusercontent.com/68470186/136691276-bc8984e3-9465-4420-b288-459dda50e933.png)  
Насколько я понял, такой формат был связан с сериализацией JSON файла. На вход подавались ```list или tuple```, что JSON воспринимать как ```array```, вместо нужного формата ``object```.
