<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>
        Permit ${approval.permit.permitNumber}
    </title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
            font-size: 13px;
        }

        .permit-container {
            background: white;
            max-width: 1100px;
            margin: auto;
            padding: 25px;
        }

        .permit-title {
            text-align: center;
            margin-bottom: 20px;
        }

        .permit-title h1 {
            margin: 0;
            font-size: 24px;
        }

        .permit-title h2 {
            margin: 5px 0;
            font-size: 18px;
        }

        .permit-number {
            text-align: right;
            font-weight: bold;
        }

        .section {
            margin-top: 18px;
            border: 1px solid #000;
        }

        .section-title {
            background: #e9ecef;
            border-bottom: 1px solid #000;
            padding: 8px;
            font-weight: bold;
            font-size: 15px;
        }

        .section-body {
            padding: 10px;
        }

        .field-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .field {
            border-bottom: 1px solid #ccc;
            padding: 5px;
        }

        .field-label {
            font-weight: bold;
        }

        .proposed-work {
            min-height: 70px;
            white-space: pre-wrap;
        }

        .hazard-list {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
        }

        .hazard {
            border: 1px solid #555;
            padding: 4px 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            border: 1px solid #000;
            padding: 6px;
            vertical-align: middle;
        }

        th {
            text-align: center;
        }

        .question {
            width: 52%;
        }

        .yes-no {
            width: 7%;
            text-align: center;
        }

        .signature {
            width: 17%;
            text-align: center;
        }

        .check {
            font-size: 18px;
            font-weight: bold;
        }

        .sign-space {
            min-height: 55px;
        }

        .approval-note {
            padding: 10px;
            border: 1px solid #000;
        }

        .print-actions {
            max-width: 1100px;
            margin: 20px auto;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        button {
            padding: 10px 20px;
            font-size: 15px;
            cursor: pointer;
        }

        @media print {

            body {
                background: white;
                padding: 0;
            }

            .permit-container {
                max-width: 100%;
                padding: 0;
            }

            .print-actions {
                display: none !important;
            }

            .section {
                break-inside: avoid;
            }

        }

    </style>

</head>

<body>

<div class="permit-container">

    <!-- ===================================================== -->
    <!-- HEADER -->
    <!-- ===================================================== -->

    <div class="permit-title">

        <h1>COLD WORK PERMIT</h1>

        <div class="permit-number">
            Permit Number:
            ${approval.permit.permitNumber}
        </div>

    </div>


    <!-- ===================================================== -->
    <!-- SECTION A -->
    <!-- ===================================================== -->

    <div class="section">

        <div class="section-title">
            A - General Information
        </div>

        <div class="section-body">

            <div class="field-grid">

                <div class="field">
                    <span class="field-label">
                        Permit Issuer Dept:
                    </span>
                    ${approval.permit.issuerDepartment}
                </div>

                <div class="field">
                    <span class="field-label">
                        Name:
                    </span>
                    ${approval.permit.issuerName}
                </div>

                <div class="field">
                    <span class="field-label">
                        Permit Acceptor Dept:
                    </span>
                    ${approval.permit.acceptorDepartment}
                </div>

                <div class="field">
                    <span class="field-label">
                        Name:
                    </span>
                    ${approval.permit.acceptorName}
                </div>

                <c:if test="${approval.permit.contractorDeployed}">

                    <div class="field">
                        <span class="field-label">
                            Contractor:
                        </span>
                        ${approval.permit.contractorName}
                    </div>

                    <div class="field">
                        <span class="field-label">
                            Supervisor:
                        </span>
                        ${approval.permit.contractorSupervisor}
                    </div>

                </c:if>

            </div>

        </div>

    </div>


    <!-- ===================================================== -->
    <!-- SECTION B -->
    <!-- ===================================================== -->

    <div class="section">

        <div class="section-title">
            B - Work Description
        </div>

        <div class="section-body">

            <div class="field-grid">

                <div class="field">
                    <span class="field-label">
                        Equipment Number:
                    </span>
                    ${approval.permit.equipmentNumber}
                </div>

                <div class="field">
                    <span class="field-label">
                        Location:
                    </span>
                    ${approval.permit.location}
                </div>

            </div>

            <div class="field" style="margin-top:10px;">

                <div class="field-label">
                    Proposed Work:
                </div>

                <div class="proposed-work">
                    ${approval.permit.proposedWork}
                </div>

            </div>

            <div class="field" style="margin-top:10px;">

                <span class="field-label">
                    Valid on Date:
                </span>

                ${approval.permit.validOnDate}

                &nbsp;&nbsp;&nbsp;

                <span class="field-label">
                    Time From:
                </span>

                ${approval.permit.timeFrom}

                &nbsp;&nbsp;&nbsp;

                <span class="field-label">
                    Time To:
                </span>

                ${approval.permit.timeTo}

            </div>

        </div>

    </div>


    <!-- ===================================================== -->
    <!-- SECTION C -->
    <!-- ===================================================== -->

    <div class="section">

        <div class="section-title">
            C - Hazard Identification
        </div>

        <div class="section-body">

            <div class="field-label">
                Hazards from equipment/installations:
            </div>

            <div class="hazard-list">

                <c:forEach items="${approval.hazards}" var="hazard">

                    <c:if test="${hazard.hazardCategory == 'EQUIPMENT_INSTALLATION'}">

                        <span class="hazard">
                            ✓ ${hazard.hazardName}
                        </span>

                    </c:if>

                </c:forEach>

            </div>


            <br>


            <div class="field-label">
                Hazards from work type/location:
            </div>

            <div class="hazard-list">

                <c:forEach items="${approval.hazards}" var="hazard">

                    <c:if test="${hazard.hazardCategory == 'WORK_TYPE_LOCATION'}">

                        <span class="hazard">
                            ✓ ${hazard.hazardName}
                        </span>

                    </c:if>

                </c:forEach>

            </div>


            <br>


            <div class="field-grid">

                <div class="field">

                    <span class="field-label">
                        Other Hazards:
                    </span>

                    <c:choose>

                        <c:when test="${not empty approval.otherHazards}">
                            ${approval.otherHazards}
                        </c:when>

                        <c:otherwise>
                            -
                        </c:otherwise>

                    </c:choose>

                </div>


                <div class="field">

                    <span class="field-label">
                        Other Hazards in accordance with Permit No:
                    </span>

                    <c:choose>

                        <c:when test="${not empty approval.relatedPermitNumber}">
                            ${approval.relatedPermitNumber}
                        </c:when>

                        <c:otherwise>
                            -
                        </c:otherwise>

                    </c:choose>

                </div>

            </div>

        </div>

    </div>


    <!-- ===================================================== -->
    <!-- SECTION D -->
    <!-- ===================================================== -->

    <div class="section">

        <div class="section-title">
            D - Protective Measures - Hazard Assessment Checklist
        </div>

        <div class="section-body" style="padding:0;">

            <table>

                <thead>

                <tr>

                    <th class="question">
                        Hazard assessment &amp; compliance checklist
                    </th>

                    <th class="yes-no">
                        Yes
                    </th>

                    <th class="yes-no">
                        No
                    </th>

                    <th class="signature">
                        Measure Implemented Sign.
                    </th>

                    <th class="signature">
                        Measure Lifted Sign.
                    </th>

                </tr>

                </thead>


                <tbody>

                <c:forEach
                        items="${approval.checklistResponses}"
                        var="checklist">

                    <tr>

                        <td>

                            <strong>
                                ${checklist.questionCode}
                            </strong>

                            ${checklist.questionText}


                            <c:if test="${not empty checklist.fieldValues}">

                                <div style="margin-top:8px;">

                                    <c:forEach
                                            items="${checklist.fieldValues}"
                                            var="field">

                                        <div style="margin-bottom:4px;">

                                            <strong>
                                                ${field.key}:
                                            </strong>

                                            ${field.value}

                                        </div>

                                    </c:forEach>

                                </div>

                            </c:if>

                        </td>


                        <!-- YES -->

                        <td class="yes-no">

                            <c:if test="${checklist.response == 'YES'}">

                                <span class="check">
                                    ✓
                                </span>

                            </c:if>

                        </td>


                        <!-- NO -->

                        <td class="yes-no">

                            <c:if test="${checklist.response == 'NO'}">

                                <span class="check">
                                    ✓
                                </span>

                            </c:if>

                        </td>


                        <!-- IMPLEMENTED -->

                        <td class="signature">

                            <c:if test="${not empty checklist.measureImplementedBy}">

                                <div class="sign-space">

                                    ${checklist.measureImplementedBy}

                                </div>

                            </c:if>

                        </td>


                        <!-- LIFTED -->

                        <td class="signature">

                            <div class="sign-space"></div>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </div>

    </div>


    <!-- ===================================================== -->
    <!-- SECTION E -->
    <!-- ===================================================== -->

    <div class="section">

        <div class="section-title">
            E - Post-work Measures required
        </div>

        <div class="section-body" style="padding:0;">

            <table>

                <thead>

                <tr>

                    <th style="width:65%;">
                        Item
                    </th>

                    <th style="width:10%;">
                        Yes
                    </th>

                    <th style="width:10%;">
                        No
                    </th>

                    <th style="width:15%;">
                        Answered By
                    </th>

                </tr>

                </thead>


                <tbody>

                <c:forEach
                        items="${approval.postWorkMeasures}"
                        var="measure">

                    <tr>

                        <td>

                            <strong>
                                ${measure.itemCode}.
                            </strong>

                            ${measure.itemText}

                            <c:if test="${not empty measure.otherText}">

                                <div style="margin-top:6px;">

                                    <strong>
                                        Other:
                                    </strong>

                                    ${measure.otherText}

                                </div>

                            </c:if>

                        </td>


                        <td class="yes-no">

                            <c:if test="${measure.response == 'YES'}">

                                <span class="check">
                                    ✓
                                </span>

                            </c:if>

                        </td>


                        <td class="yes-no">

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
                           </td>
                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </div>

    </div>


    <!-- ===================================================== -->
    <!-- SECTION F -->
    <!-- ===================================================== -->

    <div class="section">

        <div class="section-title">
            F - Approval of work permit after verification of measures
        </div>

        <div class="section-body">

            <div class="field-grid">

                <div class="field">

                    <span class="field-label">
                        Date:
                    </span>
                          ____________________
                   <%-- <c:choose>

                        <c:when test="${not empty approval.issuerApprovalDateTime}">

                            ${approval.issuerApprovalDateTime}

                        </c:when>

                        <c:otherwise>

                            ____________________

                        </c:otherwise>

                    </c:choose> --%>

                </div>


                <div class="field">

                    <span class="field-label">
                        Signature:
                    </span>
                          ____________________
                    <div class="sign-space"></div>

                </div>

            </div>


            <div style="margin-top:10px;">
                (Permit Issuer)
                <strong>
                    ${approval.permit.issuerName}
                </strong>
            </div>

        </div>

    </div>


    <!-- ===================================================== -->
    <!-- SECTION G -->
    <!-- ===================================================== -->

    <div class="section">

        <div class="section-title">
            G - Acceptance of Permit for work to be conducted
        </div>

        <div class="section-body">

            <p>
                It is confirmed that we have reviewed the measures
                taken and work can be undertaken safely.
            </p>


            <div class="field-grid">

                <div class="field">

                    <span class="field-label">
                        Date:
                    </span>

                    ____________________

                </div>

                <div class="field">

                    <span class="field-label">
                        Name &amp; Signature:
                    </span>
                          ____________________
                    <div class="sign-space"></div>

                <%--    ${approval.permit.acceptorName} --%>

                </div>


                <c:if test="${approval.permit.contractorDeployed}">

                    <div class="field">

                        <span class="field-label">
                            Date:
                        </span>

                        ____________________

                    </div>

                    <div class="field">

                        <span class="field-label">
                            Contractor Supervisor Signature:
                        </span>
                                      ____________________
                        <div class="sign-space"></div>

                      <%--  ${approval.permit.contractorSupervisor} --%>

                    </div>

                </c:if>

            </div>

        </div>

    </div>

</div>


<!-- ===================================================== -->
<!-- PRINT ACTION -->
<!-- ===================================================== -->

<div class="print-actions">

    <button type="button"
            onclick="window.print()">

        Print Permit

    </button>

</div>

</body>

</html>