#!/bin/bash

# Настройки
REMOTE_USER="root"                 # Имя пользователя на удалённом сервере
REMOTE_HOST="localhost"            # IP адрес или хост удалённого сервера
REMOTE_PORT="2222"                 # Порт SSH
REMOTE_DIRECTORY_TO_ARCHIVE="/home/vboxuser/Desktop"  # Директория для архивирования на удалённом сервере
ARCHIVE_NAME="archive.tar.gz"      # Имя архива
LOCAL_DIRECTORY="/C/Users/abgal"   # Локальная директория для сохранения архива

# Создание папки на рабочем столе и архивирование директории на удалённом сервере
ssh -p "$REMOTE_PORT" "$REMOTE_USER"@"$REMOTE_HOST" << EOF
mkdir -p ~/Desktop/backup_folder   # Создание папки на рабочем столе
tar -czf ~/Desktop/$ARCHIVE_NAME -C "$REMOTE_DIRECTORY_TO_ARCHIVE" .  # Архивирование указанной директории
EOF

# Скачивание архива на локальный компьютер
scp -P "$REMOTE_PORT" "$REMOTE_USER"@"$REMOTE_HOST:~/Desktop/$ARCHIVE_NAME" "$LOCAL_DIRECTORY/"

# Разархивирование скачанного архива
tar -xzf "$LOCAL_DIRECTORY/$ARCHIVE_NAME" -C "$LOCAL_DIRECTORY"

echo "Архивирование и скачивание завершены!"
