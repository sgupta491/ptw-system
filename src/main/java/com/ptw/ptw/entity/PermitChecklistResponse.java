package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "permit_checklist_response",uniqueConstraints = {
        @UniqueConstraint(name = "uk_permit_checklist",
                columnNames = {"permit_id","checklist_id"
                })})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitChecklistResponse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="permit_id", nullable=false)
    private Permit permit;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "checklist_id",nullable = false)
    private ChecklistMaster checklist;

    @Column(name = "question_code",nullable = false)
    private String questionCode;

    @Column(name = "question_text",nullable = false, columnDefinition = "TEXT")
    private String questionText;

    @Column(name = "response",length = 10)
    private String response;

    /*
     * Issuer who implemented the measure
     */

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "measure_implemented_by")
    private User measureImplementedBy;

    @Column(name = "measure_implemented_at")
    private LocalDateTime measureImplementedAt;

    /*
     * Later, during lifting of measures
     */

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "measure_lifted_by")
    private User measureLiftedBy;

    @Column(name = "measure_lifted_at")
    private LocalDateTime measureLiftedAt;

}
