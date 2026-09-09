package com.ptw.ptw.repository;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.PermitFinalVerification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PermitFinalVerificationRepository extends JpaRepository<PermitFinalVerification, Long> {

    Optional<PermitFinalVerification> findByPermit(Permit permit);

    boolean existsByPermit(Permit permit);
}