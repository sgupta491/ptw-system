package com.ptw.ptw.repository;

import com.ptw.ptw.entity.Contractor;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ContractorRepository extends JpaRepository<Contractor, Long> {

    Optional<Contractor> findByContractorCode(String contractorCode);

    boolean existsByContractorCode(String contractorCode);
}
