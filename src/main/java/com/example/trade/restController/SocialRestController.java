package com.example.trade.restController;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.dto.SocialLogin;
import com.example.trade.service.MemberService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/social")
public class SocialRestController {

    private final MemberService memberService;

    // 로그인한 사용자 userId 가져오기
    private String getUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Object principal = auth.getPrincipal();

        if (principal instanceof UserDetails) {
            return ((UserDetails) principal).getUsername();
        } else if (principal instanceof DefaultOAuth2User) {
            return (String) ((DefaultOAuth2User) principal).getAttribute("id");
        } else {
            throw new IllegalStateException("로그인 정보가 없습니다.");
        }
    }

    // 현재 로그인한 사용자의 연동 소셜 계정 목록
    @GetMapping("/list")
    public List<SocialLogin> getLinkedSocials() {
        String userId = getUserId();
        return memberService.getLinkedSocials(userId);
    }

    // 소셜 연동 해제
    @DeleteMapping("/unlink/{socialType}")
    public ResponseEntity<String> unlink(@PathVariable String socialType) {
        String userId = getUserId();
        memberService.unlinkSocialAccount(userId, socialType);
        return ResponseEntity.ok("연동 해제 완료");
    }
}
