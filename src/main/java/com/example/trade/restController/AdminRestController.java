package com.example.trade.restController;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.service.MemberService;

@RestController
@RequestMapping("/admin") // ✅ 관리자 전용 API
public class AdminRestController {
    private final MemberService memberService;

    public AdminRestController(MemberService memberService) {
        this.memberService = memberService;
    }

    /**
     * 관리자가 회원의 상태를 변경하는 API
     * PUT /admin/user/{userId}/status
     */
    @PutMapping("/user/{userId}/status")
    public ResponseEntity<Map<String, Object>> updateUserStatus(@PathVariable("userId") String userId, @RequestBody Map<String, String> payload) {
        Map<String, Object> response = new HashMap<>();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String id = auth.getName();
        try {
            String newStatus = payload.get("customerStatus");
            if (newStatus == null || newStatus.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "변경할 상태 코드가 누락되었습니다.");
                return ResponseEntity.badRequest().body(response);
            }
            
            // MemberService를 통해 DB 업데이트
            memberService.updateMemberStatus(userId, newStatus, id);

            response.put("success", true);
            response.put("message", "회원 상태가 성공적으로 변경되었습니다.");
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            System.err.println("회원 상태 변경 오류: " + e.getMessage());
            response.put("success", false);
            response.put("message", "상태 변경 중 내부 오류가 발생했습니다.");
            return ResponseEntity.status(500).body(response);
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