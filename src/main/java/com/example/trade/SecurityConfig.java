package com.example.trade;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // 개발 편의상 CSRF 끔
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/css/**", "/js/**", "/images/**").permitAll() // 정적 리소스 허용
                .anyRequest().authenticated() // 나머지는 로그인 필요
            )
            .formLogin(form -> form   // ✅ 스프링 시큐리티 기본 로그인 폼 사용
                .permitAll()
            )
            .logout(logout -> logout.permitAll());

        return http.build();
    }

}
