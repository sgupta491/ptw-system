package com.ptw.ptw.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChecklistFieldOption {

    private Long id;

    private String fieldCode;

    private String fieldLabel;

    private String fieldType;

    private Boolean required;

    private Integer displayOrder;
}