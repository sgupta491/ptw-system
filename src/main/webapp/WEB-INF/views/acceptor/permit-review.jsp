<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Verify Permit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5">
    <!-- HEADER -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h3 class="mb-0"> Verify Permit </h3>
            <span class="badge bg-warning text-dark">
                ${permit.status}
            </span>
        </div>
    </div>
    <!-- ERROR -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}
        </div>
    </c:if>
    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <h5 class="mb-0">   A - General Information  </h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Permit Number</label>
                    <div class="form-control bg-light"> ${permit.permitNumber}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Permit Type </label>
                    <div class="form-control bg-light"> ${permit.permitType}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Issuer Department</label>
                    <div class="form-control bg-light"> ${permit.issuerDepartment}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Issuer Name</label>
                    <div class="form-control bg-light"> ${permit.issuerName}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Acceptor Department </label>
                    <div class="form-control bg-light">${permit.acceptorDepartment} </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Acceptor Name </label>
                    <div class="form-control bg-light"> ${permit.acceptorName} </div>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">Contractor Deployment</label>
                    <div class="border rounded p-3 bg-light">
                        <c:choose>
                            <c:when test="${permit.contractorDeployed}">
                                <span class="badge bg-success mb-3">
                                    YES
                                </span>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label"> Contractor </label>
                                        <div class="form-control bg-white"> ${permit.contractorName}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label"> Supervisor Name</label>
                                        <div class="form-control bg-white">${permit.contractorSupervisor}</div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">
                                    NO
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <h5 class="mb-0">B - Work Description </h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Equipment Number</label>
                    <div class="form-control bg-light"> ${permit.equipmentNumber} </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Location </label>
                    <div class="form-control bg-light"> ${permit.location}</div>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold"> Proposed Work</label>
                    <div class="form-control bg-light" style="height:auto; min-height:100px;">
                        ${permit.proposedWork}
                    </div>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold"> Any Hazard Activity</label>
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
                            <div class="mb-2">
                                ✓ Any other:
                                ${permit.otherHazardActivity}
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
                <!-- VALIDITY -->
                <div class="col-md-4">
                    <label class="form-label fw-semibold"> Valid On  </label>
                    <div class="form-control bg-light">  ${permit.validOnDate} </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold"> Time From </label>
                    <div class="form-control bg-light">${permit.timeFrom} </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold"> Time To</label>
                    <div class="form-control bg-light">${permit.timeTo}
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card shadow-sm">
        <div class="card-header">
            <h5 class="mb-0">  Acceptor Verification</h5>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/review">
                <!-- CSRF -->
                <input type="hidden" name="${_csrf.parameterName}"value="${_csrf.token}">
                <!-- Remarks -->
                <div class="mb-4">
                    <label class="form-label fw-semibold">Remarks </label>
                    <textarea  name="remarks" class="form-control" rows="4" placeholder="Enter remarks if required"></textarea>
                </div>
                <!-- Actions -->
                <div class="d-flex justify-content-end gap-2">
                    <button type="submit" name="action" value="SENT_BACK" class="btn btn-danger">
                        Send Back
                    </button>
                    <button type="submit" name="action" value="VERIFY_AND_ACCEPT" class="btn btn-success">
                        Verify &amp; Accept
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>