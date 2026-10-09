package com.ptw.ptw.service.impl;

import com.ptw.ptw.dto.WorkRequestCompletionRequest;
import com.ptw.ptw.dto.WorkRequestCreationRequest;
import com.ptw.ptw.dto.WorkRequestResponse;
import com.ptw.ptw.entity.Department;
import com.ptw.ptw.entity.MaintenanceTypeMaster;
import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.User;
import com.ptw.ptw.entity.WorkRequest;
import com.ptw.ptw.entity.WorkRequestTradeMaster;
import com.ptw.ptw.enums.ElectricalIsolationStatus;
import com.ptw.ptw.enums.PermitStatus;
import com.ptw.ptw.enums.PermitWorkflowAction;
import com.ptw.ptw.enums.WorkRequestStatus;
import com.ptw.ptw.repository.MaintenanceTypeMasterRepository;
import com.ptw.ptw.repository.PermitRepository;
import com.ptw.ptw.repository.UserRepository;
import com.ptw.ptw.repository.WorkRequestRepository;
import com.ptw.ptw.repository.WorkRequestTradeMasterRepository;
import com.ptw.ptw.entity.PermitWorkflowHistory;
import com.ptw.ptw.repository.PermitWorkflowHistoryRepository;
import com.ptw.ptw.service.EmailNotificationService;
import com.ptw.ptw.service.WorkRequestService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class WorkRequestServiceImpl implements WorkRequestService {

    private final WorkRequestRepository workRequestRepository;
    private final PermitRepository permitRepository;
    private final UserRepository userRepository;
    private final WorkRequestTradeMasterRepository tradeMasterRepository;
    private final MaintenanceTypeMasterRepository maintenanceTypeMasterRepository;
    private final PermitWorkflowHistoryRepository workflowHistoryRepository;
    private final EmailNotificationService emailNotificationService;

    @Override
    public WorkRequestResponse createWorkRequest(Long permitId, WorkRequestCreationRequest request, String username) {

        User requester = getUser(username);

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found"));

        if (permit.getIssuer() == null || !permit.getIssuer().getId().equals(requester.getId())) {
            throw new RuntimeException("You are not authorized to create work request for this permit");
        }

        if (!Boolean.TRUE.equals(permit.getElectricalIsolationRequired())) {
            throw new RuntimeException( "Electrical isolation is not required for this permit");
        }

        if (permit.getPermitStatus() != PermitStatus.ELECTRICAL_ISOLATION
                && permit.getPermitStatus() != PermitStatus.PERMIT_ISSUED) {
            throw new RuntimeException( "Work request cannot be created in current permit status");
        }

        if (workRequestRepository.existsByPermit(permit)) {
            throw new RuntimeException( "Electrical isolation work request already exists for this permit");
        }

        Department department = requester.getDepartment();

        if (department == null) {
            throw new RuntimeException("Requester department is not assigned");
        }

        WorkRequestTradeMaster trade = tradeMasterRepository.findById(request.getWorkToBeDoneById())
                        .orElseThrow(() -> new RuntimeException("Work type not found"));

        if (!Boolean.TRUE.equals(trade.getActive())) {
            throw new RuntimeException("Selected work type is inactive");}

        MaintenanceTypeMaster maintenanceType = maintenanceTypeMasterRepository.findById(request.getMaintenanceTypeId())
                        .orElseThrow(() -> new RuntimeException("Maintenance type not found"));

        if (!Boolean.TRUE.equals(maintenanceType.getActive())) {
            throw new RuntimeException("Selected maintenance type is inactive");
        }

        validateCreationRequest(request);

        WorkRequest workRequest = WorkRequest.builder()
                                .woNumber("TEMP")
                                .permit(permit)
                                .requestingDepartment(department)
                                .requester(requester)
                                .requestDate(request.getRequestDate())
                                .requestTime(request.getRequestTime())
                                .workLocation(request.getWorkLocation().trim())
                                .requesterContactNumber(requester.getContactNumber())
                                .workToBeDoneBy(trade)
                                .maintenanceType(maintenanceType)
                                .equipmentNumber(trimToNull(request.getEquipmentNumber()))
                                .equipmentLocation(trimToNull(request.getEquipmentLocation()))
                                .jobDescription(trimToNull(request.getJobDescription()))
                                .recommendedPpe(trimToNull(request.getRecommendedPpe()))
                                .status(WorkRequestStatus.PENDING)
                                .build();

        WorkRequest saved = workRequestRepository.save(workRequest);

        // Generate global WO number

        String departmentCode = department.getDepartmentCode();

        if (departmentCode == null || departmentCode.isBlank()) {
            throw new RuntimeException("Department code is not configured");
        }

        String woNumber = String.format("%s/%02d",
                departmentCode.toUpperCase(),
                saved.getId()
        );
        saved.setWoNumber(woNumber);

        // Permit electrical isolation pending

        permit.setElectricalIsolationRequired(true);
        permit.setElectricalIsolationStatus(ElectricalIsolationStatus.PENDING);
        permit.setPermitStatus(PermitStatus.ELECTRICAL_ISOLATION);
        permit.setCurrentStage("ELECTRICAL_ISOLATION");
        Permit savedPermit = permitRepository.save(permit);

        workflowHistoryRepository.save(PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(requester)
                        .action(PermitWorkflowAction.ELECTRICAL_ISOLATION)
                        .statusAfterAction(PermitStatus.ELECTRICAL_ISOLATION)
                        .stage("ELECTRICAL_ISOLATION")
                        .remarks("Electrical isolation work request " + woNumber + " created.")
                        .actionDateTime(LocalDateTime.now())
                        .build()
        );

        List<String> maintenanceEmails = userRepository.findByRole_RoleNameAndActiveTrue("MAINTENANCE")
                        .stream()
                        .map(User::getEmail)
                        .filter(email -> email != null && !email.isBlank())
                        .distinct()
                        .toList();

        emailNotificationService.sendWorkRequestCreatedEmail(saved, maintenanceEmails);

        return mapToResponse(workRequestRepository.save(saved));
    }


    // ISSUER - VIEW WORK REQUEST

    @Override
    @Transactional(readOnly = true)
    public WorkRequestResponse getWorkRequestForIssuer(Long permitId, String username) {

        User issuer = getUser(username);

        Permit permit = permitRepository.findById(permitId)
                .orElseThrow(() -> new RuntimeException("Permit not found" ));

        if (permit.getIssuer() == null || !permit.getIssuer().getId().equals(issuer.getId())) {
            throw new RuntimeException("You are not authorized to view this work request");}

        WorkRequest workRequest = workRequestRepository.findByPermit(permit)
                        .orElseThrow(() -> new RuntimeException("Work request not found"));

        return mapToResponse(workRequest);
    }

    // MAINTENANCE - PENDING LIST

    @Override
    @Transactional(readOnly = true)
    public List<WorkRequestResponse> findPendingWorkRequests(String username) {

        requireMaintenanceUser();
        getUser(username);

        return workRequestRepository.findAllByOrderByIdDesc()
                .stream().map(this::mapToResponse).toList();
    }


    // MAINTENANCE - VIEW WORK ORDER

    @Override
    @Transactional(readOnly = true)
    public WorkRequestResponse getWorkRequestForMaintenance(Long workRequestId, String username) {

        requireMaintenanceUser();
        getUser(username);

        WorkRequest workRequest = workRequestRepository.findById(workRequestId)
                        .orElseThrow(() -> new RuntimeException("Work request not found" ));

        return mapToResponse(workRequest);
    }


    // MAINTENANCE - COMPLETE WORK REQUEST

    @Override
    public WorkRequestResponse completeWorkRequest( Long workRequestId, WorkRequestCompletionRequest request, String username) {

        requireMaintenanceUser();
        User maintenanceUser = getUser(username);

        WorkRequest workRequest = workRequestRepository.findById(workRequestId)
                        .orElseThrow(() -> new RuntimeException("Work request not found"));


        if (workRequest.getStatus() != WorkRequestStatus.PENDING) {
            throw new RuntimeException("This work request has already been completed");
        }

        validateCompletionRequest(request);

        WorkRequestTradeMaster assignedTrade = tradeMasterRepository.findById(request.getWorkAssignedToId())
                        .orElseThrow(() -> new RuntimeException("Assigned work type not found"));

        if (!Boolean.TRUE.equals(assignedTrade.getActive())) {
            throw new RuntimeException("Selected assigned work type is inactive");
        }

        workRequest.setWorkAssignedTo(assignedTrade);
        workRequest.setAssignedName(request.getAssignedName().trim());
        workRequest.setWorkStartedAt(request.getWorkStartedAt());
        workRequest.setIsolationEquipmentNumber(request.getIsolationEquipmentNumber().trim());
        workRequest.setFeederNumber(request.getFeederNumber().trim());
        workRequest.setLotoNumber(request.getLotoNumber().trim());
        workRequest.setWorkCompletedBy(request.getAssignedName().trim());
        workRequest.setCompletedAt(request.getCompletedAt());
        workRequest.setStatus(WorkRequestStatus.COMPLETED);
        workRequest.setUpdatedAt(LocalDateTime.now());

        WorkRequest savedWorkRequest = workRequestRepository.save(workRequest);


        Permit permit = workRequest.getPermit();
        permit.setElectricalIsolationStatus(ElectricalIsolationStatus.COMPLETED);
        permit.setPermitStatus(PermitStatus.PERMIT_ISSUED);
        permit.setCurrentStage("ASSESSMENT_COMPLETED");
        Permit savedPermit =permitRepository.save(permit);


        // Workflow history

        workflowHistoryRepository.save(PermitWorkflowHistory.builder()
                        .permit(savedPermit)
                        .actionBy(maintenanceUser)
                        .action(PermitWorkflowAction.ASSESSMENT_COMPLETED)
                        .statusAfterAction(PermitStatus.PERMIT_ISSUED)
                        .stage("ASSESSMENT_COMPLETED")
                        .remarks("Electrical isolation completed. "+ "WO "
                                        + workRequest.getWoNumber() + " completed.")
                        .actionDateTime(LocalDateTime.now())
                        .build()
        );

        // Notify the original Issuer after electrical isolation is completed.
        emailNotificationService.sendWorkRequestCompletedEmail(workRequest);
        return mapToResponse(savedWorkRequest);
    }


    // =========================================================
    // VALIDATION
    // =========================================================

    private void validateCreationRequest(WorkRequestCreationRequest request)
    {

        if (request.getRequestDate() == null) {
            throw new RuntimeException("Request date is required" );
        }

        if (request.getRequestTime() == null) {
            throw new RuntimeException("Request time is required");
        }

        if (isBlank(request.getWorkLocation())) {
            throw new RuntimeException("Work location is required");
        }

        if (request.getWorkToBeDoneById() == null) {
            throw new RuntimeException("Work to be done by is required");
        }

        if (request.getMaintenanceTypeId() == null) {
            throw new RuntimeException("Maintenance type is required");
        }

        if (isBlank(request.getEquipmentNumber())) {
            throw new RuntimeException("Equipment number is required");
        }

        if (isBlank(request.getJobDescription())) {
            throw new RuntimeException("Job description is required");
        }
    }


    private void validateCompletionRequest(WorkRequestCompletionRequest request
    ) {

        if (request.getWorkAssignedToId() == null) {
            throw new RuntimeException("Work assigned to is required");
        }

        if (isBlank(request.getAssignedName())) {
            throw new RuntimeException("Name is required");
        }

        if (request.getWorkStartedAt() == null) {
            throw new RuntimeException("Work started time is required");
        }

        if (isBlank(request.getIsolationEquipmentNumber())) {
            throw new RuntimeException("Equipment number is required");
        }

        if (isBlank(request.getFeederNumber())) {
            throw new RuntimeException("Feeder number is required");
        }

        if (isBlank(request.getLotoNumber())) {
            throw new RuntimeException("LOTO number is required");
        }

        if (request.getCompletedAt() == null) {
            throw new RuntimeException("Completion time is required");
        }
    }



    // SECURITY

    private void requireMaintenanceUser() {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            throw new RuntimeException("User is not authenticated");
        }

        boolean maintenance = authentication.getAuthorities()
                        .stream()
                        .anyMatch(authority ->"ROLE_MAINTENANCE"
                                        .equals(authority.getAuthority()));

        if (!maintenance) {
            throw new RuntimeException("Only maintenance users can access work orders");
        }
    }

    private User getUser(String username) {
        return userRepository.findByUsername(username).orElseThrow(() ->
                        new RuntimeException("User not found"));
    }

    // MAPPING

    private WorkRequestResponse mapToResponse(WorkRequest workRequest) {

        Permit permit = workRequest.getPermit();

        return WorkRequestResponse.builder()
                .id(workRequest.getId())
                .woNumber(workRequest.getWoNumber())
                .permitId(permit != null ? permit.getId() : null)
                .permitNumber( permit != null ? permit.getPermitNumber(): null)
                .requestingDepartment( workRequest.getRequestingDepartment() != null ? workRequest.getRequestingDepartment().getDepartmentName(): null)
                .requesterName(workRequest.getRequester() != null ? getFullName(workRequest.getRequester()) : null)
                .requesterContactNumber(workRequest.getRequesterContactNumber())
                .requestDate(workRequest.getRequestDate())
                .requestTime(workRequest.getRequestTime())
                .workLocation(workRequest.getWorkLocation())
                .workToBeDoneById(workRequest.getWorkToBeDoneBy() != null ? workRequest.getWorkToBeDoneBy().getId(): null)
                .workToBeDoneBy(workRequest.getWorkToBeDoneBy() != null ? workRequest.getWorkToBeDoneBy().getTradeName(): null)
                .maintenanceTypeId(workRequest.getMaintenanceType() != null ? workRequest.getMaintenanceType().getId() : null)
                .maintenanceType(workRequest.getMaintenanceType()!= null ? workRequest.getMaintenanceType().getMaintenanceName() : null)
                .equipmentNumber(workRequest.getEquipmentNumber())
                .equipmentLocation(workRequest.getEquipmentLocation())
                .jobDescription(workRequest.getJobDescription())
                .recommendedPpe(workRequest.getRecommendedPpe())
                .workAssignedToId(workRequest.getWorkAssignedTo() != null? workRequest.getWorkAssignedTo().getId(): null)
                .workAssignedTo(workRequest.getWorkAssignedTo()!= null ? workRequest.getWorkAssignedTo().getTradeName() : null)
                .assignedName(workRequest.getAssignedName())
                .workStartedAt(workRequest.getWorkStartedAt())
                .isolationEquipmentNumber(workRequest.getIsolationEquipmentNumber())
                .feederNumber(workRequest.getFeederNumber())
                .lotoNumber(workRequest.getLotoNumber())
                .workCompletedBy(workRequest.getWorkCompletedBy())
                .completedAt(workRequest.getCompletedAt())
                .status(workRequest.getStatus())
                .createdAt(workRequest.getCreatedAt() )
                .updatedAt(workRequest.getUpdatedAt())
                .build();
    }

    private String getFullName(User user) {

        String firstName = user.getFirstName() != null? user.getFirstName().trim() : "";
        String lastName = user.getLastName() != null? user.getLastName().trim() : "";
        return (firstName + " " + lastName).trim();
    }

    private String trimToNull(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return value.trim();
    }

    private boolean isBlank(String value) {
        return value == null|| value.isBlank();
    }
}