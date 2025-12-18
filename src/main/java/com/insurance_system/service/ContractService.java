package com.insurance_system.service;

import com.insurance_system.dao.ClientDAO;
import com.insurance_system.dao.ContractDAO;
import com.insurance_system.dao.ContractStatusDAO;
import com.insurance_system.dao.InsuranceTypeDAO;
import com.insurance_system.dao.UserDAO;
import com.insurance_system.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Service
public class ContractService {
    
    @Autowired
    private ContractDAO contractDAO;
    
    @Autowired
    private ClientDAO clientDAO;
    
    @Autowired
    private InsuranceTypeDAO insuranceTypeDAO;
    
    @Autowired
    private ContractStatusDAO contractStatusDAO;
    
    @Autowired
    private UserDAO userDAO;
    
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMdd");
    
    @Transactional
    public List<Contract> getAllContracts() {
        return contractDAO.getAllContracts();
    }
    
    @Transactional
    public Contract getContractById(Long id) {
        return contractDAO.getContractById(id);
    }
    
    @Transactional
    public void saveContract(Contract contract, Long agentId) {
        // Установка агента
        if (agentId != null) {
            User agent = userDAO.getUserById(agentId);
            contract.setAgent(agent);
        }
        
        // Генерация номера договора, если его нет
        if (contract.getContractNumber() == null || contract.getContractNumber().isEmpty()) {
            contract.setContractNumber(generateContractNumber());
        }
        
        // Установка статуса по умолчанию, если не задан
        if (contract.getStatus() == null) {
            ContractStatus defaultStatus = contractStatusDAO.getContractStatusByCode("DRAFT");
            contract.setStatus(defaultStatus);
        }
        
        // Проверка дат
        if (contract.getStartDate() != null && contract.getEndDate() != null) {
            if (!contract.getEndDate().after(contract.getStartDate())) {
                throw new RuntimeException("Дата окончания должна быть позже даты начала");
            }
        }
        
        contractDAO.saveContract(contract);
    }
    
    @Transactional
    public void updateContract(Contract contract) {
        // Проверка дат
        if (contract.getStartDate() != null && contract.getEndDate() != null) {
            if (!contract.getEndDate().after(contract.getStartDate())) {
                throw new RuntimeException("Дата окончания должна быть позже даты начала");
            }
        }
        
        contractDAO.updateContract(contract);
    }
    
    @Transactional
    public void deleteContract(Long id) {
        contractDAO.deleteContract(id);
    }
    
    @Transactional
    public void changeContractStatus(Long contractId, String statusCode) {
        Contract contract = contractDAO.getContractById(contractId);
        if (contract != null) {
            ContractStatus status = contractStatusDAO.getContractStatusByCode(statusCode);
            if (status != null) {
                contract.setStatus(status);
                contractDAO.updateContract(contract);
            }
        }
    }
    
    @Transactional
    public List<Contract> getContractsByClient(Long clientId) {
        return contractDAO.getContractsByClient(clientId);
    }
    
    @Transactional
    public List<Contract> getContractsByAgent(Long agentId) {
        return contractDAO.getContractsByAgent(agentId);
    }
    
    @Transactional
    public List<Contract> searchContracts(Date startDate, Date endDate, String typeCode, String statusCode) {
        return contractDAO.searchContracts(startDate, endDate, typeCode, statusCode);
    }
    
    @Transactional
    public Contract findContractByNumber(String contractNumber) {
        return contractDAO.findContractByNumber(contractNumber);
    }
    
    @Transactional
    public long getContractsCount() {
        return contractDAO.getContractsCount();
    }
    
    @Transactional
    public long getActiveContractsCount() {
        return contractDAO.getActiveContractsCount();
    }
    
    @Transactional
    public double getTotalPremiumAmount() {
        return contractDAO.getTotalPremiumAmount();
    }
    
    @Transactional
    public List<Contract> getContractsByType(String typeCode) {
        return contractDAO.getContractsByType(typeCode);
    }
    
    @Transactional
    public List<Contract> getContractsByStatus(String statusCode) {
        return contractDAO.getContractsByStatus(statusCode);
    }
    
    private String generateContractNumber() {
        String datePart = DATE_FORMAT.format(new Date());
        long count = contractDAO.getContractsCount() + 1;
        return "CNT-" + datePart + "-" + String.format("%05d", count);
    }
}