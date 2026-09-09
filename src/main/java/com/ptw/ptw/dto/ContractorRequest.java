package com.ptw.ptw.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ContractorRequest {

    @NotBlank(message = "Contractor code is required")
    private String contractorCode;

    @NotBlank(message = "Contractor name is required")
    private String contractorName;

    private String contactPerson;

    private String contactNumber;

    @Email(message = "Enter a valid email")
    private String email;
}
