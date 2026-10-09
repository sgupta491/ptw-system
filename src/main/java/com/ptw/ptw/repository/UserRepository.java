package com.ptw.ptw.repository;

import com.ptw.ptw.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {


    @Query("SELECT u FROM User u JOIN FETCH u.role WHERE u.username = :username")
    Optional<User> findByUsername(@Param("username") String username);

    Optional<User> findByEmail(String email);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    List<User> findByDepartmentIdAndActiveTrue(Long departmentId);

    @Query("""
       SELECT u FROM User u LEFT JOIN FETCH u.department WHERE u.username = :username
       """)
    Optional<User> findByUsernameWithDepartment(@Param("username") String username);

    List<User> findByRole_RoleNameAndActiveTrue(String roleName);
}
