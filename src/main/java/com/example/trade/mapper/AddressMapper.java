package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.trade.dto.Address;

@Mapper
public interface AddressMapper {

    List<Address> getAddressList(String userId);

    int addAddress(Address address);

    List<Address> getMainAddress(String userId);

    int resetMainAddress(@Param("userId") String userId);                       // ✅ 수정

    int changeMainAddress(@Param("userId") String userId,
                          @Param("addressNo") int addressNo);                   // ✅ 수정

    int deleteAddress(@Param("userId") String userId,
                      @Param("addressNo") int addressNo);                       // ✅ 수정
}

