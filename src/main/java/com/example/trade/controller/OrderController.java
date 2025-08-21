package com.example.trade.controller;

import java.security.Principal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.trade.dto.Address;
import com.example.trade.dto.KakaoPayApprovalResponse;
import com.example.trade.dto.KakaoPayReadyResponse;
import com.example.trade.dto.Order;
import com.example.trade.dto.PaymentMethod;
import com.example.trade.service.AddressService;
import com.example.trade.service.KakaoPayService;
import com.example.trade.service.OrderService;
import com.example.trade.service.PaymentMethodService;

@Controller
public class OrderController {

    private final OrderService orderService;
    private final KakaoPayService kakaoPayService;
    private final PaymentMethodService paymentMethodService;
    private final AddressService addressService;
    public OrderController(OrderService orderService, KakaoPayService kakaoPayService,
			PaymentMethodService paymentMethodService, AddressService addressService) {
		super();
		this.orderService = orderService;
		this.kakaoPayService = kakaoPayService;
		this.paymentMethodService = paymentMethodService;
		this.addressService = addressService;
	}
    // 결제 페이지 (주문정보 보여주기)

    @GetMapping("/personal/payment")
    public String payment(@RequestParam("orderNo") String orderNo, Model model, Principal principal) {
    	String userId = principal.getName();
    	System.out.println("🔥 userId = " + userId);

    	List<Order> orderList = orderService.getOrderList(orderNo);
        List<PaymentMethod> cardList = paymentMethodService.getUserCardList(userId);
        
        List<Address> mainAddress = addressService.getMainAddress(userId);
        model.addAttribute("mainAddress", mainAddress);
        
        int reward = orderService.getReward(userId);
        model.addAttribute("reward", reward);
        System.out.println("reward 액 : " + reward);
        
        model.addAttribute("cardList", cardList);
        System.out.println("cardList = " + cardList);
        
        model.addAttribute("orderList", orderList);
        System.out.println("orderList size = " + orderList.size());
        
        return "personal/payment"; 
    }

    // 카드 등록
    @PostMapping("/personal/payment/addCard")
    @ResponseBody
    public String addCard(@RequestBody PaymentMethod card) {
        card.setCreateUser(card.getUserId());
        card.setUseStatus("Y");
        card.setPaymentCode("CARD");
        if (card.getIsDefault() == null) {
            card.setIsDefault("N"); // 기본값 세팅
        }
        int row = paymentMethodService.insertCard(card);
        System.out.println("insert 결과: " + row);
        if (row > 0) {
            return "success";
        } else {
            return "fail";
        }
    }
    
    @PostMapping("/personal/payment/ready")
    @ResponseBody
    public KakaoPayReadyResponse kakaoPayReady(@RequestBody Map<String, Object> request) {
        String orderNo = (String) request.get("orderNo");
        String name = (String) request.get("name");
        int totalPrice = Integer.parseInt(request.get("totalPrice").toString()); // ✅ 수정 완료

        System.out.println("카카오페이 요청 들어옴: " + request);

        return kakaoPayService.payReady(orderNo, name, totalPrice);
    }


    @GetMapping("/personal/payment/success")
    public String paymentSuccess(@RequestParam("pg_token") String pgToken
                                ,@RequestParam("orderNo") String orderNo
                                ,Model model
                                ,Principal princiapl) {
    	String userId = princiapl.getName();
        // 1. 카카오 결제 승인
        KakaoPayApprovalResponse response = kakaoPayService.payApprove(pgToken);
        // 2. 주문 정보
        Order order = orderService.getOrder(orderNo);
        // 3. 아이템 개수 조회
        int itemCount = orderService.getOrderItemCount(orderNo);

        // 4. 상품명 가공
        String productName = order.getProductName();
        if (itemCount > 1) {
            productName += " 외 " + (itemCount - 1) + "건";
        }

        // 5. 실 결제 금액 계산 (상품 금액 - 사용 적립금)
        // int finalPrice = order.getTotalPrice() - orderService.getReward(userId);
        
        System.out.println("[컨트롤러] usedPoint = " + response.getUsedPoint());
        System.out.println("[컨트롤러] realPaidAmount = " + response.getRealPaidAmount());
        
        // 6. JSP에 전달
        model.addAttribute("name", order.getName());  // 구매자
        model.addAttribute("productName", productName); // 상품명
        model.addAttribute("usedPoint", response.getUsedPoint());
        model.addAttribute("realPaidAmount", response.getRealPaidAmount());
        model.addAttribute("usedKakaoPoint", response.getUsedKakaoPoint());

        return "personal/paymentSuccess";
    }
    // 결제 취소 콜백 (cancel_url)
    @GetMapping("/personal/payment/cancel")
    public String paymentCancel() {
        return "personal/paymentCancel";
    }

    // 결제 실패 콜백 (fail_url)
    @GetMapping("/personal/payment/fail")
    public String paymentFail() {
        return "personal/paymentFail";
    }
    
    // 주문조회
    @GetMapping("/personal/orderList")
    public String orderList(Model model, Principal principal) {
        String userId = principal.getName();

        List<Order> orderList = orderService.getOrderListByuserId(userId);

        // 주문번호 기준으로 그룹핑
        Map<String, List<Order>> orderGroupMap = orderList.stream()
                .collect(Collectors.groupingBy(Order::getOrderNo, LinkedHashMap::new, Collectors.toList()));

        model.addAttribute("orderGroupMap", orderGroupMap);

        return "personal/orderList";
    }
    
    // 주문 상세
    @GetMapping("/personal/orderOne")
    public String orderOne(@RequestParam("orderNo") int orderNo, Model model) {
        List<Order> orderDetailList = orderService.getOrderDetailByOrderNo(orderNo); // 서비스에서 가져오기
        model.addAttribute("orderDetailList", orderDetailList);
        return "personal/orderOne";
    }
    
    @PostMapping("/personal/payment/saveMethodAndPoints")
    @ResponseBody
    public void saveMethodAndPoints(@RequestBody Map<String, Object> req) {
        String orderNo = (String) req.get("orderNo");
        String paymentMethod = (String) req.get("paymentMethod");
        int usePoint = req.get("usePoint") == null ? 0 : Integer.parseInt(req.get("usePoint").toString());

        String methodKor = switch (paymentMethod) {
            case "kakaopay" -> "카카오페이";
            case "bank"     -> "계좌이체";
            case "card"     -> "카드결제";
            default         -> "기타";
        };
        orderService.saveMethodAndPoints(orderNo, methodKor, usePoint);
    }

}
