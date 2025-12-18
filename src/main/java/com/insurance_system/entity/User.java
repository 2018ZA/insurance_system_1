package com.insurance_system.entity;

import javax.persistence.*;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    
    @Column(name = "login", nullable = false, length = 100, unique = true)
    private String login;
    
    @Column(name = "password", nullable = false, length = 255)
    private String password;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "role_code", referencedColumnName = "code")
    private UserRole role;
    
    @Column(name = "full_name", nullable = false, length = 200)
    private String fullName;
    
    @Column(name = "active")
    private Boolean active = true;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;
    
    @OneToMany(mappedBy = "agent", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Contract> contracts = new HashSet<>();
    
    // Конструкторы
    public User() {
        this.createdAt = new Date();
    }
    
    // Геттеры и сеттеры
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getLogin() {
        return login;
    }
    
    public void setLogin(String login) {
        this.login = login;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public UserRole getRole() {
        return role;
    }
    
    public void setRole(UserRole role) {
        this.role = role;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public Boolean getActive() {
        return active;
    }
    
    public void setActive(Boolean active) {
        this.active = active;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Set<Contract> getContracts() {
        return contracts;
    }
    
    public void setContracts(Set<Contract> contracts) {
        this.contracts = contracts;
    }
    
    // Вспомогательные методы
    public boolean isAdmin() {
        return "ADMIN".equals(role.getCode());
    }
    
    public boolean isManager() {
        return "MANAGER".equals(role.getCode());
    }
    
    public boolean isAgent() {
        return "AGENT".equals(role.getCode());
    }
}