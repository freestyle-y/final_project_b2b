package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminMapper {

	// 로그인 이력 조회
	List<Map<String, Object>> selectLoginHistory();

	// 알림 목록 조회
	List<Map<String, Object>> selectAlarmList();

	// 기업 회원의 배송 현황 조회
	List<Map<String, Object>> selectBizDeliveryList();

}
