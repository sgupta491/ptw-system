package com.ptw.ptw.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PostWorkMeasureResponse {

    private String itemCode;
    private String itemText;
    private String response;
    private String otherText;

    private String answeredBy;
    private LocalDateTime answeredAt;
}