package com.ptw.ptw.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PostWorkMeasureRequest {

    private String itemCode;

    private String response;

    private String otherText;
}