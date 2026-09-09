package com.ptw.ptw.entity;

import com.ptw.ptw.enums.PermitStatus;
import com.ptw.ptw.enums.PermitWorkflowAction;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "permit_workflow_history")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PermitWorkflowHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "permit_id", nullable = false)
    private Permit permit;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "action_by", nullable = false)
    private User actionBy;

    @Enumerated(EnumType.STRING)
    @Column(name="action" , nullable = false)
    private PermitWorkflowAction action;

    @Enumerated(EnumType.STRING)
    @JoinColumn(name="status_after_action", nullable = false)
    private PermitStatus statusAfterAction;

    @Column(name="stage", nullable = false)
    private String stage;

    @Column(name="remarks", nullable = false)
    private String remarks;

    @Column(name="action_date_time")
    private LocalDateTime actionDateTime;

}

