package com.example.trade.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.trade.dto.Attachment;
import java.util.List;

@Mapper
public interface AttachmentContractMapper {
    int insertAttachment(Attachment attachment); // [수정] DTO 단일 insert

    Integer selectMaxPriority(@Param("attachmentCode") String attachmentCode,
                              @Param("categoryCode") int categoryCode);

    default int selectNextPriority(String attachmentCode, int categoryCode) {
        Integer max = selectMaxPriority(attachmentCode, categoryCode);
        return (max == null || max == 0) ? 1 : (max + 1);
    }

    // 계약서별 첨부파일 목록 조회
    List<Attachment> selectAttachmentsByContract(@Param("attachmentCode") String attachmentCode,
                                                 @Param("contractNo") int contractNo);

    // 첨부파일 상세 조회
    Attachment selectAttachmentByNo(@Param("attachmentNo") int attachmentNo);

    // 첨부파일 삭제 (논리 삭제)
    int deleteAttachment(@Param("attachmentNo") int attachmentNo,
                        @Param("updateUser") String updateUser);
    
    // 모든 첨부파일 조회 (디버깅용)
    List<Attachment> selectAllAttachments();
}
