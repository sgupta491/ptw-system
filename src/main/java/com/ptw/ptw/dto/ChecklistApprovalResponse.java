package com.ptw.ptw.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChecklistApprovalResponse {

    private Long checklistId;
    private String questionCode;
    private String questionText;
    private String response;

    private String measureImplementedBy;
    private LocalDateTime measureImplementedAt;

    private Map<String, String> fieldValues;
}