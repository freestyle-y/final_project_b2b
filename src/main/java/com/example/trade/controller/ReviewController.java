package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.service.ReviewService;

@Controller
public class ReviewController {
	private final ReviewService reviewService;
	public ReviewController(ReviewService reviewService) {
		super();
		this.reviewService = reviewService;
	}

	@PostMapping("/personal/addReview")
	public String addReview(@RequestParam("orderNo") String orderNo
	        			   ,@RequestParam("subOrderNo") String subOrderNo
	        			   ,@RequestParam("grade") double grade
	        			   ,@RequestParam("review") String review) {
		int row = reviewService.addReview(orderNo, subOrderNo, grade, review);
		
	    return "redirect:/personal/orderOne?orderNo="+orderNo;
	}

}
