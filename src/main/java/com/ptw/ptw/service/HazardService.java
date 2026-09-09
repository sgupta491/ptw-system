package com.ptw.ptw.service;


import com.ptw.ptw.dto.HazardOption;

import java.util.List;

public interface HazardService {

    List<HazardOption> findByPermitType(Long permitTypeId);
}
