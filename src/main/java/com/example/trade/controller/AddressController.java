package com.example.trade.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.trade.dto.Address;
import com.example.trade.service.AddressService;

@Controller
public class AddressController {
	private final AddressService addressService;
    public AddressController(AddressService addressService) {
		super();
		this.addressService = addressService;
	}
	// 배송지 추가 팝업 페이지
    @GetMapping("/personal/addressPopup")
    public String addressPopup(@RequestParam("user_id") String userId,Model model, Principal principal) {
        if (userId == null) {
            userId = principal.getName(); // user_id 없으면 로그인 사용자 아이디 사용
        }
    	List<Address> addressList = addressService.getAddressList(userId);
    	model.addAttribute("addressList", addressList);
    	return "personal/addressPopup";
    }
    
    @PostMapping("/personal/addressCon")
    public String addressCon(@RequestParam("addressCon") String addressCon,
                             @RequestParam("selectedAddressChk") int addressNo,
                             Principal principal) {

        String userId = principal.getName();
        int row = 0;

        if ("changeMainAddress".equals(addressCon)) {
            row = addressService.changeMainAddress(userId, addressNo);
        } else if ("deleteAddress".equals(addressCon)) {
            row = addressService.deleteAddress(userId, addressNo);
        }

        if (row > 0) {
            return "redirect:/personal/addressPopup?user_id=" + userId;
        } else {
            return "redirect:/personal/addressPopup?user_id=" + userId + "&error=true";
        }
    }

}
