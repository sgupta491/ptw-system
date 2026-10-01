package com.ptw.ptw.service;

import com.ptw.ptw.dto.*;
import com.ptw.ptw.entity.Permit;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface PermitService {

    PermitResponse createPermit(PermitCreationRequest  permitRequest, String username);
    PermitResponse findPermitById(Long id);
    List<PermitResponse> findMyPermits(String username);
    List<PermitResponse> findPermitsByIssuer(String username);
    PermitResponse getPermitForAssessment(Long permitId, String username);

    PermitResponse approvePermitForPrint(Long permitId, String username);

    PermitApprovalResponse getPermitForPrint(Long permitId,String username);

    PermitResponse markWorkCompleted(Long permitId, String username);

    PermitFullViewResponse getFullPermitView(Long permitId, String username);

    Resource getPermitDocument(Long permitId,Long documentId,String username);

    PermitResponse acceptExtension(Long permitId, String username);

    PermitResponse rejectExtension(Long permitId,  String rejectionRemark, String username);

    PermitResponse getPermitForExtensionPrint(Long permitId,String username);

    PermitResponse printExtensionForm(Long permitId, String username);
}
