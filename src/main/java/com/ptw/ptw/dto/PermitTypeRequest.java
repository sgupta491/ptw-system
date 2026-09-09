package com.ptw.ptw.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PermitTypeRequest {

    @NotBlank(message = "Permit code is required")
    private String permitCode;

    @NotBlank(message = "Permit name is required")
    private String permitName;

    private String description;
}
