package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table( name = "permit_checklist_response_field")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitChecklistResponseField {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "response_id",nullable = false)
    private PermitChecklistResponse response;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn( name = "field_id",nullable = false )
    private ChecklistFieldMaster field;

    @Column(name = "field_code", nullable = false, length = 50)
    private String fieldCode;

    @Column(name = "field_label", nullable = false)
    private String fieldLabel;


    @Column(name = "field_value",columnDefinition = "TEXT")
    private String fieldValue;
}