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

	// 계약서 목록 페이지
	@GetMapping("/biz/contractList")
	public String contractList(Principal principal, Model model) {
		String userId = principal.getName();
		List<Contract> contractList = contractService.getContractList(userId);
		model.addAttribute("contractList", contractList);
		return "biz/contractList";
	}
	
	// 계약서 상세 페이지
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
	
}
