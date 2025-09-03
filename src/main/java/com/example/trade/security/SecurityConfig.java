package com.example.trade.security;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import com.example.trade.config.ApplicationContextProvider;
import com.example.trade.service.AdminService;
import com.example.trade.service.MemberService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
	private AdminService adminService;
//	private MemberService memberService;
	public SecurityConfig(AdminService adminService/*, MemberService memberService*/) {
		this.adminService = adminService;
//		this.memberService = memberService;
	}
	
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
	SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity,
											CustomOAuth2UserService customOAuth2UserService,
											CustomOAuth2FailureHandler customOAuth2FailureHandler,
											UserDetailsService userDetailsService) throws Exception {
		
		MemberService memberService = ApplicationContextProvider.getBean(MemberService.class);
		
		// CSRF 설정 (테스트 단계이므로 disable, 추후 보안 요구사항 따라 enable 고려)
		httpSecurity.csrf((csrfConfigurer) -> csrfConfigurer.disable());
		
		// 인가 설정 (URL별 접근 권한 설정)
		httpSecurity.authorizeHttpRequests((requestMatcherRegistry)
				-> requestMatcherRegistry
										 // 모두 접근 가능 (공용 페이지, 정적 리소스)
										 .requestMatchers("/", "/public/**", "/css/**","/js/**", "/images/**", "/uploads/**", "/assets/**").permitAll()
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
		
		// ✅ 연동-aware 성공 핸들러 구성
	    AuthenticationSuccessHandler linkAwareSuccessHandler =
	        new CustomOAuth2SuccessHandler(
	            /* memberService는 아래와 같이 주입 필요 */ 
	        	ApplicationContextProvider.getBean(com.example.trade.service.MemberService.class),
	            userDetailsService,
	            loginSuccessHandler() // 일반 성공 로직으로 위임
	        );
		
		// ✅ 소셜 로그인 설정 (네이버/카카오)
	    httpSecurity.oauth2Login(oauth2 -> oauth2
	            .loginPage("/public/login")          // 소셜 로그인 실패 시 보여줄 페이지
	            .userInfoEndpoint(userInfo -> userInfo.userService(customOAuth2UserService))
	            .failureHandler(customOAuth2FailureHandler)
	            .successHandler(linkAwareSuccessHandler) // 성공 시 이동할 페이지
	    );
		// 휴면계정 필터
	    httpSecurity.addFilterAfter(new DormantAccountFilter(memberService), UsernamePasswordAuthenticationFilter.class);
	    
		// 로그아웃 설정
		httpSecurity.logout((logoutConfigurer)
				-> logoutConfigurer.logoutUrl("/public/logout")			// 로그아웃 처리 URL
								   .invalidateHttpSession(true)			// 세션 무효화
								   .addLogoutHandler((request, response, authentication) -> {
								        Cookie cookie = new Cookie("myPageAuth", null);
								        cookie.setPath("/");
								        cookie.setMaxAge(0);
								        response.addCookie(cookie);
								    })
								   .logoutSuccessUrl("/public/login"));	// 로그아웃 후 로그인 페이지로 이동
		
		return httpSecurity.build();
	}
	
	@Bean
	public WebSecurityCustomizer webSecurityCustomizer() {
		// JSP forward 시 Security가 뷰 렌더링을 막지 않도록 예외 처리
		return (web) -> web.ignoring().requestMatchers("/WEB-INF/views/**", 
														"/WEB-INF/common/**", 
														"/assets/**");
	}
	
	// 로그인 성공 시 핸들러
	// 1) 원래 요청(SavedRequest)이 있으면 그 URL로 복귀
	// 2) 없으면 권한(Role)에 따라 각 메인 페이지로 분기
	public AuthenticationSuccessHandler loginSuccessHandler() {
		return new AuthenticationSuccessHandler() {
			
			@Override
			public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
					Authentication authentication) throws IOException, ServletException {
				
				// 로그인 사용자 ID
				String userId = authentication.getName();
				
				MemberService memberService = ApplicationContextProvider.getBean(MemberService.class);
				// ✅ 추가: 로그인 직후 customer_status 확인
				try {
					String userStatus = memberService.getUserById(userId).getCustomerStatus();
					if ("CS002".equals(userStatus)) {
						// 탈퇴 또는 가입대기 상태이면 강제로 로그아웃
						new SecurityContextLogoutHandler().logout(request, response, authentication);
						
						// 로그인 페이지로 에러 메시지와 함께 리다이렉트
						String errorMsg = URLEncoder.encode("탈퇴한 계정입니다. 관리자에게 문의해주세요.", StandardCharsets.UTF_8);
						response.sendRedirect("/public/login?errorMsg=" + errorMsg);
						return;
					} else if ("CS004".equals(userStatus)) {
						new SecurityContextLogoutHandler().logout(request, response, authentication);
						
						// 로그인 페이지로 에러 메시지와 함께 리다이렉트
						String errorMsg = URLEncoder.encode("가입대기 중인 계정입니다. 관리자에게 문의해주세요.", StandardCharsets.UTF_8);
						response.sendRedirect("/public/login?errorMsg=" + errorMsg);
						return;
					} else if ("CS003".equals(userStatus)) {
						// 휴면 상태이면 휴면 계정 활성화 페이지로 리다이렉트
						response.sendRedirect("/member/accountActivate?userId=" + userId);
						return;
					}
				} catch (Exception e) {
					System.err.println("사용자 상태 확인 중 오류 발생: " + e.getMessage());
					new SecurityContextLogoutHandler().logout(request, response, authentication);
					String errorMsg = URLEncoder.encode("사용자 상태 확인 중 오류가 발생했습니다.", StandardCharsets.UTF_8);
					response.sendRedirect("/public/login?errorMsg=" + errorMsg);
					return;
				}
				
				// 로그인 이력 저장
				adminService.saveLoginHistory(userId);
				
				// ✅ 로그인 성공 시 myPageAuth false로 초기화
			    Cookie cookie = new Cookie("myPageAuth", "false");
			    cookie.setPath("/");
			    response.addCookie(cookie);
			    
				// 로그인 성공 로그
				System.out.println("로그인 성공 : " + authentication.getName());
				
				// 로그인 전 요청했던 URL(SavedRequest) 확인
				SavedRequest savedRequest = new HttpSessionRequestCache().getRequest(request, response);
				
				String targetUrl = null;
				
				if(savedRequest != null) {
					targetUrl = savedRequest.getRedirectUrl();
					
					// 로그인 페이지(/public/login)에서 로그인한 경우는 제외
					if(targetUrl.contains("/public/login") || targetUrl.startsWith("http")) {
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
				// 실패 메시지 URL 인코딩해서 전달
			    String errorMsg = URLEncoder.encode("아이디 또는 비밀번호가 올바르지 않습니다.", StandardCharsets.UTF_8);
			    response.sendRedirect("/public/login?errorMsg=" + errorMsg);
			}
		};
	}
}
