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
	private final BCryptPasswordEncoder passwordEncoder;

    public MemberController(MemberService memberService, BCryptPasswordEncoder passwordEncoder) {
        this.memberService = memberService;
        this.passwordEncoder = passwordEncoder;
    }
    
	// 마이페이지
    @GetMapping("/member/myPage")
    public String myPage(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String id = auth.getName();
        log.info(id);
        if(auth.getName() == null) {
        	return "redirect:/public/login";
        }
        User user = memberService.getUserById(id);
        model.addAttribute("user", user);
        
        // 연동된 소셜 계정 조회
        model.addAttribute("socialList", memberService.getLinkedSocials(user.getId()));
        return "member/myPage";
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
	@GetMapping("/member/changeMemberPw")
	public String changeMemberPw(Model model) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String id = auth.getName();
		model.addAttribute("id", id);
		return "member/changeMemberPw";
	}
	@PostMapping("/member/changeMemberPw")
	public String changeMemberPw(@RequestParam String nowPw,
								@RequestParam String newPw,
								RedirectAttributes redirectAttributes,
								Model model) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User user = memberService.getUserById(auth.getName());
		model.addAttribute("id", user.getId());
		
		System.out.println("--- 비밀번호 변경 디버깅 시작 ---");
	    System.out.println("현재 로그인된 사용자 ID: " + user.getId());
	    System.out.println("사용자가 입력한 현재 비밀번호 (nowPw): " + nowPw);
	    System.out.println("사용자가 입력한 새 비밀번호 (newPw): " + newPw);
	    
		if (!passwordEncoder.matches(nowPw, user.getPassword())) {
	        redirectAttributes.addFlashAttribute("error", "현재 비밀번호가 일치하지 않습니다.");
	        return "redirect:/member/changeMemberPw"; // 다시 폼으로
	    }

	    // 비밀번호 변경
	    memberService.updatePw(user.getId(), newPw);
	    User updatedUser = memberService.getUserById(user.getId());
	    System.out.println("저장된 암호: " + updatedUser.getPassword());
	    Boolean pwMatch = passwordEncoder.matches(newPw, updatedUser.getPassword());
	    System.out.println("암호 newPw , updateUser.getPassword() : " + pwMatch);
	    redirectAttributes.addFlashAttribute("success", "비밀번호가 변경되었습니다.");
		return "redirect:/member/changeMemberPw";
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
	                        @RequestParam(required = false) String keyword,
	                        @RequestParam(defaultValue = "1") int page,
	                        Model model) {
	    int pageSize = 10; // 한 페이지에 10행
	    int totalCount = memberService.countMembers(type, status, keyword);
	    int totalPage = (int) Math.ceil((double) totalCount / pageSize);

	    // 페이징 블록 (1~10, 11~20)
	    int blockSize = 10;
	    int startPage = ((page - 1) / blockSize) * blockSize + 1;
	    int endPage = Math.min(startPage + blockSize - 1, totalPage);

	    List<User> users = memberService.getMembers(type, status, keyword, page, pageSize);

	    model.addAttribute("users", users);
	    model.addAttribute("type", type);
	    model.addAttribute("status", status);
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("page", page);
	    model.addAttribute("totalPage", totalPage);
	    model.addAttribute("startPage", startPage);
	    model.addAttribute("endPage", endPage);

	    return "admin/manageUser";
	}
}
