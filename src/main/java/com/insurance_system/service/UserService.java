package com.insurance_system.service;

import com.insurance_system.dao.UserDAO;
import com.insurance_system.entity.User;
import com.insurance_system.entity.UserRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class UserService {
    
    @Autowired
    private UserDAO userDAO;
    
    @Transactional
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }
    
    @Transactional
    public User getUserById(Long id) {
        return userDAO.getUserById(id);
    }
    
    @Transactional
    public void saveUser(User user) {
        // Проверка уникальности логина
        User existingUser = userDAO.findByLogin(user.getLogin());
        if (existingUser != null && !existingUser.getId().equals(user.getId())) {
            throw new RuntimeException("Пользователь с таким логином уже существует");
        }
        
        userDAO.saveUser(user);
    }
    
    @Transactional
    public void updateUser(User user) {
        saveUser(user); // Используем тот же метод для обновления
    }
    
    @Transactional
    public void deleteUser(Long id) {
        userDAO.deleteUser(id);
    }
    
    @Transactional
    public User authenticate(String login, String password) {
        return userDAO.authenticate(login, password);
    }
    
    @Transactional
    public User findByLogin(String login) {
        return userDAO.findByLogin(login);
    }
    
    @Transactional
    public List<User> getUsersByRole(String roleCode) {
        return userDAO.getUsersByRole(roleCode);
    }
    
    @Transactional
    public List<UserRole> getAllRoles() {
        return userDAO.getAllRoles();
    }
    
    @Transactional
    public UserRole getRoleByCode(String code) {
        return userDAO.getRoleByCode(code);
    }
    
    @Transactional
    public long getUsersCount() {
        return userDAO.getUsersCount();
    }
    
    @Transactional
    public void changeUserRole(Long userId, String roleCode) {
        User user = userDAO.getUserById(userId);
        if (user != null) {
            UserRole role = userDAO.getRoleByCode(roleCode);
            if (role != null) {
                user.setRole(role);
                userDAO.updateUser(user);
            }
        }
    }
    
    @Transactional
    public void changeUserStatus(Long userId, boolean active) {
        User user = userDAO.getUserById(userId);
        if (user != null) {
            user.setActive(active);
            userDAO.updateUser(user);
        }
    }
}