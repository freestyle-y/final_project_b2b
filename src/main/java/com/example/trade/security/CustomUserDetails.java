package com.example.trade.security;

import java.util.ArrayList;
import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.example.trade.domain.UserDomain;

/**
 * CustomUserDetails
 * Spring Security의 UserDetails 인터페이스 구현체
 * DB에서 조회한 UserDomain 객체를 감싸서, 시큐리티가 이해할 수 있는 형태로 변환
 */
public class CustomUserDetails implements UserDetails {

	private UserDomain userDomain; // DB에서 조회한 사용자 정보 (id, password, customerCategory)
	
	public CustomUserDetails(UserDomain userDomain) {
		this.userDomain = userDomain;
	}
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		Collection<GrantedAuthority> roleList = new ArrayList<>();
		
        // 익명 클래스 형태로 GrantedAuthority 구현
		GrantedAuthority grantedAuthority = new GrantedAuthority() {
		// Spring Security는 권한을 Collection<GrantedAuthority> 형태로 관리
			
			@Override
			public String getAuthority() {
				String customerCategory = userDomain.getCustomerCategory();
				
				// DB의 customerCategory(CC001, CC002, CC003)를 ROLE_XXX 형태로 변환해서 반환
				if("CC001".equals(customerCategory)) {
					return "ROLE_ADMIN";
				} else if("CC002".equals(customerCategory)) {
					return "ROLE_BIZ";
				} else if("CC003".equals(customerCategory)) {
					return "ROLE_PERSONAL";
				} else {
					return "ROLE_GUEST"; // 기본값 (정의되지 않은 role의 사용자인 경우)
				}
			}
		};
		
        // 권한을 리스트에 추가
		roleList.add(grantedAuthority);
		return roleList;
	}

	@Override
	// 사용자 비밀번호 반환
	// AuthenticationProvider가 로그인 시 입력값과 DB 값(bcrypt 해시)을 비교할 때 사용
	public String getPassword() {
		return userDomain.getPassword();
	}

	@Override
	// 사용자 로그인 ID 반환
	public String getUsername() {
		return userDomain.getId();
	}

}
