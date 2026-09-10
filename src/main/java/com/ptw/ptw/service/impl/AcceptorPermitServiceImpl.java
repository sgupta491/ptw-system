package com.ptw.ptw.service.impl;

import com.ptw.ptw.dto.AcceptorReviewRequest;
import com.ptw.ptw.dto.PermitRequest;
import com.ptw.ptw.dto.PermitResponse;
import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.PermitWorkflowHistory;
import com.ptw.ptw.entity.User;
import com.ptw.ptw.enums.PermitStatus;
import com.ptw.ptw.enums.PermitWorkflowAction;
import com.ptw.ptw.repository.PermitRepository;
import com.ptw.ptw.repository.PermitWorkflowHistoryRepository;
import com.ptw.ptw.repository.UserRepository;
import com.ptw.ptw.service.AcceptorPermitService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class AcceptorPermitServiceImpl implements AcceptorPermitService {

    private final PermitRepository permitRepository;
    private final UserRepository userRepository;
    private final PermitWorkflowHistoryRepository permitWorkflowHistoryRepository;

    @Override
    public List<PermitResponse> findPendingPermits(String username) {

        User acceptor = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

      /*  return permitRepository.findByAcceptorIdAndPermitStatus(acceptor.getId(), PermitStatus.ACCEPTOR_VERIFICATION)
                .stream()
                .map(this::mapToResponse)
                .toList();*/

        List<PermitStatus> pendingStatuses = List.of(
                PermitStatus.ACCEPTOR_VERIFICATION,
                PermitStatus.READY_FOR_PRINT,
                PermitStatus.ACTIVE
        );

        return permitRepository.findByAcceptorIdAndPermitStatusInOrderByIdDesc(acceptor.getId(),pendingStatuses)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }


    @Override
    public PermitResponse findPermitForAcceptor(Long permitId, String username) {

        Permit permit = findPermit(permitId);
        validateAcceptor(permit, username);

        return mapToResponse(permit);
    }



    @Override
    public PermitResponse reviewPermit(Long permitId, AcceptorReviewRequest request, String username) {

        Permit permit = findPermit(permitId);
        validateAcceptor(permit, username);

        if(permit.getPermitStatus() != PermitStatus.ACCEPTOR_VERIFICATION)
        {
            throw new RuntimeException("Permit is not available for Acceptor verification");
        }

        User acceptor = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Acceptor not found"));

        PermitWorkflowAction action = request.getAction();
        String remarks = request.getRemarks();
        if(action == PermitWorkflowAction.VERIFY_AND_ACCEPT)
        {
            if (remarks == null || remarks.isBlank()) {
                remarks = "Permit verified and accepted";
            }
            permit.setPermitStatus(PermitStatus.ACCEPTOR_VERIFIED);
            permit.setCurrentStage("ACCEPTOR_VERIFIED");
        }
        else if (action == PermitWorkflowAction.SENT_BACK) {

            if(request.getRemarks() == null || request.getRemarks().isBlank())
            {
                throw new RuntimeException("Remarks are mandatory.");
            }

            permit.setPermitStatus(PermitStatus.RETURNED);
            permit.setCurrentStage("ISSUER_CORRECTION");
        }
        else {
            throw new RuntimeException("Invalid acceptor  action.");
        }


        Permit savedPermit = permitRepository.save(permit);

        PermitWorkflowHistory history = PermitWorkflowHistory.builder()
                .permit(savedPermit)
                .actionBy(acceptor)
                .action(action)
                .statusAfterAction(savedPermit.getPermitStatus())
                .stage(savedPermit.getCurrentStage())
                .remarks(remarks)
                .actionDateTime(LocalDateTime.now())
                .build();

        permitWorkflowHistoryRepository.save(history);

        return mapToResponse(savedPermit);
    }


    private PermitResponse mapToResponse(Permit permit) {

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
