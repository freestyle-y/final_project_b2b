package com.example.trade;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable() // ✅ POST 요청도 CSRF 없이 가능
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll() // ✅ 모든 요청 허용
            );
        return http.build();
    }
}