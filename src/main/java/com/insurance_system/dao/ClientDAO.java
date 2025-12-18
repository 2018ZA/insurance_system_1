package com.insurance_system.dao;

import com.insurance_system.entity.Client;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class ClientDAO {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    @Transactional
    public List<Client> getAllClients() {
        Session session = sessionFactory.getCurrentSession();
        Query<Client> query = session.createQuery("FROM Client ORDER BY fullName", Client.class);
        return query.getResultList();
    }
    
    @Transactional
    public Client getClientById(Long id) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(Client.class, id);
    }
    
    @Transactional
    public void saveClient(Client client) {
        Session session = sessionFactory.getCurrentSession();
        session.saveOrUpdate(client);
    }
    
    @Transactional
    public void updateClient(Client client) {
        Session session = sessionFactory.getCurrentSession();
        session.update(client);
    }
    
    @Transactional
    public void deleteClient(Long id) {
        Session session = sessionFactory.getCurrentSession();
        Client client = session.get(Client.class, id);
        if (client != null) {
            session.delete(client);
        }
    }
    
    @Transactional
    public List<Client> searchClientsByName(String name) {
        Session session = sessionFactory.getCurrentSession();
        Query<Client> query = session.createQuery(
            "FROM Client WHERE LOWER(fullName) LIKE LOWER(:name) ORDER BY fullName", 
            Client.class
        );
        query.setParameter("name", "%" + name + "%");
        return query.getResultList();
    }
    
    @Transactional
    public Client findClientByPassport(String series, String number) {
        Session session = sessionFactory.getCurrentSession();
        Query<Client> query = session.createQuery(
            "FROM Client WHERE passportSeries = :series AND passportNumber = :number", 
            Client.class
        );
        query.setParameter("series", series);
        query.setParameter("number", number);
        
        List<Client> clients = query.getResultList();
        return clients.isEmpty() ? null : clients.get(0);
    }
    
    @Transactional
    public Client findClientByPhone(String phone) {
        Session session = sessionFactory.getCurrentSession();
        Query<Client> query = session.createQuery(
            "FROM Client WHERE phone = :phone", 
            Client.class
        );
        query.setParameter("phone", phone);
        
        List<Client> clients = query.getResultList();
        return clients.isEmpty() ? null : clients.get(0);
    }
    
    @Transactional
    public long getClientsCount() {
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Client", Long.class);
        return query.uniqueResult();
    }
}