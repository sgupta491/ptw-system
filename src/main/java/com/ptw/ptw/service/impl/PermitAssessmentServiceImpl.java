package com.ptw.ptw.service.impl;

import com.ptw.ptw.dto.ChecklistResponseRequest;
import com.ptw.ptw.dto.PermitAssessmentRequest;
import com.ptw.ptw.dto.PermitResponse;
import com.ptw.ptw.dto.PostWorkMeasureRequest;
import com.ptw.ptw.entity.*;
import com.ptw.ptw.enums.ElectricalIsolationStatus;
import com.ptw.ptw.enums.PermitStatus;
import com.ptw.ptw.enums.PermitWorkflowAction;
import com.ptw.ptw.repository.*;
import com.ptw.ptw.service.PermitAssessmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class PermitAssessmentServiceImpl implements PermitAssessmentService {

    private final PermitRepository permitRepository;
    private final UserRepository userRepository;
    private final HazardMasterRepository hazardMasterRepository;
    private final PermitHazardRepository permitHazardRepository;
    private final ChecklistMasterRepository checklistMasterRepository;
    private final ChecklistFieldMasterRepository checklistFieldMasterRepository;
    private final PermitChecklistResponseRepository checklistResponseRepository;
    private final PermitChecklistResponseFieldRepository checklistResponseFieldRepository;
    private final PermitPostWorkMeasureRepository postWorkMeasureRepository;
    private final PermitWorkflowHistoryRepository workflowHistoryRepository;

    // MAIN ASSESSMENT SAVE

    @Override
    public PermitResponse saveAssessment(Long permitId, PermitAssessmentRequest request, String username) {

        User issuer =  userRepository.findByUsername(username)
                       .orElseThrow(() ->new RuntimeException("Issuer not found"));

        Permit permit = permitRepository.findById(permitId).orElseThrow(() ->
                                new RuntimeException("Permit not found"));

        if (permit.getIssuer() == null || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to assess this permit");
        }

        if (permit.getPermitStatus()!= PermitStatus.ACCEPTOR_VERIFIED) {
            throw new RuntimeException("Permit is not ready for assessment");
        }


        saveHazards(permit,request);
        permit.setOtherHazards(request.getOtherHazards());
        permit.setRelatedPermitNumber(request.getRelatedPermitNumber());

        saveChecklistResponses(permit,request,issuer);
        savePostWorkMeasures(permit,request,issuer);


        boolean electricalIsolationRequired = isElectricalIsolationRequired(request);

        permit.setElectricalIsolationRequired(electricalIsolationRequired);

        if (electricalIsolationRequired) {
            permit.setElectricalIsolationStatus(ElectricalIsolationStatus.PENDING);

        } else {
            permit.setElectricalIsolationStatus(ElectricalIsolationStatus.NOT_REQUIRED);
        }


        if (!electricalIsolationRequired) {

            permit.setElectricalIsolationStatus(ElectricalIsolationStatus.NOT_REQUIRED);
            //permit.setIssuerApprovalDateTime(LocalDateTime.now());
            permit.setPermitStatus(PermitStatus.ISSUER_APPROVAL);
            permit.setCurrentStage("ISSUER_APPROVAL");

        } else {

            permit.setPermitStatus(PermitStatus.ELECTRICAL_ISOLATION);
            permit.setCurrentStage("ELECTRICAL_ISOLATION");
        }

        Permit savedPermit = permitRepository.save(permit);

        workflowHistoryRepository.save(PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(issuer)
                        .action(electricalIsolationRequired ? PermitWorkflowAction.ELECTRICAL_ISOLATION : PermitWorkflowAction.ASSESSMENT_COMPLETED)
                        .statusAfterAction(savedPermit.getPermitStatus())
                        .stage(savedPermit.getCurrentStage())
                        .remarks(electricalIsolationRequired ? "Assessment completed. Electrical isolation required."
                                        : "Assessment, post-work measures and issuer approval completed."
                        )
                        .actionDateTime(LocalDateTime.now())
                        .build()
        );
        return mapToResponse(savedPermit);
    }


    private void saveHazards(Permit permit, PermitAssessmentRequest request) {

        permitHazardRepository.deleteByPermit(permit);

        if (request.getHazardIds() == null || request.getHazardIds().isEmpty()) {
            return;
        }

        request.getHazardIds()
                .stream()
                .distinct()
                .forEach(hazardId -> {
                    HazardMaster hazard = hazardMasterRepository
                                    .findById(hazardId).orElseThrow(() ->new RuntimeException("Hazard not found: " + hazardId));

                    PermitHazard permitHazard = PermitHazard.builder()
                                    .permit(permit)
                                    .hazard(hazard)
                                    .build();
                    permitHazardRepository.save(permitHazard);
                });
    }


    private void saveChecklistResponses(Permit permit, PermitAssessmentRequest request, User issuer) {

        var existingResponses = checklistResponseRepository.findByPermit(permit);
        for (PermitChecklistResponse response : existingResponses
        ) {

            checklistResponseFieldRepository.deleteByResponse(response);
        }

        checklistResponseRepository.deleteByPermit(permit);
        Map<Long, ChecklistResponseRequest> checklistResponses = request.getChecklistResponses();

        if (checklistResponses == null || checklistResponses.isEmpty()) {
            return;
        }

        checklistResponses.forEach(
                (checklistId, responseRequest) -> {

                    if (responseRequest == null) {
                        return;
                    }

                    if ( responseRequest.getChecklistId() == null
                    ) {
                        responseRequest.setChecklistId(checklistId);
                    }

                    ChecklistMaster checklist = checklistMasterRepository
                                    .findById(checklistId)
                                    .orElseThrow(() -> new RuntimeException(
                                                    "Checklist not found: "+ checklistId
                                            ));

                    PermitChecklistResponse response =  PermitChecklistResponse.builder()
                                    .permit(permit)
                                    .checklist(checklist)
                                    .questionCode(checklist.getQuestionCode())
                                    .questionText(checklist.getQuestionText())
                                    .response(responseRequest.getResponse())
                                    .measureImplementedBy(issuer)
                                    .measureImplementedAt(LocalDateTime.now())
                                    .build();


                    PermitChecklistResponse savedResponse = checklistResponseRepository.save(response);
                    Map<Long, String> fieldValues =  responseRequest.getFieldValues();

                    if (fieldValues == null || fieldValues.isEmpty()
                    ) {
                        return;
                    }

                    fieldValues.forEach((fieldId, fieldValue) -> {

                                if (fieldValue == null ||fieldValue.isBlank()
                                ) {
                                    return;
                                }
                                ChecklistFieldMaster field = checklistFieldMasterRepository
                                                .findById(fieldId)
                                                .orElseThrow(() ->new RuntimeException("Checklist field not found: " + fieldId));

                                PermitChecklistResponseField responseField = PermitChecklistResponseField.builder()
                                                .response(savedResponse)
                                                .field(field)
                                                .fieldCode(field.getFieldCode())
                                                .fieldLabel(field.getFieldLabel())
                                                .fieldValue(fieldValue)
                                                .build();

                                checklistResponseFieldRepository.save(responseField);
                            }
                    );
                }
        );
    }

    private boolean isElectricalIsolationRequired(PermitAssessmentRequest request) {

        Map<Long, ChecklistResponseRequest> responses = request.getChecklistResponses();
        if (responses == null || responses.isEmpty()) {
            return false;
        }
        for (ChecklistResponseRequest response : responses.values()
        ) {
            if (response == null || response.getChecklistId() == null) {
                continue;
            }
            ChecklistMaster checklist =  checklistMasterRepository
                            .findById(response.getChecklistId())
                            .orElse(null);

            if (checklist == null) {
                continue;
            }

            if ("D-3".equals(checklist.getQuestionCode()
            )) {
                return "YES".equalsIgnoreCase(
                        response.getResponse()
                );
            }
        }
        return false;
    }
    private void savePostWorkMeasures(Permit permit, PermitAssessmentRequest request, User issuer) {

        postWorkMeasureRepository.deleteByPermit(permit);

        if (request.getPostWorkMeasures() == null || request.getPostWorkMeasures().isEmpty()
        ) {
            return;
        }

        request.getPostWorkMeasures().forEach(measureRequest -> {
                    String itemText =

                            switch (measureRequest.getItemCode()
                                    ) {
                                case "E-1" ->
                                        "All tools and garbage removed from work place and area is clean and safe for working";
                                case "E-2" ->
                                        "Other";
                                default -> throw new RuntimeException(
                                                "Invalid post-work measure: "
                                                        + measureRequest
                                                        .getItemCode()
                                        );
                            };


                    PermitPostWorkMeasure measure =  PermitPostWorkMeasure.builder()
                                    .permit(permit)
                                    .itemCode(measureRequest.getItemCode())
                                    .itemText(itemText)
                                    .response(measureRequest.getResponse())
                                    .otherText(measureRequest.getOtherText())
                                    .answeredBy(issuer)
                                    .answeredAt(LocalDateTime.now())
                                    .build();

                    postWorkMeasureRepository.save(measure);
                });
    }

    private PermitResponse mapToResponse(Permit permit) {

        return PermitResponse.builder()
                .id(permit.getId())
                .permitNumber(permit.getPermitNumber())
                .permitType(permit.getPermitType().getPermitName())
                .permitTypeId(permit.getPermitType().getId())
                .issuerName(permit.getIssuer().getFirstName()+ " "+ permit.getIssuer().getLastName())
                .issuerDepartment(permit.getIssuerDepartment().getDepartmentName())
                .acceptorName(permit.getAcceptor().getFirstName()+ " "+ permit.getAcceptor().getLastName())
                .acceptorDepartment(permit.getAcceptorDepartment().getDepartmentName())
                .contractorDeployed(permit.getContractorDeployed())
                .contractorName(permit.getContractor() != null? permit.getContractor().getContractorName(): null)
                .contractorSupervisor(permit.getContractorSupervisor())
                .equipmentNumber(permit.getEquipmentNumber())
                .location(permit.getLocation())
                .proposedWork(permit.getProposedWork())
                .liftShiftByEquipment(permit.getLiftShiftByEquipment())
                .hazardousChemicalExposure(permit.getHazardousChemicalExposure())
                .otherHazardActivity(permit.getOtherHazardActivity())
                .validOnDate(permit.getValidOnDate())
                .timeFrom(permit.getTimeFrom())
                .timeTo(permit.getTimeTo())
                .status(permit.getPermitStatus())
                .currentStage(permit.getCurrentStage())
                .build();
    }
}