package com.example.trade.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.domain.UserDomain;

@Mapper
public interface UserMapper {
	// 아이디로 사용자 조회
	UserDomain findById(String id);
}
