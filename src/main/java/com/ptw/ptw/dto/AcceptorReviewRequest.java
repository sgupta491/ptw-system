package com.ptw.ptw.dto;

import com.ptw.ptw.enums.PermitWorkflowAction;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AcceptorReviewRequest {

    @NotNull(message = "Action is required")
    private PermitWorkflowAction action;

    private String remarks;
}
