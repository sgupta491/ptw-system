<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Complete Section B</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <jsp:include page="/WEB-INF/views/common/toast.jsp"/>
</head>

<body class="bg-light">
<div class="container my-5">
    <!-- HEADER -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h3 class="mb-0">Permit - Section B</h3>
            <span class="badge bg-warning text-dark">
                ${permit.status}
            </span>
        </div>
    </div>

    <!-- ERROR -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            ${error}
        </div>
    </c:if>
    <!-- SECTION A - READ ONLY -->
    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <h5 class="mb-0"> A - General Information</h5>
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
                        Issuer Department
                    </label>
                    <div class="form-control bg-light">
                        ${permit.issuerDepartment}
                    </div>
                </div>
                <!-- Issuer -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Issuer Name
                    </label>
                    <div class="form-control bg-light">
                        ${permit.issuerName}
                    </div>
                </div>

                <!-- Acceptor Department -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Acceptor Department
                    </label>
                    <div class="form-control bg-light">
                        ${permit.acceptorDepartment}
                    </div>
                </div>
                <!-- Acceptor -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Acceptor Name
                    </label>
                    <div class="form-control bg-light">
                        ${permit.acceptorName}
                    </div>
                </div>



                <!-- Proposed Work from Section A -->
                <div class="col-12">

                    <label class="form-label fw-semibold">
                        Proposed Work
                    </label>

                    <div class="form-control bg-light"
                         style="height:auto; min-height:100px;">

                        ${permit.proposedWork}

                    </div>

                </div>

            </div>

        </div>

    </div>

    <!-- SECTION B -->

    <div class="card shadow-sm mb-4">

        <div class="card-header bg-secondary text-white">
            <h5 class="mb-0">
                B - Work Description
            </h5>
        </div>

        <div class="card-body">

            <!-- PERMIT IN PROGRESS - EDITABLE -->
            <c:if test="${permit.status == 'PERMIT_IN_PROGRESS'}">
                <form method="post" action="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/section-b">
                    <!-- CSRF -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" >
                    <div class="row g-3">
                        <!-- Equipment Number -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">
                                Equipment Number
                            </label>
                            <input type="text" name="equipmentNumber"  class="form-control" value="${permit.equipmentNumber}"
                                    placeholder="Enter equipment number">
                        </div>
                        <!-- Location -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">
                                Location
                            </label>
                            <input type="text" name="location" class="form-control" value="${permit.location}" placeholder="Enter work location">
                        </div>
                        <!-- Proposed Work in Detail -->
                        <div class="col-12">
                            <label class="form-label fw-semibold">
                                Proposed Work in Detail
                            </label>

                            <textarea
                                    name="proposedWorkInDetail"
                                    class="form-control"
                                    rows="5"
                                    placeholder="Describe the proposed work in detail"
                            >${permit.proposedWorkInDetail}</textarea>
                        </div>


                          <!-- CONTRACTOR -->

                        <div class="col-12 mt-3">
                                                <div class="card border">
                                                    <div class="card-body">
                                                        <h6 class="fw-bold mb-3">
                                                             Permit Acceptor: Contractor if deployed
                                                        </h6>
                                                        <!-- Contractor Deployed -->
                                                       <!-- Contractor Deployed -->
                                                       <div class="mb-3">
                                                           <label class="form-label fw-semibold d-block">
                                                               Contractor Deployed?
                                                           </label>

                                                           <div class="d-flex gap-4">

                                                               <!-- YES -->
                                                               <div class="form-check">
                                                                   <input
                                                                           class="form-check-input"
                                                                           type="radio"
                                                                           name="contractorDeployed"
                                                                           id="contractorYes"
                                                                           value="true">

                                                                   <label class="form-check-label" for="contractorYes">
                                                                       Yes
                                                                   </label>
                                                               </div>

                                                               <!-- NO -->
                                                               <div class="form-check">
                                                                   <input
                                                                           class="form-check-input"
                                                                           type="radio"
                                                                           name="contractorDeployed"
                                                                           id="contractorNo"
                                                                           value="false">

                                                                   <label class="form-check-label" for="contractorNo">
                                                                       No
                                                                   </label>
                                                               </div>

                                                           </div>

                                                           <form:errors path="contractorDeployed" cssClass="text-danger small"/>
                                                       </div>

                                                        <!-- Contractor Details -->
                                                        <div id="contractorDetails" style="display:none;">
                                                            <div class="row g-3">

                                                                <!-- Contractor - ONLY when Yes -->
                                                                <div class="col-md-6">
                                                                    <label class="form-label">
                                                                        Contractor
                                                                    </label>

                                                                    <select name="contractorId"
                                                                            id="contractorId"
                                                                            class="form-select">

                                                                        <option value="">-- Select Contractor --</option>

                                                                        <c:forEach var="contractor" items="${contractors}">
                                                                            <option value="${contractor.id}">
                                                                                ${contractor.contractorName}
                                                                            </option>
                                                                        </c:forEach>

                                                                    </select>
                                                                </div>

                                                            </div>
                                                        </div>

                                                        <!-- Supervisor - ALWAYS visible -->
                                                        <div class="row g-3 mt-1">

                                                            <div class="col-md-6">
                                                                <label class="form-label">
                                                                    Supervisor Name
                                                                </label>

                                                                <input type="text"
                                                                       name="contractorSupervisor"
                                                                       id="contractorSupervisor"
                                                                       class="form-control"
                                                                       placeholder="Enter supervisor name">
                                                            </div>

                                                        </div>
                                                    </div>
                                                </div>
                                            </div>


                        <!-- Hazard Activity -->
                        <div class="col-12">

                            <label class="form-label fw-semibold">
                                Any Hazard Activity
                            </label>

                            <div class="border rounded p-3 bg-light">

                                <!-- Lift & Shift -->
                                <div class="form-check mb-3">

                                    <input
                                            class="form-check-input"
                                            type="checkbox"
                                            name="liftShiftByEquipment"
                                            value="true"
                                            id="liftShiftByEquipment"

                                            <c:if test="${permit.liftShiftByEquipment}">
                                                checked
                                            </c:if>
                                    >

                                    <label
                                            class="form-check-label"
                                            for="liftShiftByEquipment">

                                        Lift &amp; shift by equipment

                                    </label>

                                </div>


                                <!-- Hazardous Chemical -->
                                <div class="form-check mb-3">

                                    <input
                                            class="form-check-input"
                                            type="checkbox"
                                            name="hazardousChemicalExposure"
                                            value="true"
                                            id="hazardousChemicalExposure"

                                            <c:if test="${permit.hazardousChemicalExposure}">
                                                checked
                                            </c:if>
                                    >

                                    <label
                                            class="form-check-label"
                                            for="hazardousChemicalExposure">

                                        Exposure to hazardous chemical

                                    </label>

                                </div>


                                <!-- Other Hazard -->
                                <div class="mt-3">

                                    <label class="form-label fw-semibold">
                                        Any Other Hazard Activity
                                    </label>

                                    <textarea
                                            name="otherHazardActivity"
                                            class="form-control"
                                            rows="3"
                                            placeholder="Enter other hazard activity if applicable"
                                    >${permit.otherHazardActivity}</textarea>

                                </div>

                            </div>

                        </div>


                        <!-- Permit Validity -->
                        <div class="col-12">

                            <hr>

                            <h6 class="fw-semibold mb-3">
                                Permit Validity
                            </h6>

                        </div>


                        <!-- Valid On -->
                        <div class="col-md-4">

                            <label class="form-label fw-semibold">
                                Valid On
                            </label>

                            <input
                                    type="date"
                                    name="validOnDate"
                                    class="form-control"
                                    value="${permit.validOnDate}"
                            >

                        </div>


                        <!-- Time From -->
                        <div class="col-md-4">

                            <label class="form-label fw-semibold">
                                Time From
                            </label>

                            <input
                                    type="time"
                                    name="timeFrom"
                                    class="form-control"
                                    value="${permit.timeFrom}"
                            >

                        </div>


                        <!-- Time To -->
                        <div class="col-md-4">

                            <label class="form-label fw-semibold">
                                Time To
                            </label>

                            <input
                                    type="time"
                                    name="timeTo"
                                    class="form-control"
                                    value="${permit.timeTo}"
                            >

                        </div>

                    </div>


                    <!-- ACTIONS -->
                    <div class="d-flex justify-content-end gap-2 mt-4">

                        <a
                                href="${pageContext.request.contextPath}/acceptor/permits"
                                class="btn btn-secondary"
                        >
                            Cancel
                        </a>

                        <button
                                type="submit"
                                class="btn btn-success"
                        >
                            Submit Section B
                        </button>

                    </div>

                </form>

            </c:if>

            <!-- PERMIT ISSUED - READ ONLY -->

            <c:if test="${permit.status == 'PERMIT_ISSUED' || permit.status == 'CLOSED' || permit.status == 'WORK_IN_PROGRESS'
                        || permit.status == 'EXTENSION_REQUESTED' || permit.status == 'EXTENDED'}">

                <div class="row g-3">

                    <!-- Equipment Number -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Equipment Number
                        </label>

                        <div class="form-control bg-light">
                            ${permit.equipmentNumber}
                        </div>
                    </div>


                    <!-- Location -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Location
                        </label>

                        <div class="form-control bg-light">
                            ${permit.location}
                        </div>
                    </div>


                    <!-- Proposed Work in Detail -->
                    <div class="col-12">
                        <label class="form-label fw-semibold">
                            Proposed Work in Detail
                        </label>

                        <div
                                class="form-control bg-light"
                                style="height:auto; min-height:120px;"
                        >
                            ${permit.proposedWorkInDetail}
                        </div>
                    </div>


                    <!-- Contractor -->
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">
                                            Contractor Deployment
                                        </label>
                                        <div class="border rounded p-3 bg-light">
                                            <c:choose>
                                                <c:when test="${permit.contractorDeployed}">

                                                    <span class="badge bg-success mb-3">
                                                        YES
                                                    </span>

                                                    <div class="row g-3">

                                                        <div class="col-md-6">

                                                            <label class="form-label">
                                                                Contractor
                                                            </label>

                                                            <div class="form-control bg-white">
                                                                ${permit.contractorName}
                                                            </div>

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

                                     <div class="col-md-6">
                                            <label class="form-label fw-semibold">
                                                Supervisor Name
                                             </label>
                                                 <div class="form-control bg-white">
                                                    ${permit.contractorSupervisor}
                                                 </div>
                                        </div>

                    <!-- Hazard Activity -->
                    <div class="col-12">

                        <label class="form-label fw-semibold">
                            Any Hazard Activity
                        </label>

                        <div class="border rounded p-3 bg-light">

                            <!-- Lift & Shift -->
                            <div class="mb-3">

                                <span class="fw-semibold">
                                    Lift &amp; shift by equipment:
                                </span>

                                <c:choose>
                                    <c:when test="${permit.liftShiftByEquipment}">
                                        <span class="badge bg-success ms-2">
                                            YES
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="badge bg-secondary ms-2">
                                            NO
                                        </span>
                                    </c:otherwise>
                                </c:choose>

                            </div>


                            <!-- Hazardous Chemical -->
                            <div class="mb-3">

                                <span class="fw-semibold">
                                    Exposure to hazardous chemical:
                                </span>

                                <c:choose>
                                    <c:when test="${permit.hazardousChemicalExposure}">
                                        <span class="badge bg-success ms-2">
                                            YES
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="badge bg-secondary ms-2">
                                            NO
                                        </span>
                                    </c:otherwise>
                                </c:choose>

                            </div>


                            <!-- Other Hazard -->
                            <div>

                                <label class="form-label fw-semibold">
                                    Any Other Hazard Activity
                                </label>

                                <div
                                        class="form-control bg-light"
                                        style="height:auto; min-height:80px;"
                                >
                                    ${permit.otherHazardActivity}
                                </div>

                            </div>

                        </div>

                    </div>


                    <!-- Permit Validity -->
                    <div class="col-12">

                        <hr>

                        <h6 class="fw-semibold mb-3">
                            Permit Validity
                        </h6>

                    </div>


                    <!-- Valid On -->
                    <div class="col-md-4">

                        <label class="form-label fw-semibold">
                            Valid On
                        </label>

                        <div class="form-control bg-light">
                            ${permit.validOnDate}
                        </div>

                    </div>


                    <!-- Time From -->
                    <div class="col-md-4">

                        <label class="form-label fw-semibold">
                            Time From
                        </label>

                        <div class="form-control bg-light">
                            ${permit.timeFrom}
                        </div>

                    </div>


                    <!-- Time To -->
                    <div class="col-md-4">

                        <label class="form-label fw-semibold">
                            Time To
                        </label>

                        <div class="form-control bg-light">
                            ${permit.timeTo}
                        </div>

                    </div>

                </div>

                <!-- Issued message -->
                 <c:if test="${permit.status == 'PERMIT_ISSUED'}">
                <div class="alert alert-info mt-4 mb-0">
                    <strong>Permit  Issued:</strong>
                    Section B is no longer editable.
                </div>
                </c:if>

            </c:if>

        </div>
    </div>

</div>

<script>

    document.addEventListener("DOMContentLoaded", function () {

        const contractorYes = document.getElementById("contractorYes");
        const contractorNo = document.getElementById("contractorNo");
        const contractorDetails = document.getElementById("contractorDetails");

        function toggleContractorDetails() {
            if (contractorYes && contractorYes.checked) {
                contractorDetails.style.display = "block";
            } else {
                contractorDetails.style.display = "none";
            }
        }
        if (contractorYes) {
            contractorYes.addEventListener("change", toggleContractorDetails);
        }
        if (contractorNo) {
            contractorNo.addEventListener("change",toggleContractorDetails);
        }
        toggleContractorDetails();

    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</body>
</html>