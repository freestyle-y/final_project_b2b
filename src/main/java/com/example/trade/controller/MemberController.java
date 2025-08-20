package com.example.trade.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.User;
import com.example.trade.service.MemberService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MemberController {
	
	private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }
    
	// 마이페이지
    @GetMapping("/public/myPage")
    public String myPage(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String id = auth.getName();
        User user = memberService.getUserById(id);
        model.addAttribute("user", user);
        return "public/myPage";
    }

	// 로그인
	@GetMapping("/public/login")
	public String login() {
		return "public/login";
	}
	
	// 회원가입
	@GetMapping("/public/joinMember")
	public String joinMember() {
		return "public/joinMember";
	}
	
	// 아이디 찾기
	@GetMapping("/public/findMemberId")
	public String findMemberId() {
		return "public/findMemberId";
	}
	
	// 비밀번호 찾기
	@GetMapping("/public/findMemberPw")
	public String findMemberPw() {
		return "public/findMemberPw";
	}
	
	// 비밀번호 변경
	@GetMapping("/public/changeMemberPw")
	public String changeMemberPw(@RequestParam String id, 
								Model model) {
		User user = memberService.getUserById(id);
		model.addAttribute("pw", user.getPassword());
		return "public/changeMemberPw";
	}
	
	// 적립금 페이지
	@GetMapping("/personal/rewardList")
	public String rewardList() {
		return "personal/rewardList";
	}
	
	// 회원관리 페이지
	// 회원 목록 조회
	@GetMapping("/admin/manageUser")
	public String manageUser(@RequestParam(required = false) String type,
							@RequestParam(required = false) String status,
							Model model) {
		List<User> users = memberService.getMembers(type, status);
		model.addAttribute("users", users);
		model.addAttribute("type", type);
		model.addAttribute("status", status);
		System.out.println(users);
		return "admin/manageUser"; // JSP
	}
}
