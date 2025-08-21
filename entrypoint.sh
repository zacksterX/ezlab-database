#!/bin/bash
# Запуск PostgreSQL в фоне
docker-entrypoint.sh postgres &

# Ожидание готовности PostgreSQL
until pg_isready -h localhost -p 5432 -U postgres; do
    echo "$(date): Waiting for PostgreSQL to start..." >> /var/log/liquibase/init.log
    sleep 2
done

echo "$(date): PostgreSQL is ready" >> /var/log/liquibase/init.log

# Генерация liquibase.properties из переменных окружения
cat > /opt/ezlab-database/liquibase.properties << EOF
# URL подключения к базе данных
url=jdbc:postgresql://localhost:5432/ezlab_dev

# Имя пользователя и пароль для базы данных
username=postgres
password=dev

# Драйвер базы данных
classpath=./postgresql-42.7.7.jar
driver=org.postgresql.Driver

# Путь к главному файлу changelog
changeLogFile=main.xml

# Логирование
logLevel=info

# Управление проверкой логов
liquibase.hub.mode=off
EOF

# Первоначальный запуск liquibase
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
INIT_LOG="/var/log/liquibase/liquibase_${TIMESTAMP}.log"

echo "$(date): Running initial liquibase update..." >> "$INIT_LOG"
cd /opt/ezlab-database
liquibase update >> "$INIT_LOG" 2>&1

if [ $? -eq 0 ]; then
    echo "$(date): Initial liquibase update completed successfully" >> "$INIT_LOG"
else
    echo "$(date): Initial liquibase update failed" >> "$INIT_LOG"
    # Показать содержимое properties файла для отладки
    echo "liquibase.properties content:" >> "$INIT_LOG"
    cat liquibase.properties >> "$INIT_LOG"
fi

/opt/ezlab-database/auto-update.sh &

# Ожидание завершения основного процесса
wait