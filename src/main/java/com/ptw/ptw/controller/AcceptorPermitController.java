package com.ptw.ptw.controller;

import com.ptw.ptw.dto.AcceptorReviewRequest;
import com.ptw.ptw.dto.PermitResponse;
import com.ptw.ptw.dto.WorkCompletionRequest;
import com.ptw.ptw.service.AcceptorPermitService;
import com.ptw.ptw.service.PermitService;
import jakarta.validation.Valid;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Controller
@RequestMapping("/acceptor/permits")
@RequiredArgsConstructor
public class AcceptorPermitController {

    private final AcceptorPermitService acceptorPermitService;
    private final PermitService permitService;

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
         model.addAttribute("reviewRequest", new AcceptorReviewRequest());

         return "acceptor/permit-review";
    }

    @PostMapping("/{id}/review")
    public String reviewPermit(@PathVariable Long id, @Valid @ModelAttribute("reviewRequest") AcceptorReviewRequest request,
                               BindingResult bindingResult, Authentication authentication, Model model)
    {

            if(bindingResult.hasErrors())
            {
                model.addAttribute("permit", acceptorPermitService.findPermitForAcceptor
                        (id,authentication.getName()));

                return "acceptor/permit-review";
            };

            try{
                acceptorPermitService.reviewPermit(id, request, authentication.getName());

                return "redirect:/acceptor/permits";
            }
            catch(RuntimeException e)
            {
                model.addAttribute(("error"), e.getMessage());
                model.addAttribute("permit", acceptorPermitService.findPermitForAcceptor
                    (id,authentication.getName()));
            return "acceptor/permit-review";

            }
    }

    @GetMapping("/{id}/start-work")
    public String startWorkPage(@PathVariable Long id, Authentication authentication, Model model) {

        PermitResponse permit =permitService.getPermitForAcceptance(id,authentication.getName());
        model.addAttribute("permit", permit);

        return "acceptor/start-work";
    }

    @PostMapping("/{id}/start-work")
    public String startWork(@PathVariable Long id,Authentication authentication) {
        permitService.acceptPermitAndStartWork(id,authentication.getName());

        return "redirect:/acceptor/permits";
    }

    @GetMapping("/{id}/completion")
    public String workCompletionPage(@PathVariable Long id, Authentication authentication,Model model) {

        PermitResponse permit = permitService.getPermitForWorkCompletion(id,authentication.getName());
        model.addAttribute("permit", permit);

        return "acceptor/permit-work-completion";
    }

    @PostMapping("/{id}/completion")
    public String submitWorkCompletion(@PathVariable Long id, @ModelAttribute WorkCompletionRequest request,
                                       @RequestParam(value = "documents", required = false)
                                       List<MultipartFile> documents, Authentication authentication) {

        permitService.submitWorkCompletion(id,request, documents, authentication.getName());
        return "redirect:/acceptor/permits";
    }

}
