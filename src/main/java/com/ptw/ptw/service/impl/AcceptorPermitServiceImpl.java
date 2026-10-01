package com.ptw.ptw.service.impl;

import com.ptw.ptw.dto.*;
import com.ptw.ptw.entity.*;
import com.ptw.ptw.enums.PermitStatus;
import com.ptw.ptw.enums.PermitWorkflowAction;
import com.ptw.ptw.repository.*;
import com.ptw.ptw.service.AcceptorPermitService;
import com.ptw.ptw.service.DocumentStorageService;
import com.ptw.ptw.service.EmailNotificationService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.time.format.DateTimeFormatter;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class AcceptorPermitServiceImpl implements AcceptorPermitService {

    private final PermitRepository permitRepository;
    private final UserRepository userRepository;
    private final PermitWorkflowHistoryRepository permitWorkflowHistoryRepository;
    private final PermitDocumentRepository permitDocumentRepository;
    private final DocumentStorageService documentStorageService;
    private final EmailNotificationService emailNotificationService;
    private final ContractorRepository contractorRepository;

    @Override
    public List<PermitResponse> findPendingPermits(String username) {

        User acceptor = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

        List<PermitStatus> statuses = List.of(
                PermitStatus.PERMIT_ISSUED,
                PermitStatus.PERMIT_IN_PROGRESS,
                PermitStatus.WORK_IN_PROGRESS,
                PermitStatus.WORK_COMPLETED,
                PermitStatus.EXTENSION_REQUESTED,
                PermitStatus.EXTENDED,
                PermitStatus.CLOSED
        );

        return permitRepository.findByAcceptorIdAndPermitStatusInOrderByIdDesc(
                        acceptor.getId(),statuses)
                        .stream()
                        .map(this::mapToResponse)
                        .toList();
    }


    @Override
    public PermitResponse findPermitForAcceptor(Long permitId, String username) {

        Permit permit = findPermit(permitId);
        validateAcceptor(permit, username);

        if (permit.getPermitStatus() != PermitStatus.PERMIT_IN_PROGRESS
                && permit.getPermitStatus() != PermitStatus.PERMIT_ISSUED
                && permit.getPermitStatus() != PermitStatus.WORK_IN_PROGRESS
                && permit.getPermitStatus() != PermitStatus.WORK_COMPLETED
                && permit.getPermitStatus() != PermitStatus.EXTENSION_REQUESTED
                && permit.getPermitStatus() != PermitStatus.EXTENDED
                && permit.getPermitStatus() != PermitStatus.CLOSED) {

            throw new RuntimeException("Permit is not available for Acceptor viewing");
        }

        return mapToResponse(permit);
    }



    @Override
    public PermitResponse submitSectionB(Long permitId, PermitSectionBRequest request, String username) {

        Permit permit = findPermit(permitId);
        validateAcceptor(permit, username);

        Boolean contractorDeployed =  Boolean.TRUE.equals(request.getContractorDeployed());

        Contractor contractor = null;
        String contractorSupervisor = null;

        if (contractorDeployed) {

            if (request.getContractorId() == null) {
                throw new RuntimeException("Contractor is required when contractor is deployed");
            }

            contractor = contractorRepository.findById(request.getContractorId())
                    .orElseThrow(() ->new RuntimeException("Contractor not found"));
        }

        if (request.getContractorSupervisor() == null || request.getContractorSupervisor().isBlank()) {
            throw new RuntimeException("Contractor supervisor name is required");
        }
        contractorSupervisor = request.getContractorSupervisor().trim();

        if (permit.getPermitStatus() != PermitStatus.PERMIT_IN_PROGRESS) {
            throw new RuntimeException("Section B cannot be submitted in current permit status");
        }
        /*
         * Section B
         */
        permit.setEquipmentNumber(request.getEquipmentNumber());
        permit.setLocation(request.getLocation());
        permit.setProposedWorkInDetail(request.getProposedWorkInDetail());
        permit.setContractorDeployed(contractorDeployed);
        permit.setContractor(contractor);
        permit.setContractorSupervisor(contractorSupervisor);
        permit.setLiftShiftByEquipment(Boolean.TRUE.equals(request.getLiftShiftByEquipment()));
        permit.setHazardousChemicalExposure(Boolean.TRUE.equals(request.getHazardousChemicalExposure()));
        permit.setOtherHazardActivity(request.getOtherHazardActivity());
        permit.setValidOnDate(request.getValidOnDate());
        permit.setTimeFrom(request.getTimeFrom());
        permit.setTimeTo(request.getTimeTo());
        permit.setPermitStatus(PermitStatus.PERMIT_ISSUED);
        permit.setCurrentStage("PERMIT_ISSUED");
        Permit savedPermit = permitRepository.save(permit);

        return mapToResponse(savedPermit);
    }

    @Override
    @Transactional
    public List<PermitDocumentViewResponse> getDocuments(Long permitId, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));


        User acceptor = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

        if (permit.getAcceptor() == null || !permit.getAcceptor().getId().equals(acceptor.getId())) {
            throw new RuntimeException("You are not authorized to access these documents");
        }

        if (permit.getPermitStatus() != PermitStatus.WORK_COMPLETED && permit.getPermitStatus() != PermitStatus.CLOSED) {
            throw new RuntimeException( "Documents are available only after work completion");
        }

        List<PermitDocument> documentList = permitDocumentRepository.findByPermit(permit);

        return documentList.stream()
                .map(document ->
                        PermitDocumentViewResponse.builder()
                                .id(document.getId())
                                .documentType(document.getDocumentType())
                                .originalFileName(document.getOriginalFileName())
                                .contentType(document.getContentType())
                                .uploadedBy(document.getUploadedBy() != null ? document.getUploadedBy().getFirstName()
                                                + " " + document.getUploadedBy().getLastName(): null)
                                .uploadedAt(document.getUploadedAt())
                                .build()
                )
                .toList();
    }


    @Override
    @Transactional
    public void uploadDocument(Long permitId, String documentType, MultipartFile file, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        User acceptor = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

        if (permit.getAcceptor() == null || !permit.getAcceptor().getId().equals(acceptor.getId())) {
            throw new RuntimeException("You are not authorized to upload documents" );
        }

        if (permit.getPermitStatus() != PermitStatus.WORK_COMPLETED && permit.getPermitStatus() != PermitStatus.CLOSED) {
            throw new RuntimeException("Documents can be uploaded only after work completion");
        }

        if (file == null || file.isEmpty()) {
            throw new RuntimeException("Please select a file");
        }

        String normalizedDocumentType =
                documentType == null
                        ? null
                        : documentType.trim().toUpperCase();

        if (!List.of(
                "PRINTED_PERMIT",
                "SAFETY_BRIEFING",
                "OTHER"
        ).contains(normalizedDocumentType)) {

            throw new RuntimeException("Invalid document type");
        }

        if (!"OTHER".equals(normalizedDocumentType)
                && permitDocumentRepository.existsByPermitAndDocumentType(
                permit,  normalizedDocumentType)) {
            throw new RuntimeException( normalizedDocumentType + " document is already uploaded");
        }

        LocalDateTime now = LocalDateTime.now();
        String storedPath = documentStorageService.store(file, permit.getId());

        String storedFileName =
                java.nio.file.Paths
                        .get(storedPath)
                        .getFileName()
                        .toString();

        PermitDocument permitDocument = PermitDocument.builder()
                                        .permit(permit)
                                        .documentType(normalizedDocumentType)
                                        .originalFileName(file.getOriginalFilename())
                                        .storedFileName(storedFileName)
                                        .filePath(storedPath)
                                        .contentType(file.getContentType())
                                        .uploadedBy(acceptor)
                                        .uploadedAt(now)
                                        .build();

        permitDocumentRepository.save(permitDocument);
    }

    @Override
    public PermitResponse findPermitForDocumentUpload(Long permitId, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        /*if (permit.getPermitStatus() != PermitStatus.WORK_COMPLETED || permit.getPermitStatus() != PermitStatus.CLOSED) {
            throw new RuntimeException("Documents can be uploaded only after work completion");
        }*/

        return mapToResponse(permit);
    }


    @Override
    @Transactional
    public PermitResponse closePermit(Long permitId, LocalDate validTillDate,
                                      LocalTime validTillTime, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        User acceptor = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

        validateAcceptor(permit, username);

        if (permit.getPermitStatus() != PermitStatus.WORK_COMPLETED) {
            throw new RuntimeException("Permit can be closed only after work completion");
        }

        if (validTillDate == null || validTillTime == null) {
            throw new RuntimeException("Please select Valid Till date and time.");
        }

        List<PermitDocument> documents = permitDocumentRepository.findByPermit(permit);

        boolean printedPermitUploaded = documents.stream()
                .anyMatch(document -> "PRINTED_PERMIT".equals(document.getDocumentType()));

        boolean safetyBriefingUploaded = documents.stream()
                .anyMatch(document ->  "SAFETY_BRIEFING".equals(document.getDocumentType()));

        if (!printedPermitUploaded) {
            throw new RuntimeException("Please upload the Printed Permit before closing.");
        }

        if (!safetyBriefingUploaded) {
            throw new RuntimeException("Please upload the Safety Briefing before closing.");
        }

        LocalDateTime now = LocalDateTime.now();

        LocalDateTime finalValidTill = LocalDateTime.of(validTillDate, validTillTime);
        permit.setValidTill(finalValidTill);
        permit.setClosedAt(now);

        permit.setPermitStatus(PermitStatus.CLOSED);
        permit.setCurrentStage("CLOSED");
        Permit savedPermit = permitRepository.save(permit);

        permitWorkflowHistoryRepository.save(PermitWorkflowHistory.builder()
                                .permit(savedPermit)
                                .actionBy(acceptor)
                                .action(PermitWorkflowAction.CLOSED)
                                .statusAfterAction(PermitStatus.CLOSED)
                                .stage("CLOSED")
                                .remarks("Permit closed by Acceptor after required documents were uploaded.")
                                .actionDateTime(now)
                                .build()
        );

        return mapToResponse(savedPermit);
    }



    @Override
    @Transactional
    public PermitResponse requestExtension(Long permitId, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() ->new RuntimeException("Permit not found."));

        validateAcceptor(permit, username);

        if (permit.getPermitStatus() != PermitStatus.WORK_IN_PROGRESS) {
            throw new RuntimeException("Extension can only be requested when work is in progress.");
        }

        if (Boolean.TRUE.equals(permit.getExtensionRequestUsed())) {
            throw new RuntimeException("Extension request has already been used for this permit.");
        }

        LocalDateTime now = LocalDateTime.now();
        permit.setExtensionRequestUsed(true);

        if (permit.getOriginalPermitNumber() == null) {
            permit.setOriginalPermitNumber(permit.getPermitNumber());
        }

        permit.setPermitStatus(PermitStatus.EXTENSION_REQUESTED);
        permit.setCurrentStage("EXTENSION_REQUESTED");
        Permit savedPermit = permitRepository.save(permit);


        permitWorkflowHistoryRepository.save(
                PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(permit.getAcceptor())
                        .action(PermitWorkflowAction.EXTENSION_REQUESTED)
                        .statusAfterAction(PermitStatus.WORK_IN_PROGRESS)
                        .stage("EXTENSION_REQUESTED")
                        .remarks("Extension requested by acceptor.")
                        .actionDateTime(now)
                        .build()
        );

        try {
            emailNotificationService.sendExtensionRequestedEmail(permit);
        }catch (Exception e) {
            log.error( "Failed to send extension request email for permit {}",savedPermit.getPermitNumber(),e);
        }

        return mapToResponse(savedPermit);
    }


    private PermitResponse mapToResponse(Permit permit) {

        String displayPermitNumber = permit.getPermitNumber();

        if (Boolean.TRUE.equals(permit.getExtensionAccepted())
                && permit.getOriginalPermitNumber() != null) {
            displayPermitNumber = permit.getOriginalPermitNumber() + "/EXT";
        }

        return  PermitResponse.builder()
                .id(permit.getId())
                .permitNumber(permit.getPermitNumber())
                .permitType(permit.getPermitType().getPermitName())
                .issuerName(permit.getIssuer().getFirstName() + " " + permit.getIssuer().getLastName())
                .issuerDepartment(permit.getIssuerDepartment().getDepartmentName())
                .acceptorName(permit.getAcceptor().getFirstName() + " " + permit.getAcceptor().getLastName())
                .acceptorDepartment(permit.getAcceptorDepartment().getDepartmentName())
                .contractorDeployed(permit.getContractorDeployed())
                .contractorName(permit.getContractor() != null ? permit.getContractor().getContractorName() : null)
                .contractorSupervisor(permit.getContractorSupervisor())
                .equipmentNumber(permit.getEquipmentNumber())
                .location(permit.getLocation())
                .proposedWork(permit.getProposedWork())
                .proposedWorkInDetail(permit.getProposedWorkInDetail())
                .liftShiftByEquipment(permit.getLiftShiftByEquipment())
                .hazardousChemicalExposure(permit.getHazardousChemicalExposure())
                .otherHazardActivity(permit.getOtherHazardActivity())
                .validOnDate(permit.getValidOnDate())
                .timeFrom(permit.getTimeFrom())
                .timeTo(permit.getTimeTo())
                .status(permit.getPermitStatus())
                .currentStage(permit.getCurrentStage())
                .extensionUsed(permit.getExtensionUsed())
                .extensionRequestUsed(permit.getExtensionRequestUsed())
                .extensionAccepted(permit.getExtensionAccepted())
                .displayPermitNumber(displayPermitNumber)
                .validTill(permit.getValidTill())
                .validTillFormatted(permit.getValidTill() != null ? permit.getValidTill()
                                .format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm")): null)
                .build();
    }

    private Permit findPermit(Long permitId)
    {
        return permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("PermitId not found:"  + permitId ));
    }

    private void validateAcceptor(Permit permit, String username) {

        if(permit.getAcceptor() == null){
            throw new RuntimeException( "No Acceptor assigned to Permit");
        }

        if(!permit.getAcceptor().getUsername().equals(username)){
            throw new RuntimeException( "You are not authorized to review this permit.");
        }
    }

}
