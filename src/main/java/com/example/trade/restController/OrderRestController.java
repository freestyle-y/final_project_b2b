package com.example.trade.restController;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.service.OrderService;

@RestController
@RequestMapping("/personal/order")
public class OrderRestController {
	private final OrderService orderService;
	
	public OrderRestController(OrderService orderService) {
		super();
		this.orderService = orderService;
	}

    @PostMapping("/confirmProduct")
    public void confirmProduct(@RequestParam String orderNo
							  ,@RequestParam String subOrderNo) {

    	int row = orderService.updateOrderStatus(orderNo, subOrderNo);
    }
}
