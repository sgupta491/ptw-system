package com.ptw.ptw.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitDocumentViewResponse {

    private Long id;

    private String documentType;

    private String originalFileName;

    private String contentType;

    private String uploadedBy;

    private LocalDateTime uploadedAt;
}