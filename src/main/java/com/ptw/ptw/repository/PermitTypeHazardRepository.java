package com.ptw.ptw.repository;

import com.ptw.ptw.entity.PermitTypeHazard;
import com.ptw.ptw.entity.PermitTypeHazardId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PermitTypeHazardRepository extends JpaRepository<PermitTypeHazard, PermitTypeHazardId> {

    List<PermitTypeHazard> findByPermitType_Id(Long permitTypeId);
}
