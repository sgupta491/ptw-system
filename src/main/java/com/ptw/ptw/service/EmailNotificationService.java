package com.ptw.ptw.service;

import com.ptw.ptw.entity.Permit;
import com.ptw.ptw.entity.WorkRequest;

import java.util.List;

public interface EmailNotificationService {

    void sendExtensionRequestedEmail(Permit permit);
    void sendExtensionAcceptedEmail(Permit permit);
    void sendExtensionRejectedEmail(Permit permit,String rejectionRemark);
    void sendWorkRequestCreatedEmail(WorkRequest workRequest,List<String> maintenanceEmails);
    void sendWorkRequestCompletedEmail(WorkRequest workRequest);
}
