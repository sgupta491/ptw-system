package com.ptw.ptw.controller;

import com.ptw.ptw.dto.*;
import com.ptw.ptw.entity.User;
import com.ptw.ptw.enums.ElectricalIsolationStatus;
import com.ptw.ptw.enums.PermitStatus;
import com.ptw.ptw.service.*;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import org.springframework.core.io.Resource;
import org.springframework.http.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;

import java.util.List;

@Controller
@RequestMapping("/issuer/permits")
@RequiredArgsConstructor
public class IssuerPermitController {

    private final PermitService permitService;
    private final PermitTypeService permitTypeService;
    private final ContractorService contractorService;
    private final DepartmentService departmentService;
    private final UserService userService;
    private final HazardService hazardService;
    private final ChecklistService checklistService;
    private final PermitAssessmentService permitAssessmentService;
    private final WorkRequestService workRequestService;


    @GetMapping
    public String issuerPermits(Authentication authentication,Model model) {
        String username = authentication.getName();
        model.addAttribute("permits", permitService.findPermitsByIssuer(username));
        return "issuer/permit-list";
    }


    @GetMapping("/new")
    public String newPermit(Authentication authentication ,Model model) {

        User issuer = userService.findByUsername(authentication.getName());

        model.addAttribute("issuer", issuer);
        model.addAttribute("permitRequest", new PermitRequest());
        loadFormData(model);

        return "issuer/permit-form";
    }


    @PostMapping
    public String createPermit(@Valid @ModelAttribute("permitRequest") PermitCreationRequest request,
                               BindingResult bindingResult, Authentication authentication,Model model,
                               RedirectAttributes redirectAttributes) {

        if(bindingResult.hasErrors()) {
            loadFormData(model);
            return "issuer/permit-form";
        }

        try{
            PermitResponse permit = permitService.createPermit(request, authentication.getName());
            redirectAttributes.addFlashAttribute("successMessage","Permit created successfully.");
            return  "redirect:/issuer/permits/" + permit.getId();
        }
        catch(RuntimeException e){

            model.addAttribute("error", e.getMessage());
            loadIssuer(authentication, model);
            loadFormData(model);
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to create permit.");
            return "issuer/permit-form";
        }

    }


    @GetMapping("/{id}")
    public String viewPermit(@PathVariable Long id, Model model) {

        model.addAttribute("permit", permitService.findPermitById(id));
        return "issuer/permit-view";
    }


    @GetMapping("/acceptors")
    @ResponseBody
    public List<AcceptorOption> getAcceptors(@RequestParam Long departmentId) {

        return userService.findActiveByDepartment(departmentId)
                .stream()
                .map(user -> new AcceptorOption(user.getId(),user.getFirstName() +" "+ user.getLastName())
                )
                .toList();
    }


    @GetMapping("/hazards")
    @ResponseBody
    public List<HazardOption> getHazards(@RequestParam Long permitTypeId) {

        return hazardService.findByPermitType(permitTypeId);
    }


    @GetMapping("/{id}/assessment")
    public String assessmentPage(@PathVariable Long id,Authentication authentication, Model model) {

        String username = authentication.getName();

        PermitResponse permit = permitService.getPermitForAssessment( id, username);
        List<HazardOption> hazards = hazardService.findByPermitType(permit.getPermitTypeId());
        List<ChecklistOption> checklistQuestions  = checklistService.findByPermitType(permit.getPermitTypeId());
        PermitAssessmentRequest assessmentRequest = permitAssessmentService.getExistingAssessment(id, username);

        model.addAttribute("permit",permit);
        model.addAttribute("hazards",hazards);
        model.addAttribute("checklistQuestions",checklistQuestions);
        model.addAttribute("assessmentRequest", assessmentRequest);

        boolean assessmentReadOnly = permit.getStatus() == PermitStatus.ELECTRICAL_ISOLATION
                         ||( permit.getStatus() == PermitStatus.PERMIT_ISSUED
                         && "ASSESSMENT_COMPLETED".equals(  permit.getCurrentStage()
        ));

        boolean canPrint = permit.getStatus() == PermitStatus.PERMIT_ISSUED
                        && "ASSESSMENT_COMPLETED".equals(
                        permit.getCurrentStage()
                );

        model.addAttribute("assessmentReadOnly",assessmentReadOnly);
        model.addAttribute("canPrint", canPrint);

        try {
            WorkRequestResponse workRequest = workRequestService.getWorkRequestForIssuer(id, username);
            model.addAttribute("workRequest", workRequest);
        } catch (RuntimeException ignored) {
            // No work request exists.
        }

        return "issuer/permit-assessment";
    }

    @PostMapping("/{id}/assessment")
    public String saveAssessment( @PathVariable Long id,@ModelAttribute("assessmentRequest")
                PermitAssessmentRequest request,Authentication authentication,Model model,RedirectAttributes redirectAttributes) {
        try {

            PermitResponse response = permitAssessmentService.saveAssessment(id,request,authentication.getName());

            if (response.getElectricalIsolationStatus() == ElectricalIsolationStatus.PENDING) {

                redirectAttributes.addFlashAttribute("successMessage",
                        "Assessment saved successfully. Electrical Work Request created.");

                return "redirect:/issuer/permits/" + id + "/work-request";
            }

            redirectAttributes.addFlashAttribute("successMessage",
                    "Assessment completed successfully.");

            permitService.approvePermitForPrint(id,authentication.getName());
            return "redirect:/issuer/permits/"+ id + "/print";


        } catch (RuntimeException e) {

            model.addAttribute("error",e.getMessage());

            PermitResponse permit =permitService.getPermitForAssessment(id, authentication.getName());
            List<HazardOption> hazards = hazardService.findByPermitType(permit.getPermitTypeId());
            List<ChecklistOption> checklistQuestions = checklistService.findByPermitType(permit.getPermitTypeId());

            model.addAttribute("permit",permit);
            model.addAttribute("hazards",hazards);
            model.addAttribute("checklistQuestions",checklistQuestions);
            model.addAttribute("assessmentRequest",request);
            redirectAttributes.addFlashAttribute("errorMessage","Failed to save assessment.");

            return "issuer/permit-assessment";
        }
    }


    @PostMapping("/{id}/print")
    public String startWorkAndPrint(@PathVariable Long id, Authentication authentication, RedirectAttributes redirectAttributes) {

        try {
            permitService.approvePermitForPrint(id, authentication.getName());
            redirectAttributes.addFlashAttribute("successMessage",
                    "Permit approved successfully. Ready for printing.");
            return "redirect:/issuer/permits/" + id + "/print";
        }
             catch (RuntimeException e) {
                redirectAttributes.addFlashAttribute("errorMessage","Failed to approve permit for printing.");

                return "redirect:/issuer/permits/" + id + "/assessment";
            }

    }


    @GetMapping("/{id}/print")
    public String printPermit(@PathVariable Long id, Authentication authentication, Model model) {

        PermitApprovalResponse approval = permitService.getPermitForPrint(id, authentication.getName());
        model.addAttribute("approval", approval);

        return "issuer/permit-print";
    }

    @PostMapping("/{id}/work-completed")
    public String markWorkCompleted(@PathVariable Long id, Authentication authentication, RedirectAttributes redirectAttributes) {

        try {

            permitService.markWorkCompleted(id, authentication.getName());
            redirectAttributes.addFlashAttribute("successMessage",
                    "Work marked as completed successfully.");
             return "redirect:/issuer/permits/" + id;

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Failed to mark work as completed.");

            return "redirect:/issuer/permits";
        }
    }

    @GetMapping("/{id}/documents")
    public String documentsPage( @PathVariable Long id, Authentication authentication, Model model) {

        PermitFullViewResponse fullView = permitService.getFullPermitView(id, authentication.getName());

        model.addAttribute("permit", fullView.getPermit());
        model.addAttribute("documents", fullView.getDocuments());

        return "issuer/permit-documents";
    }


    @GetMapping("/{id}/full-view")
    public String fullPermitView(@PathVariable Long id, Authentication authentication, Model model) {

        PermitFullViewResponse permit = permitService.getFullPermitView(id,authentication.getName());
        model.addAttribute("permit", permit);

        return "issuer/permit-full-view";
    }


    @PostMapping("/{id}/accept-extension")
    public String acceptExtension(@PathVariable Long id, Authentication authentication, RedirectAttributes redirectAttributes) {

        try {
                permitService.acceptExtension(id, authentication.getName());
                 redirectAttributes.addFlashAttribute("successMessage","Extension accepted successfully." );

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage","Failed to accept extension.");
        }

        return "redirect:/issuer/permits";
    }

    @PostMapping("/{id}/reject-extension")
    public String rejectExtension(@PathVariable Long id, @RequestParam(required = false) String rejectionRemark,
                                Authentication authentication, RedirectAttributes redirectAttributes) {

        try {

            permitService.rejectExtension( id, rejectionRemark, authentication.getName());
            redirectAttributes.addFlashAttribute("successMessage","Extension rejected successfully.");

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to reject extension.");
        }

        return "redirect:/issuer/permits";
    }



    @GetMapping("/{id}/extension-form")
    public String extensionForm(@PathVariable Long id, Authentication authentication, Model model,
            RedirectAttributes redirectAttributes) {

        try {
            PermitResponse permit = permitService.getPermitForExtensionPrint(id, authentication.getName());
            model.addAttribute("permit", permit);
            return "issuer/extension-print";

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/issuer/permits";
        }
    }

    @PostMapping("/{id}/extension-form/print")
    public String printExtensionForm( @PathVariable Long id, Authentication authentication,
            Model model, RedirectAttributes redirectAttributes) {

        try {
            PermitResponse permit = permitService.printExtensionForm(id, authentication.getName());
            redirectAttributes.addFlashAttribute(
                    "successMessage",
                    "Extension form prepared for printing successfully."
            );

            model.addAttribute("permit", permit);
            model.addAttribute("autoPrint", true);
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Failed to prepare extension form for printing.");
            return "issuer/extension-print";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/issuer/permits";
        }
    }

    private void loadIssuer(Authentication authentication, Model model) {

        User issuer = userService.findByUsername(authentication.getName());
        model.addAttribute("issuer", issuer);
    }


    private void loadFormData(Model model) {

        model.addAttribute("permitTypes",permitTypeService.findActive());
        model.addAttribute("contractors",contractorService.findAll());
        model.addAttribute("departments",departmentService.findAll());
    }



    @GetMapping("/{permitId}/documents/{documentId}")
    public ResponseEntity<Resource> openDocument(@PathVariable Long permitId, @PathVariable Long documentId,
                                        Authentication authentication) throws IOException {

        Resource resource = permitService.getPermitDocument(permitId, documentId, authentication.getName());
        String contentType = Files.probeContentType(resource.getFile().toPath());

        if (contentType == null) {
            contentType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
        }

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "inline; filename=\"" +
                                resource.getFilename() +
                                "\"")
                .body(resource);
    }
}
