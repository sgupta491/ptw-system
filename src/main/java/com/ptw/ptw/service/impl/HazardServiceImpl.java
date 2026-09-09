package com.ptw.ptw.service.impl;

import com.ptw.ptw.dto.HazardOption;
import com.ptw.ptw.entity.PermitTypeHazard;
import com.ptw.ptw.repository.PermitTypeHazardRepository;
import com.ptw.ptw.service.HazardService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor()
public class HazardServiceImpl implements HazardService {

    private final PermitTypeHazardRepository permitTypeHazardRepository;

    @Override
    public List<HazardOption> findByPermitType(Long permitTypeId) {

        return permitTypeHazardRepository.findByPermitType_Id(permitTypeId)
                .stream()
                .map(PermitTypeHazard::getHazard)
                .filter(hazard-> Boolean.TRUE.equals(hazard.getActive()))
                .sorted(java.util.Comparator.comparing(hazard->hazard.getDisplayOrder()))
                .map(hazard->HazardOption.builder()
                        .id(hazard.getId())
                        .hazardCode(hazard.getHazardCode())
                        .hazardName(hazard.getHazardName())
                        .hazardCategory(hazard.getHazardCategory())
                        .displayOrder(hazard.getDisplayOrder())
                        .build())
                .toList();
    }
}
