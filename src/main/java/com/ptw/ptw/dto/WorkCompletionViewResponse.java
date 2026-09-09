package com.ptw.ptw.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkCompletionViewResponse {

    private String completionResponse;

    private String completedBy;

    private LocalDateTime completedAt;

    private String contractorSupervisorName;

    private boolean signatureRequired;

    private boolean contractorSupervisorSignatureRequired;
}