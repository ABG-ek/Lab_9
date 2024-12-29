#!/bin/bash

# Настройки
REMOTE_USER="root"                 # Имя пользователя на удалённом сервере
REMOTE_HOST="localhost"            # IP адрес или хост удалённого сервера
REMOTE_PORT="2222"                 # Порт SSH
THRESHOLD=10                        # Порог в процентах (если свободное место меньше этого значения, будет отправлено уведомление)
EMAIL="aurora84@mail.ru"     # Ваш email для уведомлений

# Проверка свободного места на диске на удалённом сервере
FREE_SPACE=$(ssh -p "$REMOTE_PORT" "$REMOTE_USER"@"$REMOTE_HOST" "df / | grep / | awk '{ print \$5 }' | sed 's/%//'")

# Сравнение с заданным порогом и отправка уведомления по электронной почте, если необходимо
if [ "$FREE_SPACE" -lt "$THRESHOLD" ]; then
    powershell -Command "Send-MailMessage -From 'sender@example.com' -To '$EMAIL' -Subject 'Уведомление о свободном месте на диске' -Body 'Внимание! Свободное пространство на диске меньше заданного порога!' -SmtpServer 'smtp.example.com'"
fi

echo "Проверка завершена. Свободное место на диске: $FREE_SPACE%"
