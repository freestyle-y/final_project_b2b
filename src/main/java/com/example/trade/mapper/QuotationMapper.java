package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.trade.dto.Quotation;
import com.example.trade.dto.QuotationItem;

@Mapper
public interface QuotationMapper {

    /** 기업회원 견적서 목록 */
    List<Quotation> getQuotationList(String userId);

    /** 기업회원 견적서 상세 (items 포함) */
    Quotation getQuotationOne(int quotationNo);
    
    List<Quotation> getAllAdminQuotations();

    /** 관리자 견적서 목록 
     * @param subProductRequestNo 
     * @param productRequestNo */
    List<Quotation> getAdminQuotationList(@Param("productRequestNo") int productRequestNo);


    /** 관리자 견적서 상세 */
    Quotation adminQuotationOne(int quotationNo);

    /** 견적 작성용 상품 조회 */
    List<QuotationItem> getProductRequestForQuotation(int productRequestNo);

    /** 견적서 마스터 insert */
    int insertQuotationMaster(Quotation quotation);

    /** 견적서 상품 insert */
    int insertQuotationItem(QuotationItem item);

    /** 견적 승인 */
    int updateStatusAtApprove(int quotationNo);

    int updateStatusAtReject(@Param("quotationNo") int quotationNo,
                             @Param("rejectionReason") String rejectionReason,
                             @Param("userId") String userId);

	int deleteQuotation(int quotationNo, int productRequestNo);

	void deleteQuotationItemsByQuotationNo(int quotationNo);

	void updateQuotationItem(QuotationItem item);

	int getContractExist(int quotationNo);
	
	int updateProductRequest(int productRequestNo);
}
