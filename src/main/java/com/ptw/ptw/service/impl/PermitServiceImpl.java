package com.ptw.ptw.service.impl;

import com.ptw.ptw.dto.*;
import com.ptw.ptw.entity.*;
import com.ptw.ptw.enums.PermitStatus;
import com.ptw.ptw.enums.PermitWorkflowAction;
import com.ptw.ptw.repository.*;
import com.ptw.ptw.service.DocumentStorageService;
import com.ptw.ptw.service.PermitService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.core.io.Resource;
import org.springframework.core.io.FileSystemResource;

import java.nio.file.Path;
import java.nio.file.Paths;

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



    @Override
    public PermitResponse createPermit(PermitRequest permitRequest, String username) {

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(()-> new RuntimeException(" Logged-in User not found"));

        Department issuerDepartment = issuer.getDepartment();

        if (issuerDepartment == null) {
            throw new RuntimeException("Issuer department is not assigned");
        }

        PermitType permitType = permitTypeRepository.findById(permitRequest.getPermitTypeId())
                .orElseThrow(()-> new RuntimeException(" PermitType not found"));



        Department acceptorDepartment = departmentRepository.findById(permitRequest.getAcceptorDepartmentId())
                .orElseThrow(()-> new RuntimeException(" Acceptor department not found"));

        User acceptor = null;

        if (permitRequest.getAcceptorId() != null) {
            acceptor = userRepository.findById(permitRequest.getAcceptorId())
                    .orElseThrow(()-> new RuntimeException(" Acceptor id not found"));
        }

        Boolean contractorDeployed = Boolean.TRUE.equals(permitRequest.getContractorDeployed());
        Contractor contractor = null;
        String contractorSupervisor = null;

        if (contractorDeployed) {
            if (permitRequest.getContractorId() == null) {
                throw new RuntimeException("Contractor is required when contractor is deployed");
            }
            if (permitRequest.getContractorSupervisor() == null || permitRequest.getContractorSupervisor().isBlank()) {
                throw new RuntimeException("Contractor supervisor name is required");
            }

            contractor = contractorRepository.findById(permitRequest.getContractorId())
                            .orElseThrow(() -> new RuntimeException("Contractor not found"));

            contractorSupervisor = permitRequest.getContractorSupervisor().trim();
        }

        Permit permit = Permit.builder()
                .permitNumber("TEMP-" + java.util.UUID.randomUUID())
                .permitType(permitType)
                .issuerDepartment(issuerDepartment)
                .issuer(issuer)
                .acceptorDepartment(acceptorDepartment)
                .acceptor(acceptor)
                .contractorDeployed(contractorDeployed)
                .contractor(contractor)
                .contractorSupervisor(contractorSupervisor)
                .equipmentNumber(permitRequest.getEquipmentNumber())
                .location(permitRequest.getLocation())
                .proposedWork(permitRequest.getProposedWork())
                .liftShiftByEquipment(Boolean.TRUE.equals(permitRequest.getLiftShiftByEquipment()))
                .hazardousChemicalExposure(Boolean.TRUE.equals(permitRequest.getHazardousChemicalExposure()))
                .otherHazardActivity(permitRequest.getOtherHazardActivity())
                .validOnDate(permitRequest.getValidOnDate())
                .timeFrom(permitRequest.getTimeFrom())
                .timeTo(permitRequest.getTimeTo())
                .permitStatus(PermitStatus.DRAFT)
                .currentStage("SECTION_A_B")
                .createdBy(issuer)
                .build();

       Permit savedPermit =  permitRepository.save(permit);

        String permitNumber = String.format("PTW/CP/%03d",savedPermit.getId());
        savedPermit.setPermitNumber(permitNumber);
        savedPermit = permitRepository.save(savedPermit);

        return mapToResponse(savedPermit);
    }



    @Override
    public PermitResponse submitPermit(Long permitId, String username) {

        Permit permit = findPermitEntity(permitId);
        validateIssuer(permit, username);

        if(permit.getPermitStatus() != PermitStatus.DRAFT &&  permit.getPermitStatus() != PermitStatus.RETURNED) {
            throw new RuntimeException(" Permit cannot be submitted in current status");
        }

        permit.setPermitStatus(PermitStatus.ACCEPTOR_VERIFICATION);
        permit.setCurrentStage("ACCEPTOR_VERIFICATION");

        return mapToResponse(permitRepository.save(permit));
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
    public List<PermitResponse> findReturnedPermits(String username) {

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));


        return permitRepository.findByIssuerIdAndPermitStatus(issuer.getId(), PermitStatus.RETURNED)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    @Override
    public PermitResponse findReturnedPermit(Long id, String username) {

        Permit permit = findPermitEntity(id);

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        if(!permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to edit this permit.");
        }

        if(permit.getPermitStatus() != PermitStatus.RETURNED) {
            throw new RuntimeException("Only RETURNED permits can be edited.");
        }

        return mapToResponse(permit);
    }

    @Override
    public PermitResponse resubmitReturnedPermit(Long permitId, PermitRequest permitRequest, String username) {

        System.out.println("===== RESUBMIT SERVICE START =====");

        Permit permit = findPermitEntity(permitId);

        System.out.println("Before status = " + permit.getPermitStatus());
        System.out.println("Before stage = " + permit.getCurrentStage());

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        if(!permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to edit this permit.");
        }

        if(permit.getPermitStatus() != PermitStatus.RETURNED) {
            throw new RuntimeException("Only RETURNED permits can be edited.");
        }

        updateSectionA(permit, permitRequest);
        updateSectionB(permit, permitRequest);

        permit.setPermitStatus(PermitStatus.ACCEPTOR_VERIFICATION);
        permit.setCurrentStage("ACCEPTOR_VERIFICATION");

        System.out.println("After status = " + permit.getPermitStatus());
        System.out.println("After stage = " + permit.getCurrentStage());

        Permit savedPermit = permitRepository.save(permit);

        System.out.println("Saved ID = " + savedPermit.getId());
        System.out.println("Saved status = " + savedPermit.getPermitStatus());
        System.out.println("Saved stage = " + savedPermit.getCurrentStage());

        System.out.println("===== RESUBMIT SERVICE END =====");

        PermitWorkflowHistory permitWorkflowHistory = PermitWorkflowHistory.builder()
                .permit(savedPermit)
                .actionBy(issuer)
                .action(PermitWorkflowAction.RESUBMITTED)
                .statusAfterAction(PermitStatus.ACCEPTOR_VERIFICATION)
                .stage("ACCEPTOR_VERIFICATION")
                .remarks("Permit resubmitted after correction")
                .actionDateTime(LocalDateTime.now())
                .build();

        permitWorkflowHistoryRepository.save(permitWorkflowHistory);

        return mapToResponse(savedPermit);
    }


    @Override
    public PermitRequest getReturnedPermitForEdit(Long permitId, String username) {

        Permit permit = findPermitEntity(permitId);

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        if(!permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to edit this permit.");
        }

        if(permit.getPermitStatus() != PermitStatus.RETURNED) {
            throw new RuntimeException("Only RETURNED permits can be edited.");
        }

        return convertToEditRequest(permit);
    }


    @Override
    public String getLatestReturnRemarks(Long permitId, String username) {

        Permit permit = findPermitEntity(permitId);

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        if(!permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("Unauthorized access.");
        }

        return permitWorkflowHistoryRepository.findByPermitOrderByActionDateTimeDesc(permit)
                .stream()
                .filter(history ->history.getAction() == PermitWorkflowAction.SENT_BACK)
                .map(PermitWorkflowHistory::getRemarks)
                .findFirst()
                .orElse(null);
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

        if(permit.getPermitStatus() != PermitStatus.ACCEPTOR_VERIFIED) {
            throw new RuntimeException("Permit is not ready for assessment.");
        }

        return mapToResponse(permit);
    }

    @Override
    public PermitApprovalResponse getPermitForIssuerApproval(Long permitId, String username) {

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        if (permit.getIssuer() == null
                || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException(
                    "You are not authorized to view this permit"
            );
        }

        if (permit.getPermitStatus() != PermitStatus.ISSUER_APPROVAL) {
            throw new RuntimeException(
                    "Permit is not awaiting issuer approval"
            );
        }

        return buildPermitApprovalResponse(permit);
    }

    @Override
    public PermitResponse approvePermitForPrint(Long permitId, String username) {

        User issuer = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Issuer not found"));

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        if (permit.getIssuer() == null
                || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException(
                    "You are not authorized to approve this permit"
            );
        }

        if (permit.getPermitStatus() != PermitStatus.ISSUER_APPROVAL) {
            throw new RuntimeException(
                    "Permit is not awaiting issuer approval"
            );
        }

        LocalDateTime now = LocalDateTime.now();

        permit.setIssuerApprovalDateTime(now);
        permit.setPermitStatus(PermitStatus.READY_FOR_PRINT);
        permit.setCurrentStage("READY_FOR_PRINT");

        Permit savedPermit = permitRepository.save(permit);

        permitWorkflowHistoryRepository.save(
                PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(issuer)
                        .action(PermitWorkflowAction.ISSUER_APPROVED)
                        .statusAfterAction(PermitStatus.READY_FOR_PRINT)
                        .stage("READY_FOR_PRINT")
                        .remarks("Issuer approved permit. Ready for printing.")
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
        if (permit.getPermitStatus() != PermitStatus.READY_FOR_PRINT) {
            throw new RuntimeException("Permit is not ready for printing");
        }

        return buildPermitApprovalResponse(permit);
    }

    @Override
    public PermitResponse getPermitForAcceptance(Long permitId, String username) {

        User acceptor = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        if (permit.getAcceptor() == null || !permit.getAcceptor().getId().equals(acceptor.getId())) {
            throw new RuntimeException("You are not authorized to accept this permit");
        }

        if (permit.getPermitStatus() != PermitStatus.READY_FOR_PRINT) {
            throw new RuntimeException("Permit is not ready for acceptance");
        }
        return mapToResponse(permit);
    }

    @Override
    public PermitResponse acceptPermitAndStartWork(Long permitId, String username) {

        User acceptor = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        if (permit.getAcceptor() == null || !permit.getAcceptor().getId().equals(acceptor.getId())) {
            throw new RuntimeException("You are not authorized to accept this permit");
        }

        if (permit.getPermitStatus() != PermitStatus.READY_FOR_PRINT) {
            throw new RuntimeException("Permit is not ready for acceptance");
        }

        LocalDateTime now = LocalDateTime.now();

        permit.setPermitStatus(PermitStatus.ACTIVE);
        permit.setCurrentStage("ACTIVE");

        Permit savedPermit = permitRepository.save(permit);

        permitWorkflowHistoryRepository.save(PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(acceptor)
                        .action(PermitWorkflowAction.ACCEPTED)
                        .statusAfterAction(PermitStatus.ACTIVE)
                        .stage("ACTIVE")
                        .remarks("Hardcopy permit acceptance completed. Work started.")
                        .actionDateTime(now)
                        .build()
        );

        return mapToResponse(savedPermit);
    }

    @Override
    public PermitResponse getPermitForWorkCompletion(Long permitId, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        User acceptor = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

        if (permit.getAcceptor() == null || !permit.getAcceptor().getId().equals(acceptor.getId())) {
            throw new RuntimeException( "You are not authorized to complete this permit");
        }

        if (permit.getPermitStatus() != PermitStatus.ACTIVE) {
            throw new RuntimeException("Permit is not active for work completion");
        }

        return mapToResponse(permit);
    }

    @Override
    public PermitResponse submitWorkCompletion(Long permitId, WorkCompletionRequest request, List<MultipartFile> documents, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        User acceptor = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

        if (permit.getAcceptor() == null || !permit.getAcceptor().getId().equals(acceptor.getId())) {
            throw new RuntimeException("You are not authorized to complete this permit");
        }
        if (permit.getPermitStatus() != PermitStatus.ACTIVE) {
            throw new RuntimeException("Permit is not active for work completion");
        }

        String response = request.getCompletionResponse();

        if (response == null  || (!"YES".equalsIgnoreCase(response) && !"NO".equalsIgnoreCase(response))) {
            throw new RuntimeException("Please select Yes or No");
        }
        if (workCompletionRepository.existsByPermit(permit)) {
            throw new RuntimeException("Work completion has already been submitted for this permit");
        }

        if (documents == null || documents.isEmpty()) {
            throw new RuntimeException("Please upload at least one document after completing the work" );
        }
        LocalDateTime now = LocalDateTime.now();
        boolean contractorDeployed = Boolean.TRUE.equals(permit.getContractorDeployed());

        PermitWorkCompletion completion = PermitWorkCompletion.builder()
                                        .permit(permit)
                                        .completionResponse(response.toUpperCase())
                                        .completedBy(acceptor)
                                        .completedAt(now)
                                        .signatureRequired(true)
                                        .contractorSupervisorName(contractorDeployed ? permit.getContractorSupervisor(): null)
                                        .contractorSupervisorSignatureRequired(contractorDeployed)
                                        .build();

        workCompletionRepository.save(completion);

        if ("YES".equalsIgnoreCase(response)) {

            /*
             * Store every uploaded document
             */
            for (MultipartFile document : documents) {

                if (document == null || document.isEmpty()) {
                    continue;
                }

                String storedPath = documentStorageService.store(document,permit.getId());
                String originalFileName = document.getOriginalFilename();
                String storedFileName = java.nio.file.Paths
                                .get(storedPath)
                                .getFileName()
                                .toString();

                PermitDocument permitDocument = PermitDocument.builder()
                                                .permit(permit)
                                                .documentType("WORK_COMPLETION_DOCUMENT")
                                                .originalFileName(originalFileName)
                                                .storedFileName(storedFileName)
                                                .filePath(storedPath)
                                                .contentType(document.getContentType())
                                                .uploadedBy(acceptor)
                                                .uploadedAt(now)
                                                .build();

                permitDocumentRepository.save(permitDocument);
            }

            /*
             * Send to Issuer for Section I
             */

            permit.setPermitStatus(PermitStatus.FINAL_VERIFICATION);
            permit.setCurrentStage("FINAL_VERIFICATION");

            Permit savedPermit = permitRepository.save(permit);

            permitWorkflowHistoryRepository.save(PermitWorkflowHistory.builder()
                                            .permit(savedPermit)
                                            .actionBy(acceptor)
                                            .action(PermitWorkflowAction.WORK_COMPLETED)
                                            .statusAfterAction(PermitStatus.FINAL_VERIFICATION)
                                            .stage("FINAL_VERIFICATION")
                                            .remarks( "Work completed. Permit sent to issuer department for Section I final verification.")
                                            .actionDateTime(now)
                                            .build()
            );

            return mapToResponse(savedPermit);
        }

        /*
         * NO:
         * Work is not complete.
         * Extension workflow will be implemented later.
         */

        permitWorkflowHistoryRepository.save(PermitWorkflowHistory.builder()
                        .permit(permit)
                        .actionBy(acceptor)
                        .action(PermitWorkflowAction.WORK_COMPLETED)
                        .statusAfterAction(PermitStatus.ACTIVE)
                        .stage("ACTIVE")
                        .remarks("Work completion reported as NO. Extension workflow pending.")
                        .actionDateTime(now)
                        .build()
        );

        return mapToResponse(permit);
    }

    @Override
    public PermitResponse getPermitForFinalVerification(Long permitId, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        User verifier = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (verifier.getDepartment() == null
                || permit.getIssuerDepartment() == null
                || !verifier.getDepartment().getId()
                .equals(permit.getIssuerDepartment().getId())) {

            throw new RuntimeException("Only issuer department personnel can perform final verification");
        }

        if (permit.getPermitStatus() != PermitStatus.FINAL_VERIFICATION) {

            throw new RuntimeException("Permit is not ready for final verification");
        }

        return mapToResponse(permit);
    }

    @Override
    public PermitResponse completeFinalVerification(Long permitId, FinalVerificationRequest request, String username) {

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() ->
                        new RuntimeException("Permit not found"));

        User verifier = userRepository.findByUsername(username)
                .orElseThrow(() ->
                        new RuntimeException("User not found"));

        /*
         * Issuer department validation
         */
        if (verifier.getDepartment() == null
                || permit.getIssuerDepartment() == null
                || !verifier.getDepartment().getId()
                .equals(permit.getIssuerDepartment().getId())) {

            throw new RuntimeException(
                    "Only issuer department personnel can perform final verification"
            );
        }

        /*
         * Status validation
         */
        if (permit.getPermitStatus()
                != PermitStatus.FINAL_VERIFICATION) {

            throw new RuntimeException(
                    "Permit is not ready for final verification"
            );
        }

        /*
         * Prevent duplicate Section I
         */
        if (finalVerificationRepository.existsByPermit(permit)) {

            throw new RuntimeException(
                    "Final verification has already been completed"
            );
        }

        LocalDateTime now = LocalDateTime.now();

        PermitFinalVerification verification =
                PermitFinalVerification.builder()
                        .permit(permit)
                        .verifiedBy(verifier)
                        .verifiedAt(now)
                        .remarks(request.getRemarks())
                        .signatureRequired(true)
                        .build();

        finalVerificationRepository.save(verification);

        /*
         * I completed → Permit Closed
         */
        permit.setPermitStatus(PermitStatus.CLOSED);
        permit.setCurrentStage("CLOSED");

        Permit savedPermit =
                permitRepository.save(permit);

        /*
         * Workflow history
         */
        permitWorkflowHistoryRepository.save(
                PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(verifier)
                        .action(PermitWorkflowAction.FINAL_VERIFICATION)
                        .statusAfterAction(PermitStatus.CLOSED)
                        .stage("CLOSED")
                        .remarks(
                                "Section I completed after field verification and withdrawal of pre-check conditions."
                        )
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


        return PermitApprovalResponse.builder()
                .permit(mapToResponse(permit))
                .hazards(hazards)
                .otherHazards(permit.getOtherHazards())
                .relatedPermitNumber(permit.getRelatedPermitNumber())
                .checklistResponses(checklistResponses)
                .postWorkMeasures(postWorkMeasures)
                .issuerApprovalDateTime(permit.getIssuerApprovalDateTime())
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
                .hazardousChemicalExposure(permit.getHazardousChemicalExposure())
                .liftShiftByEquipment(permit.getLiftShiftByEquipment())
                .otherHazardActivity(permit.getOtherHazardActivity())
                .validOnDate(permit.getValidOnDate())
                .timeFrom(permit.getTimeFrom())
                .timeTo(permit.getTimeTo())
                .status(permit.getPermitStatus())
                .currentStage(permit.getCurrentStage())
                .build();
    }


    private Permit findPermitEntity(Long permitId) {

        return  permitRepository.findById(permitId)
                .orElseThrow(()-> new RuntimeException("Permit not found" + permitId));
    }


    private void validateIssuer(Permit permit, String username) {

        if(!permit.getIssuer().getUsername().equals(username)) {
            throw new RuntimeException("You are not authorized to modify this permit");
        }
    }


    private void updateSectionA(Permit permit, PermitRequest permitRequest) {

        Department acceptorDepartment = departmentRepository.findById(permitRequest.getAcceptorDepartmentId())
                .orElseThrow(() -> new RuntimeException("Acceptor Department not found"));

        User acceptor = userRepository.findById(permitRequest.getAcceptorId())
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

        permit.setAcceptorDepartment(acceptorDepartment);
        permit.setAcceptor(acceptor);

        Boolean contractorDeployed = Boolean.TRUE.equals(permitRequest.getContractorDeployed());
        Contractor contractor = null;
        String supervisor = null;

        if(contractorDeployed)
        {
            if(permitRequest.getContractorSupervisor() == null)
            {
                throw new RuntimeException("Contractor is required");
            }
        }

        if(permitRequest.getContractorSupervisor() == null || permitRequest.getContractorSupervisor().isBlank())
        {
            throw new RuntimeException("Contractor Supervisor is required");
        }

        contractor = contractorRepository.findById(permitRequest.getContractorId())
                .orElseThrow(() -> new RuntimeException("Contractor not found"));
        supervisor = permitRequest.getContractorSupervisor().trim();

        permit.setContractorDeployed(contractorDeployed);
        permit.setContractor(contractor);
        permit.setContractorSupervisor(supervisor);
    }


    private void updateSectionB(Permit permit, PermitRequest permitRequest) {

        permit.setEquipmentNumber(permitRequest.getEquipmentNumber());
        permit.setLocation(permitRequest.getLocation());
        permit.setProposedWork(permitRequest.getProposedWork());
        permit.setLiftShiftByEquipment(permitRequest.getLiftShiftByEquipment());
        permit.setHazardousChemicalExposure(permitRequest.getHazardousChemicalExposure());
        permit.setOtherHazardActivity(permitRequest.getOtherHazardActivity());
        permit.setValidOnDate(permitRequest.getValidOnDate());
        permit.setTimeFrom(permitRequest.getTimeFrom());
        permit.setTimeTo(permitRequest.getTimeTo());
    }



}
