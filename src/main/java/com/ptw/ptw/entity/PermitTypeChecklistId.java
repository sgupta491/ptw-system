package com.ptw.ptw.entity;

import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serializable;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class PermitTypeChecklistId implements Serializable {

    private Long permitTypeId;

    private Long checklistId;
}