package com.ptw.ptw.repository;

import com.ptw.ptw.entity.PermitChecklistResponse;
import com.ptw.ptw.entity.PermitChecklistResponseField;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PermitChecklistResponseFieldRepository extends JpaRepository<PermitChecklistResponseField, Long> {

    void deleteByResponse(PermitChecklistResponse response);

    List<PermitChecklistResponseField> findByResponse(
            PermitChecklistResponse response
    );
}
