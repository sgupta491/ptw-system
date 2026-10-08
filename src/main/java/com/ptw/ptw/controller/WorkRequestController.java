package com.ptw.ptw.controller;

import com.ptw.ptw.dto.WorkRequestCompletionRequest;
import com.ptw.ptw.dto.WorkRequestCreationRequest;
import com.ptw.ptw.dto.WorkRequestResponse;
import com.ptw.ptw.entity.User;
import com.ptw.ptw.repository.MaintenanceTypeMasterRepository;
import com.ptw.ptw.repository.UserRepository;
import com.ptw.ptw.repository.WorkRequestTradeMasterRepository;
import com.ptw.ptw.service.WorkRequestService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;

@Controller
@RequiredArgsConstructor
public class WorkRequestController {

    private final WorkRequestService workRequestService;
    private final WorkRequestTradeMasterRepository tradeMasterRepository;
    private final MaintenanceTypeMasterRepository maintenanceTypeMasterRepository;
    private final UserRepository userRepository;


    @GetMapping("/issuer/permits/{permitId}/work-request")
    public String openWorkRequest(@PathVariable Long permitId,  Principal principal, Model model) {

        String username = principal.getName();

        User issuer = userRepository.findByUsernameWithDepartment(username)
                .orElseThrow(() -> new RuntimeException("Logged-in user not found"));
        model.addAttribute("issuer", issuer);

        model.addAttribute("issuerDepartmentName",issuer.getDepartment() != null ? issuer.getDepartment().getDepartmentName(): "");
        model.addAttribute("issuerName",((issuer.getFirstName() != null ? issuer.getFirstName() : "") + " " +
                        (issuer.getLastName() != null ? issuer.getLastName() : "")).trim());

        model.addAttribute("issuerContactNumber", issuer.getContactNumber());

        try {
            WorkRequestResponse existing = workRequestService.getWorkRequestForIssuer(permitId, username);
            model.addAttribute("workRequest", existing);
            model.addAttribute("existingWorkRequest", true);

        } catch (RuntimeException ex) {
            model.addAttribute("workRequest",new WorkRequestCreationRequest());
            model.addAttribute("existingWorkRequest", false);
        }

        model.addAttribute("workTypes", tradeMasterRepository.findByActiveTrueOrderByTradeNameAsc());
        model.addAttribute("maintenanceTypes", maintenanceTypeMasterRepository.findByActiveTrueOrderByMaintenanceNameAsc());
        model.addAttribute("permitId", permitId);

        return "issuer/work-request";
    }

    // ISSUER - CREATE WORK REQUEST

    @PostMapping("/issuer/permits/{permitId}/work-request")
    public String createWorkRequest(@PathVariable Long permitId, @ModelAttribute WorkRequestCreationRequest request,
                                    Principal principal, RedirectAttributes redirectAttributes) {

        try {

            workRequestService.createWorkRequest(permitId, request, principal.getName());
            redirectAttributes.addFlashAttribute("successMessage",
                    "Work order request created successfully.");

            return "redirect:/issuer/permits/" + permitId + "/work-request";

        }catch (RuntimeException ex) {

            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage","Failed to create work order request.");
            return "issuer/work-request";
        }
    }

    // MAINTENANCE - WORK ORDER LIST

    @GetMapping("/maintenance/work-orders")
    public String workOrderList(Principal principal, Model model) {

        model.addAttribute("workOrders",workRequestService.findPendingWorkRequests(principal.getName()));
        return "maintenance/work-order-list";
    }

    // MAINTENANCE - OPEN WORK ORDER

    @GetMapping("/maintenance/work-orders/{workRequestId}")
    public String openWorkOrder(@PathVariable Long workRequestId, Principal principal, Model model, RedirectAttributes redirectAttributes) {

        WorkRequestResponse workRequest = workRequestService.getWorkRequestForMaintenance
                (workRequestId,principal.getName());
        model.addAttribute("workRequest",workRequest);
        model.addAttribute("workTypes",tradeMasterRepository.findByActiveTrueOrderByTradeNameAsc());
        redirectAttributes.addFlashAttribute("successMessage", "Work order request completed successfully.");
        return "maintenance/work-order";
    }

    // MAINTENANCE - SUBMIT / COMPLETE

    @PostMapping("/maintenance/work-orders/{workRequestId}/complete")
    public String completeWorkOrder(@PathVariable Long workRequestId,
            @ModelAttribute WorkRequestCompletionRequest request,Principal principal, RedirectAttributes redirectAttributes) {

        try {
            WorkRequestResponse response = workRequestService.completeWorkRequest(
                    workRequestId, request, principal.getName());
            redirectAttributes.addFlashAttribute("successMessage", "Work order request completed successfully.");
            return "redirect:/maintenance/work-orders/" + response.getId();
        }
        catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage","Failed to complete work order request.");
            return "redirect:/maintenance/work-orders";
        }
    }
}