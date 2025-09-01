package com.example.trade.mapper;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.trade.dto.Contract;

@Mapper
public interface ContractMapper {

	List<Contract> getContractList(String userId);

	List<Contract> getContractOne(int contractNo, String userId);

	List<Contract> getContractUser(String userId);
	
	List<Contract> getContractSupplier(int contractNo);

	List<Contract> getAllContractList();

	List<Contract> getContractOneForAdmin(int contractNo);

	List<Contract> getContractForAdmin(int contractNo);

	// 관리자 화면에서 계약번호로 을(수요자) 정보를 조회
	List<Contract> getContractUserByContractNo(int contractNo);

	List<Contract> getContractSupplierByQuotation(int quotationNo);

	List<Contract> getContractUserByQuotation(int quotationNo);

	int insertContract(Contract contract);

	void deleteContract(int contractNo, int quotationNo);

	Contract getContractByContractNo(int contractNo);

	void updateContract(Contract contract);

    void updateDownPayment(@Param("contractNo") int contractNo, @Param("downPaymentDate") LocalDate downPaymentDate, @Param("downPaymentStatus") String status);

	void insertContractOrder(int contractNo);

    void updateFinalPaymentStatus(@Param("contractNo") int contractNo, @Param("finalPaymentStatus") String status);

    void updateFinalPaymentDueDate(@Param("contractNo") int contractNo, @Param("finalPaymentDate") LocalDate finalPaymentDueDate);

    boolean getSignExist(@Param("contractNo") int contractNo, @Param("priority") int priority);

}
