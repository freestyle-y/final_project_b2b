package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.dto.Quotation;
import com.example.trade.dto.QuotationItem;
import com.example.trade.mapper.QuotationMapper;

@Service
public class QuotationService {
    private final QuotationMapper quotationMapper;

    public QuotationService(QuotationMapper quotationMapper) {
        this.quotationMapper = quotationMapper;
    }
    public List<Quotation> getAllAdminQuotations() {
        return quotationMapper.getAllAdminQuotations();
    }
    /** 요청 상품에 대한 견적서 목록 */
    public List<Quotation> getQuotationList(String userId) {
        return quotationMapper.getQuotationList(userId);
    }

    /** 견적서 상세 */
    public Quotation getQuotationOne(int quotationNo) {
        return quotationMapper.getQuotationOne(quotationNo);
    }

    /** 관리자 전체 견적서 
     * @param subProductRequestNo 
     * @param productRequestNo */
    public List<Quotation> getAdminQuotationList(int productRequestNo) {
        return quotationMapper.getAdminQuotationList(productRequestNo);
    }

    /** 관리자 견적 상세 */
    public List<Quotation> adminQuotationOne(int productRequestNo) {
        return quotationMapper.adminQuotationOne(productRequestNo);
    }

    /** 상품 불러오기 (견적 작성용) */
    public List<QuotationItem> getProductRequestForQuotation(int productRequestNo) {
        return quotationMapper.getProductRequestForQuotation(productRequestNo);
    }

    /** 견적서 마스터 INSERT */
    @Transactional
    public void insertQuotationMaster(Quotation quotation) {
        quotationMapper.insertQuotationMaster(quotation);
    }

    /** 견적서 상품 INSERT */
    @Transactional
    public void insertQuotationItem(QuotationItem item) {
        quotationMapper.insertQuotationItem(item);
    }

    @Transactional
    public int updateStatusAtApprove(int quotationNo) {
        return quotationMapper.updateStatusAtApprove(quotationNo);
    }

    @Transactional
    public int updateStatusAtReject(int quotationNo, String rejectionReason, String userId) {
        return quotationMapper.updateStatusAtReject(quotationNo, rejectionReason, userId);
    }
    @Transactional
	public int deleteQuotation(int quotationNo, int productRequestNo) {
    	quotationMapper.deleteQuotationItemsByQuotationNo(quotationNo);
		return quotationMapper.deleteQuotation(quotationNo, productRequestNo);
	}
    public void updateQuotationItem(QuotationItem item) {
        quotationMapper.updateQuotationItem(item);
    }
	public int getContractExist(int quotationNo) {
		return quotationMapper.getContractExist(quotationNo);
	}

	// 관리자 확인 시 status 확인 완료 추가
	public int updateProductRequest(int productRequestNo) {
		return quotationMapper.updateProductRequest(productRequestNo);
	}
}
