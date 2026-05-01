package com.burgerbuilder;

import com.microsoft.applicationinsights.attach.ApplicationInsights;
import com.microsoft.applicationinsights.connectionstring.ConnectionString;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Arrays;

@SpringBootApplication
public class BurgerBuilderApplication {

    private static final String DEFAULT_ALLOWED_ORIGINS = "http://localhost:3000,http://localhost:5173";
    private final String[] allowedOrigins;

    public BurgerBuilderApplication(
            @Value("${app.cors.allowed-origins:" + DEFAULT_ALLOWED_ORIGINS + "}") String allowedOrigins
    ) {
        this.allowedOrigins = parseAllowedOrigins(allowedOrigins);
    }

    public static void main(String[] args) {
        configureApplicationInsights();
        SpringApplication.run(BurgerBuilderApplication.class, args);
    }

    static void configureApplicationInsights() {
        String connectionString = System.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING");
        if (connectionString != null && !connectionString.isBlank()) {
            ApplicationInsights.attach();
            ConnectionString.configure(connectionString);
        }
    }

    static String[] parseAllowedOrigins(String allowedOrigins) {
        if (allowedOrigins == null || allowedOrigins.isBlank()) {
            return new String[0];
        }

        return Arrays.stream(allowedOrigins.split(","))
                .map(String::trim)
                .filter(origin -> !origin.isBlank())
                .toArray(String[]::new);
    }

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins(allowedOrigins)
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                        .allowedHeaders("*");
            }
        };
    }
}
