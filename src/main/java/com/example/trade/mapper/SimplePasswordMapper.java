package com.example.trade.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SimplePasswordMapper {

	int checkSimPw(@Param("userId") String userId);

	int validatePassword(@Param("userId") String userId, @Param("simplePassword") String simplePassword);
	
	void registerSimplePassword(@Param("userId") String userId, @Param("simplePassword") String simplePassword);
}
