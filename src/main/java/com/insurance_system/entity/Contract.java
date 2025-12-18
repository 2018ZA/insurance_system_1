package com.insurance_system.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "contract")
public class Contract {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    
    @Column(name = "contract_number", nullable = false, length = 100, unique = true)
    private String contractNumber;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id", nullable = false)
    private Client client;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "insurance_type_code", referencedColumnName = "code")
    private InsuranceType insuranceType;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "agent_id")
    private User agent;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "status_code", referencedColumnName = "code")
    private ContractStatus status;
    
    @Temporal(TemporalType.DATE)
    @Column(name = "start_date", nullable = false)
    private Date startDate;
    
    @Temporal(TemporalType.DATE)
    @Column(name = "end_date", nullable = false)
    private Date endDate;
    
    @Column(name = "premium_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal premiumAmount;
    
    @Column(name = "insured_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal insuredAmount;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;
    
    @OneToMany(mappedBy = "contract", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Payment> payments = new HashSet<>();
    
    @OneToMany(mappedBy = "contract", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<InsuranceClaim> claims = new HashSet<>();
    
    // Конструкторы
    public Contract() {
        this.createdAt = new Date();
    }
    
    // Геттеры и сеттеры
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getContractNumber() {
        return contractNumber;
    }
    
    public void setContractNumber(String contractNumber) {
        this.contractNumber = contractNumber;
    }
    
    public Client getClient() {
        return client;
    }
    
    public void setClient(Client client) {
        this.client = client;
    }
    
    public InsuranceType getInsuranceType() {
        return insuranceType;
    }
    
    public void setInsuranceType(InsuranceType insuranceType) {
        this.insuranceType = insuranceType;
    }
    
    public User getAgent() {
        return agent;
    }
    
    public void setAgent(User agent) {
        this.agent = agent;
    }
    
    public ContractStatus getStatus() {
        return status;
    }
    
    public void setStatus(ContractStatus status) {
        this.status = status;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public BigDecimal getPremiumAmount() {
        return premiumAmount;
    }
    
    public void setPremiumAmount(BigDecimal premiumAmount) {
        this.premiumAmount = premiumAmount;
    }
    
    public BigDecimal getInsuredAmount() {
        return insuredAmount;
    }
    
    public void setInsuredAmount(BigDecimal insuredAmount) {
        this.insuredAmount = insuredAmount;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Set<Payment> getPayments() {
        return payments;
    }
    
    public void setPayments(Set<Payment> payments) {
        this.payments = payments;
    }
    
    public Set<InsuranceClaim> getClaims() {
        return claims;
    }
    
    public void setClaims(Set<InsuranceClaim> claims) {
        this.claims = claims;
    }
    
    // Вспомогательные методы
    public boolean isActive() {
        Date now = new Date();
        return "ACTIVE".equals(status.getCode()) 
                && startDate.before(now) 
                && endDate.after(now);
    }
}