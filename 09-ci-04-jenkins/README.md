# Домашнее задание к занятию "09.04 Jenkins"

## Подготовка к выполнению

1. Создать 2 VM: для jenkins-master и jenkins-agent.
2. Установить jenkins при помощи playbook'a.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True), по умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`. Цель: получить собранный стек ELK в Ya.Cloud.
8. Отправить две ссылки на репозитории в ответе: с ролью и Declarative Pipeline и c плейбукой и Scripted Pipeline.

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, которые завершились хотя бы раз неуспешно. Добавить скрипт в репозиторий с решеним с названием `AllJobFailure.groovy`.
2. Дополнить Scripted Pipeline таким образом, чтобы он мог сначала запустить через Ya.Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Тем самым, мы должны по нажатию кнопки получить готовую к использованию систему.

---

# Решение
Были подняты две виртуальные машины в YC:  
![image](https://user-images.githubusercontent.com/68470186/159178747-e9451f54-be02-47a7-b276-0332f66e1e7e.png)  
И произведена первичная настройка Jenkins мастера и агента согласно заданию:  
![image](https://user-images.githubusercontent.com/68470186/159178784-1b83157f-bc2f-481b-ab8d-eebe5c755555.png)  

## Основная часть
Для начала я приложу финальный скриншот получившихся пайплайнов:  
![image](https://user-images.githubusercontent.com/68470186/159178845-ad073a8f-0990-4dea-92bb-bedee2ff152a.png)
``Freestyle Job`` успешно сделан и протестирован:  
![image](https://user-images.githubusercontent.com/68470186/159178931-24173598-004a-40a7-be47-7adf0e96243f.png)  
Команды, которые выполнялись в рамках него:
```shell
cd roles/elastic/
pip3 install -r test-requirements.txt
molecule test
```
После этого я приступил к ``Declarative Pipeline Job``. Код был изменён и приведён к следующему виду:
```shell
pipeline{
    agent any
    stages{
        stage('Git checkout'){
            steps{
                git 'https://github.com/HimuraKrd/devops-netology-elk.git'
            }
        }
        stage('install requirements for elastic'){
            steps{
                sh 'pip3 install -r roles/elastic/test-requirements.txt'
            }
        }
        stage('run molecule test for the elastic role'){
            steps{
                sh 'cd roles/elastic/ && molecule test'
            }
        }
    }
}
```
К такому варианту пришёл не сразу, пришлось исправить ошибки в синтаксисе, но в результате всё отработало:  
![image](https://user-images.githubusercontent.com/68470186/159179099-350eacdf-a953-4c04-bf22-ce89ef6df0da.png)  
``Jenkinsfile`` может быть найден в корне каждой роли из [репозитория](https://github.com/HimuraKrd/devops-netology-elk)  
  
``Multibranch Pipeline`` был создан на запуск ``Jenkinsfile`` и успешно отработал:  
![image](https://user-images.githubusercontent.com/68470186/159179553-09b30e2c-e71c-4027-afc9-d1baa7a7102f.png)  
![image](https://user-images.githubusercontent.com/68470186/159179563-19282f01-c1f8-4f38-bbc1-be3a7ab7c3a1.png)  
![image](https://user-images.githubusercontent.com/68470186/159179451-994a3e70-d577-4228-a0ae-cb41a61396a4.png)
  
  
``Scripted Pipeline`` был создан, используя следующий код:  
```shell
node('jenkins-worker'){
        stage('Git checkout'){
            git 'https://github.com/HimuraKrd/devops-netology-elk.git'
        }
        stage('install requirements for elastic'){
            sh 'pip3 install -r roles/elastic/test-requirements.txt'
        }
        stage('run molecule test for the elastic role'){
            sh 'cd roles/elastic/ && molecule test'
        }
}
```
Результат выполнения на изображении ниже:  
![image](https://user-images.githubusercontent.com/68470186/159179606-f5a2a852-ad14-424f-acf7-9d053d565ddc.png)  

Далее этот скрипт был изменён в соответствии с инструкциями отсюда: [официальная документация Jenkins для добавления параметров](https://www.jenkins.io/doc/book/pipeline/syntax/#parameters) к следующему виду:
```shell
node('jenkins-worker'){
        stage('Git checkout'){
            git 'https://github.com/HimuraKrd/devops-netology-elk.git'
        }
        stage('install requirements for elastic'){
            sh 'pip3 install -r roles/elastic/test-requirements.txt'
            prod_run = input(message: 'Это запуск в проде?', parameters: [booleanParam(defaultValue: false, name: 'prod_run')])
        }
        stage('run molecule test for the elastic role'){
            if (prod_run) {
                sh 'ansible-playbook -e ansible_python_interpreter=/usr/bin/python2 site.yml'
            }
            else {
                sh 'ansible-playbook -e ansible_python_interpreter=/usr/bin/python2 site.yml --check --diff'
            }
        }
}
```
На этапе запуска требуется пользовательское участие:  
![image](https://user-images.githubusercontent.com/68470186/159186016-8e744beb-315b-4ad2-9e09-f5b70aa4845a.png)  
Пайплайн успешно отрабатывает в обоих случаях и устанавливает нужную роль.

