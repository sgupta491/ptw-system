<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <title>Maintenance Work Order</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"  rel="stylesheet">

    <style>

        body {
            background: #f5f6f8;
        }

        .page-wrapper {
            max-width: 1150px;
            margin: 30px auto;
            padding: 0 15px;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }

        .card-header {
            font-weight: 600;
            background: #f8f9fa;
        }

        .form-label {
            font-weight: 500;
        }

        .readonly-field {
            background-color: #e9ecef;
        }

        .required::after {
            content: " *";
            color: red;
        }

        .status-pending {
            background: #ffc107;
            color: #212529;
        }

        .status-completed {
            background: #198754;
            color: white;
        }

    </style>

</head>
<body>
<jsp:include page="/WEB-INF/views/common/toast.jsp"/>
<div class="page-wrapper">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-1"> Maintenance Work Order </h3>
        </div>
        <a href="${pageContext.request.contextPath}/maintenance/work-orders"
           class="btn btn-outline-secondary">
            Back to Work Orders
        </a>
    </div>
    <div class="card">
        <div class="card-header"> Work Order Information</div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">  Work Order Number</label>
                    <input type="text" class="form-control readonly-field"
                           value="${workRequest.woNumber}" readonly>
                </div>

                <div class="col-md-4">
                    <label class="form-label"> Permit Number</label>
                    <input type="text"  class="form-control readonly-field" value="${workRequest.permitNumber}" readonly>
                </div>
                <div class="col-md-4">
                    <label class="form-label">
                        Status
                    </label>
                        <input type="text" class="form-control readonly-field"  value="${workRequest.status}" readonly>
                </div>
            </div>
        </div>
    </div>


    <div class="card">
        <div class="card-header">
            Requester Details
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">
                        Requesting Department
                    </label>
                    <input type="text"
                           class="form-control readonly-field"
                           value="${workRequest.requestingDepartment}"
                           readonly>
                </div>
                <div class="col-md-4">
                    <label class="form-label">
                        Name of Requester
                    </label>

                    <input type="text"
                           class="form-control readonly-field"
                           value="${workRequest.requesterName}"
                           readonly>

                </div>


                <div class="col-md-4">
                    <label class="form-label">
                        Contact Number
                    </label>
                    <input type="text"
                           class="form-control readonly-field"
                           value="${workRequest.requesterContactNumber}"
                           readonly>
                </div>
            </div>
        </div>
    </div>


    <div class="card">
        <div class="card-header">
            Work Request Details
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">
                        Request Date
                    </label>
                    <input type="text"
                           class="form-control readonly-field"
                           value="${workRequest.requestDate}"
                           readonly>
                </div>
                <div class="col-md-4">
                    <label class="form-label">
                        Request Time
                    </label>
                    <input type="text"
                           class="form-control readonly-field"
                           value="${workRequest.requestTime}"
                           readonly>

                </div>

                <div class="col-md-4">
                    <label class="form-label">
                        Location
                    </label>
                    <input type="text"
                           class="form-control readonly-field"
                           value="${workRequest.workLocation}"
                           readonly>

                </div>
                <div class="col-md-6">
                    <label class="form-label">
                        Work to be Done By
                    </label>
                    <input type="text"
                           class="form-control readonly-field"
                           value="${workRequest.workToBeDoneBy}"
                           readonly>
                </div>
                <div class="col-md-6">
                    <label class="form-label">
                        Type of Maintenance
                    </label>
                    <input type="text"
                           class="form-control readonly-field"
                           value="${workRequest.maintenanceType}"
                           readonly>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            Job Details
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">
                        Equipment Number
                    </label>
                    <input type="text" class="form-control readonly-field"
                           value="${workRequest.equipmentNumber}" readonly>
                </div>

                <div class="col-md-6">
                    <label class="form-label">
                        Equipment Location
                    </label>
                    <input type="text" class="form-control readonly-field"  value="${workRequest.equipmentLocation}"
                           readonly>
                </div>
                <div class="col-md-12">
                    <label class="form-label">Description of Job to be Done</label>
                    <textarea class="form-control readonly-field" rows="4"
                              readonly>${workRequest.jobDescription}</textarea>
                </div>

                <div class="col-md-12">
                    <label class="form-label">
                        Recommended PPE
                    </label>
                    <textarea class="form-control readonly-field"  rows="3" readonly>${workRequest.recommendedPpe}</textarea>

                </div>
            </div>
        </div>
    </div>

    <!-- MAINTENANCE SECTION -->

    <c:choose>
        <c:when test="${workRequest.status == 'PENDING'}">
            <form method="post"  action="${pageContext.request.contextPath}/maintenance/work-orders/${workRequest.id}/complete">
                <c:if test="${not empty _csrf}">
                    <input type="hidden"
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}">
                </c:if>
                <div class="card">
                    <div class="card-header">
                        Maintenance Details
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label required">
                                    Work Assigned To
                                </label>
                                <select name="workAssignedToId"
                                        id="workAssignedToId"
                                        class="form-select"
                                        required>
                                    <option value="">
                                        -- Select Trade --
                                    </option>
                                    <c:forEach var="trade"
                                               items="${workTypes}">
                                        <option value="${trade.id}">
                                            ${trade.tradeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6">

                                <label class="form-label required">
                                    Name
                                </label>

                                <input type="text"
                                       name="assignedName"
                                       id="assignedName"
                                       class="form-control"
                                       placeholder="Enter person's name"
                                       required>

                            </div>


                            <div class="col-md-6">

                                <label class="form-label required">
                                    Work Started At
                                </label>

                                <input type="datetime-local"
                                       name="workStartedAt"
                                       class="form-control"
                                       required>

                            </div>


                            <div class="col-md-6">

                                <label class="form-label required">
                                    Equipment No.
                                </label>

                                <input type="text"
                                       name="isolationEquipmentNumber"
                                       class="form-control"
                                       placeholder="Enter equipment number"
                                       required>

                            </div>


                            <div class="col-md-6">

                                <label class="form-label required">
                                    Feeder No.
                                </label>

                                <input type="text"
                                       name="feederNumber"
                                       class="form-control"
                                       placeholder="Enter feeder number"
                                       required>

                            </div>


                            <div class="col-md-6">

                                <label class="form-label required">
                                    LOTO No.
                                </label>

                                <input type="text"
                                       name="lotoNumber"
                                       class="form-control"
                                       placeholder="Enter LOTO number"
                                       required>

                            </div>

                            <div class="col-md-6">
                                <label class="form-label">
                                    Work Completed By
                                </label>
                                <input type="text"
                                       name="workCompletedBy"
                                       id="workCompletedBy"
                                       class="form-control readonly-field"
                                       readonly>

                            </div>

                            <div class="col-md-6">
                                <label class="form-label required">
                                    Time of Completion
                                </label>
                                <input type="datetime-local"
                                       name="completedAt"
                                       class="form-control"
                                       required>

                            </div>
                        </div>
                    </div>
                </div>

                <div class="alert alert-warning">
                    <strong>Important:</strong>

                    Please verify Equipment No., Feeder No. and
                    LOTO No. before submitting the work order.
                </div>
                <div class="d-flex justify-content-end gap-2 mb-4">
                    <a href="${pageContext.request.contextPath}/maintenance/work-orders"
                       class="btn btn-secondary">
                        Cancel
                    </a>
                    <button type="submit"
                            class="btn btn-success">
                        Complete Work Order
                    </button>
                </div>
            </form>
        </c:when>

        <c:otherwise>
            <div class="card">
                <div class="card-header">
                    Maintenance Details
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">
                                Work Assigned To
                            </label>
                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.workAssignedTo}"
                                   readonly>

                        </div>
                        <div class="col-md-6">
                            <label class="form-label">
                                Name
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.assignedName}"
                                   readonly>

                        </div>


                        <div class="col-md-6">
                            <label class="form-label">
                                Work Started At
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.workStartedAt}"
                                   readonly>

                        </div>


                        <div class="col-md-6">
                            <label class="form-label">
                                Equipment No.
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.isolationEquipmentNumber}"
                                   readonly>

                        </div>


                        <div class="col-md-6">
                            <label class="form-label">
                                Feeder No.
                            </label>
                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.feederNumber}"
                                   readonly>

                        </div>


                        <div class="col-md-6">
                            <label class="form-label">
                                LOTO No.
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.lotoNumber}"
                                   readonly>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label">
                                Work Completed By
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.workCompletedBy}"
                                   readonly>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label">
                                Time of Completion
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.completedAt}"
                                   readonly>

                        </div>

                    </div>

                </div>

            </div>


            <div class="alert alert-success">
                <strong>Electrical Isolation Completed.</strong>
                Equipment, Feeder and LOTO details have been recorded.
            </div>
        </c:otherwise>
    </c:choose>
</div>


<script>
    const assignedNameInput =  document.getElementById("assignedName");
    const workCompletedByInput = document.getElementById("workCompletedBy");

    if (assignedNameInput && workCompletedByInput) {
        assignedNameInput.addEventListener("input", function () {
            workCompletedByInput.value = this.value;

        });

    }
</script>
</body>
</html>