package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;


@Entity
@Table(name = "roles")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "role_name", nullable = false, unique = true)
    private String roleName;

    @Column(length = 255)
    private String description;

    @Column(nullable = false)
    private Boolean active = true;


}
