package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.trade.dto.Contract;
import com.example.trade.mapper.ContractMapper;

@Service
public class ContractService {
	private final ContractMapper contractMapper;

	public ContractService(ContractMapper contractMapper) {
		super();
		this.contractMapper = contractMapper;
	}

	public List<Contract> getContractList(String userId) {
		return contractMapper.getContractList(userId);
	}

	public List<Contract> getContractOne(int contractNo, String userId) {
		return contractMapper.getContractOne(contractNo, userId);
	}

	public List<Contract> getContractUser(String userId) {
		return contractMapper.getContractUser(userId);
	}
	
	public List<Contract> getContractSupplier(int contractNo) {
		return contractMapper.getContractSupplier(contractNo);
	}
}
