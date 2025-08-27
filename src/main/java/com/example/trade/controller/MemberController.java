package com.example.trade.controller;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
        log.info(id);
        
        User user = memberService.getUserById(id);
        model.addAttribute("user", user);
        
        // 연동된 소셜 계정 조회
        model.addAttribute("socialList", memberService.getLinkedSocials(user.getId()));
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
	
	@PostMapping("/public/findMemberIdAction")
	public String findMemberId(@RequestParam String memberType,
	                           @RequestParam Map<String,String> params,
	                           Model model) {

	    String foundId = null;
	    log.info("before if foundId" + foundId);
	    if("PERSONAL".equals(memberType)) {
	        String name = params.get("name");
	        String sn  = params.get("sn");
	        foundId = memberService.findPersonalId(name, sn);
	    } else if("BIZ".equals(memberType)) {
	        String companyName = params.get("companyName");
	        String businessNo  = params.get("businessNo");
	        foundId = memberService.findBizId(companyName, businessNo);
	    }
	    
	    log.info("before model foundId" + foundId);
	    if(foundId != null) {
	        model.addAttribute("foundId", foundId);
	        log.info("foundId : "+foundId);
	    } else {
	        model.addAttribute("notFound", true);
	        log.info("아이디 찾기 실패");
	    }

	    return "public/findMemberId"; // JSP 이름
	}

	
	// 비밀번호 찾기
	@GetMapping("/public/findMemberPw")
	public String findMemberPw() {
		return "public/findMemberPw";
	}
	
	// 비밀번호 변경
	@GetMapping("/public/changeMemberPw")
	public String changeMemberPw(Model model) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String id = auth.getName();
		model.addAttribute("id", id);
		return "public/changeMemberPw";
	}
	@PostMapping("/public/changeMemberPw")
	public String changeMemberPw(@RequestParam String nowPw,
								@RequestParam String newPw,
								RedirectAttributes redirectAttributes,
								Model model) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = memberService.getUserById(auth.getName());
		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		model.addAttribute("id", user.getId());
		if (!passwordEncoder.matches(nowPw, user.getPassword())) {
	        redirectAttributes.addFlashAttribute("error", "현재 비밀번호가 일치하지 않습니다.");
	        return "redirect:/public/changeMemberPw"; // 다시 폼으로
	    }

	    // 비밀번호 변경
	    memberService.updatePw(user.getId(), passwordEncoder.encode(newPw));
	    redirectAttributes.addFlashAttribute("success", "비밀번호가 변경되었습니다.");
		return "redirect:/public/changeMemberPw";
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
