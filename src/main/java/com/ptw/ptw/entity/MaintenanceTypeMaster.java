package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "maintenance_type_master", uniqueConstraints = {
        @UniqueConstraint(name = "uk_maintenance_type_code",columnNames = "maintenance_code"),
        @UniqueConstraint(name = "uk_maintenance_type_name", columnNames = "maintenance_name")}
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MaintenanceTypeMaster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "maintenance_code", nullable = false, length = 50)
    private String maintenanceCode;

    @Column(name = "maintenance_name", nullable = false, length = 100)
    private String maintenanceName;

    @Builder.Default
    @Column(name = "active", nullable = false)
    private Boolean active = true;
}