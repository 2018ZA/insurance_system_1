package com.insurance_system.dao;

import com.insurance_system.entity.InsuranceType;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class InsuranceTypeDAO {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    @Transactional
    public List<InsuranceType> getAllInsuranceTypes() {
        Session session = sessionFactory.getCurrentSession();
        Query<InsuranceType> query = session.createQuery(
            "FROM InsuranceType WHERE active = true ORDER BY name", 
            InsuranceType.class
        );
        return query.getResultList();
    }
    
    @Transactional
    public InsuranceType getInsuranceTypeByCode(String code) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(InsuranceType.class, code);
    }
    
    @Transactional
    public void saveInsuranceType(InsuranceType insuranceType) {
        Session session = sessionFactory.getCurrentSession();
        session.saveOrUpdate(insuranceType);
    }
    
    @Transactional
    public void updateInsuranceType(InsuranceType insuranceType) {
        Session session = sessionFactory.getCurrentSession();
        session.update(insuranceType);
    }
    
    @Transactional
    public void deleteInsuranceType(String code) {
        Session session = sessionFactory.getCurrentSession();
        InsuranceType insuranceType = session.get(InsuranceType.class, code);
        if (insuranceType != null) {
            session.delete(insuranceType);
        }
    }
    
    @Transactional
    public List<InsuranceType> getInsuranceTypesByCategory(String category) {
        Session session = sessionFactory.getCurrentSession();
        Query<InsuranceType> query = session.createQuery(
            "FROM InsuranceType WHERE category = :category AND active = true ORDER BY name", 
            InsuranceType.class
        );
        query.setParameter("category", category);
        return query.getResultList();
    }
}