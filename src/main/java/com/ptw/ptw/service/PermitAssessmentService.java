package com.ptw.ptw.service;

import com.ptw.ptw.dto.PermitAssessmentRequest;
import com.ptw.ptw.dto.PermitResponse;

public interface PermitAssessmentService {

    PermitResponse saveAssessment(Long permitId, PermitAssessmentRequest request,
            String username);
}
