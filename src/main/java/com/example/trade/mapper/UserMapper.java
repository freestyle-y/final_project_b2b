package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.domain.UserDomain;
import com.example.trade.dto.User;

@Mapper
public interface UserMapper {
	// 아이디로 사용자 조회
	UserDomain findById(String id);
	
	// 회원가입
	void insertUser(User user);
	
	// 중복가입방지용 조회
	String findBySn(User user);
	String findByBusinessNo(User user);
	
	// 회원목록 조회
	List<User> findUser(Map<String, Object> params);
	
	// 가입승인
	void approveUser(String id);
}
