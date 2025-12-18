package com.insurance_system.entity;

import javax.persistence.*;

@Entity
@Table(name = "insurance_type")
public class InsuranceType {
    
    @Id
    @Column(name = "code", length = 50)
    private String code;
    
    @Column(name = "name", nullable = false, length = 100)
    private String name;
    
    @Column(name = "category", length = 100)
    private String category;
    
    @Column(name = "active")
    private Boolean active = true;
    
    // Конструкторы
    public InsuranceType() {}
    
    public InsuranceType(String code, String name) {
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
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public Boolean getActive() {
        return active;
    }
    
    public void setActive(Boolean active) {
        this.active = active;
    }
}