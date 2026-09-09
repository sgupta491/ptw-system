package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "permit_final_verification",uniqueConstraints = {@UniqueConstraint(
   name = "uk_final_verification_permit",columnNames = "permit_id") })
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitFinalVerification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "permit_id", nullable = false)
    private Permit permit;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "verified_by", nullable = false)
    private User verifiedBy;

    @Column(name = "verified_at", nullable = false)
    private LocalDateTime verifiedAt;

    @Column(name = "remarks", columnDefinition = "TEXT")
    private String remarks;

    @Column(name = "signature_required", nullable = false)
    private Boolean signatureRequired = true;
}