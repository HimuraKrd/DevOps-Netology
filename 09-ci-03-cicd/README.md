# Домашнее задание к занятию "09.03 CI\CD"

## Подготовка к выполнению

1. Создаём 2 VM в yandex cloud со следующими параметрами: 2CPU 4RAM Centos7(остальное по минимальным требованиям)
2. Прописываем в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook'a](./infrastructure/site.yml) созданные хосты
3. Добавляем в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе - найдите таску в плейбуке, которая использует id_rsa.pub имя и исправьте на своё
4. Запускаем playbook, ожидаем успешного завершения
5. Проверяем готовность Sonarqube через [браузер](http://localhost:9000)
6. Заходим под admin\admin, меняем пароль на свой
7.  Проверяем готовность Nexus через [бразуер](http://localhost:8081)
8. Подключаемся под admin\admin123, меняем пароль, сохраняем анонимный доступ

## Знакомоство с SonarQube

### Основная часть

1. Создаём новый проект, название произвольное
2. Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube
3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
4. Проверяем `sonar-scanner --version`
5. Запускаем анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`
6. Смотрим результат в интерфейсе
7. Исправляем ошибки, которые он выявил(включая warnings)
8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно
9. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ

## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-public` загружаем артефакт с GAV параметрами:
   1. groupId: netology
   2. artifactId: java
   3. version: 8_282
   4. classifier: distrib
   5. type: tar.gz
2. В него же загружаем такой же артефакт, но с version: 8_102
3. Проверяем, что все файлы загрузились успешно
4. В ответе присылаем файл `maven-metadata.xml` для этого артефекта

### Знакомство с Maven

### Подготовка к выполнению

1. Скачиваем дистрибутив с [maven](https://maven.apache.org/download.cgi)
2. Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
3. Удаляем из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем http соединение( раздел mirrors->id: my-repository-http-unblocker)
4. Проверяем `mvn --version`
5. Забираем директорию [mvn](./mvn) с pom

### Основная часть

1. Меняем в `pom.xml` блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
2. Запускаем команду `mvn package` в директории с `pom.xml`, ожидаем успешного окончания
3. Проверяем директорию `~/.m2/repository/`, находим наш артефакт
4. В ответе присылаем исправленный файл `pom.xml`

---

# Решение
Поднял две виртуальные машины в YC:  
![image](https://user-images.githubusercontent.com/68470186/159119896-b1f430fe-6869-4afd-8ab1-da7332de067e.png)  
И прогнал по ним оба плейбука:
![image](https://user-images.githubusercontent.com/68470186/159119913-8cd8f4e3-a901-4a21-8a90-8ce41df49cd4.png) 
Сервисы успешно запустились:  
![image](https://user-images.githubusercontent.com/68470186/159120012-68f60a3b-b0a5-4674-b5ba-bc4886970b7a.png)  
![image](https://user-images.githubusercontent.com/68470186/159120013-1365a6a5-ce7b-415b-8eaa-a97630e61d79.png)  
  
По ``sonar``: выполнил все требования по установке и забросил код на анализ:  
![image](https://user-images.githubusercontent.com/68470186/159120029-1de93332-c76a-4043-943c-a55970cbe8ee.png)  
В результате увидел следующие ошибки:  
![image](https://user-images.githubusercontent.com/68470186/159120036-5859df01-0576-438e-aaac-299a005210c1.png)  
Изменил код, устанив ошибки:  
![image](https://user-images.githubusercontent.com/68470186/159120061-08d11784-505e-49fa-8e87-8804a0fec5fa.png)  
После повторгого прогона ошибок не возникало:  
![image](https://user-images.githubusercontent.com/68470186/159120069-91506ffa-ba4f-4216-92a0-d10f393dfa8d.png)  
![image](https://user-images.githubusercontent.com/68470186/159120084-7d31408b-fd83-4c1c-8563-339830aa6193.png)  
  
по ``Nexus`` и ``Maven``:  
Загрузил два одинаковых файла согласно условиям:  
![image](https://user-images.githubusercontent.com/68470186/159120107-a044f841-8b79-4c6b-8b28-47cfe0e95e9d.png)  
![image](https://user-images.githubusercontent.com/68470186/159120110-509e6585-9044-4bf3-8e97-427825f9bbf0.png)  
После загрузки ``maven-metadata.xlm`` выглядит вот так:  
![image](https://user-images.githubusercontent.com/68470186/159120132-1fa1da1f-6067-41dc-9c54-eb16975c0e80.png)  
![image](https://user-images.githubusercontent.com/68470186/159120141-aba88fff-e9df-4ed7-b453-3f8e970ca872.png)  
Изменил настройки POM-ника и запустил ``maven package`` из директории с ``pom.xml``:  
![image](https://user-images.githubusercontent.com/68470186/159120160-00e3a504-5ed8-4d4f-845b-89037a0e9b2d.png)  
В результате получил артефакт:  
![image](https://user-images.githubusercontent.com/68470186/159120164-9277f8b2-c8f7-4c56-a0fc-f342c4645633.png)  
Исправленый файл ``pom.xml`` находится в том же разделе, где и был раньше.



---
