package com.ptw.ptw.dto;

import com.ptw.ptw.enums.WorkRequestStatus;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkRequestResponse {

    // WORK ORDER

    private Long id;

    private String woNumber;

    // PERMIT

    private Long permitId;

    private String permitNumber;

    // REQUESTER

    private String requestingDepartment;

    private String requesterName;

    private String requesterContactNumber;

    private LocalDate requestDate;

    private LocalTime requestTime;

    // WORK REQUEST

    private String workLocation;

    private Long workToBeDoneById;

    private String workToBeDoneBy;

    private Long maintenanceTypeId;

    private String maintenanceType;

    private String equipmentNumber;

    private String equipmentLocation;

    private String jobDescription;

    private String recommendedPpe;

    // MAINTENANCE

    private Long workAssignedToId;

    private String workAssignedTo;

    private String assignedName;

    private LocalDateTime workStartedAt;

    private String isolationEquipmentNumber;

    private String feederNumber;

    private String lotoNumber;

    private String workCompletedBy;

    private LocalDateTime completedAt;

    // STATUS

    private WorkRequestStatus status;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}