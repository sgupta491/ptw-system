<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Issuer Approval</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
 <style>
body {
    background-color: #f8f9fa;
}

.section-card {
      border: none;
      border-radius: 10px;
     overflow: hidden;
}

.section-header {
     background-color: #0d6efd;
     color: white;
}

 .readonly-box {
     min-height: 38px;
     background-color: #f8f9fa;
     border: 1px solid #dee2e6;
     border-radius: 6px;
     padding: 8px 12px;
 }

  .readonly-textarea {
      min-height: 100px;
      white-space: pre-wrap;
      background-color: #f8f9fa;
      border: 1px solid #dee2e6;
      border-radius: 6px;
      adding: 10px 12px;
  }

.checklist-table th,
.checklist-table td {
       vertical-align: middle;
 }

        .checklist-table th {
            text-align: center;
            background-color: #f1f3f5;
        }

        .question-column {
            width: 48%;
        }

        .response-column {
            width: 8%;
        }

        .sign-column {
            width: 18%;
        }

        .field-box {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 8px 10px;
            margin-bottom: 8px;
        }

        .field-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #6c757d;
            margin-bottom: 2px;
        }

        .field-value {
            font-weight: 500;
        }

        .response-yes {
            color: #198754;
            font-weight: 700;
        }

        .response-no {
            color: #dc3545;
            font-weight: 700;
        }

        .sign-value {
            font-size: 0.9rem;
            font-weight: 600;
        }

        .hazard-badge {
            margin-right: 6px;
            margin-bottom: 6px;
        }

        .approval-box {
            border: 2px solid #ffc107;
            border-radius: 8px;
            background-color: #fffdf2;
        }
    </style>
</head>
<body>
<div class="container my-5">
    <div class="card shadow-sm section-card mb-4">
        <div class="card-header bg-warning d-flex justify-content-between align-items-center">
            <h3 class="mb-0">Issuer Approval</h3>
            <span class="badge bg-dark">${approval.permit.status}</span>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Permit Number
                    </label>
                    <div class="readonly-box"> ${approval.permit.permitNumber}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Permit Type</label>
                    <div class="readonly-box">${approval.permit.permitType}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="card shadow-sm section-card mb-4">
        <div class="card-header section-header">
            <h5 class="mb-0">
                A - General Information
            </h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Issuer Department </label>
                    <div class="readonly-box">${approval.permit.issuerDepartment}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Issuer Name</label>
                    <div class="readonly-box">${approval.permit.issuerName}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Acceptor Department</label>
                    <div class="readonly-box">${approval.permit.acceptorDepartment}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Acceptor Name</label>
                    <div class="readonly-box">${approval.permit.acceptorName}</div>
                </div>
                <!-- CONTRACTOR -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Contractor Deployed</label>
                    <div class="readonly-box">
                        <c:choose>
                            <c:when test="${approval.permit.contractorDeployed}">
                                <span class="badge bg-success">Yes</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">No</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <c:if test="${approval.permit.contractorDeployed}">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Contractor</label>
                        <div class="readonly-box">${approval.permit.contractorName}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Supervisor Name</label>
                        <div class="readonly-box">${approval.permit.contractorSupervisor}</div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <!-- SECTION B -->
    <div class="card shadow-sm section-card mb-4">
        <div class="card-header section-header">
            <h5 class="mb-0"> B - Work Description</h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Equipment Number</label>
                    <div class="readonly-box">${approval.permit.equipmentNumber}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Location</label>
                    <div class="readonly-box">
                        ${approval.permit.location}
                    </div>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">Proposed Work</label>
                    <div class="readonly-textarea">${approval.permit.proposedWork}
                    </div>
                </div>
                <!-- HAZARD ACTIVITIES -->
                <div class="col-12">
                    <label class="form-label fw-semibold"> Any Hazard Activity</label>
                    <div class="readonly-box">
                        <c:if test="${approval.permit.liftShiftByEquipment}">
                            <span class="badge bg-warning text-dark me-2">Lift &amp; shift by equipment</span>
                        </c:if>
                        <c:if test="${approval.permit.hazardousChemicalExposure}">
                            <span class="badge bg-danger me-2">
                                Exposure to hazardous chemical
                            </span>
                        </c:if>
                        <c:if test="${not empty approval.permit.otherHazardActivity}">
                            <span class="badge bg-secondary me-2">
                                Other: ${approval.permit.otherHazardActivity}
                            </span>
                        </c:if>
                        <c:if test="${not approval.permit.liftShiftByEquipment
                                     and not approval.permit.hazardousChemicalExposure
                                     and empty approval.permit.otherHazardActivity}">
                            <span class="text-muted">
                                No hazard activity selected
                            </span>
                        </c:if>
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Valid Date </label>
                    <div class="readonly-box">${approval.permit.validOnDate}</div>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-semibold"> Time From </label>
                    <div class="readonly-box">${approval.permit.timeFrom}</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Time To</label>
                    <div class="readonly-box">${approval.permit.timeTo}</div>
                </div>
            </div>
        </div>
    </div>
    <!-- SECTION C -->
    <div class="card shadow-sm section-card mb-4">
        <div class="card-header section-header">
            <h5 class="mb-0"> C - Hazard Identification</h5>
        </div>
        <div class="card-body">
            <div class="row g-4">
                <!-- EQUIPMENT HAZARDS -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Hazards from equipment/installations
                    </label>
                    <div class="readonly-box">
                        <c:set var="equipmentHazardFound" value="false"/>
                        <c:forEach items="${approval.hazards}" var="hazard">
                            <c:if test="${hazard.hazardCategory == 'EQUIPMENT_INSTALLATION'}">
                                <c:set var="equipmentHazardFound" value="true"/>
                                <span class="badge bg-secondary hazard-badge">${hazard.hazardName}</span>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not equipmentHazardFound}">
                            <span class="text-muted">
                                No equipment hazard selected
                            </span>
                        </c:if>
                    </div>
                </div>
                <!-- WORK TYPE / LOCATION HAZARDS -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Hazards from work type/location
                    </label>
                    <div class="readonly-box">
                        <c:set var="workHazardFound" value="false"/>
                        <c:forEach items="${approval.hazards}" var="hazard">
                            <c:if test="${hazard.hazardCategory == 'WORK_TYPE_LOCATION'}">
                                <c:set var="workHazardFound" value="true"/>
                                <span class="badge bg-secondary hazard-badge">
                                    ${hazard.hazardName}
                                </span>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not workHazardFound}">
                            <span class="text-muted">
                                No work type/location hazard selected
                            </span>
                        </c:if>
                    </div>
                </div>
                <!-- OTHER HAZARDS -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Other Hazards</label>
                    <div class="readonly-box">
                        <c:choose>
                            <c:when test="${not empty approval.otherHazards}">
                                ${approval.otherHazards}
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">
                                    None
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <!-- RELATED PERMIT -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Other Hazards in accordance with Permit No. </label>
                    <div class="readonly-box">
                        <c:choose>
                            <c:when test="${not empty approval.relatedPermitNumber}">
                                ${approval.relatedPermitNumber}
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
    </div>
    <!-- SECTION D -->
    <div class="card shadow-sm section-card mb-4">
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
                        <th class="question-column">Hazard assessment &amp; compliance checklist</th>
                        <th class="response-column">Yes</th>
                        <th class="response-column"> No </th>
                        <th class="sign-column"> Measure Implemented Sign.</th>
                        <th class="sign-column">Measure Lifted Sign.
                        </th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${not empty approval.checklistResponses}">
                            <c:forEach items="${approval.checklistResponses}" var="checklist">
                                <tr>
                                    <!-- QUESTION + FIELDS -->
                                    <td>
                                        <div class="fw-semibold mb-2">
                                            <strong> ${checklist.questionCode} </strong>
                                            &nbsp;
                                            ${checklist.questionText}
                                        </div>

                                        <!-- ADDITIONAL FIELDS -->
                                        <c:if test="${not empty checklist.fieldValues}">
                                            <div class="mt-2">
                                                <c:forEach
                                                        items="${checklist.fieldValues}"
                                                        var="fieldEntry">
                                                    <div class="field-box">
                                                        <div class="field-label">
                                                            ${fieldEntry.key}
                                                        </div>
                                                        <div class="field-value">
                                                            ${fieldEntry.value}
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </td>
                                    <!-- YES -->
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${checklist.response == 'YES'}">
                                                <span class="response-yes fs-5">
                                                    ✓
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">
                                                   -
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <!-- NO -->
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${checklist.response == 'NO'}">
                                                <span class="response-no fs-5">
                                                    ✓
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">
                                                    -
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <!-- IMPLEMENTED SIGN -->
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty checklist.measureImplementedBy}">
                                                <div class="sign-value">
                                                    ${checklist.measureImplementedBy}
                                                </div>
                                               <%--  <div class="small text-muted">
                                                   ${checklist.measureImplementedAt}
                                                </div>--%>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">
                                                    -
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <!-- LIFTED SIGN -->
                                    <td class="text-center">
                                        <span class="text-muted">
                                            -
                                        </span>
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
    </div>
    <!-- SECTION E -->
    <div class="card shadow-sm section-card mb-4">
        <div class="card-header section-header">
            <h5 class="mb-0"> E - Post-work Measures required</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty approval.postWorkMeasures}">
                    <c:forEach
                            items="${approval.postWorkMeasures}"
                            var="measure">
                        <div class="border rounded p-3 mb-3">
                            <div class="row align-items-center">
                                <div class="col-md-7">
                                    <div class="fw-semibold">
                                        ${measure.itemCode}.
                                        ${measure.itemText}
                                    </div>
                                    <c:if test="${not empty measure.otherText}">
                                        <div class="mt-2">
                                            <label class="form-label fw-semibold">
                                                Other
                                            </label>
                                            <div class="readonly-box">
                                                ${measure.otherText}
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- RESPONSE -->

                                <div class="col-md-2 text-center">

                                    <div class="small text-muted">
                                        Response
                                    </div>

                                    <c:choose>

                                        <c:when test="${measure.response == 'YES'}">

                                            <span class="response-yes">
                                                YES
                                            </span>

                                        </c:when>

                                        <c:when test="${measure.response == 'NO'}">

                                            <span class="response-no">
                                                NO
                                            </span>

                                        </c:when>

                                        <c:otherwise>

                                            <span class="text-muted">
                                                -
                                            </span>

                                        </c:otherwise>

                                    </c:choose>

                                </div>


                                <!-- ANSWERED BY -->

                              <%--  <div class="col-md-3">

                                    <div class="small text-muted">
                                        Answered By
                                    </div>

                                    <div class="fw-semibold">
                                        ${measure.answeredBy}
                                    </div>

                                    <div class="small text-muted">
                                        ${measure.answeredAt}
                                    </div>

                                </div>--%>

                            </div>

                        </div>

                    </c:forEach>

                </c:when>


                <c:otherwise>

                    <div class="text-center text-muted py-3">
                        No post-work measures found.
                    </div>

                </c:otherwise>

            </c:choose>

        </div>

    </div>


    <!-- ========================================================= -->
    <!-- SECTION F -->
    <!-- ========================================================= -->

    <div class="card shadow-sm section-card mb-4">

        <div class="card-header section-header"">

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

                   <%--  <div class="readonly-box">
                        <c:choose>
                            <c:when test="${not empty approval.issuerApprovalDateTime}">
                               ${approval.issuerApprovalDateTime}
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">
                                    Pending Issuer Approval
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div> --%>



                </div>


                <div class="col-md-6">

                    <label class="form-label fw-semibold">
                        Signature
                    </label>

                    <div class="readonly-box">

                    </div>

                </div>


                <div class="col-12">

                    <div class="text-muted">

                        Permit Issuer:

                        <strong>
                            ${approval.permit.issuerName}
                        </strong>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- SECTION G -->

    <div class="card shadow-sm section-card mb-4">
        <div class="card-header section-header">
            <h5 class="mb-0"> G - Acceptance of Permit for work to be conducted</h5>
        </div>
        <div class="card-body">
            <p class="mb-4">
                It is confirmed that we have reviewed the measures taken
                and work can be undertaken safely.
            </p>
            <div class="row g-4">
                <!-- ACCEPTOR DATE -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Date
                    </label>
                    <div class="readonly-box">
                       &nbsp;
                    </div>

                </div>

                <!-- ACCEPTOR NAME + SIGNATURE -->

                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Name &amp; Signature
                    </label>
                    <div class="readonly-box"
                         style="min-height: 70px;">
                      <%--  ${approval.permit.acceptorName} --%>
                        <div class="small text-muted mt-2">

                        </div>
                    </div>
                </div>
                <!-- CONTRACTOR SUPERVISOR DATE -->
                <c:if test="${approval.permit.contractorDeployed}">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Date
                        </label>
                        <div class="readonly-box">

                        </div>
                    </div>

                    <!-- CONTRACTOR SUPERVISOR SIGNATURE -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Contractor Supervisor Name &amp; Signature
                        </label>
                        <div class="readonly-box"
                             style="min-height: 70px;"
                            ${approval.permit.contractorSupervisor}
                            <div class="small text-muted mt-2">

                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- ACTION -->


    <div class="card shadow-sm mb-5">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <div class="text-muted">
                    <strong>Note:</strong>
                    Review all permit sections before moving
                    the permit to print stage.
                </div>
                <form method="post"
                      action="${pageContext.request.contextPath}/issuer/permits/${approval.permit.id}/approve-print">

                    <input type="hidden"
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}">

                    <button type="submit"
                            class="btn btn-success btn-lg px-4">

                        Ready for Print

                    </button>

                </form>

            </div>

        </div>

    </div>

</div>

</body>
</html>