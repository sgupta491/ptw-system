package com.ptw.ptw.service;

import com.ptw.ptw.dto.ChecklistOption;

import java.util.List;

public interface ChecklistService {

    List<ChecklistOption> findByPermitType(Long permitTypeId);
}
