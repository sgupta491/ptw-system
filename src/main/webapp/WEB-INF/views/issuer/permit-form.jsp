<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <title>New Permit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>


<body class="bg-light">
<div class="container my-4">
    <!-- HEADER -->
    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="mb-0">Work Permit</h4>
                    <div class="text-muted small mt-1"> Create new permit</div>
                </div>
                <div class="text-end">
                    <div class="text-muted small"> Permit Number </div>
                    <strong>  System generated after saving</strong>
                </div>
            </div>
        </div>
    </div>
    <!-- ERROR -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger shadow-sm">
            <strong>Error:</strong>
            ${error}
        </div>
    </c:if>
    <!-- FORM -->

    <form:form method="post" action="${pageContext.request.contextPath}/issuer/permits" modelAttribute="permitRequest">
        <!-- CSRF -->
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <!-- SECTION A -->

        <div class="card shadow-sm mb-3">
            <div class="card-body">
                <div class="d-flex align-items-baseline mb-4">
                    <div>
                        <h5 class="section-title mb-0">
                            SECTION A — GENERAL INFORMATION
                        </h5>
                        <div class="text-muted small mt-1">
                            Issuer to complete this section
                        </div>
                    </div>
                </div>
                <div class="row g-3">
                    <!-- PERMIT TYPE -->
                    <div class="col-12">
                        <div class="card bg-light border">
                            <div class="card-body">
                                <h6 class="fw-bold mb-3">
                                    Permit Information
                                </h6>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">
                                            Permit Type
                                            <span class="text-danger">*</span>
                                        </label>
                                        <form:select  path="permitTypeId"  cssClass="form-select">
                                            <form:option value="" label="-- Select Permit Type --"/>
                                            <form:options items="${permitTypes}" itemValue="id" itemLabel="permitName"/>
                                        </form:select>
                                        <form:errors  path="permitTypeId" cssClass="text-danger small"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- ISSUER -->
                    <div class="col-12">
                        <div class="card bg-light border">
                            <div class="card-body">
                                <h6 class="fw-bold mb-3">
                                    1. Permit Issuer
                                </h6>
                                <div class="row g-3">
                                    <!-- Department -->
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">
                                            Department
                                        </label>
                                        <input type="text" class="form-control" value="${issuer.department.departmentName}"
                                                readonly />
                                    </div>
                                    <!-- Name -->
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">
                                            Name
                                        </label>
                                        <input type="text" class="form-control" value="${issuer.firstName} ${issuer.lastName}"
                                                readonly
                                        />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- ACCEPTOR -->
                    <div class="col-12">
                        <div class="card border-primary">
                            <div class="card-body">
                                <h6 class="fw-bold mb-3">
                                    2. Permit Acceptor
                                </h6>
                                <div class="row g-3">
                                    <!-- Acceptor Department -->
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">
                                            Department
                                            <span class="text-danger">*</span>
                                        </label>

                                        <form:select path="acceptorDepartmentId" id="acceptorDepartment" cssClass="form-select">
                                            <form:option value="" label="-- Select Department --"/>
                                            <form:options items="${departments}" itemValue="id" itemLabel="departmentName"/>
                                        </form:select>

                                        <form:errors  path="acceptorDepartmentId" cssClass="text-danger small"/>
                                    </div>
                                    <!-- Acceptor Name -->
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">
                                            Name<span class="text-danger">*</span>
                                        </label>
                                        <form:select path="acceptorId" id="acceptorId" cssClass="form-select">
                                            <form:option value="" label="-- Select Acceptor --"/>
                                        </form:select>
                                        <form:errors  path="acceptorId" cssClass="text-danger small"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- CONTRACTOR -->


                    <!-- PROPOSED WORK -->

                    <div class="col-12 mt-3">
                        <div class="card border-primary">
                            <div class="card-body">
                                <h6 class="fw-bold mb-3">
                                    3. Proposed Work
                                </h6>
                                <label class="form-label fw-semibold">
                                    Proposed Work
                                    <span class="text-danger">*</span>
                                </label>
                                <form:textarea path="proposedWork"  rows="5"  cssClass="form-control"
                                        placeholder="Text"/>
                                <form:errors path="proposedWork" cssClass="text-danger small"/>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
            <div class="text-end">
                <button type="submit" class="btn btn-primary px-4">
                    Create &amp; Send to Acceptor
                </button>
            </div>
        </div>
    </form:form>
</div>

<script>

    document.addEventListener("DOMContentLoaded", function () {

        const acceptorDepartment = document.getElementById("acceptorDepartment");
        const acceptorSelect = document.getElementById("acceptorId");

        if (acceptorDepartment && acceptorSelect) {
            acceptorDepartment.addEventListener(
                    "change",
                    function () {
                        const departmentId = this.value;
                        acceptorSelect.innerHTML = '<option value="">-- Select Acceptor --</option>';
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
                        })

                        .then(users => {
                            users.forEach(user => {
                                const option = document.createElement("option");
                                option.value = user.id;
                                option.textContent = user.name;
                                acceptorSelect.appendChild(option);
                            });
                        })
                        .catch(error => {
                            console.error("Unable to load acceptors:",error);
                        });
                    }
            );
        }
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>