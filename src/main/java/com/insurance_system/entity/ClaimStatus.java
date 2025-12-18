package com.insurance_system.entity;

import javax.persistence.*;

@Entity
@Table(name = "claim_status")
public class ClaimStatus {
    
    @Id
    @Column(name = "code", length = 50)
    private String code;
    
    @Column(name = "name", nullable = false, length = 100)
    private String name;
    
    // Конструкторы
    public ClaimStatus() {}
    
    public ClaimStatus(String code, String name) {
        this.code = code;
        this.name = name;
    }
    
    // Геттеры и сеттеры
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
}