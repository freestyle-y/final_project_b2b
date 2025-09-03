package com.example.trade.restController;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.*;

import com.example.trade.dto.Address;
import com.example.trade.service.AddressService;

@RestController
@RequestMapping("/api/address")
public class AddressRestController {

    private final AddressService addressService;

    public AddressRestController(AddressService addressService) {
        this.addressService = addressService;
    }

    /** 배송지 목록 조회 */
    @GetMapping("/list")
    public List<Address> list(Principal principal) {
        String userId = principal.getName();
        return addressService.getAddressList(userId);
    }


    /** 배송지 추가 */
    @PostMapping("/add")
    public Map<String, Object> add(@RequestBody Address address, Principal principal) {
        String userId = principal.getName();
        address.setUserId(userId);
        address.setCreateUser(userId);
        if (address.getOwnerType() == null || address.getOwnerType().isBlank()) address.setOwnerType("AC001"); // 개인 기본
        if (address.getMainAddress() == null || address.getMainAddress().isBlank()) address.setMainAddress("N");
        if (address.getUseStatus() == null || address.getUseStatus().isBlank()) address.setUseStatus("Y");

        int row = addressService.addAddress(address);
        Map<String, Object> res = new HashMap<>();
        res.put("status", row > 0 ? "success" : "error");
        return res;
    }

    /** 기본 배송지로 지정 */
    @PostMapping("/main")
    public Map<String, Object> setMain(@RequestBody Map<String, Integer> body, Principal principal) {
        String userId = principal.getName();
        Integer addressNo = body.get("addressNo");
        int row = addressService.changeMainAddress(userId, addressNo);
        Map<String, Object> res = new HashMap<>();
        res.put("status", row > 0 ? "success" : "error");
        return res;
    }

    /** 배송지 삭제 */
    @PostMapping("/delete")
    public Map<String, Object> delete(@RequestBody Map<String, Integer> body, Principal principal) {
        String userId = principal.getName();
        Integer addressNo = body.get("addressNo");
        int row = addressService.deleteAddress(userId, addressNo);
        Map<String, Object> res = new HashMap<>();
        res.put("status", row > 0 ? "success" : "error");
        return res;
    }
}
