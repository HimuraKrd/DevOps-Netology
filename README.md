# DevOps-Netology

# Часть 2.4

## 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
Быстрый вариант: 
$git show aefea
полный хэш: aefead2207ef7e2aa5dc81a34aedf0cad4c32545
комментарий: Update CHANGELOG.md

Долгий вариант:
git rev-parse aefea #находим полный коммит  
aefead2207ef7e2aa5dc81a34aedf0cad4c32545  
git show aefead2207ef7e2aa5dc81a34aedf0cad4c32545  

commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545  
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>  
Date:   Thu Jun 18 10:29:58 2020 -0400  

   Update CHANGELOG.md  

diff --git a/CHANGELOG.md b/CHANGELOG.md  
index 86d70e3e0..588d807b1 100644  
--- a/CHANGELOG.md  
+++ b/CHANGELOG.md  
@@ -27,6 +27,7 @@ BUG FIXES:  
backend/s3: Prefer AWS shared configuration over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134))  
backend/s3: Prefer ECS credentials over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134))  
backend/s3: Remove hardcoded AWS Provider messaging ([#25134](https://github.com/hashicorp/terraform/issues/25134))  
command: Fix bug with global `-v`/`-version`/`--version` flags introduced in 0.13.0beta2 [GH-25277]  
command/0.13upgrade: Fix `0.13upgrade` usage help text to include options ([#25127](https://github.com/hashicorp/terraform/issues/25127))  
command/0.13upgrade: Do not add source for builtin provider ([#25215](https://github.com/hashicorp/terraform/issues/25215))  
command/apply: Fix bug which caused Terraform to silently exit on Windows when using absolute plan path ([#25233](https://github.com/hashicorp/terraform/issues/25233))  

  
## 2. Какому тегу соответствует коммит 85024d3?
$git show 85024d3
тег: 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)

Долгий вариант по аналогии с заданием #1 :)


## 3. Сколько родителей у коммита b8d720? Напишите их хеши.    
$ git show b8d720 --pretty=%P    
56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b    
  
git rev-list --parents -n 1 b8d720  
b8d720f8340221f2146e4e4870bf2ee0bc48f2d5 56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b  


## 4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.  
git log v0.12.23...v0.12.24 --oneline  
33ff1c03b (tag: v0.12.24) v0.12.24  
b14b74c49 [Website] vmc provider links  
3f235065b Update CHANGELOG.md  
6ae64e247 registry: Fix panic when server is unreachable  
5c619ca1b website: Remove links to the getting started guide's old location  
06275647e Update CHANGELOG.md  
d5f9411f5 command: Fix bug when using terraform login on Windows  
4b6d06cc5 Update CHANGELOG.md  
dd01a3507 Update CHANGELOG.md  
225466bc3 Cleanup after v0.12.23 release  


## 5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).  
Два варианта: поиск через git grep -S "providerSource", после чего поиск через git show по всем коммитам (или посмотреть на время самого раннего) :)  
Второй вариант более длинный: через git grep "providerSource" найти все моменты вхождения функции, после чего сделать git log -L :providerSource:"file_name" и посмотреть на diff.  
Оба варианта приведут к тому, что самыый ранний коммит с этой функцией : 8c928e83589d90a031f811fae52a81be7153e82f

## 6. Найдите все коммиты в которых была изменена функция globalPluginDirs.  
git grep "globalPluginDirs"  
commands.go:    GlobalPluginDirs: globalPluginDirs(),  
commands.go:    helperPlugins := pluginDiscovery.FindPlugins("credentials", globalPluginDirs())  
internal/command/cliconfig/config_unix.go:              // FIXME: homeDir gets called from globalPluginDirs during init, before  
plugins.go:// globalPluginDirs returns directories that should be searched for  
plugins.go:func globalPluginDirs() []string {  
  
$ git log -L :globalPluginDirs:plugins.go  
commit 8364383c359a6b738a436d1b7745ccdce178df47  
commit 66ebff90cdfaa6938f26f908c7ebad8d547fea17  
commit 41ab0aef7a0fe030e84018973a64135b11abcd70  
commit 52dbf94834cb970b510f2fba853a5b49ad9b1a46  
commit 78b12205587fe839f10d946ea3fdc06719decb05  

## 7. Кто автор функции synchronizedWriters?  
git log --pretty=format:"%h : %an" -S 'synchronizedWriters'  
bdfea50cc : James Bardin  
fd4f7eb0b : James Bardin  
5ac311e2a : Martin Atkins  
Ответ: Martin Atkins  



First line to edit
Second line


# В файле .gitignore будет происходить следующее
# - будут игнорироваться все  локальные дирректории, имеющие в пути "terraform"
# - будут игнорировать файлы состояния (с расширением .tfstate, и имеющие в названии .tfstate)
# - журнал сбоев
# - все файлы, имеющие расширение .tfvars и содержащие пароли, и прочую важную информацию
# - и т.д. :)
# Надеюсь, задание понято правильно.

# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log

# Exclude all .tfvars files, which are likely to contain sentitive data, such as
# password, private keys, and other secrets. These should not be part of version 
# control as they are data points which are potentially sensitive and subject 
# to change depending on the environment.
#
*.tfvars

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
#
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

# Ignore CLI configuration files
.terraformrc
terraform.rc
