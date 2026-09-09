package com.ptw.ptw.service;

import com.ptw.ptw.dto.*;
import com.ptw.ptw.entity.Permit;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface PermitService {

    PermitResponse createPermit(PermitRequest permitRequest, String username);

    PermitResponse submitPermit(Long permitId, String username);

    PermitResponse findPermitById(Long id);

    List<PermitResponse> findMyPermits(String username);

    List<PermitResponse> findReturnedPermits(String username);

    PermitResponse findReturnedPermit(Long id, String username);

    PermitResponse resubmitReturnedPermit(Long permitId, PermitRequest permitRequest, String username);

    PermitRequest getReturnedPermitForEdit(Long permitId, String username);

    String getLatestReturnRemarks(Long permitId,String username);

    List<PermitResponse> findPermitsByIssuer(String username);

    PermitResponse getPermitForAssessment(Long permitId, String username);

    PermitApprovalResponse getPermitForIssuerApproval(Long permitId, String username);

    PermitResponse approvePermitForPrint(Long permitId, String username);

    PermitApprovalResponse getPermitForPrint(Long permitId,String username);

    PermitResponse getPermitForAcceptance(Long permitId, String username);
    PermitResponse acceptPermitAndStartWork(Long permitId, String username);

    PermitResponse getPermitForWorkCompletion(Long permitId,String username);

    PermitResponse submitWorkCompletion(Long permitId, WorkCompletionRequest request, List<MultipartFile> documents, String username);

    PermitResponse getPermitForFinalVerification(Long permitId,String username);

    PermitResponse completeFinalVerification(Long permitId, FinalVerificationRequest request,String username);
}
