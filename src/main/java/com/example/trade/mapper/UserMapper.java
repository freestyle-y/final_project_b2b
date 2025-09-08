package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.trade.domain.UserDomain;
import com.example.trade.dto.SocialLogin;
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
	int countUser(Map<String, Object> params);

	
	// 가입승인
	void approveUser(@Param("id") String id, @Param("updateUser") String updateUser);
	
	// 비밀번호 확인, 마이페이지 정보조회
	User getInfoById(String id);
	
	// 회원 정보 업데이트
    void updateUser(User updates);
    
    // 비밀번호 변경
    void updatePw(String id, String password);
    
    // 아이디찾기
	String findIdBySn(String name, String sn);
	String findIdByBusinessNo(String companyName, String businessNo);
	
	// 비밀번호 찾기
	User findPersonalUser(@Param("id") String id, @Param("name") String name, @Param("sn") String sn);
	User findCompanyUser(@Param("id") String id, @Param("companyName") String companyName, @Param("businessNo") String businessNo);
	
	// 소셜로그인
	// 소셜 계정 추가
    int insertSocial(SocialLogin socialLogin);

    // 특정 소셜 계정 찾기
    SocialLogin findAllBySocialTypeAndSocialId(
        @Param("socialType") String socialType,
        @Param("socialId") String socialId
    );

    // 특정 회원이 연동한 모든 소셜 계정
    List<SocialLogin> findSocialByUserId(String userId);

    // 소셜 연동 해제
    int deleteByUserIdAndSocialType(
        @Param("userId") String userId,
        @Param("socialType") String socialType
    );
    // 회원상태 수정
    void updateMemberStatus(String userId, String customerStatus, String updateUser);

	int getTotalReward(String id);
}
