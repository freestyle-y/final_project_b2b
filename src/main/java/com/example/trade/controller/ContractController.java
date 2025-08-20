package com.example.trade.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.Contract;
import com.example.trade.service.ContractService;

@Controller
public class ContractController {
	private final ContractService contractService;
	
	public ContractController(ContractService contractService) {
		super();
		this.contractService = contractService;
	}

	// 기업 회원 계약서 목록 페이지
	@GetMapping("/biz/contractList")
	public String contractList(Principal principal, Model model) {
		String userId = principal.getName();
		List<Contract> contractList = contractService.getContractList(userId);
		model.addAttribute("contractList", contractList);
		return "biz/contractList";
	}
	
	// 기업 회원 계약서 상세 페이지
	@GetMapping("/biz/contractOne")
	public String contractOne(@RequestParam("contractNo") int contractNo
							 ,Principal principal
							 ,Model model) {
		String userId = principal.getName();
		List<Contract> contractOne = contractService.getContractOne(contractNo, userId);
		List<Contract> contractUser = contractService.getContractUser(userId);
		List<Contract> contractSupplier = contractService.getContractSupplier(contractNo);
		
		model.addAttribute("contractUser", contractUser);
		model.addAttribute("contractOne", contractOne);
		model.addAttribute("contractSupplier", contractSupplier);
		return "biz/contractOne";
	}
	
	// 관리자 계약서 목록 페이지
	@GetMapping("/admin/contractList")
	public String contractList(Model model) {
		List<Contract> contractList = contractService.getAllContractList();
		model.addAttribute("contractList", contractList);
		return "admin/contractList";
	}
	
	// 관리자 계약서 상세 페이지
	@GetMapping("/admin/contractOne")
	public String contractOne(@RequestParam("contractNo") int contractNo, Model model) {
	    List<Contract> contractOne = contractService.getContractOneForAdmin(contractNo);
	    // 관리자 페이지에서도 갑/을 정보를 노출하려면 공급자/수요자 모두 모델에 담아 전달
	    List<Contract> contractSupplier = contractService.getContractSupplier(contractNo);
	    List<Contract> contractUser = contractService.getContractUserByContractNo(contractNo);

	    model.addAttribute("contractOne", contractOne);
	    model.addAttribute("contractSupplier", contractSupplier);
	    model.addAttribute("contractUser", contractUser);

	    return "admin/contractOne";
	}
	
	// 관리자 계약서 작성 페이지
	@GetMapping("/admin/writeContract")
	public String writeContract(@RequestParam(value = "contractNo", required = false) Integer contractNo, Model model) {
		// 목록에서 넘어온 contractNo가 있으면 관련 정보(품목/당사자)를 미리 채움
		if (contractNo != null) {
			List<Contract> contractOne = contractService.getContractOneForAdmin(contractNo);
			List<Contract> contractSupplier = contractService.getContractSupplier(contractNo);
			List<Contract> contractUser = contractService.getContractUserByContractNo(contractNo);
			model.addAttribute("contractOne", contractOne);
			model.addAttribute("contractSupplier", contractSupplier);
			model.addAttribute("contractUser", contractUser);
			model.addAttribute("contractNo", contractNo);
		}
		return "admin/writeContract";
	}
}
