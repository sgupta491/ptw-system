package com.ptw.ptw.repository;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.PermitHazard;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PermitHazardRepository extends JpaRepository<PermitHazard, Long> {

    List<PermitHazard> findByPermit(Permit permit);
    void deleteByPermit(Permit permit);
}
