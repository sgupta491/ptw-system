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
                                    <input type="checkbox" class="form-check-input"
                                    name="hazardIds" value="${hazard.id}" id="hazard_${hazard.id}"
                                     <c:if test="${assessmentRequest.hazardIds != null
                                       and assessmentRequest.hazardIds.contains(hazard.id)}">
                                               checked
                                           </c:if>
                                       <c:if test="${assessmentReadOnly}">
                                               disabled
                                           </c:if>>
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
                                     value="${hazard.id}" id="hazard_${hazard.id}"
                                      <c:if test="${assessmentRequest.hazardIds != null
                                        and assessmentRequest.hazardIds.contains(hazard.id)}">
                                          checked
                                          </c:if>
                                           <c:if test="${assessmentReadOnly}">
                                              disabled
                                            </c:if>>
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
                    <input type="text" name="otherHazards" class="form-control" value="${assessmentRequest.otherHazards}"
                      <c:if test="${assessmentReadOnly}">readonly</c:if>>
                </div>
                <!-- RELATED PERMIT -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Other hazards in accordance
                        with Permit No:
                    </label>
                    <input type="text" name="relatedPermitNumber" class="form-control"
                     value="${assessmentRequest.relatedPermitNumber}"
                           <c:if test="${assessmentReadOnly}">
                               readonly
                           </c:if>>
                </div>
            </div>
        </div>
    </div>

     <!-- SECTION D -->

<div id="electricalIsolationMessage" class="alert alert-warning mt-3" style="display:none;">
    <div class="fw-bold mb-1">
        Electrical Isolation Required
    </div>
    <div>
        Electrical isolation is required for this permit.
        Please save the assessment and create the Electrical Work Request.
    </div>
</div>

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
                           <c:choose>
                               <c:when test="${question.questionCode == '3'}">
                                   <tr class="checklist-section-header">
                                       <td>
                                           <div>
                                               <strong>${question.questionCode}</strong>
                                               &nbsp;
                                               <strong>Making Electrical isolation safe</strong>
                                           </div>
                                           <div class="mt-2">
                                               <strong>Electrical Isolation Required</strong>
                                           </div>

                                           <c:if test="${not empty workRequest}">
                                              <c:choose>
                                                   <c:when test="${permit.electricalIsolationStatus == 'PENDING'}">
                                                       <div class="alert alert-warning mt-3 mb-0">
                                                        <div class="fw-bold">
                                                          Electrical Isolation Pending
                                                            </div>
                                                        <div class="small mt-1">
                                                        Work Order:
                                                        <strong>${workRequest.woNumber}</strong>
                                                        </div>
                                                        <div class="small">
                                                        Maintenance work is pending.
                                                        Permit cannot be printed until isolation is completed.
                                                     </div>
                                                     </div>
                                                     </c:when>
                                                        <c:when test="${permit.electricalIsolationStatus == 'COMPLETED'}">
                                                          <div class="alert alert-success mt-3 mb-0">
                                                            <div class="fw-bold mb-2">
                                                              Electrical Isolation Completed
                                                               </div>
                                                                <div class="row g-2">
                                                                   <div class="col-md-4">
                                                                     <strong>WO No:</strong>
                                                                      ${workRequest.woNumber}
                                                                    </div>
                                                                    <div class="col-md-4">
                                                                      <strong>Equipment No:</strong>
                                                                      ${workRequest.isolationEquipmentNumber}
                                                                     </div>
                                                                    <div class="col-md-4">
                                                                      <strong>Feeder No:</strong>
                                                                       ${workRequest.feederNumber}
                                                                     </div>
                                                                      <div class="col-md-4">
                                                                         <strong>LOTO No:</strong>
                                                                          ${workRequest.lotoNumber}
                                                                          </div>
                                                                         <div class="col-md-4">
                                                                         <strong>Completed By:</strong>
                                                                         ${workRequest.workCompletedBy}
                                                                         </div>
                                                                     <div class="col-md-4">
                                                                         <strong>Completed At:</strong>
                                                                        ${workRequest.completedAt}
                                                                     </div>
                                                           </div>
                                                          </div>
                                                        </c:when>
                                                   </c:choose>
                                           </c:if>

                                           <input type="hidden"  name="checklistResponses[${question.id}].checklistId" value="${question.id}">
                                       </td>
                                       <td class="text-center">
                                           <div class="form-check d-flex justify-content-center align-items-center gap-1">
                                               <input type="radio" class="form-check-input checklist-response"
                                               name="checklistResponses[${question.id}].response" value="YES"
                                               data-question-id="${question.id}" data-question-code="${question.questionCode}"
                                               id="yes_${question.id}"
                                               <c:if test="${assessmentRequest.checklistResponses[question.id].response == 'YES'}">
                                                  checked
                                                </c:if>
                                                <c:if test="${assessmentReadOnly}">
                                                  disabled
                                                 </c:if>>
                                               <label class="form-check-label mb-0"
                                                      for="yes_${question.id}">
                                                   Yes
                                               </label>
                                           </div>

                                       </td>
                                       <!-- NO -->
                                       <td class="text-center">
                                           <div class="form-check d-flex justify-content-center align-items-center gap-1">
                                               <input type="radio" class="form-check-input checklist-response"
                                                name="checklistResponses[${question.id}].response"
                                                value="NO" data-question-id="${question.id}"
                                                data-question-code="${question.questionCode}" id="no_${question.id}"
                                                 <c:if test="${assessmentRequest.checklistResponses[question.id].response == 'NO'}">
                                                   checked
                                                  </c:if>
                                                  <c:if test="${assessmentReadOnly}">
                                                     disabled
                                                   </c:if>>
                                               <label class="form-check-label mb-0"
                                                      for="no_${question.id}">
                                                   No
                                               </label>
                                           </div>
                                       </td>
                                       <td class="text-center">
                                           <span id="implementedSign_${question.id}"
                                                 class="implemented-sign text-muted">
                                               -
                                           </span>
                                       </td>
                                       <td class="text-center">
                                           <span id="liftedSign_${question.id}"
                                                 class="lifted-sign text-muted">
                                               -
                                           </span>
                                       </td>
                                   </tr>
                               </c:when>
                               <c:otherwise>
                                   <tr class="checklist-section-header">
                                       <td colspan="5">
                                           <strong>${question.questionCode}</strong>
                                           &nbsp;
                                           ${question.questionText}
                                       </td>
                                   </tr>
                               </c:otherwise>
                           </c:choose>
                       </c:when>
                        <c:otherwise>
                            <tr>
                                <td>
                                <c:choose>
                                    <c:when test="${checklist.questionCode == '3.1'}">
                                        <div class="mb-2">
                                            <strong>3.1</strong>
                                            &nbsp;
                                            Deactivate power supply and testing
                                        </div>
                                        <div class="border rounded p-3 bg-light">
                                            <div class="mb-2">
                                                <strong>Work Order No:</strong>
                                                ${workRequest.woNumber}
                                            </div>
                                            <div class="mb-2">
                                                <strong>Equipment No:</strong>
                                                ${workRequest.isolationEquipmentNumber}
                                            </div>
                                            <div class="mb-2">
                                                <strong>Feeder No:</strong>
                                                ${workRequest.feederNumber}
                                            </div>
                                            <div class="mb-2">
                                                <strong>LOTO Tag No:</strong>
                                                ${workRequest.lotoNumber}
                                            </div>
                                            <div class="mt-3">
                                                <strong>
                                                    Name &amp; signature of electrician:
                                                </strong>
                                                <div style=" margin-top:12px; width:80%;
                                                    border-bottom:1px solid #000; height:30px; ">
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mb-1">
                                            <strong>${question.questionCode}</strong>
                                            &nbsp;
                                            ${question.questionText}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
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
                                                             <input type="text" class="form-control form-control-sm"
                                                             name="checklistResponses[${question.id}].fieldValues[${field.id}]"
                                                               <c:if test="${field.required}"> required</c:if>
                                                              value="${assessmentRequest.checklistResponses[question.id].fieldValues[field.id]}"
                                                               <c:if test="${assessmentReadOnly}">
                                                                 readonly
                                                                 </c:if>>
                                                         </c:when>
                                                         <c:when test="${field.fieldType == 'NUMBER'}">
                                                             <input type="number"
                                                                    class="form-control form-control-sm"
                                                                    name="checklistResponses[${question.id}].fieldValues[${field.id}]"
                                                                    <c:if test="${field.required}">
                                                                        required
                                                                    </c:if>
                                                                     value="${assessmentRequest.checklistResponses[question.id].fieldValues[field.id]}"
                                                                     <c:if test="${assessmentReadOnly}">
                                                                        readonly
                                                                    </c:if>>
                                                         </c:when>

                                                         <c:when test="${field.fieldType == 'DATE'}">
                                                             <input type="date"
                                                                    class="form-control form-control-sm"
                                                                    name="checklistResponses[${question.id}].fieldValues[${field.id}]"
                                                                    <c:if test="${field.required}">
                                                                        required
                                                                    </c:if>
                                                                     value="${assessmentRequest.checklistResponses[question.id].fieldValues[field.id]}"
                                                                       <c:if test="${assessmentReadOnly}">
                                                                         readonly
                                                                       </c:if>>
                                                         </c:when>

                                                         <c:when test="${field.fieldType == 'TIME'}">
                                                             <input type="time"
                                                                    class="form-control form-control-sm"
                                                                    name="checklistResponses[${question.id}].fieldValues[${field.id}]"
                                                                    <c:if test="${field.required}">
                                                                        required
                                                                    </c:if>
                                                                     value="${assessmentRequest.checklistResponses[question.id].fieldValues[field.id]}"
                                                                     <c:if test="${assessmentReadOnly}">
                                                                       readonly
                                                                    </c:if>>
                                                         </c:when>

                                                         <c:otherwise>
                                                             <input type="text" class="form-control form-control-sm"
                                                              name="checklistResponses[${question.id}].fieldValues[${field.id}]"
                                                              value="${assessmentRequest.checklistResponses[question.id].fieldValues[field.id]}"
                                                                   <c:if test="${assessmentReadOnly}">
                                                                              readonly
                                                                          </c:if>>
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
                                                     data-question-code="${question.questionCode}"
                                                   id="yes_${question.id}"
                                                   <c:if test="${assessmentRequest.checklistResponses[question.id].response == 'YES'}">
                                                     checked</c:if>
                                                    <c:if test="${assessmentReadOnly}"> disabled</c:if>>
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
                                                    data-question-code="${question.questionCode}"
                                                    id="no_${question.id}"
                                                    <c:if test="${assessmentRequest.checklistResponses[question.id].response == 'NO'}">
                                                               checked
                                                           </c:if>
                                                           <c:if test="${assessmentReadOnly}">
                                                               disabled
                                                           </c:if>>
                                            <label class="form-check-label mb-0" for="no_${question.id}">
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
                <input type="radio" class="form-check-input" name="postWorkMeasures[0].response" value="YES"
                <c:if test="${assessmentRequest.postWorkMeasures[0].response == 'YES'}">
                  checked </c:if>
                  <c:if test="${assessmentReadOnly}">disabled</c:if>>
            </div>

            <div class="col-md-2 text-center">
                <label class="form-label d-block"> No</label>
                <input type="radio" class="form-check-input" name="postWorkMeasures[0].response" value="NO"
                <c:if test="${assessmentRequest.postWorkMeasures[0].response == 'NO'}">
                  checked</c:if>
                  <c:if test="${assessmentReadOnly}">disabled</c:if>>
            </div>

            <input type="hidden" name="postWorkMeasures[0].itemCode" value="E-1">
        </div>
        <div class="row align-items-center">
            <div class="col-md-8">
                <strong> 2. </strong>
                Other:
                <input type="text" class="form-control mt-2" name="postWorkMeasures[1].otherText"
                value="${assessmentRequest.postWorkMeasures[1].otherText}"
                       <c:if test="${assessmentReadOnly}">
                           readonly
                       </c:if>>
            </div>

            <div class="col-md-2 text-center">
                <label class="form-label d-block">  Yes </label>
                <input type="radio" class="form-check-input" name="postWorkMeasures[1].response" value="YES"
                 <c:if test="${assessmentRequest.postWorkMeasures[1].response == 'YES'}">checked</c:if>
                  <c:if test="${assessmentReadOnly}"> disabled </c:if>>
            </div>

            <div class="col-md-2 text-center">
                <label class="form-label d-block"> No </label>
                <input type="radio"  class="form-check-input" name="postWorkMeasures[1].response" value="NO"
                <c:if test="${assessmentRequest.postWorkMeasures[1].response == 'NO'}">checked</c:if>
                                  <c:if test="${assessmentReadOnly}"> disabled </c:if>>
            </div>
            <input type="hidden" name="postWorkMeasures[1].itemCode" value="E-2">
        </div>
    </div>
</div>

<c:choose>
    <c:when test="${not assessmentReadOnly}">
        <div class="d-flex justify-content-end mt-4 mb-4">
            <button type="submit" id="assessmentSubmitButton"
                    class="btn btn-success btn-lg">
                Save &amp; Continue
            </button>
        </div>
    </c:when>

    <c:when test="${assessmentReadOnly && not canPrint}">
        <div class="alert alert-warning mt-4 mb-4">
            <strong>Electrical Isolation Pending.</strong>
            <div class="mt-1">
                Permit cannot be printed until electrical isolation
                is completed by Maintenance.
            </div>
        </div>
    </c:when>

    <c:when test="${canPrint}">
        <div class="d-flex justify-content-end mt-4 mb-4">
            <button type="submit" formmethod="post"
              formaction="${pageContext.request.contextPath}/issuer/permits/${permit.id}/print"
               class="btn btn-success btn-lg">
                Print Permit
            </button>
        </div>
    </c:when>

</c:choose>

</form>

</form>

</body>
<script>
document.addEventListener("DOMContentLoaded", function () {

    const issuerName = "${permit.issuerName}";
    const electricalIsolationMessage = document.getElementById("electricalIsolationMessage");
    const assessmentSubmitButton = document.getElementById("assessmentSubmitButton");


    document.querySelectorAll(".checklist-response")
        .forEach(function (radio) {
            radio.addEventListener("change", function () {
                const questionId =  this.dataset.questionId;
                const questionCode = this.dataset.questionCode;


                const sign = document.getElementById("implementedSign_" + questionId);

                if (sign) {
                    sign.textContent = issuerName;
                    sign.classList.remove("text-muted");
                }


                if (questionCode === "3") {
                    if (this.value === "YES") {
                        electricalIsolationMessage.style.display = "block";
                        assessmentSubmitButton.textContent =
                            "Save Assessment & Create Work Request";
                        assessmentSubmitButton.classList.remove(
                            "btn-success"
                        );
                        assessmentSubmitButton.classList.add(
                            "btn-warning"
                        );
                    }
                    else if (this.value === "NO") {
                        electricalIsolationMessage.style.display = "none";
                        assessmentSubmitButton.textContent =
                            "Save & Continue";
                        assessmentSubmitButton.classList.remove(
                            "btn-warning"
                        );
                        assessmentSubmitButton.classList.add(
                            "btn-success"
                        );
                    }
                }
            });
        });

});

</script>
</html>