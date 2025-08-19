package com.example.trade.restController;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.dto.User;
import com.example.trade.service.UserService;

@RestController
@RequestMapping("/public")
public class MemberRestController {
	
	private final UserService userService;

    public MemberRestController(UserService userService){
        this.userService = userService;
    }

    // AJAX 아이디 중복 확인
    @GetMapping("/checkId")
    public String checkId(@RequestParam String id){
        boolean available = userService.isIdAvailable(id.trim().toLowerCase());
        return available ? "OK" : "FAIL";
    }

    // 회원가입 처리
    @PostMapping("/joinPersonal")
    public ResponseEntity<String> joinPersonal(@ModelAttribute User user){
        try{
            user.setCustomerCategory("CC003"); // 개인회원
            userService.registerUser(user);
            return ResponseEntity.ok("SUCCESS");
        } catch(RuntimeException e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/joinBiz")
    public ResponseEntity<String> joinBiz(@ModelAttribute User user){
        try{
            user.setCustomerCategory("CC002"); // 기업회원
            userService.registerUser(user);
            return ResponseEntity.ok("SUCCESS");
        } catch(RuntimeException e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
