package com.ptw.ptw.controller;

import com.ptw.ptw.dto.*;
import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.User;
import com.ptw.ptw.service.*;
import jakarta.validation.Valid;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import org.springframework.core.io.Resource;
import org.springframework.http.*;

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

    @GetMapping("/new")
    public String newPermit(Authentication authentication ,Model model) {

        User issuer = userService.findByUsername(authentication.getName());

        model.addAttribute("issuer", issuer);
        model.addAttribute("permitRequest", new PermitRequest());
        loadFormData(model);

        return "issuer/permit-form";
    }

    @GetMapping
    public String issuerPermits(Authentication authentication,Model model) {
        String username = authentication.getName();
        model.addAttribute("permits", permitService.findPermitsByIssuer(username));
        return "issuer/permit-list";
    }

    @PostMapping
    public String createPermit(@Valid @ModelAttribute("permitRequest") PermitRequest request,
                               BindingResult bindingResult,
                               Authentication authentication,
                               Model model
                               ) {

        if(bindingResult.hasErrors()) {
            loadFormData(model);
            return "issuer/permit-form";
        }

        try{
            PermitResponse permit = permitService.createPermit(request, authentication.getName());
            return  "redirect:/issuer/permits/" + permit.getId();
        }
        catch(RuntimeException e){

            model.addAttribute("error", e.getMessage());
            loadIssuer(authentication, model);
            loadFormData(model);
            return "issuer/permit-form";
        }

    }


    @GetMapping("/{id}")
    public String viewPermit(@PathVariable Long id, Model model) {

        model.addAttribute("permit", permitService.findPermitById(id));
        return "issuer/permit-view";
    }




    @PostMapping("/{id}/submit")
    public String submitPermit(@PathVariable Long id,Authentication authentication) {

        permitService.submitPermit(id,authentication.getName());
        return "redirect:/issuer/permits/" + id;
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


    @GetMapping("/returned")
    public String returnedPermit(Authentication authentication, Model model)
    {
        model.addAttribute("permits", permitService.findReturnedPermits(authentication.getName()));
        return "issuer/returned-permits";
    }


    @GetMapping("/{id}/edit")
    public String editReturnedPermit(@PathVariable Long id,Authentication authentication,Model model) {

        String username = authentication.getName();

        PermitRequest request = permitService.getReturnedPermitForEdit(id, username);
        PermitResponse permit = permitService.findReturnedPermit(id, username);

        String returnRemarks = permitService.getLatestReturnRemarks(id, username);


        model.addAttribute("permitRequest",request);
        model.addAttribute("permit", permit);
        model.addAttribute("returnRemarks", returnRemarks);
        loadFormData(model);

        return "issuer/permit-edit";
    }


    @PostMapping("/{id}/resubmit")
    public String resubmitReturnedPermit(@PathVariable Long id, @Valid @ModelAttribute("permitRequest")
            PermitRequest request, BindingResult bindingResult, Authentication authentication, Model model) {

        String username = authentication.getName();

        if (bindingResult.hasErrors()) {

            model.addAttribute("permit",permitService.findReturnedPermit(id,username));
            model.addAttribute("returnRemarks",permitService.getLatestReturnRemarks(id,username));
            loadFormData(model);
            return "issuer/permit-edit";
        }

        try {
            permitService.resubmitReturnedPermit(id, request,username);
            return "redirect:/issuer/permits";

        } catch (RuntimeException e) {

            model.addAttribute("error",e.getMessage());
            model.addAttribute("permit", permitService.findReturnedPermit(id, username ));
            model.addAttribute("returnRemarks",permitService.getLatestReturnRemarks(id,username));
            loadFormData(model);
            return "issuer/permit-edit";
        }
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

        model.addAttribute("permit",permit);
        model.addAttribute("hazards",hazards);
        model.addAttribute("checklistQuestions",checklistQuestions);
        model.addAttribute("assessmentRequest", new PermitAssessmentRequest()
        );

        return "issuer/permit-assessment";
    }

    @PostMapping("/{id}/assessment")
    public String saveAssessment( @PathVariable Long id,@ModelAttribute("assessmentRequest")
                PermitAssessmentRequest request,Authentication authentication,Model model) {
        try {

            permitAssessmentService.saveAssessment(id,request,authentication.getName());

            return "redirect:/issuer/permits/{id}/approval";
        } catch (RuntimeException e) {

            model.addAttribute("error",e.getMessage());

            PermitResponse permit =permitService.getPermitForAssessment(id, authentication.getName());
            List<HazardOption> hazards = hazardService.findByPermitType(permit.getPermitTypeId());
            List<ChecklistOption> checklistQuestions = checklistService.findByPermitType(permit.getPermitTypeId());

            model.addAttribute("permit",permit);
            model.addAttribute("hazards",hazards);
            model.addAttribute("checklistQuestions",checklistQuestions);
            model.addAttribute("assessmentRequest",request);

            return "issuer/permit-assessment";
        }
    }

    @GetMapping("/{id}/approval")
    public String issuerApprovalPage(@PathVariable Long id, Authentication authentication,Model model) {

        PermitApprovalResponse  approval  = permitService.getPermitForIssuerApproval(id,authentication.getName());
        model.addAttribute("approval", approval );

        return "issuer/permit-approval";
    }

    @PostMapping("/{id}/approve-print")
    public String approveForPrint(@PathVariable Long id, Authentication authentication) {

        permitService.approvePermitForPrint(id,authentication.getName());
        return "redirect:/issuer/permits/" + id + "/print";
    }

    @GetMapping("/{id}/print")
    public String printPermit(@PathVariable Long id, Authentication authentication,Model model) {

        PermitApprovalResponse approval = permitService.getPermitForPrint(id,authentication.getName());
        model.addAttribute("approval", approval);

        return "issuer/permit-print";
    }

    @GetMapping("/{id}/final-verification")
    public String finalVerificationPage(@PathVariable Long id, Authentication authentication, Model model) {

        PermitResponse permit =permitService.getPermitForFinalVerification(id,authentication.getName());

        PermitFullViewResponse fullresponse =permitService.getFullPermitView(id, authentication.getName());
        List<PermitDocumentViewResponse> documents = fullresponse.getDocuments();

        model.addAttribute("permit", permit);
        model.addAttribute("documents", documents);

        return "issuer/permit-final-verification";
    }

    @PostMapping("/{id}/final-verification")
    public String completeFinalVerification(@PathVariable Long id,@ModelAttribute FinalVerificationRequest request,
            Authentication authentication) {

        permitService.completeFinalVerification(id,request,authentication.getName());

        return "redirect:/issuer/permits";
    }

    @GetMapping("/{id}/full-view")
    public String fullPermitView(@PathVariable Long id, Authentication authentication, Model model) {

        PermitFullViewResponse permit = permitService.getFullPermitView(id,authentication.getName());
        model.addAttribute("permit", permit);

        return "issuer/permit-full-view";
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
