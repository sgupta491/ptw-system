package com.ptw.ptw.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitApprovalResponse {

    // A + B
    private PermitResponse permit;

    // Section C
    private List<HazardOption> hazards;
    private String otherHazards;
    private String relatedPermitNumber;

    // Section D
    private List<ChecklistApprovalResponse> checklistResponses;

    // Section E
    private List<PostWorkMeasureResponse> postWorkMeasures;

    // Section F
    private LocalDateTime issuerApprovalDateTime;

}