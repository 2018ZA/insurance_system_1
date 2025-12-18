package com.insurance_system.service;

import com.insurance_system.dao.ClientDAO;
import com.insurance_system.dao.ContractDAO;
import com.insurance_system.dao.InsuranceTypeDAO;
import com.insurance_system.entity.InsuranceType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class StatisticsService {
    
    @Autowired
    private ClientDAO clientDAO;
    
    @Autowired
    private ContractDAO contractDAO;
    
    @Autowired
    private InsuranceTypeDAO insuranceTypeDAO;
    
    @Transactional
    public Map<String, Object> getGeneralStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        stats.put("totalClients", clientDAO.getClientsCount());
        stats.put("totalContracts", contractDAO.getContractsCount());
        stats.put("activeContracts", contractDAO.getActiveContractsCount());
        stats.put("totalPremium", contractDAO.getTotalPremiumAmount());
        
        return stats;
    }
    
    @Transactional
    public List<Map<String, Object>> getContractsByTypeStatistics() {
        List<Map<String, Object>> result = new ArrayList<>();
        List<InsuranceType> types = insuranceTypeDAO.getAllInsuranceTypes();
        
        for (InsuranceType type : types) {
            Map<String, Object> typeStats = new HashMap<>();
            typeStats.put("typeName", type.getName());
            typeStats.put("typeCode", type.getCode());
            
            long count = 0;
            List<com.insurance_system.entity.Contract> contracts = contractDAO.getContractsByType(type.getCode());
            if (contracts != null) {
                count = contracts.size();
            }
            
            typeStats.put("contractCount", count);
            
            // Расчет средней премии
            double avgPremium = 0;
            if (count > 0) {
                double totalPremium = 0;
                for (com.insurance_system.entity.Contract contract : contracts) {
                    totalPremium += contract.getPremiumAmount().doubleValue();
                }
                avgPremium = totalPremium / count;
            }
            typeStats.put("averagePremium", avgPremium);
            
            result.add(typeStats);
        }
        
        return result;
    }
    
    @Transactional
    public Map<String, Long> getContractsByStatusStatistics() {
        Map<String, Long> statusStats = new HashMap<>();
        
        List<com.insurance_system.entity.ContractStatus> statuses = new ArrayList<>();
        // Здесь нужно получить все статусы через DAO
        // Для простоты используем основные статусы
        String[] statusCodes = {"ACTIVE", "EXPIRED", "TERMINATED", "DRAFT"};
        
        for (String statusCode : statusCodes) {
            List<com.insurance_system.entity.Contract> contracts = contractDAO.getContractsByStatus(statusCode);
            statusStats.put(statusCode, (long) contracts.size());
        }
        
        return statusStats;
    }
}