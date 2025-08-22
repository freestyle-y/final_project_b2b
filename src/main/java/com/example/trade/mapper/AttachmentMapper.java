package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.example.trade.dto.Attachment;

@Mapper
public interface AttachmentMapper {
    int insertOne(Attachment a);
    int insertBatch(List<Attachment> list);

    List<Attachment> selectByCodeAndCategory(String attachmentCode, String categoryCode);
}
