package com.ptw.ptw.dto;

import lombok.*;

import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChecklistResponseRequest {

    private Long checklistId;

    private String response;

    private Map<Long, String> fieldValues;
}