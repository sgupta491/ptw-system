package com.ptw.ptw.service;

import com.ptw.ptw.dto.ContractorRequest;
import com.ptw.ptw.entity.Contractor;

import java.util.List;

public interface ContractorService {

    List<Contractor> findAll();

    Contractor findById(Long id);

    Contractor save(ContractorRequest request);

    Contractor update(Long id, ContractorRequest request);

    void deactivate(Long id);
}
