package com.example.trade.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.domain.UserDomain;
import com.example.trade.dto.Address;
import com.example.trade.dto.SocialLogin;
import com.example.trade.dto.User;
import com.example.trade.mapper.AddressMapper;
import com.example.trade.mapper.UserMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MemberService {
	
	private final UserMapper userMapper;
	private final AddressMapper addressMapper;
	private final BCryptPasswordEncoder passwordEncoder;
	private final MailService mailService;

	public MemberService(UserMapper userMapper, BCryptPasswordEncoder passwordEncoder, MailService mailService, AddressMapper addressMapper){
		this.userMapper = userMapper;
		this.passwordEncoder = passwordEncoder;
		this.mailService = mailService;
		this.addressMapper = addressMapper;
	}
	
	public boolean isIdAvailable(String id){
		return userMapper.findById(id) == null;
	}
	
	public UserDomain getSessionByUserId(String id) {
		return userMapper.findById(id);
	}
	
	@Transactional
	public void registerUser(User user){
	    // 아이디 중복 체크 (대소문자/trim 처리)
	    String checkId = user.getId().trim().toLowerCase();
	    if(userMapper.findById(checkId) != null){
	        throw new RuntimeException("이미 존재하는 아이디입니다.");
	    }
	    user.setId(checkId);

	    // 개인회원 → 주민등록번호 중복 가입 방지
	    if("CC003".equals(user.getCustomerCategory())) {
	    	String existingSn = userMapper.findBySn(user);
	    	if(existingSn != null) {
	    		throw new RuntimeException("이미 등록된 주민등록번호입니다.");
	    	}
	    }

	    // 기업회원 → 사업자등록번호 중복 가입 방지
	    if("CC002".equals(user.getCustomerCategory())) {
	    	String existingBizNo = userMapper.findByBusinessNo(user);
	    	if(existingBizNo != null) {
	    		throw new RuntimeException("이미 등록된 사업자등록번호입니다.");
	    	}
	    }
	    
	    // 비밀번호 암호화
	    user.setPassword(passwordEncoder.encode(user.getPassword()));

	    // 생성자, 상태 초기화
	    user.setCreateUser(user.getId());
	    user.setCustomerStatus("CS001");
	    user.setFailedLoginCount(0);
	    user.setTotalReward(0);

	    // 기업회원 컬럼 처리 (null 처리)
	    if(!"CC002".equals(user.getCustomerCategory())){
	        user.setCompanyName(null);
	        user.setBusinessNo(null);
	    }
	    if("CC002".equals(user.getCustomerCategory())) {
	    	user.setCustomerStatus("CS004");
	    }

	    // DB 삽입
	    userMapper.insertUser(user);
	    
	    // address테이블 입력
	    // 개인, 기업 따로
	    if ("CC003".equals(user.getCustomerCategory())) {
	    	Address address = new Address();
	    	address.setOwnerType("AC001");
	    	address.setUserId(user.getCreateUser());
	    	address.setPostal(user.getPostal());
	    	address.setAddress(user.getAddress());
	    	address.setDetailAddress(user.getDetailAddress());
	    	address.setNickname(null);
	    	address.setCreateUser(user.getCreateUser());
	    	address.setMainAddress("Y");
	    	
	    	addressMapper.addAddress(address);
	    }
	    
	    if ("CC002".equals(user.getCustomerCategory())) {
	    	Address address = new Address();
	    	address.setOwnerType("AC002");
	    	address.setUserId(user.getCreateUser());
	    	address.setPostal(user.getPostal());
	    	address.setAddress(user.getAddress());
	    	address.setDetailAddress(user.getDetailAddress());
	    	address.setNickname(null);
	    	address.setCreateUser(user.getCreateUser());
	    	address.setMainAddress("Y");
	    	
	    	addressMapper.addAddress(address);
	    }

	}
	
	// 회원 목록 조회 (검색 + 페이징)
	public List<User> getMembers(String type, String status, String keyword, int page, int pageSize) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("customerCategory", type);
	    params.put("customerStatus", status);
	    params.put("searchKeyword", keyword);
	    params.put("offset", (page - 1) * pageSize);
	    params.put("pageSize", pageSize);

	    return userMapper.findUser(params);
	}

	// 총 회원 수
	public int countMembers(String type, String status, String keyword) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("customerCategory", type);
	    params.put("customerStatus", status);
	    params.put("searchKeyword", keyword);
	    return userMapper.countUser(params);
	}

    // 기업회원 가입 승인
    @Transactional
    public void approveUser(String id) {
    	// 1) 현재 로그인한 관리자 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if(authentication == null || !authentication.isAuthenticated()) {
            throw new IllegalStateException("로그인한 관리자가 없습니다.");
        }

        String adminId = authentication.getName();

        // 2) ROLE_ADMIN 체크
        boolean isAdmin = authentication.getAuthorities().stream()
                            .map(GrantedAuthority::getAuthority)
                            .anyMatch(role -> role.equals("ROLE_ADMIN"));

        if(!isAdmin) {
            throw new IllegalStateException("승인 권한이 없습니다. 관리자만 가능합니다.");
        }

        // 3) DB 업데이트: 상태 변경 + updateUser 컬럼에 관리자 ID 기록
        userMapper.approveUser(id, adminId);
    }
    
    // 비밀번호 확인
    public boolean checkPassword(String id, String rawPassword) {
        User user = userMapper.getInfoById(id);
        return passwordEncoder.matches(rawPassword, user.getPassword());
    }
    
    // 아이디 별 회원정보(마이페이지)
    public User getUserById(String id) {
        return userMapper.getInfoById(id);
    }
    
    // 회원정보 변경
    @Transactional
    public void updateUserInfo(String id, User updateUser){
        User user = userMapper.getInfoById(id);
        if(user == null) throw new RuntimeException("회원 정보가 존재하지 않습니다.");

        // 업데이트 가능한 필드만 변경
        if(updateUser.getName() != null) user.setName(updateUser.getName());
        if(updateUser.getPhone() != null) user.setPhone(updateUser.getPhone());
        if(updateUser.getEmail() != null) user.setEmail(updateUser.getEmail());
        if(updateUser.getPostal() != null) user.setPostal(updateUser.getPostal());
        if(updateUser.getAddress() != null) user.setAddress(updateUser.getAddress());
        if(updateUser.getDetailAddress() != null) user.setDetailAddress(updateUser.getDetailAddress());
        if(updateUser.getSimplePassword() != null) user.setSimplePassword(updateUser.getSimplePassword());

        if(updateUser.getCompanyName() != null && "CC002".equals(user.getCustomerCategory())) {
            user.setCompanyName(updateUser.getCompanyName());
        }

        // DB 업데이트
        userMapper.updateUser(user);
    }
    
    // 비밀번호 변경
    @Transactional
    public void updatePw(String id, String password) {
    	userMapper.updatePw(id, passwordEncoder.encode(password));
    }
    
    // 아이디 찾기(개인)
	public String findPersonalId(String name, String sn) {
		String id = userMapper.findIdBySn(name, sn);
		log.info("findPersonalId() result = " + id);
		return id;
	}
	// 아이디 찾기(기업)
	public String findBizId(String companyName, String businessNo) {
		String id = userMapper.findIdByBusinessNo(companyName, businessNo);
		log.info("findBizId() result = " + id);
		return id;
	}
	
	// 비밀번호 찾기
	@Transactional
	public String findAndSendTempPw(Map<String,String> req){
	    User user = null;

	    if("CC003".equals(req.get("customerCategory"))){ // 개인회원
	        user = userMapper.findPersonalUser(req.get("id"), req.get("name"), req.get("sn"));
	    } else { // 기업회원
	        user = userMapper.findCompanyUser(req.get("id"), req.get("companyName"), req.get("businessNo"));
	    }

	    if(user == null){
	        throw new RuntimeException("입력한 정보와 일치하는 회원이 없습니다.");
	    }

	    // 임시 비밀번호 생성
	    String tempPw = UUID.randomUUID().toString().substring(0,8);

	    // DB 업데이트 (암호화)
	    userMapper.updatePw(user.getId(), passwordEncoder.encode(tempPw));

	    // 이메일 발송
	    mailService.sendMail(user.getEmail(), "임시 비밀번호 안내",
	            "안녕하세요, 요청하신 임시 비밀번호는 " + tempPw + " 입니다.");

	    return "등록된 이메일로 임시 비밀번호를 발송했습니다.";
	}
	
	// 소셜 조회
	public List<SocialLogin> getLinkedSocials(String userId) {
	    return userMapper.findSocialByUserId(userId);
	}
	
	// 소셜 계정 추가 연동
    public void linkSocialAccount(String userId, String socialType, String socialId) {
    	log.info("memberService에서 소셜연동 호출");
        SocialLogin existing = userMapper.findAllBySocialTypeAndSocialId(socialType, socialId);
        if (existing != null) {
            throw new IllegalStateException("이미 다른 계정에 연동된 소셜입니다.");
        }

        SocialLogin socialLogin = new SocialLogin();
        socialLogin.setUserId(userId);
        socialLogin.setSocialType(socialType);
        socialLogin.setSocialId(socialId);

        userMapper.insertSocial(socialLogin);
    }

    // 소셜 계정으로 로그인 시 기존 유저 찾기
    public String findUserIdBySocial(String socialType, String socialId) {
        SocialLogin socialLogin = userMapper.findAllBySocialTypeAndSocialId(socialType, socialId);
        return (socialLogin != null) ? socialLogin.getUserId() : null;
    }

    // 소셜 연동 해제
    public void unlinkSocialAccount(String userId, String socialType) {
        userMapper.deleteByUserIdAndSocialType(userId, socialType);
    }
    
    // 회원상태 업데이트(회원 탈퇴 포함)
    public void updateMemberStatus(String userId, String customerStatus, String updateUser) {
    	
        userMapper.updateMemberStatus(userId, customerStatus, updateUser);
    }
    
    //휴면해제
    public boolean activateDormantAccount(String userId, String personalNumber, String bizNumber) {
        // 1. userId로 회원 정보 조회
        User user = userMapper.getInfoById(userId);
        if (user == null || !"CS003".equals(user.getCustomerStatus())) {
            return false; // 회원이 없거나 휴면 상태가 아니면 실패
        }

        // 2. 회원 유형에 따라 번호 확인
        // 개인 회원일 경우 주민등록번호 뒷자리, 기업 회원일 경우 사업자 등록 번호
        boolean isValid = false;
        if ("CC003".equals(user.getCustomerCategory()) && personalNumber != null) {
            // 실제로는 주민등록번호를 암호화하여 저장하고 복호화 후 비교해야 합니다.
            // 여기서는 예시로 단순 비교를 가정합니다.
            if (personalNumber.equals(user.getSn())) { 
                isValid = true;
            }
        } else if ("CC002".equals(user.getCustomerCategory()) && bizNumber != null) {
            if (bizNumber.equals(user.getBusinessNo())) {
                isValid = true;
            }
        }

        if (isValid) {
            // 3. 번호가 일치하면 customer_status를 'CS001'(정상)으로 업데이트
            userMapper.updateMemberStatus(userId, "CS001", userId);
            return true;
        }

        return false; // 번호가 일치하지 않으면 실패
    }

}
