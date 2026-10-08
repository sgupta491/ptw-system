package com.ptw.ptw.entity;

import com.ptw.ptw.enums.WorkRequestStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "work_requests", uniqueConstraints = {
       @UniqueConstraint(name = "uk_work_request_wo_number",columnNames = "wo_number"),
        @UniqueConstraint(name = "uk_work_request_permit", columnNames = "permit_id")},
        indexes = {@Index(name = "idx_work_request_status", columnList = "status"),
                @Index(name = "idx_work_request_department", columnList = "requesting_department_id"),
                @Index(name = "idx_work_request_trade",columnList = "work_to_be_done_by_id"),
                @Index(name = "idx_work_request_maintenance_type", columnList = "maintenance_type_id")}
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "wo_number", nullable = false, length = 50)
    private String woNumber;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "permit_id", nullable = false, unique = true)
    private Permit permit;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "requesting_department_id",nullable = false)
    private Department requestingDepartment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn( name = "requester_user_id", nullable = false)
    private User requester;

    @Column(name = "request_date", nullable = false)
    private LocalDate requestDate;

    @Column(name = "request_time", nullable = false)
    private LocalTime requestTime;

    @Column(name = "work_location", nullable = false, length = 255)
    private String workLocation;

    @Column(name = "requester_contact_number", length = 30)
    private String requesterContactNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "work_to_be_done_by_id",nullable = false)
    private WorkRequestTradeMaster workToBeDoneBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "maintenance_type_id", nullable = false)
    private MaintenanceTypeMaster maintenanceType;

    @Column(name = "equipment_number", length = 100)
    private String equipmentNumber;

    @Column(name = "equipment_location", length = 255)
    private String equipmentLocation;

    @Column(name = "job_description", columnDefinition = "TEXT")
    private String jobDescription;

    @Column(name = "recommended_ppe", columnDefinition = "TEXT")
    private String recommendedPpe;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "work_assigned_to_id")
    private WorkRequestTradeMaster workAssignedTo;

    @Column(name = "assigned_name", length = 150)
    private String assignedName;

    @Column(name = "work_started_at")
    private LocalDateTime workStartedAt;

    @Column(name = "isolation_equipment_number", length = 100)
    private String isolationEquipmentNumber;

    @Column(name = "feeder_number", length = 100)
    private String feederNumber;

    @Column(name = "loto_number", length = 100)
    private String lotoNumber;

    @Column(name = "work_completed_by", length = 150)
    private String workCompletedBy;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 30)
    @Builder.Default
    private WorkRequestStatus status = WorkRequestStatus.PENDING;

    // ==============================
    // AUDIT
    // ==============================

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();
}