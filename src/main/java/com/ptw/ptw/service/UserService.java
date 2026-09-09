package com.ptw.ptw.service;

import com.ptw.ptw.entity.User;

import java.util.List;

public interface UserService {

    User findByUsername(String username);

    List<User> findActiveByDepartment(Long departmentId);
}
