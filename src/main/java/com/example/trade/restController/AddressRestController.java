package com.example.trade.restController;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.trade.dto.Address;
import com.example.trade.service.AddressService;

@RestController
@RequestMapping("/api/address")  // ✅ REST형 경로로 분리
public class AddressRestController {

    private final AddressService addressService;

    public AddressRestController(AddressService addressService) {
        this.addressService = addressService;
    }

    /**
     * 배송지 추가 API
     * POST /api/address/add
     */
    @PostMapping("/add")
    public Map<String, Object> addAddress(@RequestBody Address address, Principal principal) {
        String userId = principal.getName();
        address.setOwnerType("AC001");
        address.setUserId(userId);
        address.setCreateUser(userId);

        if (address.getMainAddress() == null) {
            address.setMainAddress("N");
        }

        int row = addressService.addAddress(address);

        Map<String, Object> result = new HashMap<>();
        result.put("status", row > 0 ? "success" : "error");
        return result;
    }
}
