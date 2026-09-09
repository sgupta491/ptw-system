package com.ptw.ptw.service;

import com.ptw.ptw.dto.AcceptorReviewRequest;
import com.ptw.ptw.dto.PermitRequest;
import com.ptw.ptw.dto.PermitResponse;

import java.util.List;

public interface AcceptorPermitService {

    List<PermitResponse> findPendingPermits(String username);
    PermitResponse findPermitForAcceptor(Long permitId, String username);
    PermitResponse reviewPermit(Long permitId, AcceptorReviewRequest request, String username);

}
