package com.insurance_system.service;

import com.insurance_system.dao.InsuranceTypeDAO;
import com.insurance_system.entity.InsuranceType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class InsuranceTypeService {
    
    @Autowired
    private InsuranceTypeDAO insuranceTypeDAO;
    
    @Transactional
    public List<InsuranceType> getAllInsuranceTypes() {
        return insuranceTypeDAO.getAllInsuranceTypes();
    }
    
    @Transactional
    public InsuranceType getInsuranceTypeByCode(String code) {
        return insuranceTypeDAO.getInsuranceTypeByCode(code);
    }
    
    @Transactional
    public void saveInsuranceType(InsuranceType insuranceType) {
        insuranceTypeDAO.saveInsuranceType(insuranceType);
    }
    
    @Transactional
    public void updateInsuranceType(InsuranceType insuranceType) {
        insuranceTypeDAO.updateInsuranceType(insuranceType);
    }
    
    @Transactional
    public void deleteInsuranceType(String code) {
        insuranceTypeDAO.deleteInsuranceType(code);
    }
    
    @Transactional
    public List<InsuranceType> getInsuranceTypesByCategory(String category) {
        return insuranceTypeDAO.getInsuranceTypesByCategory(category);
    }
}