package com.example.trade.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.trade.dto.Contract;
import com.example.trade.dto.ContractDelivery;
import com.example.trade.service.FinalPaymentHistory;

@Controller
public class PaymentHistoryController {
	private final FinalPaymentHistory finalPaymentHistory;
	public PaymentHistoryController(FinalPaymentHistory finalPaymentHistory) {
		super();
		this.finalPaymentHistory = finalPaymentHistory;
	}
	@GetMapping("/admin/finalPaymentHistory")
	public String finalPaymentHistory(Model model) {
		List<Contract> list = finalPaymentHistory.getFinalList();
		model.addAttribute("list", list);
		return "admin/finalPaymentHistory";
	}
}
