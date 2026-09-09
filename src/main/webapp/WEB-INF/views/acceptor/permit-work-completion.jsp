<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Work Completion</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
 <style>
body {
            background-color: #f8f9fa;
        }

        .completion-card {
            border: none;
            border-radius: 12px;
            overflow: hidden;
        }

        .readonly-box {
            min-height: 42px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 9px 12px;
        }

        .signature-box {
            min-height: 80px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 12px;
        }

        .completion-option {
            cursor: pointer;
        }

    </style>

</head>
<body class="bg-light">
<div class="container my-5">
    <div class="card shadow-sm completion-card">
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0">H - Completion Report</h3>
        </div>
        <div class="card-body">
            <!-- PERMIT DETAILS -->
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Permit Number</label>
                    <div class="readonly-box"> ${permit.permitNumber}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Permit Type</label>
                    <div class="readonly-box"> ${permit.permitType}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Equipment Number</label>
                    <div class="readonly-box">${permit.equipmentNumber}</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"> Location </label>
                    <div class="readonly-box"> ${permit.location}</div>
                </div>
            </div>

            <!-- SECTION H -->
            <div class="border rounded p-4">
                <h5 class="mb-3">
                    H - Completion Report by the Person Completing
                    the Work to the Issuer Department
                </h5>
                <p class="mb-4"
                    The proposed work as given in the description
                    has been completed.
                </p>

                <form method="post" enctype="multipart/form-data"
                      action="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/completion">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <!-- YES / NO -->
                    <div class="row g-3">
                        <!-- YES -->
                        <div class="col-md-6">
                            <label class="completion-option w-100">
                                <div class="border rounded p-4">
                                    <input type="radio" class="form-check-input me-2" name="completionResponse"
                                           value="YES" required>
                                    <span class="fw-semibold fs-5">Yes</span>
                                    <div class="text-muted mt-2">The proposed work has been completed.</div>
                                </div>
                            </label>
                        </div>
                        <!-- NO -->
                        <div class="col-md-6">
                            <label class="completion-option w-100">
                                <div class="border rounded p-4">
                                    <input type="radio"  class="form-check-input me-2" name="completionResponse"
                                           value="NO" required>
                                    <span class="fw-semibold fs-5">No </span>
                                    <div class="text-muted mt-2"> Work is not yet completed.</div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- DOCUMENT UPLOAD -->

                    <div id="documentUploadSection"  class="card border-primary mt-4" style="display:none;">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"> Upload Documents</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Select Documents </label>
                                <input type="file" class="form-control" name="documents" multiple
                                       accept=".pdf,.jpg,.jpeg,.png">
                            </div>
                        </div>
                    </div>
                    <!-- ACCEPTOR / EXECUTOR -->
                    <div class="row g-4 mt-4">

                        <div class="col-md-6">

                            <label class="form-label fw-semibold">
                                Date
                            </label>

                            <div class="readonly-box">
                                System generated on submission
                            </div>

                        </div>

                        <div class="col-md-6">

                            <label class="form-label fw-semibold">
                              Acceptor Signature
                            </label>

                            <div class="signature-box">

                                <strong>
                                    ${permit.acceptorName}
                                </strong>

                            </div>

                        </div>
                        <!-- CONTRACTOR SUPERVISOR -->
                        <c:if test="${permit.contractorDeployed}">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold"> Date</label>
                                <div class="readonly-box">
                                    System generated on submission
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold"> Contractor Supervisor Signature</label>
                                <div class="signature-box">
                                    <strong> ${permit.contractorSupervisor} </strong>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    </div>
                    <!-- SUBMIT -->
                    <div class="d-flex justify-content-end mt-4">
                        <button type="submit" class="btn btn-success btn-lg px-4">
                            Submit Completion Report
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
<script>

document.addEventListener("DOMContentLoaded", function () {

    const yesRadio = document.querySelector('input[name="completionResponse"][value="YES"]');
    const noRadio = document.querySelector('input[name="completionResponse"][value="NO"]');
    const uploadSection = document.getElementById("documentUploadSection");
    function toggleUploadSection() {
        if (yesRadio.checked) {
            uploadSection.style.display = "block";
        } else {
            uploadSection.style.display = "none";
        }
    }
    yesRadio.addEventListener("change", toggleUploadSection);
    noRadio.addEventListener("change", toggleUploadSection);
});
</script>
</html>