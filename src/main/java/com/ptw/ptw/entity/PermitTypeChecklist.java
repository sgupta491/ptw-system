package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
        name = "permit_type_checklist"
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitTypeChecklist {

    @EmbeddedId
    private PermitTypeChecklistId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("permitTypeId")
    @JoinColumn(name = "permit_type_id")
    private PermitType permitType;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("checklistId")
    @JoinColumn(name = "checklist_id")
    private ChecklistMaster checklist;

    @Column(name = "display_order",nullable = false)
    private Integer displayOrder;
}