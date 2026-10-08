package com.ptw.ptw.repository;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.WorkRequest;
import com.ptw.ptw.enums.WorkRequestStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WorkRequestRepository extends JpaRepository<WorkRequest, Long> {

    Optional<WorkRequest> findByPermit(Permit permit);

    Optional<WorkRequest> findByWoNumber(String woNumber);

    boolean existsByPermit(Permit permit);

    List<WorkRequest> findByStatusOrderByIdDesc(WorkRequestStatus status);

    List<WorkRequest> findAllByOrderByIdDesc();
}