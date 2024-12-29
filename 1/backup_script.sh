#!/bin/bash

# Настройки
DIRECTORY_NAME="my_directory"          # Имя директории, которую нужно создать
ARCHIVE_NAME="ARCHIVE_lab_9.tar.gz"    # Имя архива
REMOTE_USER="root"                      # Пользователь удаленного сервера
REMOTE_HOST="localhost"                 # IP-адрес или хост удаленного сервера
REMOTE_PORT="2222"                      # Порт SSH
REMOTE_DIR="/home/vboxuser/Desktop"     # Путь на удаленном сервере для хранения архива

# 1. Создание директории
if [ ! -d "$DIRECTORY_NAME" ]; then
    mkdir -p "$DIRECTORY_NAME"
    echo "Создана директория: $DIRECTORY_NAME"
else
    echo "Директория $DIRECTORY_NAME уже существует."
fi

# 2. Создание архива с помощью tar
if [ -d "$DIRECTORY_NAME" ]; then
    tar -czf "$ARCHIVE_NAME" "$DIRECTORY_NAME"
    echo "Создан архив: $ARCHIVE_NAME"
else
    echo "Неудалось создать архив, так как директория не найдена."
    exit 1
fi

# 3. Копирование архива на удаленный сервер
scp -P "$REMOTE_PORT" "$ARCHIVE_NAME" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
echo "Архив скопирован на удаленный сервер."

# 4. Удаление старых архивов на удаленном сервере, если их больше трех
ssh -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" "cd $REMOTE_DIR && ls -t | grep 'ARCHIVE_lab_9' | awk 'NR>3' | xargs -r rm"
echo "Старые архивы удалены при необходимости."

# Завершение работы
echo "Скрипт завершен."

