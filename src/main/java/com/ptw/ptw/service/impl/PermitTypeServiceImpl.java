package com.ptw.ptw.service.impl;

import com.ptw.ptw.dto.PermitTypeRequest;
import com.ptw.ptw.entity.PermitType;
import com.ptw.ptw.repository.PermitTypeRepository;
import com.ptw.ptw.service.PermitTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PermitTypeServiceImpl implements PermitTypeService {

    private final PermitTypeRepository permitTypeRepository;

    @Override
    public List<PermitType> findAll() {
        return permitTypeRepository.findAll();
    }

    @Override
    public List<PermitType> findActive() {
        return permitTypeRepository.findAll()
                .stream()
                .filter(PermitType ::getActive)
                .toList();
    }

    @Override
    public PermitType findById(Long id) {
        return permitTypeRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("PermitType not found:" +id));
    }

    @Override
    public PermitType save(PermitTypeRequest request) {
         if(permitTypeRepository.existsByPermitCode(request.getPermitCode())) {

             throw new RuntimeException("PermitType already exists");
         }

         PermitType permitType = PermitType.builder()
                 .permitCode(request.getPermitCode())
                 .permitCode(request.getPermitCode())
                 .description(request.getDescription())
                 .active(true)
                 .build();

         return permitTypeRepository.save(permitType);
    }

    @Override
    public PermitType update(Long id, PermitTypeRequest request) {

        PermitType permitType = findById(id);

        permitType.setPermitCode(request.getPermitCode());
        permitType.setPermitName(request.getPermitName());
        permitType.setDescription(request.getDescription());


        return permitTypeRepository.save(permitType);
    }

    @Override
    public void deactivate(Long id) {

        PermitType permitType = findById(id);
        permitType.setActive(false);
        permitTypeRepository.save(permitType);
    }
}
