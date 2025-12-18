package com.insurance_system.service;

import com.insurance_system.dao.ContractStatusDAO;
import com.insurance_system.entity.ContractStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ContractStatusService {
    
    @Autowired
    private ContractStatusDAO contractStatusDAO;
    
    @Transactional
    public List<ContractStatus> getAllContractStatuses() {
        return contractStatusDAO.getAllContractStatuses();
    }
    
    @Transactional
    public ContractStatus getContractStatusByCode(String code) {
        return contractStatusDAO.getContractStatusByCode(code);
    }
}