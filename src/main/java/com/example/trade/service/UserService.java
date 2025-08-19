package com.example.trade.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.dto.User;
import com.example.trade.mapper.UserMapper;

@Service
public class UserService {
	
	private final UserMapper userMapper;
	private final BCryptPasswordEncoder passwordEncoder;

	public UserService(UserMapper userMapper, BCryptPasswordEncoder passwordEncoder){
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
	        user.setBussinessNo(null);
	    }
	    if("CC002".equals(user.getCustomerCategory())) {
	    	user.setCustomerStatus("CS004");
	    }

	    // DB 삽입
	    userMapper.insertUser(user);
	}
}
