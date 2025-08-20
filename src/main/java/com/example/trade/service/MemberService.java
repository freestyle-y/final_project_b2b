package com.example.trade.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.dto.User;
import com.example.trade.mapper.UserMapper;

@Service
public class MemberService {
	
	private final UserMapper userMapper;
	private final BCryptPasswordEncoder passwordEncoder;

	public MemberService(UserMapper userMapper, BCryptPasswordEncoder passwordEncoder){
		this.userMapper = userMapper;
		this.passwordEncoder = passwordEncoder;
	}
	
	public boolean isIdAvailable(String id){
		return userMapper.findById(id) == null;
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
	    if(user.getTotalReward() == 0) user.setTotalReward(0);

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
	}
	
	// 회원 목록 조회
    public List<User> getMembers(String type, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("customerCategory", type);
        params.put("customerStatus", status);
        return userMapper.findUser(params);
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
    
    @Transactional
    public void updateUserInfo(String id, Map<String,Object> updates){
        User user = userMapper.getInfoById(id);
        if(user == null) throw new RuntimeException("회원 정보가 존재하지 않습니다.");

        // 업데이트 가능한 필드만 처리
        if(updates.containsKey("name")) user.setName((String)updates.get("name"));
        if(updates.containsKey("phone")) user.setPhone((String)updates.get("phone"));
        if(updates.containsKey("email")) user.setEmail((String)updates.get("email"));
        if(updates.containsKey("postal")) user.setPostal((String)updates.get("postal"));
        if(updates.containsKey("address")) user.setAddress((String)updates.get("address"));
        if(updates.containsKey("detailAddress")) user.setDetailAddress((String)updates.get("detailAddress"));
        if(updates.containsKey("simplePassword")) user.setSimplePassword((String)updates.get("simplePassword"));
        if(updates.containsKey("companyName") && "CC002".equals(user.getCustomerCategory()))
            user.setCompanyName((String)updates.get("companyName"));

        userMapper.updateUser(user);
    }
    
    // 비밀번호 변경
    public void updatePw(String id, String password) {
    	userMapper.updatePw(id, passwordEncoder.encode(password));
    }
    
    // 아이디 찾기(개인)
	public String findPersonalId(String name, String sn) {
		userMapper.findIdBySn(name, sn);
		return null;
	}
	// 아이디 찾기(기업)
	public String findBizId(String companyName, String businessNo) {
		userMapper.findIdByBusinessNo(companyName, businessNo);
		return null;
	}
}
