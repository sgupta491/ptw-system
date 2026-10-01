package com.ptw.ptw.service.impl;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.service.EmailNotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailNotificationServiceImpl implements EmailNotificationService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;


    @Override
    public void sendExtensionRequestedEmail(Permit permit) {

        if (permit.getIssuer() == null || permit.getIssuer().getEmail() == null
                || permit.getIssuer().getEmail().isBlank()) {
            return;
        }

        String subject =  "Extension Request - " + permit.getPermitNumber();

        String body =
                "Dear " +
                        getFullName(permit.getIssuer()) +
                        ",\n\n" +

                        "An extension request has been raised for the following permit.\n\n" +

                        "Permit Number: " + permit.getPermitNumber() + "\n" +
                        "Permit Type: " +
                        (permit.getPermitType() != null
                                ? permit.getPermitType().getPermitName()
                                : "") + "\n" +
                        "Acceptor: " +
                        getFullName(permit.getAcceptor()) + "\n" +
                        "Location: " +
                        nullSafe(permit.getLocation()) + "\n\n" +

                        "Please login to the PTW system to review the extension request.\n\n" +

                        "Regards,\n" +
                        "PTW System";

        sendMail(permit.getIssuer().getEmail(), subject, body);
    }


    @Override
    public void sendExtensionAcceptedEmail(Permit permit) {

        if (permit.getAcceptor() == null || permit.getAcceptor().getEmail() == null
                || permit.getAcceptor().getEmail().isBlank()) {

            return;
        }

        String subject = "Extension Accepted - " + permit.getPermitNumber();

        String body = "Dear " +
                        getFullName(permit.getAcceptor()) +
                        ",\n\n" +

                        "Your extension request has been accepted.\n\n" +

                        "Permit Number: " + permit.getPermitNumber() + "\n" +
                        "Status: EXTENDED\n\n" +

                        "Please login to the PTW system and proceed with the extension process.\n\n" +

                        "Regards,\n" +
                        "PTW System";

        sendMail(permit.getAcceptor().getEmail(),subject, body);
    }


    @Override
    public void sendExtensionRejectedEmail( Permit permit, String rejectionRemark) {

        if (permit.getAcceptor() == null  || permit.getAcceptor().getEmail() == null
                || permit.getAcceptor().getEmail().isBlank()) {

            return;
        }

        String subject = "Extension Rejected - " + permit.getPermitNumber();

        String remark = rejectionRemark != null
                        && !rejectionRemark.isBlank()
                        ? rejectionRemark.trim()
                        : "No rejection remark was provided.";

        String body =   "Dear " +
                        getFullName(permit.getAcceptor()) +
                        ",\n\n" +

                        "Your extension request has been rejected.\n\n" +

                        "Permit Number: " + permit.getPermitNumber() + "\n\n" +

                        "Reason:\n" +
                        remark + "\n\n" +

                        "Please login to the PTW system for further details.\n\n" +

                        "Regards,\n" +
                        "PTW System";

        sendMail(permit.getAcceptor().getEmail(), subject, body);
    }


    private void sendMail(String to, String subject, String body)
    {

        SimpleMailMessage message = new SimpleMailMessage();

        message.setFrom(fromEmail);
        message.setTo(to);
        message.setSubject(subject);
        message.setText(body);

        mailSender.send(message);
    }


    private String getFullName(com.ptw.ptw.entity.User user) {

        if (user == null) {
            return "";
        }

        String firstName = nullSafe(user.getFirstName());

        String lastName = nullSafe(user.getLastName());

        return (firstName + " " + lastName).trim();
    }


    private String nullSafe(String value) {
        return value == null ? "" : value;
    }
}