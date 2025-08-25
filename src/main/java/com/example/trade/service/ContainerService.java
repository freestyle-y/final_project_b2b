package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.trade.dto.Container;
import com.example.trade.mapper.ContainerMapper;

@Service
public class ContainerService {
	private final ContainerMapper containerMapper;
	public ContainerService(ContainerMapper containerMapper) {
		super();
		this.containerMapper = containerMapper;
	}

	public int insertContainer(int contractNo, String containerLocation) {
		return containerMapper.insertContainer(contractNo, containerLocation);
	}

	public List<Container> getContainerList() {
		return containerMapper.getContainerList();
	}

	public void deleteContainer(int containerNo) {
		containerMapper.deleteContainer(containerNo);
	}

}
