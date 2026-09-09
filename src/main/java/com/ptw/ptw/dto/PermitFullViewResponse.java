package com.ptw.ptw.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitFullViewResponse {

    // Basic + A + B
    private PermitResponse permit;

    // C
    private List<HazardOption> hazards;
    private String otherHazards;
    private String relatedPermitNumber;

    // D
    private List<ChecklistApprovalResponse> checklistResponses;

    // E
    private List<PostWorkMeasureResponse> postWorkMeasures;

    // F
    private LocalDateTime issuerApprovalDateTime;

    // H
    private WorkCompletionViewResponse workCompletion;

    // I
    private FinalVerificationViewResponse finalVerification;

    // Uploaded documents
    private List<PermitDocumentViewResponse> documents;
}