package com.example.trade.security;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import com.example.trade.dto.User;
import com.example.trade.service.MemberService;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DormantAccountFilter extends OncePerRequestFilter {

    private final MemberService memberService;

    public DormantAccountFilter(MemberService memberService) {
        this.memberService = memberService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        // 1. 현재 요청의 URI를 확인합니다.
        String requestURI = request.getRequestURI();

        // 2. 로그인, 로그아웃, 휴면 해제 페이지는 필터링을 건너뜁니다.
        //    (무한 리다이렉트 루프를 방지하기 위함)
        if (requestURI.startsWith("/public/login") || 
            requestURI.startsWith("/public/logout") || 
            requestURI.startsWith("/member/activateAccount") || 
            requestURI.startsWith("/member/accountActivate")) {
            filterChain.doFilter(request, response);
            return;
        }

        // 3. 현재 인증된 사용자(Principal) 정보를 가져옵니다.
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // 4. 사용자가 로그인 상태이고, 'anonymousUser'가 아닌지 확인합니다.
        if (authentication != null && authentication.isAuthenticated() && 
            !"anonymousUser".equals(authentication.getPrincipal())) {
            
            String userId = authentication.getName();
            
            // 5. MemberService를 통해 사용자의 최신 상태를 DB에서 조회합니다.
            try {
                User member = memberService.getUserById(userId);
                
                // 6. 사용자가 휴면 상태(CS003)인지 확인합니다.
                if ("CS003".equals(member.getCustomerStatus())) {
                    System.out.println("휴면 계정 감지: " + userId + " - 휴면 해제 페이지로 리디렉션");
                    
                    // 7. 휴면 해제 페이지로 강제 리다이렉션
                    response.sendRedirect("/member/accountActivate?userId=" + userId);
                    return; // 리다이렉션 후 필터 체인 종료
                }
            } catch (Exception e) {
                System.err.println("DormantAccountFilter 오류: " + e.getMessage());
                // 오류 발생 시, 필터 체인을 계속 진행하여 정상적인 에러 페이지로 유도
            }
        }
        
        // 8. 휴면 상태가 아니면 다음 필터로 진행합니다.
        filterChain.doFilter(request, response);
    }
}