package com.insurance_system.dao;

import com.insurance_system.entity.User;
import com.insurance_system.entity.UserRole;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class UserDAO {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    @Transactional
    public List<User> getAllUsers() {
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery("FROM User ORDER BY fullName", User.class);
        return query.getResultList();
    }
    
    @Transactional
    public User getUserById(Long id) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(User.class, id);
    }
    
    @Transactional
    public void saveUser(User user) {
        Session session = sessionFactory.getCurrentSession();
        session.saveOrUpdate(user);
    }
    
    @Transactional
    public void updateUser(User user) {
        Session session = sessionFactory.getCurrentSession();
        session.update(user);
    }
    
    @Transactional
    public void deleteUser(Long id) {
        Session session = sessionFactory.getCurrentSession();
        User user = session.get(User.class, id);
        if (user != null) {
            session.delete(user);
        }
    }
    
    @Transactional
    public User findByLogin(String login) {
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery("FROM User WHERE login = :login", User.class);
        query.setParameter("login", login);
        
        List<User> users = query.getResultList();
        return users.isEmpty() ? null : users.get(0);
    }
    
    @Transactional
    public User authenticate(String login, String password) {
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery(
            "FROM User WHERE login = :login AND password = :password AND active = true", 
            User.class
        );
        query.setParameter("login", login);
        query.setParameter("password", password);
        
        List<User> users = query.getResultList();
        return users.isEmpty() ? null : users.get(0);
    }
    
    @Transactional
    public List<User> getUsersByRole(String roleCode) {
        Session session = sessionFactory.getCurrentSession();
        Query<User> query = session.createQuery(
            "FROM User WHERE role.code = :roleCode AND active = true ORDER BY fullName", 
            User.class
        );
        query.setParameter("roleCode", roleCode);
        return query.getResultList();
    }
    
    @Transactional
    public List<UserRole> getAllRoles() {
        Session session = sessionFactory.getCurrentSession();
        Query<UserRole> query = session.createQuery("FROM UserRole ORDER BY name", UserRole.class);
        return query.getResultList();
    }
    
    @Transactional
    public UserRole getRoleByCode(String code) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(UserRole.class, code);
    }
    
    @Transactional
    public long getUsersCount() {
        Session session = sessionFactory.getCurrentSession();
        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM User WHERE active = true", Long.class);
        return query.uniqueResult();
    }
}