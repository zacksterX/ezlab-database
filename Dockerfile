FROM postgres:15

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    git \
    openjdk-21-jre-headless \
    wget \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Скачивание и настройка Liquibase
ENV LIQUIBASE_VERSION=4.27.0
RUN wget -O /tmp/liquibase.tar.gz https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz \
    && mkdir -p /opt/liquibase \
    && tar -xzf /tmp/liquibase.tar.gz -C /opt/liquibase \
    && ln -s /opt/liquibase/liquibase /usr/local/bin/liquibase \
    && rm /tmp/liquibase.tar.gz

# Рабочая директория
WORKDIR /opt/ezlab-database

# Копирование файлов проекта
COPY . .

# Установка прав на выполнение и преобразование формата файлов
RUN chmod +x *.sh && \
    dos2unix *.sh && \
    chmod +x /opt/ezlab-database/*.sh

# Настройка Liquibase
ENV LIQUIBASE_URL=jdbc:postgresql://localhost:5432/ezlab_dev
ENV LIQUIBASE_USERNAME=postgres
ENV LIQUIBASE_PASSWORD=dev

# Создание директории для логов
RUN mkdir -p /var/log/liquibase

# Точка входа
ENTRYPOINT ["/opt/ezlab-database/entrypoint.sh"]