package com.insurance_system.dao;

import com.insurance_system.entity.ContractStatus;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class ContractStatusDAO {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    @Transactional
    public List<ContractStatus> getAllContractStatuses() {
        Session session = sessionFactory.getCurrentSession();
        Query<ContractStatus> query = session.createQuery(
            "FROM ContractStatus ORDER BY name", 
            ContractStatus.class
        );
        return query.getResultList();
    }
    
    @Transactional
    public ContractStatus getContractStatusByCode(String code) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(ContractStatus.class, code);
    }
    
    @Transactional
    public void saveContractStatus(ContractStatus contractStatus) {
        Session session = sessionFactory.getCurrentSession();
        session.saveOrUpdate(contractStatus);
    }
}