package com.ptw.ptw.repository;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.PermitPostWorkMeasure;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PermitPostWorkMeasureRepository extends JpaRepository<PermitPostWorkMeasure, Long> {

    List<PermitPostWorkMeasure> findByPermitOrderByIdAsc(Permit permit);
    List<PermitPostWorkMeasure> findByPermit(Permit permit);
    void deleteByPermit(Permit permit);
}
