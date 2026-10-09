package com.ptw.ptw.controller;

import com.ptw.ptw.dto.*;
import com.ptw.ptw.service.AcceptorPermitService;
import com.ptw.ptw.service.ContractorService;
import com.ptw.ptw.service.PermitService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
@RequestMapping("/acceptor/permits")
@RequiredArgsConstructor
public class AcceptorPermitController {

    private final AcceptorPermitService acceptorPermitService;
    private final PermitService permitService;
    private final ContractorService contractorService;

    @GetMapping
    public String pendingPermits(Authentication authentication, Model model) {

        model.addAttribute("permits", acceptorPermitService.findPendingPermits(authentication.getName()));
        return "acceptor/permit-list";
    }


    @GetMapping("/{id}")
    public String viewPermit(@PathVariable Long id , Authentication authentication, Model model)
    {
        PermitResponse response =  acceptorPermitService.findPermitForAcceptor(id,authentication.getName());
         model.addAttribute("permit", response);
        model.addAttribute("sectionBRequest", new PermitSectionBRequest());
        model.addAttribute("contractors",contractorService.findAll());

         return "acceptor/permit-review";
    }

    @PostMapping("/{id}/section-b")
    public String submitSectionB(@PathVariable Long id, @Valid @ModelAttribute("sectionBRequest") PermitSectionBRequest request,
                            BindingResult bindingResult, Authentication authentication, Model model,  RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("permit",acceptorPermitService.findPermitForAcceptor(id,authentication.getName())
            );
            return "acceptor/permit-review";
        }
        try {
            acceptorPermitService.submitSectionB(id,request, authentication.getName());
            redirectAttributes.addFlashAttribute("successMessage","Permit issued successfully.");
            return "redirect:/acceptor/permits";

        } catch (RuntimeException e) {

            model.addAttribute("error", e.getMessage());
            model.addAttribute("permit", acceptorPermitService.findPermitForAcceptor( id, authentication.getName()));
            model.addAttribute("contractors",contractorService.findAll());
            redirectAttributes.addFlashAttribute("errorMessage","Failed to complete Section B.");
            return "acceptor/permit-review";
        }
    }


    @GetMapping("/{id}/documents")
    public String documentsPage(@PathVariable Long id, Authentication authentication, Model model) {

        List<PermitDocumentViewResponse> documents = acceptorPermitService.getDocuments(id, authentication.getName());
        PermitResponse permit = acceptorPermitService.findPermitForDocumentUpload(id, authentication.getName());

        model.addAttribute("permit", permit);
        model.addAttribute("documents", documents);

        return "acceptor/permit-documents";
    }


    @PostMapping("/{id}/documents")
    public String uploadDocument(@PathVariable Long id, @RequestParam("documentType") String documentType,
            @RequestParam("file") MultipartFile file, Authentication authentication, RedirectAttributes redirectAttributes) {
        try {

            acceptorPermitService.uploadDocument(id, documentType, file, authentication.getName());
            redirectAttributes.addFlashAttribute("successMessage","Document uploaded successfully.");
        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute("errorMessage",
                    "Failed to upload document.");
        }
        return "redirect:/acceptor/permits/" + id + "/documents";
    }


    @GetMapping("/{id}/documents/{documentId}")
    public ResponseEntity<Resource> viewDocument(@PathVariable Long id, @PathVariable Long documentId,
            Authentication authentication) {

        Resource resource = permitService.getPermitDocument(id, documentId,authentication.getName());
        String contentType = "application/octet-stream";

        try {
            contentType = Files.probeContentType(Paths.get(resource.getFile().getAbsolutePath()));
        } catch (Exception ignored) {
        }

        MediaType mediaType;

        try {
            mediaType = MediaType.parseMediaType(contentType);
        } catch (Exception e) {
            mediaType = MediaType.APPLICATION_OCTET_STREAM;
        }

        return ResponseEntity.ok()
                .contentType(mediaType)
                .header(
                        HttpHeaders.CONTENT_DISPOSITION,
                        "inline; filename=\"" + resource.getFilename() + "\""
                )
                .body(resource);
    }


    @PostMapping("/{id}/close")
    public String closePermit(@PathVariable Long id, @RequestParam LocalDate validTillDate, @RequestParam LocalTime validTillTime,
                              Authentication authentication, RedirectAttributes redirectAttributes) {

        try {
                acceptorPermitService.closePermit(id, validTillDate, validTillTime, authentication.getName());
                redirectAttributes.addFlashAttribute("successMessage","Permit closed successfully.");
                 return "redirect:/acceptor/permits";

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Failed to upload document.");
            return "redirect:/acceptor/permits/"+ id+ "/documents";
        }

    }

    @PostMapping("/{id}/extension-request")
    public String requestExtension(@PathVariable Long id,Authentication authentication,RedirectAttributes redirectAttributes) {

        try {
            acceptorPermitService.requestExtension(id,authentication.getName());
            redirectAttributes.addFlashAttribute("successMessage","Extension request sent to the Permit Issuer.");

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Failed to sent extension request to the Permit Issuer.");
        }
        return "redirect:/acceptor/permits";
    }


}
