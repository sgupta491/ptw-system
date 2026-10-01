package com.ptw.ptw.service;

import com.ptw.ptw.dto.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface AcceptorPermitService {

    List<PermitResponse> findPendingPermits(String username);

    PermitResponse findPermitForAcceptor(Long permitId, String username);

    PermitResponse submitSectionB(Long permitId,PermitSectionBRequest request,String username);

    List<PermitDocumentViewResponse> getDocuments(Long permitId,String username);

    void uploadDocument(Long permitId, String documentType, MultipartFile file, String username);

    PermitResponse findPermitForDocumentUpload(Long permitId,  String username);

    PermitResponse closePermit(Long permitId, LocalDate validTillDate, LocalTime validTillTime, String username);

    PermitResponse requestExtension(Long id, String name);
}
