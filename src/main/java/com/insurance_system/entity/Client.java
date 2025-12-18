package com.insurance_system.entity;

import javax.persistence.*;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "client")
public class Client {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    
    @Column(name = "full_name", nullable = false, length = 200)
    private String fullName;
    
    @Column(name = "passport_series", length = 10)
    private String passportSeries;
    
    @Column(name = "passport_number", length = 20)
    private String passportNumber;
    
    @Column(name = "phone", nullable = false, length = 20, unique = true)
    private String phone;
    
    @Column(name = "email", length = 100)
    private String email;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "registration_date")
    private Date registrationDate;
    
    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Contract> contracts = new HashSet<>();
    
    // Конструкторы
    public Client() {
        this.registrationDate = new Date();
    }
    
    public Client(String fullName, String phone) {
        this();
        this.fullName = fullName;
        this.phone = phone;
    }
    
    // Геттеры и сеттеры
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getPassportSeries() {
        return passportSeries;
    }
    
    public void setPassportSeries(String passportSeries) {
        this.passportSeries = passportSeries;
    }
    
    public String getPassportNumber() {
        return passportNumber;
    }
    
    public void setPassportNumber(String passportNumber) {
        this.passportNumber = passportNumber;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public Date getRegistrationDate() {
        return registrationDate;
    }
    
    public void setRegistrationDate(Date registrationDate) {
        this.registrationDate = registrationDate;
    }
    
    public Set<Contract> getContracts() {
        return contracts;
    }
    
    public void setContracts(Set<Contract> contracts) {
        this.contracts = contracts;
    }
    
    public String getFullPassport() {
        if (passportSeries != null && passportNumber != null) {
            return passportSeries + " " + passportNumber;
        }
        return "";
    }
}