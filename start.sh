#!/bin/bash

# Получение каталога где запускается скрипт
DIR=`dirname $0`

# Скачивание необходимых программ
# sudo pacman -S jq terraform ansible

# Скачиваем модули
# terraform -chdir=./terraform init -upgrade
# Применяем настройку
terraform -chdir=./terraform apply

# Получаем список ip адресов для дальнейшего использования в ansible
> ./ansible/inventory.ini
for i in $(terraform -chdir=./terraform output -json vm_ipv4_address | jq -r '.[]'); do
  echo "$i owner=\"$1\"" >> ./ansible/inventory.ini
done

ansible-playbook ./ansible/start.yaml
