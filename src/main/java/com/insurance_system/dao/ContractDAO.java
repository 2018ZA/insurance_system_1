package com.insurance_system.dao;

import com.insurance_system.entity.Contract;
import com.insurance_system.entity.ContractStatus;
import com.insurance_system.entity.InsuranceType;
import com.insurance_system.entity.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Repository
public class ContractDAO {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    @Transactional
    public List<Contract> getAllContracts() {
        Session session = sessionFactory.getCurrentSession();
        Query<Contract> query = session.createQuery(
            "FROM Contract c LEFT JOIN FETCH c.client LEFT JOIN FETCH c.insuranceType ORDER BY c.createdAt DESC", 
            Contract.class
        );
        return query.getResultList();
    }
    
    @Transactional
    public Contract getContractById(Long id) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(Contract.class, id);
    }
    
    @Transactional
    public void saveContract(Contract contract) {
        Session session = sessionFactory.getCurrentSession();
        session.saveOrUpdate(contract);
    }
    
    @Transactional
    public void updateContract(Contract contract) {
        Session session = sessionFactory.getCurrentSession();
        session.update(contract);
    }
    
    @Transactional
    public void deleteContract(Long id) {
        Session session = sessionFactory.getCurrentSession();
        Contract contract = session.get(Contract.class, id);
        if (contract != null) {
            session.delete(contract);
        }
    }
    
    @Transactional
    public Contract findContractByNumber(String contractNumber) {
        Session session = sessionFactory.getCurrentSession();
        Query<Contract> query = session.createQuery(
            "FROM Contract WHERE contractNumber = :number", 
            Contract.class
        );
        query.setParameter("number", contractNumber);
        
        List<Contract> contracts = query.getResultList();
        return contracts.isEmpty() ? null : contracts.get(0);
    }
    
    @Transactional
    public List<Contract> getContractsByClient(Long clientId) {
        Session session = sessionFactory.getCurrentSession();
        Query<Contract> query = session.createQuery(
            "FROM Contract WHERE client.id = :clientId ORDER BY startDate DESC", 
            Contract.class
        );
        query.setParameter("clientId", clientId);
        return query.getResultList();
    }
    
    @Transactional
    public List<Contract> getContractsByAgent(Long agentId) {
        Session session = sessionFactory.getCurrentSession();
        Query<Contract> query = session.createQuery(
            "FROM Contract WHERE agent.id = :agentId ORDER BY createdAt DESC", 
            Contract.class
        );
        query.setParameter("agentId", agentId);
        return query.getResultList();
    }
    
    @Transactional
    public List<Contract> getContractsByType(String typeCode) {
        Session session = sessionFactory.getCurrentSession();
        Query<Contract> query = session.createQuery(
            "FROM Contract WHERE insuranceType.code = :typeCode ORDER BY startDate DESC", 
            Contract.class
        );
        query.setParameter("typeCode", typeCode);
        return query.getResultList();
    }
    
    @Transactional
    public List<Contract> getContractsByStatus(String statusCode) {
        Session session = sessionFactory.getCurrentSession();
        Query<Contract> query = session.createQuery(
            "FROM Contract WHERE status.code = :statusCode ORDER BY startDate DESC", 
            Contract.class
        );
        query.setParameter("statusCode", statusCode);
        return query.getResultList();
    }
    
    @Transactional
    public List<Contract> searchContracts(Date startDate, Date endDate, String typeCode, String statusCode) {
        Session session = sessionFactory.getCurrentSession();
        StringBuilder hql = new StringBuilder("FROM Contract WHERE 1=1");
        
        if (startDate != null) {
            hql.append(" AND startDate >= :startDate");
        }
        if (endDate != null) {
            hql.append(" AND endDate <= :endDate");
        }
        if (typeCode != null && !typeCode.isEmpty()) {
            hql.append(" AND insuranceType.code = :typeCode");
        }
        if (statusCode != null && !statusCode.isEmpty()) {
            hql.append(" AND status.code = :statusCode");
        }
        
        hql.append(" ORDER BY startDate DESC");
        
        Query<Contract> query = session.createQuery(hql.toString(), Contract.class);
        
        if (startDate != null) {
            query.setParameter("startDate", startDate);
        }
        if (endDate != null) {
            query.setParameter("endDate", endDate);
        }
        if (typeCode != null && !typeCode.isEmpty()) {
            query.setParameter("typeCode", typeCode);
        }
        if (statusCode != null && !statusCode.isEmpty()) {
            query.setParameter("statusCode", statusCode);
        }
        
        return query.getResultList();
    }
    
    @Transactional
    public long getContractsCount() {
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Contract", Long.class);
        return query.uniqueResult();
    }
    
    @Transactional
    public long getActiveContractsCount() {
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery(
            "SELECT COUNT(*) FROM Contract WHERE status.code = 'ACTIVE'", 
            Long.class
        );
        return query.uniqueResult();
    }
    
    @Transactional
    public double getTotalPremiumAmount() {
        Session session = sessionFactory.getCurrentSession();
        Query<Double> query = session.createQuery(
            "SELECT SUM(premiumAmount) FROM Contract WHERE status.code = 'ACTIVE'", 
            Double.class
        );
        Double result = query.uniqueResult();
        return result != null ? result : 0.0;
    }
}