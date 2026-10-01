<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Permit Full View</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .section-card {
            border: none;
            border-radius: 12px;
            overflow: hidden;
        }

        .section-header {
            background-color: #0d6efd;
            color: white;
        }

        .readonly-box {
            min-height: 42px;
            padding: 9px 12px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
        }

        .readonly-text {
            min-height: 100px;
            padding: 12px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            white-space: pre-wrap;
        }

        .signature-box {
            min-height: 80px;
            padding: 12px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
        }

        .checklist-table th,
        .checklist-table td {
            vertical-align: middle;
        }

        .checklist-table th {
            text-align: center;
            background-color: #f1f3f5;
        }

        .check {
            font-size: 20px;
            font-weight: bold;
        }

        .document-item {
            transition: background-color 0.2s ease;
        }

        .document-item:hover {
            background-color: #f8f9fa;
        }

        .section-spacing {
            margin-bottom: 1.5rem;
        }

    </style>
</head>
<body>
<div class="container my-5">
    <!-- PAGE HEADER -->
    <div class="card shadow-sm section-card section-spacing">
        <div class="card-header bg-warning text-white">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h3 class="mb-1 text-black">  Permit Full View </h3>
                    <small class="text-black-50"> Complete permit history and closure record  </small>
                </div>
                <span class="badge bg-success fs-6">
                    ${permit.permit.status}
                </span>
            </div>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Permit Number </label>
                    <div class="readonly-box">${permit.permit.permitNumber} </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Permit Type</label>
                    <div class="readonly-box"> ${permit.permit.permitType}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- SECTION A -->
    <div class="card shadow-sm section-card section-spacing">
        <div class="card-header section-header">
            <h5 class="mb-0">  A - General Information</h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Issuer Department </label>
                    <div class="readonly-box"> ${permit.permit.issuerDepartment}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Issuer Name</label>
                    <div class="readonly-box">${permit.permit.issuerName}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Acceptor Department</label>
                    <div class="readonly-box"> ${permit.permit.acceptorDepartment}</div>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Acceptor Name</label>
                    <div class="readonly-box"> ${permit.permit.acceptorName}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Contractor Deployed </label>
                    <div class="readonly-box">
                        <c:choose>
                            <c:when test="${permit.permit.contractorDeployed}">
                                <span class="badge bg-success">Yes</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary"> No </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <c:if test="${permit.permit.contractorDeployed}">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold"> Contractor</label>
                        <div class="readonly-box">${permit.permit.contractorName} </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Contractor Supervisor </label>
                        <div class="readonly-box">${permit.permit.contractorSupervisor}</div>
                    </div>
                </c:if>

                 <div class="col-12">
                   <label class="form-label fw-semibold">Proposed Work</label>
                     <div class="readonly-box">${permit.permit.proposedWork} </div>
                   </div>
            </div>
        </div>
    </div>

    <!-- SECTION B -->
    <div class="card shadow-sm section-card section-spacing">
        <div class="card-header section-header">
            <h5 class="mb-0"> B - Work Description</h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Equipment Number</label>
                    <div class="readonly-box">${permit.permit.equipmentNumber}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Location </label>
                    <div class="readonly-box"> ${permit.permit.location} </div>
                </div>

                <div class="col-12">
                    <label class="form-label fw-semibold">Proposed Work in Detail</label>
                    <div class="readonly-text">${permit.permit.proposedWorkInDetail} </div>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-semibold">Valid Date</label>
                    <div class="readonly-box"> ${permit.permit.validOnDate}</div>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-semibold">Time From</label>
                    <div class="readonly-box">${permit.permit.timeFrom}</div>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-semibold">Time To</label>
                    <div class="readonly-box"> ${permit.permit.timeTo}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- SECTION C -->

   <!-- <div class="card shadow-sm section-card section-spacing">
            <div class="card-header section-header">
                <h5 class="mb-0">C - Hazard Identification</h5>
            </div>

        <div class="card-body">
            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Hazards from equipment/installations</label>
                    <div class="readonly-box">
                        <c:forEach items="${permit.hazards}" var="hazard">
                            <c:if test="${hazard.hazardCategory == 'EQUIPMENT_INSTALLATION'}">
                                <span class="badge bg-secondary me-1 mb-1">
                                    ✓ ${hazard.hazardName}
                                </span>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>


                <div class="col-md-6">
                    <label class="form-label fw-semibold">Hazards from work type/location</label>

                    <div class="readonly-box">
                        <c:forEach items="${permit.hazards}" var="hazard">
                            <c:if test="${hazard.hazardCategory == 'WORK_TYPE_LOCATION'}">
                                <span class="badge bg-secondary me-1 mb-1">
                                    ✓ ${hazard.hazardName}
                                </span>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">  Other Hazards </label>
                    <div class="readonly-box">
                        <c:choose>
                            <c:when test="${not empty permit.otherHazards}">  ${permit.otherHazards} </c:when>
                            <c:otherwise>
                                <span class="text-muted">
                                    None
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Other Hazards in accordance with Permit No.
                    </label>
                    <div class="readonly-box">
                        <c:choose>
                            <c:when test="${not empty permit.relatedPermitNumber}">
                                ${permit.relatedPermitNumber}
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">
                                    None
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div> -->

    <!-- SECTION D -->

    <!-- <div class="card shadow-sm section-card section-spacing">
        <div class="card-header section-header">
            <h5 class="mb-0">
                D - Protective Measures – Hazard Assessment Checklist
            </h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered mb-0 checklist-table">
                    <thead>
                    <tr>
                        <th>Hazard assessment &amp; compliance checklist </th>
                        <th style="width: 7%;"> Yes</th>
                        <th style="width: 7%;"> No</th>
                        <th style="width: 18%;"> Measure Implemented Sign.</th>
                        <th style="width: 18%;">  Measure Lifted Sign.</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty permit.checklistResponses}">
                            <c:forEach items="${permit.checklistResponses}" var="checklist">

                                <tr>
                                    <td>
                                        <strong>${checklist.questionCode} </strong>
                                        ${checklist.questionText}
                                        <c:if test="${not empty checklist.fieldValues}">
                                            <div class="mt-2">
                                                <c:forEach  items="${checklist.fieldValues}" var="field">
                                                    <div class="small mb-1">
                                                        <strong> ${field.key}: </strong>
                                                        ${field.value}
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </td>


                                    <td class="text-center">
                                        <c:if test="${checklist.response == 'YES'}">
                                            <span class="check">
                                                ✓
                                            </span>
                                        </c:if>
                                    </td>

                                    <td class="text-center">
                                        <c:if test="${checklist.response == 'NO'}">
                                            <span class="check">
                                                ✓
                                            </span>
                                        </c:if>
                                    </td>

                                    <td class="text-center">
                                        <c:if test="${not empty checklist.measureImplementedBy}">
                                            <strong>
                                                ${checklist.measureImplementedBy}
                                            </strong>
                                        </c:if>
                                    </td>

                                    <td class="text-center">
                                      <%-- <c:if test="${not empty checklist.measureLiftedBy}">
                                            <strong> ${checklist.measureLiftedBy} </strong>
                                        </c:if> --%>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">
                                    No checklist responses found.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
       </div> -->

    <!-- SECTION E -->
    <!-- <div class="card shadow-sm section-card section-spacing">
        <div class="card-header section-header">
            <h5 class="mb-0">
                E - Post-work Measures required
            </h5>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered mb-0">
                    <thead class="table-light">
                    <tr>
                        <th> Item</th>
                        <th class="text-center" style="width: 10%;"> Yes</th>
                        <th class="text-center" style="width: 10%;"> No</th>
                        <th style="width: 20%;">Answered By </th>
                    </tr>
                    </thead>
                    <tbody>

                    <c:forEach items="${permit.postWorkMeasures}" var="measure">

                        <tr>
                            <td>
                                <strong>${measure.itemCode}.</strong>
                                ${measure.itemText}
                                <c:if test="${not empty measure.otherText}">
                                    <div class="mt-2">
                                        <strong> Other:</strong>
                                        ${measure.otherText}
                                    </div>
                                </c:if>
                            </td>

                            <td class="text-center">
                                <c:if test="${measure.response == 'YES'}">
                                    <span class="check">
                                        ✓
                                    </span>
                                </c:if>
                            </td>

                            <td class="text-center">
                                <c:if test="${measure.response == 'NO'}">
                                    <span class="check">
                                        ✓
                                    </span>
                                </c:if>
                            </td>
                            <td>
                                <strong>
                                    ${measure.answeredBy}
                                </strong>

                               <%-- <div class="small text-muted">
                                    ${measure.answeredAt}
                                </div> --%>

                            </td>
                        </tr>
                    </c:forEach>
                   </tbody>
                </table>
            </div>
        </div>
    </div> -->


    <!-- SECTION F -->
    <!--  <div class="card shadow-sm section-card section-spacing">
        <div class="card-header section-header">
            <h5 class="mb-0">
                F - Approval of work permit after verification of measures
            </h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Date
                    </label>
                    <div class="readonly-box">
                        <c:choose>
                            <c:when test="${not empty permit.issuerApprovalDateTime}">
                                ${permit.issuerApprovalDateTime}
                            </c:when>
                            <c:otherwise>
                                -
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Signature
                    </label>
                    <div class="signature-box">
                        <strong>
                            ${permit.permit.issuerName}
                        </strong>
                    </div>
                </div>
            </div>
        </div>
    </div> -->

    <!-- SECTION G -->
    <!-- <div class="card shadow-sm section-card section-spacing">
        <div class="card-header section-header">
            <h5 class="mb-0">
                G - Acceptance of Permit for work to be conducted
            </h5>
        </div>

        <div class="card-body">
            <p class="mb-4">
                It is confirmed that we have reviewed the measures
                taken and work can be undertaken safely.
            </p>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Acceptor
                    </label>
                    <div class="readonly-box">
                        ${permit.permit.acceptorName}
                    </div>

                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Department
                    </label>
                    <div class="readonly-box">
                        ${permit.permit.acceptorDepartment}
                    </div>
                </div>


                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Date
                    </label>
                    <div class="readonly-box">
                         Present on the HardCopy
                     </div>
                </div>


                <div class="col-md-6">

                    <label class="form-label fw-semibold"> Name &amp; Signature </label>
                    <div class="signature-box">
                        <strong>${permit.permit.acceptorName}</strong>
                    </div>
                </div>

                <c:if test="${permit.permit.contractorDeployed}">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Contractor Supervisor</label>
                        <div class="readonly-box">  ${permit.permit.contractorSupervisor}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold"> Contractor Supervisor Signature</label>
                    </div>
                </c:if>
            </div>
        </div>
    </div> -->

    <!-- SECTION H -->

    <!-- <div class="card shadow-sm section-card section-spacing">
        <div class="card-header section-header">
            <h5 class="mb-0">H - Completion Report</h5>
        </div>

        <div class="card-body">
            <c:choose>
                <c:when test="${not empty permit.workCompletion}">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Work Completed</label>
                            <div class="readonly-box">
                                <c:choose>
                                    <c:when test="${permit.workCompletion.completionResponse == 'YES'}">
                                        <span class="text-success fw-bold">
                                            ✓ YES
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-danger fw-bold">
                                            ✓ NO
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">
                                Completed By
                            </label>
                            <div class="readonly-box">
                                ${permit.workCompletion.completedBy}
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">
                                Date &amp; Time
                            </label>
                            <div class="readonly-box">
                                ${permit.workCompletion.completedAt}
                            </div>

                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">
                                Signature
                            </label>
                            <div class="signature-box">
                                <strong>
                                    ${permit.workCompletion.completedBy}
                                </strong>
                            </div>

                        </div>


                        <c:if test="${not empty permit.workCompletion.contractorSupervisorName}">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">
                                    Contractor Supervisor
                                </label>

                                <div class="readonly-box">
                                    ${permit.workCompletion.contractorSupervisorName}
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">
                                    Contractor Supervisor Signature
                                </label>
                            </div>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>

                    <div class="alert alert-warning mb-0">
                        No work completion record found.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div> -->

    <!-- SECTION I -->

     <!-- <div class="card shadow-sm section-card section-spacing">
        <div class="card-header section-header">
            <h5 class="mb-0">
                I - Acceptance Check and Withdrawal of Pre-check Conditions
            </h5>
        </div>

        <div class="card-body">
            <c:choose>
                <c:when test="${not empty permit.finalVerification}">
                    <div class="row g-3">
                         <div class="col-md-6">
                                <label class="form-label fw-semibold">
                                       Signature</label>
                                 <div class="signature-box">
                                    <strong> ${permit.finalVerification.verifiedBy}
                                     </strong></div>
                                   </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">
                                Date &amp; Time
                            </label>

                            <div class="readonly-box">
                                ${permit.finalVerification.verifiedAt}
                            </div>

                        </div>
                        <div class="col-12">

                            <label class="form-label fw-semibold">
                                Remarks
                            </label>

                            <div class="readonly-box">
                                <c:choose>

                                    <c:when test="${not empty permit.finalVerification.remarks}">
                                        ${permit.finalVerification.remarks}
                                    </c:when>

                                    <c:otherwise>
                                        No remarks
                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </div>

                    </div>

                </c:when>

                <c:otherwise>

                    <div class="alert alert-warning mb-0">
                        No final verification record found.
                    </div>

                </c:otherwise>

            </c:choose>

        </div>

    </div> -->

    <!-- UPLOADED DOCUMENTS -->

    <div class="card shadow-sm section-card section-spacing">
        <div class="card-header bg-secondary text-white">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    Uploaded Documents
                </h5>
                <span class="badge bg-light text-dark">
                    ${permit.documents.size()} Files
                </span>
            </div>
        </div>

        <div class="card-body">
            <c:choose>
                <c:when test="${not empty permit.documents}">
                    <div class="list-group">
                        <c:forEach items="${permit.documents}" var="document">
                            <div class="list-group-item document-item">
                                <div class="row align-items-center g-3">
                                    <div class="col-md-7">
                                        <div class="fw-semibold">
                                            ${document.originalFileName}
                                        </div>

                                        <div class="small text-muted">
                                            Uploaded by:
                                            ${document.uploadedBy}
                                            <span class="mx-2">
                                                |
                                            </span>
                                            ${document.uploadedAt}
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <span class="badge bg-light text-dark border">
                                            ${document.documentType}
                                        </span>
                                    </div>

                                    <div class="col-md-3 text-md-end">
                                        <a href="${pageContext.request.contextPath}/issuer/permits/${permit.permit.id}/documents/${document.id}"
                                           target="_blank"
                                           class="btn btn-outline-primary btn-sm">

                                            Open Document
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-secondary mb-0">
                        No documents uploaded for this permit.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

</body>
</html>