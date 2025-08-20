package com.example.trade.security;

import java.io.IOException;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
	// 비밀번호 암호화 방식 지정 (BCrypt)
	@Bean
	public BCryptPasswordEncoder bCryptPasswordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
    /* 
     * 참고 사항
     * Security 5.x (Boot 2.x) -> AuthenticationManagerBuilder 가 자동 설정
	 * PasswordEncoder Bean만 등록하면 → 내부적으로 자동 연결.
	 * 
	 * Security 6.x (Boot 3.x) -> 구조 변경되어 자동 연결 X
	 * AuthenticationManager Bean을 직접 등록해서 .userDetailsService(userDetailsService).passwordEncoder(passwordEncoder)를 연결해줘야 정상 동작.
	 */
	
	
	/*
     * AuthenticationManager Bean 등록
     * UserDetailsService + PasswordEncoder를 Security에 연결
     * 로그인 시 입력한 비밀번호와 DB 해시값 비교를 여기서 처리
     */
	@Bean
	public AuthenticationManager authenticationManager(HttpSecurity http,
	                                                   PasswordEncoder passwordEncoder,
	                                                   UserDetailsService userDetailsService) throws Exception {
	    return http.getSharedObject(AuthenticationManagerBuilder.class)
	               .userDetailsService(userDetailsService) // 사용자 조회 서비스
	               .passwordEncoder(passwordEncoder) // 비밀번호 암호화 방식
	               .and()
	               .build();
	}
	
    /**
     * SecurityFilterChain: CSRF/인증/인가(권한) 및 로그인/로그아웃 설정
     */
	@Bean
	SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {

		// CSRF 설정 (테스트 단계이므로 disable, 추후 보안 요구사항 따라 enable 고려)
		httpSecurity.csrf((csrfConfigurer) -> csrfConfigurer.disable());
		
		// 인가 설정 (URL별 접근 권한 설정)
		httpSecurity.authorizeHttpRequests((requestMatcherRegistry)
				-> requestMatcherRegistry
										 // 모두 접근 가능 (공용 페이지, 정적 리소스)
										 .requestMatchers("/", "/public/**", "/WEB-INF/views/**", "/WEB-INF/common/**","/css/**","/js/**", "/images/**").permitAll()
										 // 로그인 한 사용자만 접근 가능
										 .requestMatchers("/member/**").authenticated()
										 // 관리자만 접근 가능
										 .requestMatchers("/admin/**").hasAnyRole("ADMIN")
										 // 기업 회원 및 관리자 접근 가능
										 .requestMatchers("/biz/**").hasAnyRole("ADMIN", "BIZ")
										 // 개인 회원 및 관리자 접근 가능
										 .requestMatchers("/personal/**").hasAnyRole("ADMIN", "PERSONAL")
										 // 기타 URL 로그인 필요
										 .anyRequest().authenticated());
		
		// 인증(로그인) 설정
		httpSecurity.formLogin((formLoginConfigurer)
				->formLoginConfigurer.loginPage("/public/login")				// 로그인 페이지
									 .loginProcessingUrl("/public/loginAction")	// 로그인 처리 URL (POST)
									 .successHandler(loginSuccessHandler())		// 로그인 성공 시 동작
									 .failureHandler(loginFailureHandler())		// 로그인 실패 시 동작
									 .permitAll());
		
		// ✅ 소셜 로그인 설정 (네이버/카카오)
	    httpSecurity.oauth2Login(oauth2 -> oauth2
	            .loginPage("/public/login")          // 소셜 로그인 실패 시 보여줄 페이지
	            .defaultSuccessUrl("/public/mainPage", true) // 성공 시 이동할 페이지
	    );
		
		// 로그아웃 설정
		httpSecurity.logout((logoutConfigurer)
				-> logoutConfigurer.logoutUrl("/public/logout")			// 로그아웃 처리 URL
								   .invalidateHttpSession(true)			// 세션 무효화
								   .logoutSuccessUrl("/public/login"));	// 로그아웃 후 로그인 페이지로 이동
		
		return httpSecurity.build();
	}
	
	// 로그인 성공 시 핸들러
	// 1) 원래 요청(SavedRequest)이 있으면 그 URL로 복귀
	// 2) 없으면 권한(Role)에 따라 각 메인 페이지로 분기
	public AuthenticationSuccessHandler loginSuccessHandler() {
		return new AuthenticationSuccessHandler() {
			
			@Override
			public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
					Authentication authentication) throws IOException, ServletException {
				// 로그인 성공 로그
				System.out.println("로그인 성공 : " + authentication.getName());
				
				// 로그인 전 요청했던 URL(SavedRequest) 확인
				SavedRequest savedRequest = new HttpSessionRequestCache().getRequest(request, response);
				
				String targetUrl = null;
				
				if(savedRequest != null) {
					targetUrl = savedRequest.getRedirectUrl();
					
					// 로그인 페이지(/public/login)에서 로그인한 경우는 제외
					if(targetUrl.contains("/public/login")) {
						targetUrl = null;
					}
				}
				
				// 1) 원래 요청 URL이 있으면 해당 URL로 이동
				if(targetUrl != null) {
					response.sendRedirect(targetUrl);
				// 2) 원래 요청이 없으면 role별 메인 페이지로 이동
				} else {
					// 권한(Role) 확인
					String role = authentication.getAuthorities().iterator().next().getAuthority();
					System.out.println("사용자 권한 : " + role);
					
					// 권한에 따른 분기 처리 (각 권한별 메인 페이지로 리다이렉트)
					if("ROLE_ADMIN".equals(role)) {
						response.sendRedirect("/admin/mainPage");
					} else if("ROLE_BIZ".equals(role)) {
						response.sendRedirect("/biz/mainPage");
					} else if("ROLE_PERSONAL".equals(role)) {
						response.sendRedirect("/personal/mainPage");
					} else {
						response.sendRedirect("/public/mainPage");
					}
				}
			}
		};
	}
	
	// 로그인 실패 시 핸들러
	// 예외 메시지 로그 출력 후 로그인 페이지로 리다이렉트
	public AuthenticationFailureHandler loginFailureHandler() {
		return new AuthenticationFailureHandler() {
			
			@Override
			public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
					AuthenticationException exception) throws IOException, ServletException {
				System.out.println("로그인 실패 원인" + exception.getMessage());
				response.sendRedirect("/public/login");
			}
		};
	}
}
