<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Permit Assessment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>

.checklist-table {
    width: 100%;
    table-layout: fixed;
    }

.checklist-table th,
.checklist-table td {
     vertical-align: middle;
     }

.question-column {
   width: 55%;
 }

.response-column {
     width: 7%;
}

.sign-column {
     width: 15.5%;
}

.checklist-section-header td {
     background-color: #f1f3f5;
     font-weight: 600;
}

.checklist-table .form-check-input {
     width: 18px;
     height: 18px;
     cursor: pointer;
}

.implemented-sign {
   font-size: 0.9rem;
   font-weight: 600;
 }

 </style>
</head>

<body class="bg-light">
<div class="container my-5">
    <!-- HEADER -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
            <h3 class="mb-0"> Permit Assessment</h3>
            <span class="badge bg-light text-dark">
                ${permit.status}
            </span>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <strong> Permit Number: </strong>
                    ${permit.permitNumber}
                </div>
                <div class="col-md-6">
                    <strong>  Permit Type: </strong>
                    ${permit.permitType}
                </div>
            </div>
        </div>
    </div>

    <!-- SECTION A -->

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">
                A - General Information
            </h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Issuer Department
                    </label>
                    <div class="form-control bg-light"> ${permit.issuerDepartment}
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Issuer Name</label>
                    <div class="form-control bg-light"> ${permit.issuerName}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Acceptor Department </label>
                    <div class="form-control bg-light">  ${permit.acceptorDepartment} </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Acceptor Name </label>
                    <div class="form-control bg-light"> ${permit.acceptorName}</div>
                </div>
                 <div class="col-12">
                    <label class="form-label fw-semibold">Proposed Work</label>
                     <div class="form-control bg-light" style="height:auto; min-height:100px;"> ${permit.proposedWork} </div>
                 </div>
            </div>
        </div>
    </div>

    <!-- SECTION B -->

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0"> B - Work Description</h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Equipment Number </label>
                    <div class="form-control bg-light"> ${permit.equipmentNumber}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Location</label>
                    <div class="form-control bg-light">${permit.location} </div>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">Proposed Work in Detail</label>
                    <div class="form-control bg-light" style="height:auto; min-height:100px;"> ${permit.proposedWorkInDetail} </div>
                </div>
                <!-- Contractor -->
                 <div class="col-md-6">
                    <label class="form-label fw-semibold">Contractor Deployed</label>
                      <div>
                        <c:choose>
                            <c:when test="${permit.contractorDeployed}">
                               <span class="badge bg-success"> Yes</span>
                          </c:when>
                            <c:otherwise>
                              <span class="badge bg-secondary">
                                 No
                                 </span>
                                 </c:otherwise>
                                 </c:choose>
                              </div>
                                </div>
                                <c:if test="${permit.contractorDeployed}">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold"> Contractor </label>
                                        <div class="form-control bg-light">${permit.contractorName} </div>
                                    </div>
                                </c:if>
                                 <div class="col-md-6">
                                   <label class="form-label fw-semibold">Supervisor Name</label>
                                    <div class="form-control bg-light">${permit.contractorSupervisor}</div>
                                     </div>
                <!-- Any Hazard Activity -->
                <div class="col-12">
                    <label class="form-label fw-semibold">
                        Any Hazard Activity
                    </label>
                    <div class="border rounded p-3 bg-light">
                        <c:if test="${permit.liftShiftByEquipment}">
                            <div class="mb-2">
                                ✓ Lift &amp; shift by equipment
                            </div>
                        </c:if>
                        <c:if test="${permit.hazardousChemicalExposure}">
                            <div class="mb-2">
                                ✓ Exposure to hazardous chemical
                            </div>
                        </c:if>
                        <c:if test="${not empty permit.otherHazardActivity}">
                            <div>
                                ✓ Any other:
                                ${permit.otherHazardActivity}
                            </div>
                        </c:if>
                        <c:if  test="${not permit.liftShiftByEquipment
                                    and not permit.hazardousChemicalExposure
                                    and empty permit.otherHazardActivity}">
                            <span class="text-muted">
                                No hazard activity selected.
                            </span>
                        </c:if>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Valid Date</label>
                    <div class="form-control bg-light"> ${permit.validOnDate}</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Time From</label>
                    <div class="form-control bg-light"> ${permit.timeFrom} </div>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Time To</label>
                    <div class="form-control bg-light"> ${permit.timeTo}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- SECTION C -->
    <form method="post" action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/assessment">
        <input type="hidden" name="${_csrf.parameterName}"value="${_csrf.token}">

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">C - Hazard Identification </h5>
        </div>
        <div class="card-body">
            <div class="row g-4">
                <!-- EQUIPMENT HAZARDS -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Hazards from equipment/installations:</label>
                    <div class="border rounded p-3 bg-light">
                    <div class="row">
                        <c:forEach items="${hazards}" var="hazard">
                            <c:if test="${hazard.hazardCategory  == 'EQUIPMENT_INSTALLATION'}">
                              <div class="col-md-4 mb-2">
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" name="hazardIds" value="${hazard.id}" id="hazard_${hazard.id}">
                                    <label class="form-check-label" for="hazard_${hazard.id}">
                                        ${hazard.hazardName}
                                    </label>
                                  </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        </div>
                    </div>
                </div>
                <!-- WORK LOCATION HAZARDS -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Hazards from work type/location: </label>
                    <div class="border rounded p-3 bg-light">
                    <div class="row">
                        <c:forEach items="${hazards}" var="hazard">
                            <c:if test="${hazard.hazardCategory == 'WORK_TYPE_LOCATION'}">
                                <div class="col-md-4 mb-2">
                                  <div class="form-check">
                                    <input type="checkbox" class="form-check-input" name="hazardIds"
                                            value="${hazard.id}" id="hazard_${hazard.id}">
                                    <label class="form-check-label" for="hazard_${hazard.id}">
                                        ${hazard.hazardName}
                                    </label>
                                </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        </div>
                    </div>
                </div>
                <!-- OTHER HAZARDS -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Other hazards:
                    </label>
                    <input type="text" name="otherHazards" class="form-control">
                </div>
                <!-- RELATED PERMIT -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Other hazards in accordance
                        with Permit No:
                    </label>
                    <input type="text" name="relatedPermitNumber" class="form-control">
                </div>
            </div>
        </div>
    </div>

     <!-- SECTION D -->


<div class="card shadow-sm mb-4">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0">
            D - Protective Measures – Hazard Assessment Checklist
        </h5>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-bordered mb-0 align-middle checklist-table">
                <thead class="table-light">
                <tr>
                    <th class="question-column">Hazard assessment &amp; compliance checklist</th>
                    <th class="response-column text-center">Yes</th>
                    <th class="response-column text-center">No</th>
                    <th class="sign-column text-center">Measure Implemented Sign.</th>
                    <th class="sign-column text-center">Measure Lifted Sign.</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${checklistQuestions}" var="question">
                    <c:choose>
                        <c:when test="${question.itemType == 'HEADER'}">
                            <tr class="checklist-section-header">
                                <td colspan="5">
                                    <strong>${question.questionCode}</strong>
                                    &nbsp;
                                    ${question.questionText}
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td> <div class="mb-1">
                                        <strong> ${question.questionCode} </strong>
                                        &nbsp;
                                        ${question.questionText}
                                    </div>
                                 <c:if test="${not empty question.fields}">
                                     <div class="mt-2">
                                         <c:forEach items="${question.fields}" var="field">

                                             <div class="row align-items-center mb-2">
                                                 <div class="col-md-4">
                                                     <label class="form-label mb-1">
                                                         ${field.fieldLabel}

                                                         <c:if test="${field.required}">
                                                             <span class="text-danger">*</span>
                                                         </c:if>
                                                     </label>
                                                 </div>

                                                 <div class="col-md-8">

                                                     <c:choose>

                                                         <c:when test="${field.fieldType == 'TEXT'}">
                                                             <input type="text"
                                                                    class="form-control form-control-sm"
                                                                    name="checklistResponses[${question.id}].fieldValues[${field.id}]"
                                                                    <c:if test="${field.required}">
                                                                        required
                                                                    </c:if>>
                                                         </c:when>

                                                         <c:when test="${field.fieldType == 'NUMBER'}">
                                                             <input type="number"
                                                                    class="form-control form-control-sm"
                                                                    name="checklistResponses[${question.id}].fieldValues[${field.id}]"
                                                                    <c:if test="${field.required}">
                                                                        required
                                                                    </c:if>>
                                                         </c:when>

                                                         <c:when test="${field.fieldType == 'DATE'}">
                                                             <input type="date"
                                                                    class="form-control form-control-sm"
                                                                    name="checklistResponses[${question.id}].fieldValues[${field.id}]"
                                                                    <c:if test="${field.required}">
                                                                        required
                                                                    </c:if>>
                                                         </c:when>

                                                         <c:when test="${field.fieldType == 'TIME'}">
                                                             <input type="time"
                                                                    class="form-control form-control-sm"
                                                                    name="checklistResponses[${question.id}].fieldValues[${field.id}]"
                                                                    <c:if test="${field.required}">
                                                                        required
                                                                    </c:if>>
                                                         </c:when>

                                                         <c:otherwise>
                                                             <input type="text" class="form-control form-control-sm"
                                                                    name="checklistResponses[${question.id}].fieldValues[${field.id}]">
                                                         </c:otherwise>
                                                     </c:choose>
                                                 </div>
                                             </div>
                                         </c:forEach>
                                     </div>
                                 </c:if>

                                 <!-- THIS IS THE HIDDEN CHECKLIST ID -->
                                 <input type="hidden" name="checklistResponses[${question.id}].checklistId"  value="${question.id}">
                                 </td>
                                <td class="text-center">
                                 <div class="form-check d-flex justify-content-center align-items-center gap-1">
                                            <input type="radio"
                                                   class="form-check-input checklist-response"
                                                   name="checklistResponses[${question.id}].response"
                                                   value="YES"
                                                   data-question-id="${question.id}"
                                                   id="yes_${question.id}">
                                                <label class="form-check-label mb-0" for="yes_${question.id}">
                                                   Yes
                                                 </label>
                                    </div>
                                  </td>

                                        <!-- NO -->
                                        <td class="text-center">
                                          <div class="form-check d-flex justify-content-center align-items-center gap-1">
                                            <input type="radio"
                                                   class="form-check-input checklist-response"
                                                   name="checklistResponses[${question.id}].response"
                                                   value="NO"
                                                   data-question-id="${question.id}"
                                                    id="no_${question.id}">
                                            <label class="form-check-label mb-0"
                                                           for="no_${question.id}">
                                                        No
                                                    </label>
                                                </div>
                                        </td>

                                        <!-- IMPLEMENTED SIGN -->
                                        <td class="text-center">
                                            <span id="implementedSign_${question.id}"
                                                  class="implemented-sign text-muted">
                                                -
                                            </span>
                                        </td>

                                        <!-- LIFTED SIGN -->
                                        <td class="text-center">
                                            <span id="liftedSign_${question.id}"
                                                  class="lifted-sign text-muted">
                                                -
                                            </span>
                                        </td>

                            </tr>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!--<div id="electricalIsolationMessage" class="alert alert-warning mt-3" style="display:none;">
    Electrical isolation is required.
    The permit will be forwarded to the
    Electrical Department for isolation and testing.
</div>  -->

<!-- SECTION E -->

<div class="card shadow-sm mb-4">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0"> E - Post-work Measures required</h5>
    </div>
    <div class="card-body">
        <div class="row align-items-center mb-4">
            <div class="col-md-8">
                <strong>  1.</strong>
                All tools and garbage removed from
                work place and area is clean and
                safe for working
            </div>
            <div class="col-md-2 text-center">
                <label class="form-label d-block">  Yes</label>
                <input type="radio" class="form-check-input" name="postWorkMeasures[0].response" value="YES">
            </div>

            <div class="col-md-2 text-center">
                <label class="form-label d-block"> No</label>
                <input type="radio" class="form-check-input" name="postWorkMeasures[0].response" value="NO">
            </div>

            <input type="hidden" name="postWorkMeasures[0].itemCode" value="E-1">
        </div>
        <div class="row align-items-center">
            <div class="col-md-8">
                <strong> 2. </strong>
                Other:
                <input type="text" class="form-control mt-2" name="postWorkMeasures[1].otherText">
            </div>

            <div class="col-md-2 text-center">
                <label class="form-label d-block">  Yes </label>
                <input type="radio" class="form-check-input" name="postWorkMeasures[1].response" value="YES">
            </div>

            <div class="col-md-2 text-center">
                <label class="form-label d-block"> No </label>
                <input type="radio"  class="form-check-input" name="postWorkMeasures[1].response" value="NO">
            </div>
            <input type="hidden" name="postWorkMeasures[1].itemCode" value="E-2">
        </div>
    </div>
</div>
<div class="d-flex justify-content-end mt-4">
    <button type="submit" class="btn btn-success btn-lg">
       Save & Continue</button>
</div>

</form>

</body>
<script>

document.addEventListener("DOMContentLoaded", function () {

    const issuerName = "${permit.issuerName}";
    document.querySelectorAll(".checklist-response")
        .forEach(function (radio) {
            radio.addEventListener("change", function () {
                const questionId = this.dataset.questionId;

                const sign = document.getElementById("implementedSign_" + questionId);

                if (sign) {
                    sign.textContent = issuerName;
                    sign.classList.remove("text-muted");
                }

            });

        });

});

</script>
</html>