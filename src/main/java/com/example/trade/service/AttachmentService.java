package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.dto.Attachment;
import com.example.trade.mapper.AttachmentMapper;

@Service
public class AttachmentService {
	private final AttachmentMapper attachmentMapper;

	public AttachmentService(AttachmentMapper attachmentMapper) {
		super();
		this.attachmentMapper = attachmentMapper;
	}
	
	  @Transactional
	  public void saveAll(List<Attachment> list) {
	    if (list == null || list.isEmpty()) return;
	    if (list.size() == 1) {
	      attachmentMapper.insertOne(list.get(0));
	    } else {
	      attachmentMapper.insertBatch(list);
	    }
	  }

	  public List<Attachment> findContractSigns(int contractNo) {
	    return attachmentMapper.selectByCodeAndCategory("CONTRACT_SIGN", String.valueOf(contractNo));
	  }
}
