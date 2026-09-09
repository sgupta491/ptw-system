package com.ptw.ptw.repository;

import com.ptw.ptw.entity.PermitType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface PermitTypeRepository extends JpaRepository<PermitType, Long> {

    Optional<PermitType> findByPermitCode(String permitCode);
    boolean existsByPermitCode(String permitCode);
}
