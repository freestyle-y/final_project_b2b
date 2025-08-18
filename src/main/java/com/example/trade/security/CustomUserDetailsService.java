package com.example.trade.security;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.trade.domain.UserDomain;
import com.example.trade.mapper.UserMapper;

/**
 * CustomUserDetailsService
 * Spring Security의 UserDetailsService 구현체
 * 로그인 시 사용자가 입력한 username(id)으로 DB를 조회
 * 조회 결과(UserDomain)를 UserDetails 규격(CustomUserDetails)로 감싸서 반환
 */
@Service
public class CustomUserDetailsService implements UserDetailsService {
	
	private UserMapper userMapper;
	
	public CustomUserDetailsService(UserMapper userMapper) {
		this.userMapper = userMapper;
	}

	/**
	 * 로그인 시 호출되는 메서드
	 * @param username 로그인 폼에서 전달된 아이디
	 * @return UserDetails (Spring Security에서 인증 절차에 사용하는 객체)
	 * @throws UsernameNotFoundException DB에 해당 username이 없으면 예외 발생
	 */
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// DB 조회
		UserDomain userDomain = userMapper.findById(username);
		
		// 사용자 없을 경우 예외 발생
		if(userDomain == null) {
			throw new UsernameNotFoundException(username + "의 사용자가 없습니다.");
		}
		
		// 조회된 사용자 정보를 Spring Security 규격(UserDetails)으로 변환
		return new CustomUserDetails(userDomain);
	}

}
