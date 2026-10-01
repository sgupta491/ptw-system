package com.ptw.ptw.service;

import com.ptw.ptw.entity.Permit;

public interface EmailNotificationService {

    void sendExtensionRequestedEmail(Permit permit);
    void sendExtensionAcceptedEmail(Permit permit);
    void sendExtensionRejectedEmail(Permit permit,String rejectionRemark);
}
