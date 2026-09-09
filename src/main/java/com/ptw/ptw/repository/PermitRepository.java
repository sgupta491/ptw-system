package com.ptw.ptw.repository;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.PermitWorkflowHistory;
import com.ptw.ptw.enums.PermitStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PermitRepository extends JpaRepository<Permit, Long> {

    Optional<Permit> findByPermitNumber(String permitNumber);

    boolean existsByPermitNumber(String permitNumber);

    List<Permit> findByIssuerId(Long issuerId);

    List<Permit> findByPermitStatus(PermitStatus permitStatus);

    List<Permit> findByAcceptorIdAndPermitStatus(Long acceptorId, PermitStatus permitStatus);

    List<Permit> findByAcceptorIdAndPermitStatusIn(Long acceptorId,List<PermitStatus> statuses);

    List<Permit> findByIssuerIdAndPermitStatus(Long issuerId, PermitStatus permitStatus);

    List<Permit> findByIssuerIdOrderByIdDesc(Long issuerId);


}
