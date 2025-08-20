package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.service.ContainerService;

@Controller
public class ContainerController {
	private final ContainerService containerService;
	public ContainerController(ContainerService containerService) {
		super();
		this.containerService = containerService;
	}

	// 컨테이너 입력 페이지
	@GetMapping("/admin/insertContainer")
	public String insertContainer(@RequestParam("contractNo") int contractNo
								,Model model) {
		model.addAttribute("contractNo", contractNo);
		return "admin/insertContainer";
	}
	
	@PostMapping("/admin/insertContainer")
	public String insertContainer(@RequestParam("contractNo") int contractNo
								 ,@RequestParam("containerLocation") String containerLocation) {
		int row = containerService.insertContainer(contractNo, containerLocation);
		return "admin/insertContainer";
	}
}
