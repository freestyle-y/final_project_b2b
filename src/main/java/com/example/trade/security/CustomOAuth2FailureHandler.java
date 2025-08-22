package com.example.trade.security;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class CustomOAuth2FailureHandler implements AuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
                                        HttpServletResponse response,
                                        AuthenticationException exception)
            throws IOException, ServletException {

    	if ("NO_LINKED_ACCOUNT".equals(exception.getMessage())) {
    	    String msg = URLEncoder.encode("등록되지 않은 소셜 계정입니다. 먼저 회원가입을 진행해주세요.", StandardCharsets.UTF_8);
    	    response.sendRedirect("/public/join?errorMsg=" + msg);
    	} else {
    	    String msg = URLEncoder.encode("소셜 로그인에 실패했습니다. 다시 시도해주세요.", StandardCharsets.UTF_8);
    	    response.sendRedirect("/public/login?errorMsg=" + msg);
    	}
    }
}
