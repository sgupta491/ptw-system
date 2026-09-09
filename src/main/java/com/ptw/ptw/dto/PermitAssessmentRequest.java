package com.ptw.ptw.dto;

import lombok.*;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitAssessmentRequest {

    private List<Long> hazardIds;

    private String otherHazards;

    private String relatedPermitNumber;

    private Boolean electricalIsolationRequired;

    private Map<Long, ChecklistResponseRequest>
            checklistResponses;

    private List<PostWorkMeasureRequest>
            postWorkMeasures;
}
