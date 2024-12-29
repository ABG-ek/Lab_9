#!/bin/bash

# Настройки
REMOTE_USER="root"               # Имя пользователя на удалённом сервере
REMOTE_HOST="localhost"           # IP адрес или хост удалённого сервера
REMOTE_PORT="2222"                # Порт SSH
LOAD_THRESHOLD=2.0                # Установленный порог средней загрузки

# Подключение к удалённому серверу и извлечение загрузки процессора
LOAD_DATA=$(ssh -o StrictHostKeyChecking=no -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" "uptime")
STATUS=$?

if [ $STATUS -ne 0 ]; then
   echo "Ошибка подключения к удалённому серверу."
   exit 1
fi

# Извлечение средней загрузки из вывода команды uptime
CURRENT_LOAD=$(echo "$LOAD_DATA" | awk '{print $10}' | sed 's/,//')
echo "Текущая средняя загрузка: $CURRENT_LOAD"

# Сравнение средней загрузки с установленным порогом
if (( $(echo "$CURRENT_LOAD > $LOAD_THRESHOLD" | bc -l) )); then
    echo "Средняя загрузка превышает порог. Завершение процессов."

    # Получение и завершение подходящих процессов
    # В данном случае мы завершим процессы, использующие наибольшее количество процессоров
    # Используем ps для получения списка процессов с их PID, сортируем по загрузке процессора
    # и завершаем процессы, если загрузка превышает 10% на CPU

    # Получаем PID процессов, которые перегружают процессор
    HIGH_LOAD_PIDS=$(ssh -o StrictHostKeyChecking=no -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" "ps aux --sort=-%cpu | awk '\$3 > 10 {print \$2}'")

    # Завершение процессов
    for PID in $HIGH_LOAD_PIDS; do
        echo "Завершение процесса с PID: $PID"
        ssh -o StrictHostKeyChecking=no -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" "kill -9 $PID"
    done

    echo "Процессы завершены."
else
    echo "Средняя загрузка в пределах нормы."
fi
