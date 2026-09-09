package com.ptw.ptw.service.impl;

import com.ptw.ptw.entity.User;
import com.ptw.ptw.repository.UserRepository;
import com.ptw.ptw.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;


    @Override
    public User findByUsername(String username) {

        return userRepository.findByUsername(username)
                .orElseThrow(()-> new RuntimeException("Username not found: " + username));
    }

    @Override
    public List<User> findActiveByDepartment(Long departmentId) {
        return userRepository.findByDepartmentIdAndActiveTrue(departmentId);
    }
}
