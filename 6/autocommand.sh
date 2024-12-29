#!/bin/bash

# Настройки
REMOTE_HOST="localhost"
COMMAND="apt-get update && apt-get -s upgrade"  # Команда для проверки обновлений (с помощью -s у нас будет только симуляция)
LOG_FILE="execution_log.txt"
SERVER_FILE="servers.txt"

# Очистка лог-файла перед началом выполнения
> "$LOG_FILE"

# Чтение серверов из файла
while IFS=: read -r REMOTE_HOST REMOTE_PORT; do
    # Проверяем, установлено ли значение для порта
    if [ -z "$REMOTE_PORT" ]; then
        REMOTE_PORT=2222  # Используем стандартный порт SSH, если порт не указан
    fi

    # Выполнение команды на удалённом сервере
    OUTPUT=$(ssh -o StrictHostKeyChecking=no -p "$REMOTE_PORT" "root@$REMOTE_HOST" "$COMMAND" 2>&1)
    STATUS=$?

    # Сохранение вывода команды в лог-файл с указанием IP
    echo "Output from $REMOTE_HOST:$REMOTE_PORT" >> "$LOG_FILE"
    echo "$OUTPUT" >> "$LOG_FILE"
    echo "Execution status: $STATUS" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"

done < "$SERVER_FILE"

echo "Execution completed. Log saved to $LOG_FILE."
