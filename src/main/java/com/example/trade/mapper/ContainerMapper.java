package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Container;

@Mapper
public interface ContainerMapper {

	int insertContainer(int contractNo, String containerLocation);

	List<Container> getContainerList();

	void deleteContainer(int containerNo);

	Container getContainerOne(int containerNo);

	void updateContainer(Container container);

	void insertContractOrder(int contractNo);

}
