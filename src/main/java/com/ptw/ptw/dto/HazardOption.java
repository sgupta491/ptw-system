package com.ptw.ptw.dto;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class HazardOption {

    private Long id;

    private String hazardCode;

    private String hazardName;

    private String hazardCategory;

    private Integer displayOrder;
}
