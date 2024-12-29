#!/bin/bash

# Настройки
REMOTE_USER="root"                # Имя пользователя для подключения к удалённому серверу
REMOTE_HOST="localhost"                 # IP-адрес или хост удалённого сервера
REMOTE_PORT="2222"                        # Порт SSH
EMAIL="aurora84@mail.ru"                # Адрес электронной почты для уведомлений

# Команды для обновления системы
UPDATE_COMMANDS="sudo apt update && sudo apt upgrade -y"

# Проверка, нужна ли перезагрузка
REBOOT_FLAG_FILE="/var/run/reboot-required"

# Подключение к удалённому серверу
ssh -p "$REMOTE_PORT" "$REMOTE_USER"@"$REMOTE_HOST" << EOF
    # Выполнение команд обновления системы
    echo "Обновление системы..."
    $UPDATE_COMMANDS

    # Проверка, нужна ли перезагрузка
    if [ -f "$REBOOT_FLAG_FILE" ]; then
        # Отправка уведомления по электронной почте
        echo "Сервер был перезагружен после обновления." | mail -s "Уведомление: Сервер перезагружен" "$EMAIL"
        echo "Сервер перезагрузился, уведомление отправлено."
    else
        echo "Перезагрузка не требуется."
    fi
EOF

echo "Обновление завершено!"
