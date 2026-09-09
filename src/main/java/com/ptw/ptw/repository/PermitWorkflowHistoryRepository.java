package com.ptw.ptw.repository;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.PermitWorkflowHistory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PermitWorkflowHistoryRepository extends JpaRepository<PermitWorkflowHistory, Long> {

    List<PermitWorkflowHistory> findByPermitOrderByActionDateTimeAsc(Permit permit);

    List<PermitWorkflowHistory>findByPermitOrderByActionDateTimeDesc(Permit permit);
}
