package com.ptw.ptw.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkRequestCompletionRequest {

    private Long workAssignedToId;

    private String assignedName;

    private LocalDateTime workStartedAt;

    private String isolationEquipmentNumber;

    private String feederNumber;

    private String lotoNumber;

    private String workCompletedBy;

    private LocalDateTime completedAt;
}