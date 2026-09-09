package com.ptw.ptw.repository;

import com.ptw.ptw.entity.PermitType;
import com.ptw.ptw.entity.PermitTypeChecklist;
import com.ptw.ptw.entity.PermitTypeChecklistId;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PermitTypeChecklistRepository extends JpaRepository<PermitTypeChecklist, PermitTypeChecklistId> {

    List<PermitTypeChecklist> findByPermitType_IdOrderByDisplayOrderAsc(Long permitTypeId);
}
