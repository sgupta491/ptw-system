package com.ptw.ptw.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitCreationRequest {

    private Long permitTypeId;

    private Long acceptorDepartmentId;
    private Long acceptorId;

    private String proposedWork;
}