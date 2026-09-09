package com.ptw.ptw.service;

import com.ptw.ptw.dto.PermitTypeRequest;
import com.ptw.ptw.entity.PermitType;

import java.util.List;

public interface PermitTypeService {

    List<PermitType> findAll();

    List<PermitType> findActive();

    PermitType findById(Long id);

    PermitType save(PermitTypeRequest request);

    PermitType update(Long id, PermitTypeRequest request);

    void deactivate(Long id);
}
