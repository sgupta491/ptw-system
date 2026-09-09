package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
        name = "permit_type_hazard"
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermitTypeHazard {

    @EmbeddedId
    private PermitTypeHazardId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("permitTypeId")
    @JoinColumn(name = "permit_type_id")
    private PermitType permitType;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("hazardId")
    @JoinColumn(name = "hazard_id")
    private HazardMaster hazard;
}