package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="hazard_master",  uniqueConstraints
        = {@UniqueConstraint(name="uk_hazard_code", columnNames = "hazard_code")})
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class HazardMaster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name="hazard_code", nullable = false, unique = true)
    private String hazardCode;

    @Column(name="hazard_name", nullable = false)
    private String hazardName;

    @Column(name = "hazard_category", nullable = false)
    private String hazardCategory;

    @Column(name="display_order", nullable = false)
    private Integer displayOrder;

    @Column(nullable = false)
    private Boolean active;
}
