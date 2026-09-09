package com.ptw.ptw.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication) {

        String role = authentication.getAuthorities()
                .stream()
                .findFirst()
                .map(GrantedAuthority::getAuthority)
                .orElse("");

        if ("ROLE_ADMIN".equals(role)) {
            return "redirect:/admin/dashboard";
        }

        if ("ROLE_ISSUER".equals(role)) {
            return "redirect:/issuer/permits";
        }

        if ("ROLE_ACCEPTOR".equals(role)) {
            return "redirect:/acceptor/permits";
        }

        if ("ROLE_ELECTRICIAN".equals(role)) {
            return "redirect:/electrician/dashboard";
        }

        if ("ROLE_CONTRACTOR".equals(role)) {
            return "redirect:/contractor/dashboard";
        }

        return "redirect:/";
    }
}