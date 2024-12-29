#!/bin/bash

# Настройки
REMOTE_USER="root"                     # Имя пользователя на удалённом сервере
REMOTE_HOST="localhost"                 # IP адрес или хост удалённого сервера
REMOTE_PORT="2222"                      # Порт SSH
REMOTE_DIR="/home/vboxuser/Desktop/ARCHIVE_lab_9.tar."  # Путь к удалённой директории
LOCAL_DIR="/C/Users/abgal/ARCHIVE_lab_9_5"                # Путь к локальной директории
EMAIL="aurora84@mail.ru"          # email для уведомлений
IGNORE_PATTERNS=("--exclude=*.tmp" "--exclude=*.log" "--exclude=ignored_folder/")  # Игнорируемые файлы/директории

# Функция для отправки отчёта по электронной почте
send_email_report() {
    local subject="$1"
    local body="$2"
    echo "$body" | mail -s "$subject" "$EMAIL"
}

# Синхронизация с удаленной директории в локальную
rsync -avz "${IGNORE_PATTERNS[@]}" -e "ssh -p $REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/" "$LOCAL_DIR/"
sync_result_1=$?

# Синхронизация с локальной директории в удаленную
rsync -avz "${IGNORE_PATTERNS[@]}" -e "ssh -p $REMOTE_PORT" "$LOCAL_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/"
sync_result_2=$?

# Проверка успешности выполнения и подготовка отчёта
if [ $sync_result_1 -eq 0 ] && [ $sync_result_2 -eq 0 ]; then
    subject="Синхронизация завершена успешно"
    body="Синхронизация данных успешно завершена с:\n\nЛокальная директория: $LOCAL_DIR\nУдаленная директория: $REMOTE_HOST:$REMOTE_DIR"
else
    subject="Ошибка синхронизации"
    body="Произошла ошибка при синхронизации данных.\n\nЛокальная директория: $LOCAL_DIR\nУдаленная директория: $REMOTE_HOST:$REMOTE_DIR"
fi

# Отправка отчёта по электронной почте
send_email_report "$subject" "$body"

echo "Синхронизация завершена. Отчёт отправлен на $EMAIL."
