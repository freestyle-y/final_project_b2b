package com.example.trade.restController;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.dto.User;
import com.example.trade.service.MemberService;

@RestController
@RequestMapping("/public")
public class MemberRestController {
	
	private final MemberService memberService;

    public MemberRestController(MemberService memberService){
        this.memberService = memberService;
    }

    // AJAX 아이디 중복 확인
    @GetMapping("/checkId")
    public String checkId(@RequestParam String id){
        boolean available = memberService.isIdAvailable(id.trim().toLowerCase());
        return available ? "OK" : "FAIL";
    }

    // 회원가입 처리
    @PostMapping("/joinPersonal")
    public ResponseEntity<String> joinPersonal(@ModelAttribute User user){
        try{
            user.setCustomerCategory("CC003"); // 개인회원
            memberService.registerUser(user);
            return ResponseEntity.ok("SUCCESS");
        } catch(RuntimeException e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/joinBiz")
    public ResponseEntity<String> joinBiz(@ModelAttribute User user){
        try{
            user.setCustomerCategory("CC002"); // 기업회원
            memberService.registerUser(user);
            return ResponseEntity.ok("SUCCESS");
        } catch(RuntimeException e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    

    // 기업회원 승인 처리
    @PutMapping("/{id}/approve")
    public ResponseEntity<Void> approveMember(@PathVariable("id") String id) {
    	try {
    		memberService.approveUser(id);
    		return ResponseEntity.ok().build(); // 200 OK
    	} catch (IllegalStateException e) {
    		return ResponseEntity.badRequest().build(); // 잘못된 요청 (조건 불일치)
    	} catch (Exception e) {
    		return ResponseEntity.internalServerError().build(); // 서버 오류
    	}
    }
    
 // 비밀번호 확인 AJAX
    @PostMapping("/checkPassword")
    public ResponseEntity<Boolean> checkPassword(@RequestParam String password) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String id = auth.getName();
        boolean match = memberService.checkPassword(id, password);
        return ResponseEntity.ok(match);
    }

    // 마이페이지 정보 조회
    @GetMapping("/info")
    public ResponseEntity<User> getUserInfo() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String id = auth.getName();
        User user = memberService.getUserById(id);
        return ResponseEntity.ok(user);
    }
    
    // 회원 정보 업데이트
    @PutMapping("/updateUserInfo")
    public ResponseEntity<String> updateUserInfo(@RequestBody Map<String, Object> updates) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String id = auth.getName();
        try {
            memberService.updateUserInfo(id, updates);
            return ResponseEntity.ok("SUCCESS");
        } catch(Exception e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
