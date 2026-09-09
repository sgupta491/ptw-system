package com.ptw.ptw.repository;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.PermitWorkCompletion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface PermitWorkCompletionRepository extends JpaRepository<PermitWorkCompletion, Long> {

    Optional<PermitWorkCompletion> findByPermit(Permit permit);

    boolean existsByPermit(Permit permit);
}
