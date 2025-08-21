package com.example.trade.service;

import org.springframework.stereotype.Service;

import com.example.trade.mapper.ReviewMapper;

@Service
public class ReviewService {
	private final ReviewMapper reviewMapper;
	public ReviewService(ReviewMapper reviewMapper) {
		super();
		this.reviewMapper = reviewMapper;
	}

	public int addReview(String orderNo, String subOrderNo, double grade, String review) {

		return reviewMapper.addReview(orderNo, subOrderNo, grade, review);
	}

}
