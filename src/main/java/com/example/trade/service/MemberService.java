package com.example.trade.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        userMapper.approveUser(id);
    }
}
