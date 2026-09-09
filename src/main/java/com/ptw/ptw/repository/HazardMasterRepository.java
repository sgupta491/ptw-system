package com.ptw.ptw.repository;

import com.ptw.ptw.entity.HazardMaster;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HazardMasterRepository extends JpaRepository<HazardMaster, Long> {

    List<HazardMaster> findByActiveTrueOrderByDisplayOrderAsc();

    List<HazardMaster> findByHazardCategoryAndActiveTrueOrderByDisplayOrderAsc(
            String hazardCategory
    );
}
