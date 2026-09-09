<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Permit Details</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container my-4">
    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <div> <h4 class="mb-1">Cold Work Permit  </h4>
                </div>
                 <div class="row g-3">
                    <div class="col-md-6">
                       <label class="form-label fw-semibold"> Status </label>
                         <div><span class="badge text-bg-warning">
                               ${permit.status}
                               </span>
                         </div>
                    </div>
            </div>
        </div>
    </div>
    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <div class="d-flex align-items-baseline mb-3">
                <h5 class="section-title mb-0"> SECTION A — GENERAL INFORMATION
                </h5>
            </div>
            <div class="row g-3">
                <!-- Permit Type -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">  Permit Type </label>
                    <div class="form-control bg-light"> ${permit.permitType}
                   </div>
                </div>
                <!-- Permit Number -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Permit Number</label>
                    <div class="form-control bg-light">${permit.permitNumber} </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Permit Issuer Department
                    </label>
                    <div class="form-control bg-light">
                        ${permit.issuerDepartment}
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Permit Issuer Name
                    </label>
                    <div class="form-control bg-light">
                        ${permit.issuerName}
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Permit Acceptor Department
                    </label>
                    <div class="form-control bg-light">
                        ${permit.acceptorDepartment}
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Permit Acceptor Name
                    </label>
                    <div class="form-control bg-light">
                        ${permit.acceptorName}
                    </div>
                </div>

             <div class="col-12">
                 <label class="form-label fw-semibold">
                     Contractor Deployment
                 </label>
                 <div class="border rounded p-3 bg-light">
                     <c:choose>
                         <c:when test="${permit.contractorDeployed}">
                             <div class="mb-3">
                                 <span class="badge bg-success">
                                     YES
                                 </span>
                             </div>
                             <div class="row g-3">
                                 <!-- Contractor -->
                                 <div class="col-md-6">
                                     <label class="form-label fw-semibold">
                                         Contractor
                                     </label>
                                     <div class="form-control bg-white">
                                         ${permit.contractorName}
                                     </div>
                                 </div>
                                 <div class="col-md-6">
                                     <label class="form-label fw-semibold">
                                         Supervisor Name
                                     </label>
                                     <div class="form-control bg-white">
                                         ${permit.contractorSupervisor}
                                     </div>
                                 </div>
                             </div>
                         </c:when>
                         <c:otherwise>
                             <!-- No -->
                             <span class="badge bg-secondary">  NO  </span>
                         </c:otherwise>
                     </c:choose>
                 </div>
             </div>
            </div>
        </div>
    </div>
    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-baseline mb-3">
                <h5 class="section-title mb-0">
                    SECTION B — WORK DESCRIPTION
                </h5>
            </div>
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-semibold">
                        Equipment Number
                    </label>
                    <div class="form-control bg-light">
                        ${permit.equipmentNumber}
                    </div>
                </div>
                <!-- Location -->
                <div class="col-md-8">
                    <label class="form-label fw-semibold">
                        Location
                    </label>
                    <div class="form-control bg-light">
                        ${permit.location}
                    </div>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">
                        Proposed Work
                    </label>
                    <div class="form-control bg-light" style="height:auto; min-height:100px;">
                        ${permit.proposedWork}
                    </div>
                </div>
<div class="col-12">
    <label class="form-label fw-semibold">
        Any Hazard Activity
    </label>
    <div class="border rounded p-3 bg-light">
        <c:if test="${permit.liftShiftByEquipment}">
            <div class="form-check mb-2">
                <input type="checkbox" class="form-check-input" checked disabled>
                <label class="form-check-label">
                    Lift &amp; shift by equipment
                </label>
            </div>
        </c:if>
        <c:if test="${permit.hazardousChemicalExposure}">
            <div class="form-check mb-2">
                <input type="checkbox" class="form-check-input" checked disabled >
                <label class="form-check-label">
                    Exposure to hazardous chemical
                </label>
            </div>
        </c:if>
        <c:if test="${not empty permit.otherHazardActivity}">
            <div class="form-check mb-2">
                <input type="checkbox" class="form-check-input" checked disabled>
                <label class="form-check-label">
                    Any other:
                </label>
                <span class="ms-2">
                    ${permit.otherHazardActivity}
                </span>
            </div>
        </c:if>
        <c:if test="${not permit.liftShiftByEquipment
                     and not permit.hazardousChemicalExposure
                     and empty permit.otherHazardActivity}">
            <span class="text-muted">
                No hazard activity selected.
            </span>
        </c:if>
    </div>
</div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">
                        Valid On
                    </label>
                    <div class="form-control bg-light">
                        ${permit.validOnDate}
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">
                       Time From
                    </label>
                    <div class="form-control bg-light">
                        ${permit.timeFrom}
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">
                        Time To
                    </label>
                    <div class="form-control bg-light">
                        ${permit.timeTo}
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-baseline mb-3">
                <h5 class="section-title mb-0">
                    Workflow Information
                </h5>
            </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Current Stage
                    </label>
                    <div>
                        <span class="badge text-bg-info">
                            ${permit.currentStage}
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card shadow-sm mb-5">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <div class="text-muted small">
                    <strong>Note:</strong>
                    Review the permit details before submitting
                    it to the acceptor for verification.
                </div>

                 <c:choose>

                <c:when test="${permit.status == 'DRAFT'}">
                <form method="post" action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/submit">
                  <input type= "hidden"  name="${_csrf.parameterName}" value="${_csrf.token}">
                      <button type="submit" class="btn btn-primary px-4">
                              Submit to Acceptor
                       </button>
                    </form>
                    </c:when>
                 <c:otherwise>
                  <button type="submit" class="btn btn-primary px-4" disabled>Sent to Acceptor </button>
                   </c:otherwise>
             </c:choose>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">\</script>
</body>

</html>