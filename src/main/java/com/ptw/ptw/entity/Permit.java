package com.ptw.ptw.entity;


import com.ptw.ptw.enums.ElectricalIsolationStatus;
import com.ptw.ptw.enums.PermitStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "permits",
uniqueConstraints = {@UniqueConstraint( name = "uk_permit_number", columnNames = "permit_number")})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Permit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "permit_number", nullable = false, unique = true)
    private String permitNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "permit_type_id", nullable = false)
    private PermitType permitType;

    /*
     * Section A
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "issuer_department_id")
    private Department issuerDepartment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name ="issuer_user_id")
    private User issuer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "acceptor_department_id")
    private Department acceptorDepartment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_acceptor_id")
    private User acceptor;

    @Builder.Default
    @Column(name = "contractor_deployed", nullable = false)
    private Boolean contractorDeployed = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contractor_id")
    private Contractor contractor;

    @Column(name = "contractor_supervisor")
    private String contractorSupervisor;

    @Column(name = "proposed_work", columnDefinition = "TEXT")
    private String proposedWork;

    /*
     * Section B
     */

    @Column(name = "equipment_number")
    private String equipmentNumber;

    @Column(name= "location")
    private String location;

    @Column(name = "proposed_work_in_detail", columnDefinition = "TEXT")
    private String proposedWorkInDetail;

    @Column(name = "lift_shift_by_equipment")
    private Boolean liftShiftByEquipment;

    @Column(name = "hazardous_chemical_exposure")
    private Boolean hazardousChemicalExposure;

    @Column( name = "other_hazard_activity", columnDefinition = "TEXT" )
    private String otherHazardActivity;

    @Column(name = "valid_on_date")
    private LocalDate validOnDate;

    @Column(name = "time_from")
    private LocalTime timeFrom;

    @Column(name = "time_to")
    private LocalTime timeTo;


    /*
     * Workflow
     */

    @Enumerated(EnumType.STRING)
    @Column(name = "permit_status", nullable = false)
    private PermitStatus permitStatus;

    @Column(name = "current_stage")
    private String currentStage;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by", nullable = false)
    private User createdBy;

    @Column(name = "other_hazards",columnDefinition = "TEXT")
    private String otherHazards;

    @Column(name = "related_permit_number",length = 100)
    private String relatedPermitNumber;

    @Column(name = "electrical_isolation_required")
    private Boolean electricalIsolationRequired = false;

    @Enumerated(EnumType.STRING)
    @Column(name = "electrical_isolation_status")
    private ElectricalIsolationStatus electricalIsolationStatus;

    @Column(name = "issuer_approval_date_time")
    private LocalDateTime issuerApprovalDateTime;

    @Column(name = "original_permit_number")
    private String originalPermitNumber;

    @Column(name = "original_valid_till")
    private LocalDateTime originalValidTill;

    @Column(name = "valid_till")
    private LocalDateTime validTill;

    @Column(name = "closed_at")
    private LocalDateTime closedAt;

    @Builder.Default
    @Column(name = "extension_used", nullable = false)
    private Boolean extensionUsed = false;

    @Builder.Default
    @Column(name = "extension_request_used", nullable = false)
    private Boolean extensionRequestUsed = false;

    @Builder.Default
    @Column(name = "extension_accepted", nullable = false)
    private Boolean extensionAccepted = false;

}
