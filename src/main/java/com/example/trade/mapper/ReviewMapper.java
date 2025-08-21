package com.example.trade.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ReviewMapper {

	int addReview(@Param("orderNo") String orderNo
				 ,@Param("subOrderNo") String subOrderNo
				 ,@Param("grade") double grade
				 ,@Param("review") String review);

}
