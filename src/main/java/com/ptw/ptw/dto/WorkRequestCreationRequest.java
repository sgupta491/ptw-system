package com.ptw.ptw.dto;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkRequestCreationRequest {

    private LocalDate requestDate;

    private LocalTime requestTime;

    private String workLocation;

    private Long workToBeDoneById;

    private Long maintenanceTypeId;

    private String equipmentNumber;

    private String equipmentLocation;

    private String jobDescription;

    private String recommendedPpe;
}