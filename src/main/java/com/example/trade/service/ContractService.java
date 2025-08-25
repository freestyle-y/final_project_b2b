package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

	public List<Contract> getAllContractList() {
		return contractMapper.getAllContractList();
	}

	public List<Contract> getContractOneForAdmin(int contractNo) {
		return contractMapper.getContractOneForAdmin(contractNo);
	}

	public List<Contract> getContractForAdmin(int contractNo) {
		return contractMapper.getContractForAdmin(contractNo);
	}

	public List<Contract> getContractUserByContractNo(int contractNo) {
		return contractMapper.getContractUserByContractNo(contractNo);
	}

	public List<Contract> getContractSupplierByQuotation(int quotationNo) {
		return contractMapper.getContractSupplierByQuotation(quotationNo);
	}

	public List<Contract> getContractUserByQuotation(int quotationNo) {
		return contractMapper.getContractUserByQuotation(quotationNo);
	}

	@Transactional
	public int insertContract(Contract contract) {
	    System.out.println("🔥 Service insertContract 진입: " + contract);
	    int result = contractMapper.insertContract(contract);
	    System.out.println("🔥 Mapper insert 결과: " + result);
	    return result;
	}

	public void deleteContract(int contractNo, int quotationNo) {
		contractMapper.deleteContract(contractNo, quotationNo);
	}
}
