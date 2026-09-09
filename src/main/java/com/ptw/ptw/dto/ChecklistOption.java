package com.ptw.ptw.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChecklistOption {

    private Long id;

    private String questionCode;

    private String questionText;

    private String section;

    private String itemType;

    private Integer displayOrder;

    private List<ChecklistFieldOption> fields;
}