package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "permit_work_completion")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitWorkCompletion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "permit_id", nullable = false, unique = true)
    private Permit permit;

    // H - Work completed? YES / NO
    @Column(name = "completion_response", nullable = false, length = 10)
    private String completionResponse;

    // Person who submitted H
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "completed_by", nullable = false)
    private User completedBy;

    // System-generated date/time
    @Column(name = "completed_at", nullable = false)
    private LocalDateTime completedAt;

    // Actual hardcopy signature remains on printed permit
    @Column(name = "signature_required", nullable = false)
    private Boolean signatureRequired = true;

    // Contractor supervisor details
    @Column(name = "contractor_supervisor_name")
    private String contractorSupervisorName;

    @Column(name = "contractor_supervisor_signature_required")
    private Boolean contractorSupervisorSignatureRequired = false;

    @Column(name = "contractor_supervisor_completed_at")
    private LocalDateTime contractorSupervisorCompletedAt;
}