package com.ptw.ptw.repository;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.PermitDocument;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PermitDocumentRepository extends JpaRepository<PermitDocument, Long> {

    List<PermitDocument> findByPermit(Permit permit);

    boolean existsByPermitAndDocumentType(Permit permit, String documentType);
}