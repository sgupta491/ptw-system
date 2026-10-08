<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Permit Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <jsp:include page="/WEB-INF/views/common/toast.jsp"/>
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h3 class="mb-0">
                        Permit Details
                    </h3>
                </div>
                <!-- STATUS -->
                <div>
                    <c:choose>
                        <c:when test="${permit.status == 'PERMIT_IN_PROGRESS'}">
                            <span class="badge bg-warning text-dark fs-6 px-3 py-2">
                                PERMIT IN PROGRESS
                            </span>
                        </c:when>

                        <c:when test="${permit.status == 'PERMIT_ISSUED'}">
                            <span class="badge bg-success fs-6 px-3 py-2">
                                PERMIT ISSUED
                            </span>
                        </c:when>

                        <c:when test="${permit.status == 'ELECTRICAL_ISOLATION'}">
                            <span class="badge bg-danger fs-6 px-3 py-2">
                                ELECTRICAL ISOLATION
                            </span>
                        </c:when>

                        <c:when test="${permit.status == 'WORK_IN_PROGRESS'}">
                            <span class="badge bg-primary fs-6 px-3 py-2">
                                WORK IN PROGRESS
                            </span>
                        </c:when>

                        <c:when test="${permit.status == 'WORK_COMPLETED'}">
                            <span class="badge bg-info text-dark fs-6 px-3 py-2">
                                WORK COMPLETED
                            </span>
                        </c:when>
                        <c:when test="${permit.status == 'CLOSED'}">
                            <span class="badge bg-dark fs-6 px-3 py-2">
                                CLOSED
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary fs-6 px-3 py-2">
                                ${permit.status}
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    <c:if test="${permit.status == 'PERMIT_IN_PROGRESS'}">
        <div class="alert alert-warning shadow-sm">
            <strong>Action pending with Acceptor.</strong>
            Section A has been completed by the Issuer.
            The selected Acceptor must now complete Section B.
        </div>
    </c:if>



    <!-- ===================================================== -->
    <!-- SECTION A -->
    <!-- ===================================================== -->

    <div class="card shadow-sm mb-4">

        <div class="card-header">

            <h5 class="mb-0">
                A - General Information
            </h5>

        </div>


        <div class="card-body">

            <div class="row g-3">


                <!-- Permit Number -->

                <div class="col-md-6">

                    <label class="form-label fw-semibold">
                        Permit Number
                    </label>

                    <div class="form-control bg-light">
                        ${permit.permitNumber}
                    </div>

                </div>


                <!-- Permit Type -->

                <div class="col-md-6">

                    <label class="form-label fw-semibold">
                        Permit Type
                    </label>

                    <div class="form-control bg-light">
                        ${permit.permitType}
                    </div>

                </div>


                <!-- Issuer Department -->

                <div class="col-md-6">

                    <label class="form-label fw-semibold">
                        Permit Issuer - Department
                    </label>

                    <div class="form-control bg-light">
                        ${permit.issuerDepartment}
                    </div>

                </div>


                <!-- Issuer Name -->

                <div class="col-md-6">

                    <label class="form-label fw-semibold">
                        Permit Issuer - Name
                    </label>

                    <div class="form-control bg-light">
                        ${permit.issuerName}
                    </div>

                </div>


                <!-- Acceptor Department -->

                <div class="col-md-6">

                    <label class="form-label fw-semibold">
                        Permit Acceptor - Department
                    </label>

                    <div class="form-control bg-light">
                        ${permit.acceptorDepartment}
                    </div>

                </div>


                <!-- Acceptor Name -->

                <div class="col-md-6">

                    <label class="form-label fw-semibold">
                        Permit Acceptor - Name
                    </label>

                    <div class="form-control bg-light">
                        ${permit.acceptorName}
                    </div>

                </div>
                <!-- Proposed Work -->

                <div class="col-12">

                    <label class="form-label fw-semibold">
                        Proposed Work
                    </label>

                    <div
                            class="form-control bg-light"
                            style="height:auto; min-height:120px;">

                        <c:choose>

                            <c:when test="${not empty permit.proposedWork}">

                                ${permit.proposedWork}

                            </c:when>

                            <c:otherwise>

                                <span class="text-muted">
                                    No proposed work entered.
                                </span>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>


            </div>

        </div>

    </div>



    <!-- ===================================================== -->
    <!-- SECTION B -->
    <!-- ===================================================== -->

    <div class="card shadow-sm mb-4">

        <div class="card-header">

            <h5 class="mb-0">
                B - Work Description
            </h5>

        </div>


        <div class="card-body">

            <div class="row g-3">


                <!-- Equipment Number -->

                <div class="col-md-6">

                    <label class="form-label fw-semibold">
                        Equipment Number
                    </label>

                    <div class="form-control bg-light">

                        <c:choose>

                            <c:when test="${not empty permit.equipmentNumber}">

                                ${permit.equipmentNumber}

                            </c:when>

                            <c:otherwise>

                                <span class="text-muted">
                                    Pending Acceptor
                                </span>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>



                <!-- Location -->

                <div class="col-md-6">

                    <label class="form-label fw-semibold">
                        Location
                    </label>

                    <div class="form-control bg-light">

                        <c:choose>

                            <c:when test="${not empty permit.location}">

                                ${permit.location}

                            </c:when>

                            <c:otherwise>

                                <span class="text-muted">
                                    Pending Acceptor
                                </span>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>



                <!-- Proposed Work in Detail -->

                <div class="col-12">

                    <label class="form-label fw-semibold">
                        Proposed Work in Detail
                    </label>

                    <div
                            class="form-control bg-light"
                            style="height:auto; min-height:120px;">

                        <c:choose>

                            <c:when test="${not empty permit.proposedWorkInDetail}">

                                ${permit.proposedWorkInDetail}

                            </c:when>

                            <c:otherwise>

                                <span class="text-muted">
                                    To be completed by Acceptor in Section B.
                                </span>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>

                 <!-- Contractor -->

                                <div class="col-md-6">

                                    <label class="form-label fw-semibold">
                                        Contractor
                                    </label>

                                    <div class="form-control bg-light">

                                        <c:choose>

                                            <c:when test="${permit.contractorDeployed}">

                                                ${permit.contractorName}

                                            </c:when>

                                            <c:otherwise>

                                                Pending

                                            </c:otherwise>

                                        </c:choose>

                                    </div>

                                </div>

                <!-- Contractor Supervisor -->

                                <div class="col-md-6">

                                    <label class="form-label fw-semibold">
                                        Contractor Supervisor
                                    </label>

                                    <div class="form-control bg-light">

                                        <c:choose>

                                            <c:when test="${not empty permit.contractorSupervisor}">

                                                ${permit.contractorSupervisor}

                                            </c:when>

                                            <c:otherwise>

                                                -

                                            </c:otherwise>

                                        </c:choose>

                                    </div>

                                </div>




                <!-- Hazard Activity -->

                <div class="col-12">

                    <label class="form-label fw-semibold">
                        Any Hazard Activity
                    </label>


                    <div class="border rounded p-3 bg-light">


                        <!-- Lift Shift -->

                        <div class="form-check mb-2">

                            <input
                                    type="checkbox"
                                    class="form-check-input"
                                    disabled

                                    <c:if test="${permit.liftShiftByEquipment}">
                                        checked
                                    </c:if>
                            >

                            <label class="form-check-label">

                                Lift &amp; shift by equipment

                            </label>

                        </div>



                        <!-- Chemical -->

                        <div class="form-check mb-2">

                            <input
                                    type="checkbox"
                                    class="form-check-input"
                                    disabled

                                    <c:if test="${permit.hazardousChemicalExposure}">
                                        checked
                                    </c:if>
                            >

                            <label class="form-check-label">

                                Exposure to hazardous chemical

                            </label>

                        </div>



                        <!-- Other -->

                        <div class="mt-3">

                            <label class="form-label fw-semibold">
                                Any Other Hazard Activity
                            </label>

                            <div class="form-control bg-white">

                                <c:choose>

                                    <c:when test="${not empty permit.otherHazardActivity}">

                                        ${permit.otherHazardActivity}

                                    </c:when>

                                    <c:otherwise>

                                        -

                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </div>


                    </div>

                </div>



                <!-- Validity -->

                <div class="col-md-4">

                    <label class="form-label fw-semibold">
                        Valid On
                    </label>

                    <div class="form-control bg-light">

                        <c:choose>

                            <c:when test="${not empty permit.validOnDate}">

                                ${permit.validOnDate}

                            </c:when>

                            <c:otherwise>

                                <span class="text-muted">
                                    Pending Acceptor
                                </span>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>



                <!-- Time From -->

                <div class="col-md-4">
                    <label class="form-label fw-semibold">
                        Time From
                    </label>
                    <div class="form-control bg-light">
                        <c:choose>
                            <c:when test="${not empty permit.timeFrom}">
                                ${permit.timeFrom}
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">
                                    Pending Acceptor
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">
                        Time To
                    </label>
                    <div class="form-control bg-light">
                        <c:choose>
                            <c:when test="${not empty permit.timeTo}">
                                ${permit.timeTo}
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">
                                    Pending Acceptor
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>



    <div class="card shadow-sm">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <!-- BACK -->
                <a href="${pageContext.request.contextPath}/issuer/permits"
                        class="btn btn-secondary">
                    Back to Permits
                </a>
                <div>
                    <c:if test="${permit.status == 'PERMIT_IN_PROGRESS'}">
                        <span class="text-muted me-3">
                            Waiting for Acceptor to complete
                            Section B.
                        </span>
                    </c:if>
                   <c:if test="${permit.status == 'PERMIT_ISSUED'}">
                       <div class="d-flex gap-2">
                       <div class="alert alert-info py-1 px-2 mb-0 small">
                            Once print-out is taken then permit will be WORK_IN_PROGRESS.
                       </div>
                          <%-- <a  href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/assessment"
                                   class="btn btn-outline-primary">
                               Proceed to Section C, D &amp; E
                           </a> --%>
                           <form method="post" action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/print">
                               <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                               <button type="submit" class="btn btn-dark">
                                   Print Permit
                               </button>
                           </form>
                       </div>

                   </c:if>
                    <c:if test="${permit.status == 'WORK_IN_PROGRESS'}">
                     <div class="d-flex gap-2">
                        <span class="badge bg-primary px-3 py-2">
                            Work is currently in progress
                        </span>
                         <form method="post" action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/print">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <button type="submit" class="btn btn-dark">
                                  Print Permit
                            </button>
                         </form>

                         <form method="post" action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/work-completed">
                                 <input type="hidden"  name="${_csrf.parameterName}" value="${_csrf.token}">
                                 <button type="submit" class="btn btn-success"
                                         onclick="return confirm('Mark this work as completed?');">
                                     Mark Work Completed
                                 </button>
                             </form>
                         </div>
                    </c:if>
                    <c:if test="${permit.status == 'WORK_COMPLETED'}">
                        <span class="badge bg-info text-dark px-3 py-2">
                            Work completed - awaiting document closure
                        </span>
                    </c:if>
                    <c:if test="${permit.status == 'CLOSED'}">
                        <span class="badge bg-dark px-3 py-2">
                            Permit Closed
                        </span>
                    </c:if>
                    <c:if test="${permit.status == 'EXTENDED' && permit.extensionUsed}">
                        <form method="post" action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/work-completed"
                              style="display:inline;">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit"  class="btn btn-sm btn-success"
                                    onclick="return confirm('Are you sure you want to mark this work as completed?');">
                                Mark Work Completed
                            </button>
                        </form>

                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>
</body>
</html>