package com.ptw.ptw.service.impl;

import com.ptw.ptw.entity.Department;
import com.ptw.ptw.repository.DepartmentRepository;
import com.ptw.ptw.service.DepartmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DepartmentServiceImpl implements DepartmentService {

    private final DepartmentRepository departmentRepository;

    @Override
    public List<Department> findAll() {
        return departmentRepository.findAll();
    }

    @Override
    public List<Department> findActive() {
        return departmentRepository.findAll()
                .stream()
                .filter(Department::getActive)
                .toList();
    }

    @Override
    public Department findById(Long id) {

        return departmentRepository.findById(id)
                .orElseThrow(() ->new RuntimeException("Department not found: " + id));
    }
}
