package com.example.trade.mapper;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ContainerMapper {

	int insertContainer(int contractNo, String containerLocation);

}
