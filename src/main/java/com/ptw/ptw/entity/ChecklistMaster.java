package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="checklist_master")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChecklistMaster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "question_code", nullable = false, unique = true, length = 50)
    private String questionCode;

    @Column(name = "question_text", nullable = false,columnDefinition = "TEXT")
    private String questionText;

    @Column(name = "section", nullable = false,length = 10)
    private String section;

    @Column(name = "active", nullable = false)
    private Boolean active;

    @Column(name = "display_order",nullable = false)
    private Integer displayOrder;

    @Column(name = "item_type", nullable = false,length = 20)
    private String itemType;
}


