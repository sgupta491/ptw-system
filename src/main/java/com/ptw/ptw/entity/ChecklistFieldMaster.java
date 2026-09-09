package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "checklist_field_master")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChecklistFieldMaster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "checklist_id", nullable = false)
    private ChecklistMaster checklist;

    @Column(name = "field_code", nullable = false,length = 50)
    private String fieldCode;

    @Column(name = "field_label", nullable = false)
    private String fieldLabel;

    @Column(name = "field_type", nullable = false, length = 30)
    private String fieldType;

    @Column(name = "required", nullable = false)
    private Boolean required;

    @Column(name = "display_order",nullable = false)
    private Integer displayOrder;

    @Column( name = "active", nullable = false)
    private Boolean active;
}