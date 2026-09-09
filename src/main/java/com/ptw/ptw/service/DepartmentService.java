package com.ptw.ptw.service;

import com.ptw.ptw.entity.Department;

import java.util.List;

public interface DepartmentService {

    List<Department> findAll();
    List<Department> findActive();
    Department findById(Long id);
}
