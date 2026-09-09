package com.ptw.ptw.dto;

import com.ptw.ptw.entity.User;
import com.ptw.ptw.enums.PermitStatus;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PermitRequest {

    @NotNull(message = "Permit type is required")
    private Long permitTypeId;

    //private Long issuerDepartmentId;

    private Long acceptorDepartmentId;

    private Long acceptorId;

    @NotNull(message = "Please select whether contractor is deployed")
    private Boolean contractorDeployed;

    private Long contractorId;

    private String contractorSupervisor;

    private String equipmentNumber;

    private String location;

    private String proposedWork;

    private Boolean liftShiftByEquipment;

    private Boolean hazardousChemicalExposure;

    private String otherHazardActivity;

    @DateTimeFormat(pattern = "dd-MM-yyyy")
    private LocalDate validOnDate;

    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime timeFrom;

    @DateTimeFormat(pattern = "HH:mm")
    private LocalTime timeTo;

    /*
     * Section C
     */

    private List<Long> hazardIds;

    private String otherHazards;

    private String relatedPermitNumber;

}
