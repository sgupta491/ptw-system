package com.ptw.ptw.repository;

import com.ptw.ptw.entity.MaintenanceTypeMaster;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface MaintenanceTypeMasterRepository extends CrudRepository<MaintenanceTypeMaster, Long> {

    List<MaintenanceTypeMaster> findByActiveTrueOrderByMaintenanceNameAsc();
}
