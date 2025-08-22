package com.example.trade.restController;

import com.example.trade.dto.SocialLogin;
import com.example.trade.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/social")
public class SocialRestController {

    private final MemberService memberService;

    // 현재 로그인한 사용자의 연동 소셜 계정 목록
    @GetMapping("/list")
    public List<SocialLogin> getLinkedSocials(@AuthenticationPrincipal UserDetails user) {
        return memberService.getLinkedSocials(user.getUsername());
    }

    // 소셜 연동 해제
    @DeleteMapping("/unlink/{socialType}")
    public String unlink(@AuthenticationPrincipal UserDetails user,
                         @PathVariable String socialType) {
        memberService.unlinkSocialAccount(user.getUsername(), socialType);
        return "연동 해제 완료";
    }
}
