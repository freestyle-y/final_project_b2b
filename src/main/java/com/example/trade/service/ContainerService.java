package com.example.trade.service;

import org.springframework.stereotype.Service;

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

}
