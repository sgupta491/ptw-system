package com.ptw.ptw.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FinalVerificationViewResponse {

    private String verifiedBy;

    private LocalDateTime verifiedAt;

    private String remarks;

    private boolean signatureRequired;
}