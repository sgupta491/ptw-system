package com.ptw.ptw.repository;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.PermitChecklistResponse;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PermitChecklistResponseRepository extends JpaRepository<PermitChecklistResponse, Long> {

    List<PermitChecklistResponse>findByPermit(Permit permit);

    void deleteByPermit(Permit permit);
}
