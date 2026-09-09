package com.ptw.ptw.service.impl;

import com.ptw.ptw.dto.ContractorRequest;
import com.ptw.ptw.entity.Contractor;
import com.ptw.ptw.repository.ContractorRepository;
import com.ptw.ptw.service.ContractorService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ContractorServiceImpl implements ContractorService {

    private final ContractorRepository contractorRepository;

    @Override
    public List<Contractor> findAll() {
        return contractorRepository.findAll();
    }

    @Override
    public Contractor findById(Long id) {
        return contractorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException(
                                "Contractor not found: " + id
                        ));
    }

    @Override
    public Contractor save(ContractorRequest request) {

        if (contractorRepository
                .existsByContractorCode(request.getContractorCode())) {
            throw new RuntimeException(
                    "Contractor code already exists"
            );
        }

        Contractor contractor = Contractor.builder()
                .contractorCode(request.getContractorCode())
                .contractorName(request.getContractorName())
                .contactPerson(request.getContactPerson())
                .contactNumber(request.getContactNumber())
                .email(request.getEmail())
                .active(true)
                .build();

        return contractorRepository.save(contractor);
    }

    @Override
    public Contractor update(Long id, ContractorRequest request) {

        Contractor contractor = findById(id);

        contractor.setContractorCode(request.getContractorCode());
        contractor.setContractorName(request.getContractorName());
        contractor.setContactPerson(request.getContactPerson());
        contractor.setContactNumber(request.getContactNumber());
        contractor.setEmail(request.getEmail());

        return contractorRepository.save(contractor);
    }

    @Override
    public void deactivate(Long id) {

        Contractor contractor = findById(id);
        contractor.setActive(false);
        contractorRepository.save(contractor);
    }
}