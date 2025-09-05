package com.example.trade.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.trade.dto.ProductRequest;
import com.example.trade.mapper.ProductRequestMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProductRequestService {
    private final ProductRequestMapper productRequestMapper;

    public List<ProductRequest> getProductRequestList() {
        // 1) 조인 결과를 정렬된 그대로 받음
        List<ProductRequest> rows = productRequestMapper.getProductRequestListRaw();

        // 2) product_request_no 별로 최근 본 quotation_no와 현재 회차를 기억
        Map<Integer, Long> lastQuote = new HashMap<>();
        Map<Integer, Integer> rev     = new HashMap<>();

        for (ProductRequest r : rows) {
            int prn = r.getProductRequestNo();
            Long qno = r.getQuotationNo();

            if (qno == null) {           // 견적 미작성
                r.setRevisionNo(0);
                continue;
            }
            Long last = lastQuote.get(prn);
            if (last == null || !last.equals(qno)) {   // 새 견적 번호 만나면 회차 +1
                int next = rev.getOrDefault(prn, 0) + 1;
                rev.put(prn, next);
                lastQuote.put(prn, qno);
            }
            r.setRevisionNo(rev.get(prn));             // 현재 회차 세팅
        }
        return rows;
    }
}
	
