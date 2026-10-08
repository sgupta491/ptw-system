<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <title>Electrical Work Request</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <jsp:include page="/WEB-INF/views/common/toast.jsp"/>
    <style>
        body {
            background: #f5f6f8;
        }

        .page-wrapper {
            max-width: 1100px;
            margin: 30px auto;
            padding: 0 15px;
        }

        .page-title {
            font-weight: 600;
            margin-bottom: 20px;
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

        .section-number {
            font-weight: 700;
            margin-right: 8px;
        }
    </style>
</head>

<body>

<div class="page-wrapper">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="page-title mb-0">
            Electrical Work Request
        </h3>

        <a href="${pageContext.request.contextPath}/issuer/permits"
           class="btn btn-outline-secondary">
            Back to Permit List
        </a>
    </div>



    <c:choose>
        <c:when test="${existingWorkRequest}">
            <div class="card">
                <div class="card-header">
                    Work Request Details
                </div>
                <div class="card-body">

                    <div class="row g-3">

                        <div class="col-md-4">
                            <label class="form-label">Work Order Number</label>
                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.woNumber}"
                                   readonly>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Permit Number</label>
                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.permitNumber}"
                                   readonly>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Status</label>
                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.status}"
                                   readonly>
                        </div>

                    </div>

                </div>
            </div>

            <div class="card">

                <div class="card-header">
                    <span class="section-number">1.</span>
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
                    <span class="section-number">2.</span>
                    Work Request Details
                </div>

                <div class="card-body">

                    <div class="row g-3">

                        <div class="col-md-6">

                            <label class="form-label">
                                Date
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.requestDate}"
                                   readonly>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label">
                                Time
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.requestTime}"
                                   readonly>

                        </div>


                        <div class="col-md-12">

                            <label class="form-label">
                                Location of Work
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.workLocation}"
                                   readonly>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label">
                                Work to be done by
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
                    <span class="section-number">3.</span>
                    Equipment Details
                </div>

                <div class="card-body">

                    <div class="row g-3">

                        <div class="col-md-6">

                            <label class="form-label">
                                Equipment Number
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.equipmentNumber}"
                                   readonly>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label">
                                Equipment Location
                            </label>

                            <input type="text"
                                   class="form-control readonly-field"
                                   value="${workRequest.equipmentLocation}"
                                   readonly>

                        </div>

                        <div class="col-md-12">

                            <label class="form-label">
                                Description of Job to be Done
                            </label>

                            <textarea class="form-control readonly-field"
                                      rows="4"
                                      readonly>${workRequest.jobDescription}</textarea>

                        </div>
                        <div class="col-md-12">

                            <label class="form-label">
                                Recommended PPE
                            </label>

                            <textarea class="form-control readonly-field"
                                      rows="3"
                                      readonly>${workRequest.recommendedPpe}</textarea>

                        </div>

                    </div>

                </div>
            </div>


            <div class="card">

                <div class="card-header">
                    <span class="section-number">4.</span>
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
                                Isolation Equipment Number
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

        </c:when>

        <c:otherwise>

            <form method="post"
                  action="${pageContext.request.contextPath}/issuer/permits/${permitId}/work-request">


                <c:if test="${not empty _csrf}">
                    <input type="hidden"
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}">
                </c:if>




                <div class="card">

                    <div class="card-header">
                        <span class="section-number">1.</span>
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
                                       value="${issuerDepartmentName}"
                                       readonly>

                            </div>


                            <div class="col-md-4">

                                <label class="form-label">
                                    Name of Requester
                                </label>

                                <input type="text"
                                       class="form-control readonly-field"
                                       value="${issuerName}"
                                       readonly>

                            </div>


                            <div class="col-md-4">

                                <label class="form-label">
                                    Contact Number
                                </label>

                                <input type="text"
                                       class="form-control readonly-field"
                                       value="${issuerContactNumber}"
                                       readonly>

                            </div>

                        </div>

                    </div>
                </div>




                <div class="card">

                    <div class="card-header">
                        <span class="section-number">2.</span>
                        Work Request Details
                    </div>

                    <div class="card-body">

                        <div class="row g-3">

                            <div class="col-md-6">

                                <label class="form-label required">
                                    Date
                                </label>

                                <input type="date"
                                       name="requestDate"
                                       class="form-control"
                                       required>

                            </div>


                            <div class="col-md-6">

                                <label class="form-label required">
                                    Time
                                </label>

                                <input type="time"
                                       name="requestTime"
                                       class="form-control"
                                       required>

                            </div>


                            <div class="col-md-12">

                                <label class="form-label required">
                                    Location of Work
                                </label>

                                <input type="text"  name="workLocation" class="form-control"
                                       placeholder="Enter location"
                                       required>

                            </div>
                            <div class="col-md-6">
                                <label class="form-label required">
                                    Work to be done by
                                </label>
                                <select name="workToBeDoneById"
                                        class="form-select"
                                        required>
                                    <option value="">
                                        -- Select Trade --
                                    </option>
                                    <c:forEach var="trade" items="${workTypes}">
                                        <option value="${trade.id}">
                                            ${trade.tradeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label required">
                                    Type of Maintenance
                                </label>
                                <select name="maintenanceTypeId"
                                        class="form-select"
                                        required>
                                    <option value="">
                                        -- Select Maintenance Type --
                                    </option>
                                    <c:forEach var="maintenanceType" items="${maintenanceTypes}">
                                        <option value="${maintenanceType.id}">
                                            ${maintenanceType.maintenanceName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">

                    <div class="card-header">
                        <span class="section-number">3.</span>
                        Equipment Details
                    </div>

                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label required"> Equipment Number </label>
                                <input type="text" name="equipmentNumber" class="form-control"
                                       placeholder="Enter equipment number" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label"> Equipment Location </label>
                                <input type="text"  name="equipmentLocation"  class="form-control"  placeholder="Enter equipment location">
                            </div>

                            <div class="col-md-12">
                                <label class="form-label required">  Description of Job to be Done  </label>
                                <textarea name="jobDescription"  class="form-control" rows="4"
                                 placeholder="Describe the job to be done"
                                  required></textarea>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">  Recommended PPE</label>
                                <textarea name="recommendedPpe" class="form-control" rows="3"
                                  placeholder="Enter recommended PPE"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mb-4">
                    <a href="${pageContext.request.contextPath}/issuer/permits"
                       class="btn btn-secondary">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        Create Work Request
                    </button>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script
</body>
</html>