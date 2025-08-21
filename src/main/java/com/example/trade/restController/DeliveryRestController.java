package com.example.trade.restController;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.dto.Order;
import com.example.trade.service.OrderService;

@RestController
@RequestMapping("/personal/payment")
public class DeliveryRestController {
    private final OrderService orderService;

    public DeliveryRestController(OrderService orderService) {
        this.orderService = orderService;
    }
    
    @PostMapping("/deliveryRequest")
    public ResponseEntity<Void> deliveryRequest(@RequestBody Order order) {
        // 타입 맞추기: orderNo가 String이면 Service/Mapper도 String으로, 숫자면 Long/Integer로 통일
        orderService.updateDeliveryRequest(order.getOrderNo(), order.getDeliveryRequest());
        return ResponseEntity.noContent().build();
    }

}
