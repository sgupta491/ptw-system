package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "permit_types")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "permit_code", nullable = false, unique = true)
    private String permitCode;

    @Column(name = "permit_name", nullable = false)
    private String permitName;

    @Column(length = 500)
    private String description;

    @Column(nullable = false)
    private Boolean active = true;
}