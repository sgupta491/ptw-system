package com.ptw.ptw.dto;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitSectionBRequest {

    private String equipmentNumber;
    private String location;
    private String proposedWorkInDetail;

    private Boolean contractorDeployed;
    private Long contractorId;
    private String contractorSupervisor;

    private Boolean liftShiftByEquipment;
    private Boolean hazardousChemicalExposure;
    private String otherHazardActivity;

    private LocalDate validOnDate;
    private LocalTime timeFrom;
    private LocalTime timeTo;
}