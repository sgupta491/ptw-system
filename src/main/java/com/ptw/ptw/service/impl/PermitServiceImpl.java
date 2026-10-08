package com.ptw.ptw.service.impl;

import com.ptw.ptw.dto.*;
import com.ptw.ptw.entity.*;
import com.ptw.ptw.enums.ElectricalIsolationStatus;
import com.ptw.ptw.enums.PermitStatus;
import com.ptw.ptw.enums.PermitWorkflowAction;
import com.ptw.ptw.repository.*;
import com.ptw.ptw.service.DocumentStorageService;
import com.ptw.ptw.service.EmailNotificationService;
import com.ptw.ptw.service.PermitService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.core.io.Resource;
import org.springframework.core.io.FileSystemResource;

import java.nio.file.Path;
import java.nio.file.Paths;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class PermitServiceImpl implements PermitService {


    private final PermitRepository permitRepository;
    private final PermitTypeRepository permitTypeRepository;
    private final DepartmentRepository departmentRepository;
    private final UserRepository userRepository;
    private final ContractorRepository contractorRepository;
    private final PermitWorkflowHistoryRepository permitWorkflowHistoryRepository;

    private final PermitHazardRepository permitHazardRepository;
    private final HazardMasterRepository hazardMasterRepository;
    private final PermitChecklistResponseRepository checklistResponseRepository;
    private final PermitChecklistResponseFieldRepository checklistResponseFieldRepository;
    private final PermitPostWorkMeasureRepository postWorkMeasureRepository;
    private final PermitWorkCompletionRepository workCompletionRepository;

    private final PermitDocumentRepository permitDocumentRepository;
    private final DocumentStorageService documentStorageService;

    private final PermitFinalVerificationRepository finalVerificationRepository;

    private final EmailNotificationService emailNotificationService;
    private final WorkRequestRepository workRequestRepository;



    @Override
    public PermitResponse createPermit(PermitCreationRequest permitRequest, String username) {

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Logged-in User not found"));

        Department issuerDepartment = issuer.getDepartment();

        if (issuerDepartment == null) {
            throw new RuntimeException("Issuer department is not assigned");
        }

        PermitType permitType = permitTypeRepository.findById(permitRequest.getPermitTypeId())
                .orElseThrow(() -> new RuntimeException("PermitType not found"));

        Department acceptorDepartment = departmentRepository
                .findById(permitRequest.getAcceptorDepartmentId())
                .orElseThrow(() -> new RuntimeException("Acceptor department not found"));

        User acceptor = null;

        if (permitRequest.getAcceptorId() != null) {
            acceptor = userRepository.findById(permitRequest.getAcceptorId())
                    .orElseThrow(() -> new RuntimeException("Acceptor id not found"));
        }



        Permit permit = Permit.builder()
                .permitNumber("TEMP-" + java.util.UUID.randomUUID())
                .permitType(permitType)
                .issuerDepartment(issuerDepartment)
                .issuer(issuer)
                .acceptorDepartment(acceptorDepartment)
                .acceptor(acceptor)
                .proposedWork(permitRequest.getProposedWork())
                /*
                 * Section B
                 */
                .permitStatus(PermitStatus.PERMIT_IN_PROGRESS)
                .currentStage("PERMIT_IN_PROGRESS")
                .createdBy(issuer)
                .build();

        Permit savedPermit = permitRepository.save(permit);

        String permitNumber = String.format("PTW/CP/%03d",savedPermit.getId());
        savedPermit.setPermitNumber(permitNumber);
        savedPermit = permitRepository.save(savedPermit);
        return mapToResponse(savedPermit);
    }



    @Override
    public PermitResponse findPermitById(Long id) {

        return mapToResponse(findPermitEntity(id));
    }

    @Override
    public List<PermitResponse> findMyPermits(String username) {

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return permitRepository
                .findByIssuerId(issuer.getId())
                .stream()
                .map(this::mapToResponse)
                .toList();
    }


    @Override
    public List<PermitResponse> findPermitsByIssuer(String username) {

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        return permitRepository.findByIssuerIdOrderByIdDesc(issuer.getId())
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    @Override
    public PermitResponse getPermitForAssessment(Long permitId, String username) {

        Permit permit = findPermitEntity(permitId);

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        if(!permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException(" You are not authorized to access this permit.");
        }

        if(permit.getPermitStatus() != PermitStatus.PERMIT_ISSUED
                && permit.getPermitStatus() != PermitStatus.ELECTRICAL_ISOLATION) {
            throw new RuntimeException("Permit is not ready for assessment.");
        }

        return mapToResponse(permit);
    }

    @Override
    public PermitResponse approvePermitForPrint(Long permitId, String username) {

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        if (permit.getIssuer() == null || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to approve this permit");
        }

       /* if (permit.getPermitStatus() != PermitStatus.PERMIT_ISSUED) {
            throw new RuntimeException( "Permit is not awaiting issuer approval");
        }*/

        if (Boolean.TRUE.equals(permit.getElectricalIsolationRequired())
                && permit.getElectricalIsolationStatus()
                != ElectricalIsolationStatus.COMPLETED) {

            throw new RuntimeException( "Electrical isolation is not completed");
        }

        LocalDateTime now = LocalDateTime.now();

        permit.setIssuerApprovalDateTime(now);
        permit.setPermitStatus(PermitStatus.WORK_IN_PROGRESS);
        permit.setCurrentStage("WORK_IN_PROGRESS");

        Permit savedPermit = permitRepository.save(permit);

        permitWorkflowHistoryRepository.save(
                PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(issuer)
                        .action(PermitWorkflowAction.ISSUER_APPROVED)
                        .statusAfterAction(PermitStatus.WORK_IN_PROGRESS)
                        .stage("WORK_IN_PROGRESS")
                        .remarks("Permit printed. Work is now in progress.")
                        .actionDateTime(now)
                        .build()
        );

        return mapToResponse(savedPermit);
    }

    @Override
    public PermitApprovalResponse getPermitForPrint(Long permitId, String username) {

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        if (permit.getIssuer() == null || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to view this permit"
            );
        }
        if (permit.getPermitStatus() != PermitStatus.WORK_IN_PROGRESS) {
            throw new RuntimeException("Permit is not available for printing");
        }

        return buildPermitApprovalResponse(permit);
    }

    @Override
    public PermitResponse markWorkCompleted(Long permitId, String username) {

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        if (permit.getIssuer() == null || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to complete this permit");
        }

        if (permit.getPermitStatus() != PermitStatus.WORK_IN_PROGRESS
                && permit.getPermitStatus() != PermitStatus.EXTENDED) {
            throw new RuntimeException("Work can be completed only when permit is in progress");
        }

        if (permit.getPermitStatus() == PermitStatus.EXTENDED
                && !Boolean.TRUE.equals(permit.getExtensionUsed())) {
            throw new RuntimeException( "Please print the extension form before completing the work.");
        }

        LocalDateTime now = LocalDateTime.now();

        permit.setPermitStatus(PermitStatus.WORK_COMPLETED);
        permit.setCurrentStage("WORK_COMPLETED");

        Permit savedPermit = permitRepository.save(permit);

        permitWorkflowHistoryRepository.save(
                PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(issuer)
                        .action(PermitWorkflowAction.WORK_COMPLETED)
                        .statusAfterAction(PermitStatus.WORK_COMPLETED)
                        .stage("WORK_COMPLETED")
                        .remarks("Issuer marked the work as completed.")
                        .actionDateTime(now)
                        .build()
        );

        return mapToResponse(savedPermit);
    }


    @Override
    @Transactional
    public PermitFullViewResponse getFullPermitView(Long permitId, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() ->new RuntimeException("Permit not found"));

        User user = userRepository.findByUsername(username)
                .orElseThrow(() ->new RuntimeException("User not found"));

        boolean isIssuer = permit.getIssuer() != null && permit.getIssuer().getId().equals(user.getId());

        boolean isAcceptor = permit.getAcceptor() != null && permit.getAcceptor().getId().equals(user.getId());

        if (!isIssuer && !isAcceptor) {
            throw new RuntimeException("You are not authorized to view this permit"
            );
        }

      /*  if (permit.getPermitStatus() != PermitStatus.CLOSED) {
            throw new RuntimeException("Full permit history is available after closure"
            );
        }*/

        /*
         * C
         */
        List<HazardOption> hazards = permitHazardRepository.findByPermit(permit)
                                    .stream()
                                    .map(PermitHazard::getHazard)
                                    .map(hazard ->
                                            HazardOption.builder()
                                                    .id(hazard.getId())
                                                    .hazardCode(hazard.getHazardCode())
                                                    .hazardName(hazard.getHazardName())
                                                    .hazardCategory(hazard.getHazardCategory())
                                                    .displayOrder(hazard.getDisplayOrder())
                                                    .build())
                                                    .toList();

        /*
         * D
         */
        List<ChecklistApprovalResponse> checklistResponses = checklistResponseRepository.findByPermit(permit)
                        .stream()
                        .map(response -> {
                            List<PermitChecklistResponseField> fields = checklistResponseFieldRepository
                                            .findByResponse(response);
                            java.util.Map<String, String> fieldValues =
                                    fields.stream().collect(
                                                    java.util.stream.Collectors
                                                            .toMap(PermitChecklistResponseField::getFieldCode,
                                                                    PermitChecklistResponseField::getFieldValue,
                                                                    (first, second) -> second ));

                            return ChecklistApprovalResponse.builder()
                                    .checklistId(response.getChecklist().getId())
                                    .questionCode(response.getQuestionCode())
                                    .questionText(response.getQuestionText())
                                    .response(response.getResponse())
                                    .measureImplementedBy(response.getMeasureImplementedBy() != null ? response.getMeasureImplementedBy()
                                                    .getFirstName() + " " + response.getMeasureImplementedBy().getLastName(): null)
                                    .measureImplementedAt(response.getMeasureImplementedAt())
                                    .fieldValues(fieldValues)
                                    .build();
                        })
                        .toList();

        /*
         * E
         */
        List<PostWorkMeasureResponse> postWorkMeasures = postWorkMeasureRepository.findByPermit(permit)
                        .stream()
                        .map(measure ->
                                PostWorkMeasureResponse.builder()
                                        .itemCode(measure.getItemCode())
                                        .itemText(measure.getItemText())
                                        .response(measure.getResponse())
                                        .otherText(measure.getOtherText())
                                        .answeredBy(measure.getAnsweredBy() != null ? measure.getAnsweredBy()
                                                        .getFirstName()+ " "+ measure.getAnsweredBy().getLastName(): null)
                                        .answeredAt(measure.getAnsweredAt())
                                        .build()
                        )
                        .toList();

        /*
         * H
         */
        WorkCompletionViewResponse workCompletion = null;

        Optional<PermitWorkCompletion> completionOptional = workCompletionRepository.findByPermit(permit);

        if (completionOptional.isPresent()) {
            PermitWorkCompletion completion =  completionOptional.get();

            workCompletion = WorkCompletionViewResponse.builder()
                            .completionResponse(completion.getCompletionResponse())
                            .completedBy(completion.getCompletedBy() != null ? completion.getCompletedBy()
                                            .getFirstName()+ " "+ completion.getCompletedBy().getLastName(): null)
                            .completedAt(completion.getCompletedAt())
                            .contractorSupervisorName(completion.getContractorSupervisorName())
                            .signatureRequired(Boolean.TRUE.equals(completion.getSignatureRequired()))
                            .contractorSupervisorSignatureRequired(Boolean.TRUE.equals(completion.getContractorSupervisorSignatureRequired()))
                            .build();
        }

        /*
         * I
         */
        FinalVerificationViewResponse finalVerification = null;

        Optional<PermitFinalVerification> verificationOptional = finalVerificationRepository.findByPermit(permit);

        if (verificationOptional.isPresent()) {

            PermitFinalVerification verification = verificationOptional.get();

            finalVerification =
                    FinalVerificationViewResponse.builder()
                            .verifiedBy( verification.getVerifiedBy() != null ? verification.getVerifiedBy().getFirstName()
                                            + " " + verification.getVerifiedBy().getLastName(): null)
                            .verifiedAt(verification.getVerifiedAt())
                            .remarks(verification.getRemarks())
                            .signatureRequired(Boolean.TRUE.equals(verification.getSignatureRequired()))
                            .build();
        }

        /*
         * Documents
         */
        List<PermitDocumentViewResponse> documents =
                permitDocumentRepository.findByPermit(permit)
                        .stream()
                        .map(document ->
                                PermitDocumentViewResponse.builder()
                                        .id(document.getId())
                                        .documentType(document.getDocumentType())
                                        .originalFileName(document.getOriginalFileName())
                                        .contentType(document.getContentType())
                                        .uploadedBy(document.getUploadedBy() != null ? document.getUploadedBy().getFirstName()
                                                        + " " + document.getUploadedBy().getLastName(): null)
                                        .uploadedAt(document.getUploadedAt())
                                        .build())
                        .toList();

        return PermitFullViewResponse.builder()
                .permit(mapToResponse(permit))
                .hazards(hazards)
                .otherHazards(permit.getOtherHazards())
                .relatedPermitNumber(permit.getRelatedPermitNumber())
                .checklistResponses(checklistResponses)
                .postWorkMeasures(postWorkMeasures)
                .issuerApprovalDateTime(permit.getIssuerApprovalDateTime())
                .workCompletion(workCompletion)
                .finalVerification(finalVerification)
                .documents(documents)
                .build();
    }


    @Override
    @Transactional
    public Resource getPermitDocument(Long permitId,Long documentId,String username) {

        User user = userRepository.findByUsername(username)
                .orElseThrow(() ->new RuntimeException("User not found"));

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() ->new RuntimeException("Permit not found"));

        boolean isIssuer = permit.getIssuer() != null && permit.getIssuer().getId().equals(user.getId());
        boolean isAcceptor = permit.getAcceptor() != null && permit.getAcceptor().getId().equals(user.getId());

        if (!isIssuer && !isAcceptor) {
            throw new RuntimeException("You are not authorized to view this document");
        }

        // Document
        PermitDocument document = permitDocumentRepository.findById(documentId)
                        .orElseThrow(() ->new RuntimeException("Document not found"));

        if (document.getPermit() == null || !document.getPermit().getId().equals(permitId)) {
            throw new RuntimeException("Document does not belong to this permit");
        }
        // Physical file
        Path filePath = Paths.get(document.getFilePath()).toAbsolutePath().normalize();

        Resource resource = new FileSystemResource(filePath);

        if (!resource.exists() || !resource.isReadable()) {
            throw new RuntimeException("Document file not found or not readable");
        }
        return resource;
    }

    @Override
    @Transactional
    public PermitResponse acceptExtension(Long permitId, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found."));

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found."));

        if (permit.getIssuer() == null || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to accept this extension.");
        }

        if (permit.getPermitStatus() != PermitStatus.EXTENSION_REQUESTED) {
            throw new RuntimeException("This permit does not have a pending extension request.");
        }

        LocalDateTime now = LocalDateTime.now();

        permit.setPermitStatus(PermitStatus.EXTENDED);
        permit.setCurrentStage("EXTENDED");
        permit.setExtensionAccepted(true);
        Permit savedPermit = permitRepository.save(permit);

        permitWorkflowHistoryRepository.save(
                PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(issuer)
                        .action(PermitWorkflowAction.EXTENSION_ACCEPTED)
                        .statusAfterAction(PermitStatus.EXTENDED)
                        .stage("EXTENDED")
                        .remarks("Extension accepted by issuer.")
                        .actionDateTime(now)
                        .build()
        );

        try {
            emailNotificationService.sendExtensionAcceptedEmail(savedPermit);
        } catch (Exception e) {
            log.error("Failed to send extension accepted email for permit {}", savedPermit.getPermitNumber(), e);
        }

        return mapToResponse(savedPermit);
    }

    @Override
    @Transactional
    public PermitResponse rejectExtension(Long permitId, String rejectionRemark, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() ->new RuntimeException("Permit not found."));

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() ->  new RuntimeException("Issuer not found."));

        if (permit.getIssuer() == null || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to reject this extension.");
        }

        if (permit.getPermitStatus() != PermitStatus.EXTENSION_REQUESTED) {
            throw new RuntimeException("This permit does not have a pending extension request.");
        }

        LocalDateTime now = LocalDateTime.now();
        permit.setPermitStatus(PermitStatus.WORK_IN_PROGRESS);
        permit.setCurrentStage("EXTENSION_REJECTED");

        Permit savedPermit = permitRepository.save(permit);

        permitWorkflowHistoryRepository.save(
                PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(issuer)
                        .action(PermitWorkflowAction.EXTENSION_REJECTED)
                        .statusAfterAction(PermitStatus.WORK_IN_PROGRESS)
                        .stage("EXTENSION_REJECTED")
                        .remarks(rejectionRemark != null && !rejectionRemark.trim().isEmpty()
                                        ? rejectionRemark.trim() : "Extension rejected by issuer.")
                        .actionDateTime(now)
                        .build()
        );

        try {
            emailNotificationService.sendExtensionRejectedEmail(savedPermit,rejectionRemark);
        } catch (Exception e) {
            log.error("Failed to send extension rejection email for permit {}", savedPermit.getPermitNumber(),e);
        }

        return mapToResponse(savedPermit);
    }


    @Override
    public PermitResponse getPermitForExtensionPrint(Long permitId, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() ->new RuntimeException("Permit not found."));

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() ->new RuntimeException("Issuer not found."));

        if (permit.getIssuer() == null || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to print this extension." );
        }

        if (permit.getPermitStatus() != PermitStatus.EXTENDED) {
            throw new RuntimeException("Extension has not been approved yet.");
        }

        if (Boolean.TRUE.equals(permit.getExtensionUsed())) {
            throw new RuntimeException("Extension form has already been printed.");
        }
        return mapToResponse(permit);
    }


    @Override
    @Transactional
    public PermitResponse printExtensionForm(Long permitId, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found."));

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() ->new RuntimeException("Issuer not found."));

        if (permit.getIssuer() == null || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to print this extension.");
        }

        if (permit.getPermitStatus() != PermitStatus.EXTENDED) {
            throw new RuntimeException( "Extension has not been approved yet." );
        }

        if (Boolean.TRUE.equals(permit.getExtensionUsed())) {
            throw new RuntimeException("Extension form has already been printed.");
        }

        if (permit.getOriginalPermitNumber() == null) {
            permit.setOriginalPermitNumber(permit.getPermitNumber());
        }
        LocalDateTime now = LocalDateTime.now();
       // permit.setPermitNumber(permit.getOriginalPermitNumber() + "/EXT");
        permit.setExtensionUsed(true);
        permit.setCurrentStage("EXTENDED");

        Permit savedPermit = permitRepository.save(permit);

        permitWorkflowHistoryRepository.save(
                PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(issuer)
                        .action(PermitWorkflowAction.EXTENSION_PRINTED)
                        .statusAfterAction(PermitStatus.EXTENDED)
                        .stage("EXTENDED")
                        .remarks("Extension form printed by issuer.")
                        .actionDateTime(now)
                        .build()
        );

        return mapToResponse(savedPermit);
    }



    private PermitApprovalResponse buildPermitApprovalResponse(Permit permit) {


        List<HazardOption> hazards = permitHazardRepository.findByPermit(permit)
                        .stream()
                        .map(PermitHazard::getHazard)
                        .map(hazard -> HazardOption.builder()
                                .id(hazard.getId())
                                .hazardCode(hazard.getHazardCode())
                                .hazardName(hazard.getHazardName())
                                .hazardCategory(hazard.getHazardCategory())
                                .displayOrder(hazard.getDisplayOrder())
                                .build())
                        .toList();


        List<ChecklistApprovalResponse> checklistResponses =
                checklistResponseRepository.findByPermit(permit)
                        .stream()
                        .map(response -> {

                            List<PermitChecklistResponseField> fields = checklistResponseFieldRepository.findByResponse(response);

                            Map<String, String> fieldValues =
                                    fields.stream()
                                            .collect(java.util.stream.Collectors.toMap(
                                                            PermitChecklistResponseField::getFieldCode,
                                                            PermitChecklistResponseField::getFieldValue));

                            return ChecklistApprovalResponse.builder()
                                    .checklistId(response.getChecklist().getId())
                                    .questionCode(response.getQuestionCode())
                                    .questionText(response.getQuestionText())
                                    .response(response.getResponse())
                                    .measureImplementedBy(response.getMeasureImplementedBy() != null ? response.getMeasureImplementedBy()
                                                    .getFirstName()+ " " + response.getMeasureImplementedBy().getLastName(): null)
                                    .measureImplementedAt(response.getMeasureImplementedAt())
                                    .fieldValues(fieldValues)
                                    .build();

                        })
                        .toList();


        List<PostWorkMeasureResponse> postWorkMeasures =
                postWorkMeasureRepository.findByPermit(permit)
                        .stream()
                        .map(measure ->
                                PostWorkMeasureResponse.builder()
                                        .itemCode(measure.getItemCode())
                                        .itemText(measure.getItemText())
                                        .response(measure.getResponse())
                                        .otherText(measure.getOtherText())
                                        .answeredBy(measure.getAnsweredBy() != null? measure.getAnsweredBy().getFirstName()
                                                        + " "+ measure.getAnsweredBy().getLastName(): null)
                                        .answeredAt(measure.getAnsweredAt())
                                        .build()
                        )
                        .toList();

        WorkRequest workRequest = workRequestRepository.findByPermit(permit).orElse(null);

        return PermitApprovalResponse.builder()
                .permit(mapToResponse(permit))
                .hazards(hazards)
                .otherHazards(permit.getOtherHazards())
                .relatedPermitNumber(permit.getRelatedPermitNumber())
                .checklistResponses(checklistResponses)
                .postWorkMeasures(postWorkMeasures)
                .issuerApprovalDateTime(permit.getIssuerApprovalDateTime())
                .electricalWorkOrderNumber(workRequest != null ? workRequest.getWoNumber() : null)
                .electricalEquipmentNumber(workRequest != null ? workRequest.getIsolationEquipmentNumber(): null)
                .electricalFeederNumber(workRequest != null ? workRequest.getFeederNumber() : null)
                .electricalLotoNumber(workRequest != null? workRequest.getLotoNumber() : null)
                .build();
    }

    private PermitRequest convertToEditRequest(Permit permit) {

        PermitRequest permitRequest = new PermitRequest();
        permitRequest.setPermitTypeId(permit.getPermitType()!=null ? permit.getPermitType().getId(): null);
        permitRequest.setAcceptorDepartmentId(permit.getAcceptorDepartment()!=null ? permit.getAcceptorDepartment().getId(): null);
        permitRequest.setAcceptorId(permit.getAcceptor()!=null ? permit.getAcceptor().getId(): null);
        permitRequest.setContractorDeployed(permit.getContractorDeployed());
        permitRequest.setContractorId(permit.getContractor()!=null ? permit.getContractor().getId(): null);
        permitRequest.setContractorSupervisor(permit.getContractorSupervisor());
        permitRequest.setEquipmentNumber(permit.getEquipmentNumber());
        permitRequest.setLocation(permit.getLocation());
        permitRequest.setProposedWork(permit.getProposedWork());
        permitRequest.setLiftShiftByEquipment(permit.getLiftShiftByEquipment());
        permitRequest.setHazardousChemicalExposure(permit.getHazardousChemicalExposure());
        permitRequest.setOtherHazardActivity(permit.getOtherHazardActivity());
        permitRequest.setValidOnDate(permit.getValidOnDate());
        permitRequest.setTimeFrom(permit.getTimeFrom());
        permitRequest.setTimeTo(permit.getTimeTo());

        return permitRequest;
    }

    private PermitResponse mapToResponse(Permit permit) {

        String displayPermitNumber = permit.getPermitNumber();

        if (Boolean.TRUE.equals(permit.getExtensionAccepted())
                && permit.getOriginalPermitNumber() != null) {

            displayPermitNumber = permit.getOriginalPermitNumber() + "/EXT";
        }

        return PermitResponse.builder()
                .id(permit.getId())
                .permitNumber(permit.getPermitNumber())
                .permitTypeId(permit.getPermitType() != null ? permit.getPermitType().getId() : null)
                .permitType(permit.getPermitType().getPermitName())
                .issuerName(permit.getIssuer().getFirstName() + " " + permit.getIssuer().getLastName())
                .issuerDepartment(permit.getIssuerDepartment().getDepartmentName())
                .acceptorName(permit.getAcceptor() != null ? permit.getAcceptor().getFirstName() + " " + permit.getAcceptor().getLastName(): null)
                .acceptorDepartment(permit.getAcceptorDepartment().getDepartmentName())
                .contractorDeployed(permit.getContractorDeployed())
                .contractorName(permit.getContractor() != null ? permit.getContractor().getContractorName() : null)
                .contractorSupervisor(permit.getContractorSupervisor())
                .equipmentNumber(permit.getEquipmentNumber())
                .location(permit.getLocation())
                .proposedWork(permit.getProposedWork())
                .proposedWorkInDetail(permit.getProposedWorkInDetail())
                .hazardousChemicalExposure(permit.getHazardousChemicalExposure())
                .liftShiftByEquipment(permit.getLiftShiftByEquipment())
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
                .validTillFormatted(permit.getValidTill() != null
                                ? permit.getValidTill()
                                .format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm"))
                                : null
                )
                .electricalIsolationRequired(permit.getElectricalIsolationRequired())
                .build();
    }


    private Permit findPermitEntity(Long permitId) {
        return  permitRepository.findById(permitId)
                .orElseThrow(()-> new RuntimeException("Permit not found" + permitId));
    }

}
