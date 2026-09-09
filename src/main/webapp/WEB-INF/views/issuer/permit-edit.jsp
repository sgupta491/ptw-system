<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Correct Returned Permit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
</head>
<body class="bg-light">
<div class="container my-5">
    <!-- HEADER -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-danger text-white d-flex justify-content-between align-items-center">
            <h3 class="mb-0"> Correct Returned Permit
            </h3>
            <span class="badge bg-warning text-dark">
                RETURNED
            </span>
        </div>

        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <strong>  Permit Number: </strong>
                    ${permit.permitNumber}
                </div>
                <div class="col-md-6">
                  <label class="form-label">Permit Type</label>
                      <input type="text" value="${permit.permitType}" class="form-control" readonly>
                      <form:errors path="permitTypeId" cssStyle="color:red"/>
                </div>
            </div>
        </div>
    </div>
    <!-- ERROR -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            ${error}
        </div>
    </c:if>

    <!-- RETURN REMARKS -->

    <c:if test="${not empty returnRemarks}">
        <div class="alert alert-warning">
            <strong> Acceptor Remarks:</strong>
            <br>
            ${returnRemarks}
        </div>
    </c:if>
    <form:form method="post" modelAttribute="permitRequest"
            action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/resubmit">
        <!-- CSRF -->
        <input type="hidden" name="${_csrf.parameterName}"  value="${_csrf.token}">
           <input type="hidden" name="permitTypeId"  value="${permitRequest.permitTypeId}">
        <!-- SECTION A -->

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    A - General Information
                </h5>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <!-- ISSUER -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Issuer Department</label>
                        <div class="form-control bg-light"> ${permit.issuerDepartment}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold"> Issuer Name </label>
                        <div class="form-control bg-light">${permit.issuerName}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold"> Acceptor Department</label>
                        <form:select path="acceptorDepartmentId" id="acceptorDepartment" cssClass="form-select">
                            <form:option value="" label="-- Select Department --"/>
                            <form:options items="${departments}" itemValue="id" itemLabel="departmentName"/>
                        </form:select>
                        <form:errors   path="acceptorDepartmentId" cssClass="text-danger"/>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">  Acceptor Name </label>
                        <form:select path="acceptorId"  id="acceptorId" cssClass="form-select">
                            <form:option value="" label="-- Select Acceptor --"/>
                        </form:select>
                        <form:errors path="acceptorId"  cssClass="text-danger"/>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold">
                            2b. Permit Acceptor:
                            Contractor if deployed
                        </label>
                        <div class="border rounded p-3 bg-light">
                            <div class="mb-3">
                                <label class="form-label"> Contractor Deployed?</label>
                                <div>
                                    <div class="form-check form-check-inline">
                                        <form:radiobutton path="contractorDeployed" value="true" id="contractorYes"/>
                                        <label class="form-check-label" for="contractorYes">
                                            Yes
                                        </label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <form:radiobutton path="contractorDeployed" value="false" id="contractorNo"/>
                                        <label class="form-check-label" for="contractorNo"> No </label>
                                    </div>
                                </div>
                            </div>
                            <!-- Contractor Details -->
                            <div id="contractorDetails">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Contractor
                                        </label>
                                        <form:select path="contractorId" id="contractorId" cssClass="form-select">
                                            <form:option  value="" label="-- Select Contractor --"/>
                                            <form:options items="${contractors}" itemValue="id" itemLabel="contractorName"/>
                                        </form:select>
                                        <form:errors path="contractorId" cssClass="text-danger"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Supervisor Name</label>
                                        <form:input path="contractorSupervisor" id="contractorSupervisor" cssClass="form-control"/>
                                        <form:errors path="contractorSupervisor" cssClass="text-danger"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- SECTION B -->
        <div class="card shadow-sm mb-4">
           <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    B - Work Description
                </h5>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <!-- Equipment -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold"> Equipment Number </label>
                        <form:input path="equipmentNumber" cssClass="form-control"/>
                        <form:errors path="equipmentNumber" cssClass="text-danger"/>
                    </div>
                    <!-- Location -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Location </label>
                        <form:input path="location" cssClass="form-control"/>
                        <form:errors path="location" cssClass="text-danger"/>
                    </div>
                    <!-- Proposed Work -->
                    <div class="col-12">
                        <label class="form-label fw-semibold">Proposed Work</label>
                        <form:textarea  path="proposedWork" cssClass="form-control" rows="4"/>
                        <form:errors path="proposedWork" cssClass="text-danger"/>
                    </div>
                    <!-- Hazards -->
                    <div class="col-12">
                        <label class="form-label fw-semibold"> Any Hazard Activity
                        </label>
                        <div class="border rounded p-3">
                            <div class="form-check mb-2">
                                <form:checkbox  path="liftShiftByEquipment" cssClass="form-check-input" id="liftShiftByEquipment"/>
                                <label class="form-check-label" for="liftShiftByEquipment">
                                    Lift &amp; shift by equipment
                                </label>
                            </div>
                            <div class="form-check mb-2">
                                <form:checkbox path="hazardousChemicalExposure"
                                 cssClass="form-check-input" id="hazardousChemicalExposure"/>
                                <label class="form-check-label" for="hazardousChemicalExposure">
                                    Exposure to hazardous chemical
                                </label>
                            </div>
                            <div class="row align-items-center">
                                <div class="col-auto">
                                    <form:input  path="otherHazardActivity"
                                    cssClass="form-control"  placeholder="Any other"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Date -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Valid Date
                        </label>
                        <form:input path="validOnDate" id="validOnDate"  type="text" cssClass="form-control"  placeholder="dd-mm-yyyy"/>
                        <form:errors path="validOnDate" cssClass="text-danger"/>
                    </div>
                    <!-- From -->
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Time From </label>
                        <form:input path="timeFrom" type="time" cssClass="form-control"/>
                    </div>
                    <!-- To -->
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Time To</label>
                        <form:input  path="timeTo" type="time" cssClass="form-control"/>
                    </div>
                </div>
            </div>
        </div>
        <!-- ACTION -->
        <div class="card shadow-sm">
            <div class="card-body">
                <div class="d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/issuer/permits/returned" class="btn btn-secondary">
                        Back
                    </a>
                    <button type="submit" class="btn btn-success">
                        Resubmit to Acceptor
                    </button>
                </div>
            </div>
        </div>
    </form:form>
</div>
<script>

document.addEventListener("DOMContentLoaded",function () {

    const yes = document.getElementById("contractorYes");
    const no =  document.getElementById("contractorNo");
    const details = document.getElementById("contractorDetails");

      function toggleContractor() {
                if (yes.checked) {
                    details.style.display ="block";
                } else {
                    details.style.display = "none";
                }
            }
            yes.addEventListener("change", toggleContractor );
            no.addEventListener("change",toggleContractor);
            toggleContractor();
 });


document.addEventListener("DOMContentLoaded", function () {

    const acceptorDepartment = document.getElementById("acceptorDepartment");
    const acceptorSelect = document.getElementById("acceptorId");
    const existingAcceptorId = "${permitRequest.acceptorId}";

    function loadAcceptors(departmentId, selectedAcceptorId) {

        acceptorSelect.innerHTML =
            '<option value="">-- Select Acceptor --</option>';

        if (!departmentId) {
            return;
        }

        fetch('${pageContext.request.contextPath}/issuer/permits/acceptors?departmentId=' +
            departmentId
        )
        .then(response => {
            if (!response.ok) {
                throw new Error("Unable to load acceptors");
            }
            return response.json();
        })
        .then(users => {
            console.log("Acceptors received =", users);
            users.forEach(user => {
                const option = document.createElement("option");
                option.value = user.id;
                option.textContent = user.name;
                if (
                    String(user.id) ===
                    String(selectedAcceptorId)
                ) {
                    option.selected = true;
                }
                acceptorSelect.appendChild(option);
            });
            console.log( "Selected acceptor =",acceptorSelect.value);
        })
        .catch(error => {
            console.error("Unable to load acceptors:", error);
        });
    }

    acceptorDepartment.addEventListener("change",
        function () {
            loadAcceptors(this.value, null);
        }
    );

    if (acceptorDepartment.value) {
        loadAcceptors(
            acceptorDepartment.value,
            existingAcceptorId
        );
    }

});
</script>
<script>
flatpickr("#validOnDate", {
    dateFormat: "d-m-Y"
});
</script>
</body>
</html>