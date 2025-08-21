package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SimplePasswordController {
	@GetMapping("/personal/passwordPopup")
	public String passwordPopup() {
		return "personal/passwordPopup";
	}
}
