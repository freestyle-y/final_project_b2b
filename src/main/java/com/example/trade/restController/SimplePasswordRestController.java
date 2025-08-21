package com.example.trade.restController;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.service.SimplePasswordService;

@RestController
@RequestMapping("/personal/payment")
public class SimplePasswordRestController {
	private final SimplePasswordService simPWService; 
	
	public SimplePasswordRestController(SimplePasswordService simPWService) {
		super();
		this.simPWService = simPWService;
	}

	@GetMapping("/simplePassword")
	public boolean simplePassword(@RequestParam("userId") String userId) {
		return simPWService.checkSimPw(userId);
	}
	
    @PostMapping("/validate-password")
    public boolean validatePassword(@RequestParam("userId") String userId,
                                    @RequestParam("pw") String simplePassword) {
        return simPWService.validatePassword(userId, simplePassword);
    }
    
    @PostMapping("/registerSimplePassword")
    public void registerSimplePassword(@RequestBody SimplePasswordRequest request) {
        simPWService.registerSimplePassword(request.getUserId(), request.getPassword());
    }
    
    // 간편결제 비밀번호 등록 요청 DTO
    public static class SimplePasswordRequest {
        private String userId;
        private String password;
        
        public String getUserId() { return userId; }
        public void setUserId(String userId) { this.userId = userId; }
        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
    }
}
