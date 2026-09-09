package com.ptw.ptw.repository;

import com.ptw.ptw.entity.ChecklistFieldMaster;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ChecklistFieldMasterRepository extends JpaRepository<ChecklistFieldMaster, Long> {

    List<ChecklistFieldMaster> findByChecklist_IdAndActiveTrueOrderByDisplayOrderAsc(Long checklistId);
}
