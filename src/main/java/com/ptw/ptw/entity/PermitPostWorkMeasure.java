package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "permit_post_work_measure")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitPostWorkMeasure {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "permit_id",nullable = false)
    private Permit permit;


    @Column(name = "item_code", nullable = false,length = 20)
    private String itemCode;

    @Column(name = "item_text", nullable = false, columnDefinition = "TEXT")
    private String itemText;

    @Column(name = "response", length = 10)
    private String response;

    @Column(name = "other_text", columnDefinition = "TEXT")
    private String otherText;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "answered_by")
    private User answeredBy;


    @Column( name = "answered_at")
    private LocalDateTime answeredAt;
}