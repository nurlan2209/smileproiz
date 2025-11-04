# Многоэтапная сборка для оптимизации размера образа

# Этап 1: Сборка приложения
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Копируем pom.xml и загружаем зависимости (кэширование слоя)
COPY backend/pom.xml .
RUN mvn dependency:go-offline -B

# Копируем исходный код и собираем
COPY backend/src ./src
RUN mvn clean package -DskipTests

# Этап 2: Создание финального образа
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Создаем непривилегированного пользователя
RUN addgroup -g 1001 -S appuser && adduser -u 1001 -S appuser -G appuser

# Копируем JAR из этапа сборки
COPY --from=build /app/target/*.jar app.jar

# Меняем владельца файлов
RUN chown -R appuser:appuser /app

# Переключаемся на непривилегированного пользователя
USER appuser

# Открываем порт
EXPOSE 8080

# Запускаем приложение
ENTRYPOINT ["java", "-Xmx512m", "-Xms256m", "-jar", "app.jar"]