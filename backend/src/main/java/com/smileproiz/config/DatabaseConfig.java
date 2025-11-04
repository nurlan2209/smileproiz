package com.smileproiz.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;
import java.net.URI;

@Configuration
public class DatabaseConfig {

    @Bean
    public DataSource dataSource() {
        String databaseUrl = System.getenv("DATABASE_URL");
        
        System.out.println("🔍 DATABASE_URL присутствует: " + (databaseUrl != null));
        
        if (databaseUrl == null || databaseUrl.isEmpty()) {
            throw new RuntimeException("❌ DATABASE_URL не найден в переменных окружения!");
        }
        
        try {
            // Railway предоставляет DATABASE_URL в формате:
            // postgresql://user:password@host:port/database
            
            URI dbUri = new URI(databaseUrl);
            
            String username = dbUri.getUserInfo().split(":")[0];
            String password = dbUri.getUserInfo().split(":")[1];
            String host = dbUri.getHost();
            int port = dbUri.getPort();
            String database = dbUri.getPath().substring(1); // Убираем первый /
            
            // Формируем JDBC URL
            String jdbcUrl = String.format("jdbc:postgresql://%s:%d/%s", host, port, database);
            
            // Логируем успешное подключение
            System.out.println("✅ PostgreSQL Connection Info:");
            System.out.println("   JDBC URL: " + jdbcUrl);
            System.out.println("   Username: " + username);
            System.out.println("   Database: " + database);
            System.out.println("   Host: " + host + ":" + port);
            
            // Настройка HikariCP
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(jdbcUrl);
            config.setUsername(username);
            config.setPassword(password);
            config.setDriverClassName("org.postgresql.Driver");
            
            // Connection Pool Settings (оптимизировано для Railway)
            config.setMaximumPoolSize(5);
            config.setMinimumIdle(2);
            config.setConnectionTimeout(20000);
            config.setIdleTimeout(300000);
            config.setMaxLifetime(1200000);
            config.setLeakDetectionThreshold(60000);
            
            // Connection Test
            config.setConnectionTestQuery("SELECT 1");
            
            return new HikariDataSource(config);
            
        } catch (Exception e) {
            System.err.println("❌ Ошибка при парсинге DATABASE_URL:");
            System.err.println("   URL: " + databaseUrl);
            System.err.println("   Ошибка: " + e.getMessage());
            throw new RuntimeException("Не удалось создать DataSource из DATABASE_URL", e);
        }
    }
}