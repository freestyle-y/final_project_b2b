package com.example.trade.restController;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
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
}
