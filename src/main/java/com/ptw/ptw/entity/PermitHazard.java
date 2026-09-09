package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "permit_hazard", uniqueConstraints = {@UniqueConstraint(
        name = "uk_permit_hazard",
        columnNames = {"permit_id", "hazard_id"})})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitHazard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "permit_id",nullable = false)
    private Permit permit;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn( name = "hazard_id", nullable = false)
    private HazardMaster hazard;
}