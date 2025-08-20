package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
	void approveUser(@Param("id") String id, @Param("updateUser") String updateUser);
	
	// 비밀번호 확인, 마이페이지 정보조회
	User getInfoById(String id);
	
	// 회원 정보 업데이트
    void updateUser(User user);
    
    // 비밀번호 변경
    void updatePw(String id, String password);
    
    // 아이디찾기
	String findIdBySn(String name, String sn);
	String findIdByBusinessNo(String companyName, String businessNo);
}
