<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Final Verification</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>

        body {
            background-color: #f8f9fa;
        }

        .verification-card {
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
            min-height: 90px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 12px;
        }

    </style>

</head>

<body class="bg-light">
<div class="container my-5">
    <div class="card shadow-sm verification-card">
        <!-- HEADER -->
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0"> I - Acceptance Check and Withdrawal of
                Pre-check Conditions
            </h3>
        </div>

        <div class="card-body">
            <!-- PERMIT DETAILS -->
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Permit Number
                    </label>
                    <div class="readonly-box">
                        ${permit.permitNumber}
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Permit Type
                    </label>
                    <div class="readonly-box">
                        ${permit.permitType}
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Equipment Number
                    </label>
                    <div class="readonly-box">
                        ${permit.equipmentNumber}
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Location
                    </label>
                    <div class="readonly-box">
                        ${permit.location}
                    </div>
                </div>
            </div>
            <!-- FIELD VERIFICATION NOTE -->
            <div class="alert alert-warning">
                <strong>Final Verification:</strong>
                Verify the completed work in the field and
                confirm that the pre-check conditions have been
                withdrawn / safety measures lifted.

            </div>


            <!-- SECTION I FORM -->

            <form method="post" action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/final-verification">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <div class="row g-4">
                    <!-- DATE & TIME -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold"> Date &amp; Time
                        </label>
                        <div class="readonly-box">
                            System generated on submission
                        </div>
                    </div>
                    <!-- RESPONSIBLE PERSON -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Verified By</label>
                        <div class="readonly-box">
                             <strong>
                                  ${permit.issuerName}
                               </strong>
                        </div>

                    </div>


                    <!-- SIGNATURE -->

                    <div class="col-md-6">

                        <label class="form-label fw-semibold">
                            Signature
                        </label>

                        <div class="signature-box">
                        <strong> ${permit.issuerName}
                            </strong>
                        </div>
                    </div>

                    <!-- REMARKS -->
                    <div class="col-12">
                        <label class="form-label fw-semibold">Remarks</label>
                        <textarea name="remarks" class="form-control" rows="4"
                                placeholder="Enter final verification remarks..."></textarea>

                    </div>
                </div>

                <!-- DOCUMENTS -->

                <div class="card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            Completion Documents
                        </h5>

                    </div>
                    <div class="card-body">
                        <p class="text-muted mb-0">
                            Documents submitted with the
                            work completion report are associated
                            with this permit.
                        </p>
                    </div>
                </div>
                <!-- ACTION -->
                <div class="d-flex justify-content-end mt-4">
                    <button type="submit" class="btn btn-success btn-lg px-4">
                        Complete Final Verification &amp; Close Permit
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>