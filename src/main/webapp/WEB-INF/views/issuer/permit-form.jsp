<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>New Permit</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
 <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>

document.addEventListener("DOMContentLoaded", function () {

    const contractorYes = document.getElementById("contractorYes");
    const contractorNo = document.getElementById("contractorNo");
    const contractorDetails = document.getElementById("contractorDetails");

    function toggleContractorDetails() {
       if (contractorYes.checked) {
           contractorDetails.style.display ="block";
                } else {
                    contractorDetails.style.display = "none";
                }
            }

            contractorYes.addEventListener("change", toggleContractorDetails);
            contractorNo.addEventListener( "change",toggleContractorDetails);
            toggleContractorDetails();

});
</script>
</head>
<body class="bg-light">
<div class="container my-4">

    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="mb-0"> Work Permit</h4>
                </div>
                <div class="text-end">
                    <div class="text-muted small">
                        Permit Number
                    </div>
                    <strong> System generated after saving </strong>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger shadow-sm">
            <strong>Error:</strong>
            ${error}
        </div>
    </c:if>

   <form:form method="post" action="${pageContext.request.contextPath}/issuer/permits" modelAttribute="permitRequest">
        <!-- CSRF -->
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <div class="card shadow-sm mb-3">
            <div class="card-body">
                <h5 class="section-title mb-3">Permit Information</h5>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold"> Permit Type<span class="text-danger">*</span>
                        </label>

                        <form:select path="permitTypeId" cssClass="form-select">
                            <form:option  value="" label="-- Select Permit Type --"/>
                            <form:options items="${permitTypes}" itemValue="id" itemLabel="permitName"/>
                        </form:select>
                        <form:errors  path="permitTypeId"  cssClass="text-danger small"/>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm mb-3">
            <div class="card-body">
                <div class="d-flex align-items-baseline mb-3">
                    <h5 class="section-title mb-0">
                        SECTION A — GENERAL INFORMATION
                    </h5>
                </div>
                <div class="row g-3">
                    <div class="col-12">
                        <div class="card bg-light border">
                            <div class="card-body"><h6 class="fw-bold mb-3"> 1. Permit Issuer </h6>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Department</label>
                                        <input type="text" class="form-control" value="${issuer.department.departmentName}" readonly/>
                                    </div>
                                    <!-- Issuer Name -->
                                    <div class="col-md-6">
                                        <label class="form-label"> Name</label>
                                        <input type="text" class="form-control" value="${issuer.firstName} ${issuer.lastName}" readonly/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="card border-primary">
                            <div class="card-body">
                                <h6 class="fw-bold mb-3">  2a. Permit Acceptor </h6>
                                <div class="row g-3">
                                    <!-- Acceptor Department -->
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Department<span class="text-danger">*</span>
                                        </label>

                                        <form:select path="acceptorDepartmentId" id="acceptorDepartment" cssClass="form-select">
                                            <form:option value=""  label="-- Select Department --"/>
                                            <form:options  items="${departments}" itemValue="id" itemLabel="departmentName"/>
                                        </form:select>

                                        <form:errors path="acceptorDepartmentId" cssClass="text-danger small"/>
                                    </div>
                                    <!-- Acceptor Name -->
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold"> Name<span class="text-danger">  *</span>
                                        </label>

                                        <form:select path="acceptorId" id="acceptorId" cssClass="form-select">
                                            <form:option value="" label="-- Select Acceptor --"/>
                                        </form:select>
                                        <form:errors path="acceptorId" cssClass="text-danger small"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                   <div class="mt-4">
                       <label class="form-label fw-semibold">
                           2b. Permit Acceptor: Contractor if deployed
                       </label>
                       <div class="border rounded p-3 bg-light">
                           <!-- Contractor Deployed -->
                           <div class="mb-3"><label class="form-label">Contractor Deployed? </label>
                               <div>
                                   <div class="form-check form-check-inline">

                                       <form:radiobutton  path="contractorDeployed" value="true" id="contractorYes"/>
                                       <label class="form-check-label" for="contractorYes"> Yes</label>
                                   </div>

                                   <div class="form-check form-check-inline">
                                       <form:radiobutton path="contractorDeployed" value="false" id="contractorNo"/>
                                       <label class="form-check-label"  for="contractorNo">No
                                       </label>
                                   </div>
                               </div>
                               <form:errors  path="contractorDeployed" cssClass="text-danger"/>
                           </div>
                           <!-- Contractor Details -->
                           <div id="contractorDetails" style="display:none;">
                               <div class="row g-3">
                                   <!-- Contractor -->
                                   <div class="col-md-6">
                                       <label class="form-label"> Contractor
                                       </label>
                                       <form:select path="contractorId" id="contractorId" cssClass="form-select">
                                           <form:option value="" label="-- Select Contractor --"/>
                                           <form:options items="${contractors}" itemValue="id" itemLabel="contractorName"/>
                                       </form:select>
                                       <form:errors path="contractorId" cssClass="text-danger"/>
                                   </div>

                                   <!-- Supervisor -->
                                   <div class="col-md-6">
                                      <label class="form-label">  Supervisor Name</label>
                                       <form:input path="contractorSupervisor" id="contractorSupervisor" cssClass="form-control"
                                               placeholder="Enter supervisor name"/>
                                       <form:errors  path="contractorSupervisor" cssClass="text-danger"/>
                                   </div>
                               </div>
                           </div>
                       </div>
                   </div>
                </div>
            </div>
        </div>

        <!-- SECTION B -->

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
                        <form:input path="equipmentNumber" cssClass="form-control" placeholder="Enter equipment number"/>
                        <form:errors path="equipmentNumber" cssClass="text-danger small"/>
                    </div>

                    <div class="col-md-8">
                        <label class="form-label fw-semibold">
                            Location <span class="text-danger">*</span>
                        </label>

                        <form:input path="location" cssClass="form-control" placeholder="Enter work location"/>
                        <form:errors path="location" cssClass="text-danger small"/>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold"> Proposed Work <span class="text-danger"> *</span>
                        </label>
                        <form:textarea path="proposedWork" rows="3" cssClass="form-control" placeholder="Brief description of work to be carried out"/>
                        <form:errors path="proposedWork" cssClass="text-danger small"/>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold">
                            Any Hazard Activity
                        </label>
                        <div class="border rounded p-3 bg-light">
                            <div class="row g-3 align-items-center">
                                <!-- Lift & Shift -->
                                <div class="col-md-4">
                                    <div class="form-check">
                                        <form:checkbox  path="liftShiftByEquipment" cssClass="form-check-input"/>
                                        <label class="form-check-label"> Lift &amp; shift by equipment
                                        </label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-check">
                                        <form:checkbox  path="hazardousChemicalExposure" cssClass="form-check-input"/>
                                        <label class="form-check-label">
                                            Exposure to hazardous chemical
                                        </label>
                                    </div>
                                </div>
                                <!-- Other -->
                                <div class="col-md-4">
                                    <label class="form-label"> Any Other </label>
                                    <form:input path="otherHazardActivity"  cssClass="form-control" placeholder="Specify other hazard"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold"> Valid On <span class="text-danger">  *</span>
                        </label><form:input type="text" path="validOnDate" id="validOnDate" cssClass="form-control" placeholder="dd-mm-yyyy"/>
                        <form:errors path="validOnDate" cssClass="text-danger small"/>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold">  Time From <span class="text-danger">  * </span>
                        </label>
                        <form:input type="time" path="timeFrom" cssClass="form-control"/>
                        <form:errors path="timeFrom" cssClass="text-danger small"/>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold"> Time To  <span class="text-danger"> * </span>
                        </label>
                        <form:input  type="time" path="timeTo" cssClass="form-control"/>
                        <form:errors path="timeTo" cssClass="text-danger small"/>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mt-3 mb-5">
           <div class="text-muted small"><strong>Note:</strong>
                Save the permit as a draft first.
                You can submit it to the acceptor after reviewing
                the saved permit.
            </div>

            <div class="text-end">
                <button type="submit" class="btn btn-primary px-4">
                    Save Draft
                </button>
            </div>
        </div>
    </form:form>
</div>
<script>

flatpickr("#validOnDate", {
    dateFormat: "d-m-Y"
});

 document.addEventListener( "DOMContentLoaded", function () {

      const acceptorDepartment = document.getElementById("acceptorDepartment");
      const acceptorSelect =  document.getElementById("acceptorId");
      acceptorDepartment.addEventListener("change", function () {
      const departmentId = this.value;
                    acceptorSelect.innerHTML =
                        '<option value="">-- Select Acceptor --</option>';
                    if (!departmentId) {
                        return;
                    }
                    fetch(
                         '${pageContext.request.contextPath}' +
                        '/issuer/permits/acceptors?departmentId=' +
                        departmentId
                    )
                    .then(response => {
                            if (!response.ok) {
                                throw new Error("Unable to load acceptors");
                            }
                           return response.json();
                        }
                    )
                    .then(users => {
                            users.forEach(user => {
                              const option = document.createElement("option");
                                option.value = user.id;
                                option.textContent = user.name;
                                acceptorSelect.appendChild(option);
                                }
                            );
                        })
                    .catch(error => {
                            console.error( "Unable to load acceptors:",error);
                        }
                    );
                }
            );
        }
    );

</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>
</body>
</html>