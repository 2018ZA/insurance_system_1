package com.insurance_system.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "insurance_claim")
public class InsuranceClaim {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contract_id", nullable = false)
    private Contract contract;
    
    @Column(name = "claim_number", nullable = false, length = 100, unique = true)
    private String claimNumber;
    
    @Temporal(TemporalType.DATE)
    @Column(name = "incident_date", nullable = false)
    private Date incidentDate;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "claimed_amount", precision = 15, scale = 2)
    private BigDecimal claimedAmount;
    
    @Column(name = "approved_amount", precision = 15, scale = 2)
    private BigDecimal approvedAmount;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "status_code", referencedColumnName = "code")
    private ClaimStatus status;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;
    
    // Конструкторы
    public InsuranceClaim() {
        this.createdAt = new Date();
    }
    
    // Геттеры и сеттеры
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Contract getContract() {
        return contract;
    }
    
    public void setContract(Contract contract) {
        this.contract = contract;
    }
    
    public String getClaimNumber() {
        return claimNumber;
    }
    
    public void setClaimNumber(String claimNumber) {
        this.claimNumber = claimNumber;
    }
    
    public Date getIncidentDate() {
        return incidentDate;
    }
    
    public void setIncidentDate(Date incidentDate) {
        this.incidentDate = incidentDate;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getClaimedAmount() {
        return claimedAmount;
    }
    
    public void setClaimedAmount(BigDecimal claimedAmount) {
        this.claimedAmount = claimedAmount;
    }
    
    public BigDecimal getApprovedAmount() {
        return approvedAmount;
    }
    
    public void setApprovedAmount(BigDecimal approvedAmount) {
        this.approvedAmount = approvedAmount;
    }
    
    public ClaimStatus getStatus() {
        return status;
    }
    
    public void setStatus(ClaimStatus status) {
        this.status = status;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}