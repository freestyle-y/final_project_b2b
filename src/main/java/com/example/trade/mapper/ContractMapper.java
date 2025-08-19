package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Contract;

@Mapper
public interface ContractMapper {

	List<Contract> getContractList(String userId);

	List<Contract> getContractOne(int contractNo, String userId);

	List<Contract> getContractUser(String userId);
	
	List<Contract> getContractSupplier(int contractNo);

}
