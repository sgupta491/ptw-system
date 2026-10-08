package com.ptw.ptw.service;

import com.ptw.ptw.dto.WorkRequestCompletionRequest;
import com.ptw.ptw.dto.WorkRequestCreationRequest;
import com.ptw.ptw.dto.WorkRequestResponse;

import java.util.List;

public interface WorkRequestService {

    WorkRequestResponse createWorkRequest(Long permitId, WorkRequestCreationRequest request, String username);

    WorkRequestResponse getWorkRequestForIssuer(Long permitId, String username);

    List<WorkRequestResponse> findPendingWorkRequests(String username);

    WorkRequestResponse getWorkRequestForMaintenance(Long workRequestId, String username);

    WorkRequestResponse completeWorkRequest(Long workRequestId,WorkRequestCompletionRequest request, String username);
}