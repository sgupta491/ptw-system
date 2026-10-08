package com.ptw.ptw.repository;

import com.ptw.ptw.entity.WorkRequestTradeMaster;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WorkRequestTradeMasterRepository extends JpaRepository<WorkRequestTradeMaster, Long> {

    List<WorkRequestTradeMaster> findByActiveTrueOrderByTradeNameAsc();
}
