package com.ptw.ptw.dto;

import com.ptw.ptw.enums.PermitStatus;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PermitResponse {

    private Long id;

    private String permitNumber;

    private Long permitTypeId;

    private String permitType;

    private String issuerName;

    private String issuerDepartment;

    private String acceptorName;

    private String acceptorDepartment;

    private Boolean contractorDeployed;

    private String contractorName;

    private String contractorSupervisor;

    private String equipmentNumber;

    private String location;

    private String proposedWork;

    private String proposedWorkInDetail;

    private Boolean liftShiftByEquipment;

    private Boolean hazardousChemicalExposure;

    private String otherHazardActivity;

    @DateTimeFormat(pattern = "dd-MM-yyyy")
    private LocalDate validOnDate;

    public String getFormattedValidOnDate() {
        if (validOnDate == null) {return "";}
        return validOnDate.format(DateTimeFormatter.ofPattern("dd-MM-yyyy"));
    }

    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime timeFrom;

    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime timeTo;

    private PermitStatus status;

    private String currentStage;

    private Boolean extensionRequestUsed;
    private Boolean extensionUsed;
    private Boolean extensionAccepted;

    private String displayPermitNumber;

    private LocalDateTime validTill;

    private String validTillFormatted;
}
