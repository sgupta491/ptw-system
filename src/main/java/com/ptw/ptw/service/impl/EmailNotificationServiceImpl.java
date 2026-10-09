package com.ptw.ptw.service.impl;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.WorkRequest;
import com.ptw.ptw.service.EmailNotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
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

        String body = "Dear " +
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


    @Override
    public void sendWorkRequestCreatedEmail(WorkRequest workRequest, List<String> maintenanceEmails) {

        if (maintenanceEmails == null || maintenanceEmails.isEmpty()) {
            log.warn("No maintenance email recipients for work order {}", workRequest.getWoNumber());
            return;
        }

        String permitNumber = workRequest.getPermit().getPermitNumber();
        String requesterName =  workRequest.getRequester().getFirstName()
                        + " "
                        + workRequest.getRequester().getLastName();

        String subject = "New Work Order - Permit " + permitNumber;

        String body = "Dear Maintenance Team,\n\n"
                        + "A new electrical work request has been created "
                        + "and is awaiting your action.\n\n"
                        + "Permit Number: " + permitNumber + "\n"
                        + "Work Order Number: " + workRequest.getWoNumber() + "\n"
                        + "Requested By: " + requesterName + "\n"
                        + "Department: " + workRequest.getRequestingDepartment().getDepartmentName()
                        + "\n"
                        + "Equipment Number: " + workRequest.getEquipmentNumber() + "\n"
                        + "Location: " + workRequest.getWorkLocation() + "\n"
                        + "Work To Be Done By: "
                        + workRequest.getWorkToBeDoneBy().getTradeName() + "\n\n"
                        + "Please log in to the PTW system and do the needful.\n\n"
                        + "Regards,\n"
                        + "PTW System";

        for (String recipient : maintenanceEmails) {

            if (recipient == null || recipient.isBlank()) {
                continue;
            }

            sendMail(recipient, subject, body);
        }
    }


    @Override
    public void sendWorkRequestCompletedEmail(WorkRequest workRequest) {

        String permitNumber = workRequest.getPermit().getPermitNumber();
        String issuerEmail = workRequest.getPermit().getIssuer().getEmail();

        String subject = "Work Order Completed - Permit" + permitNumber;

        if (issuerEmail == null || issuerEmail.isBlank()) {
            log.warn("Issuer email missing for permit {}", permitNumber);
            return;
        }

            String body = "Dear "
                            + workRequest.getPermit().getIssuer().getFirstName() +" "
                            + workRequest.getPermit().getIssuer().getLastName()
                         + ",\n\n"
                            + "The electrical work order for your permit "
                            + "has been completed by Maintenance department.\n\n"
                            + "Permit Number: " + permitNumber + "\n"
                            + "Work Order Number: " + workRequest.getWoNumber() + "\n"
                            + "Status: " + workRequest.getStatus() + "\n"
                            + "Equipment Number: "
                            + workRequest.getIsolationEquipmentNumber() + "\n"
                            + "Feeder Number: " + workRequest.getFeederNumber() + "\n"
                            + "LOTO Number: " + workRequest.getLotoNumber() + "\n"
                            + "Completed By: " + workRequest.getWorkCompletedBy() + "\n"
                            + "Completed At: " + workRequest.getCompletedAt() + "\n\n"
                            + "Please log in to the PTW system to continue "
                            + "the permit workflow.\n\n"
                            + "Regards,\n"
                            + "PTW System";

        sendMail(issuerEmail, subject, body);

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