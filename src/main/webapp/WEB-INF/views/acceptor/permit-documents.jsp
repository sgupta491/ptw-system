<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Permit Documents</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <style>

        body {
            background-color: #f5f7fb;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        .page-container {
            max-width: 1200px;
        }

        .page-title {
            font-weight: 700;
            color: #212529;
        }

        .page-subtitle {
            color: #6c757d;
            font-size: 14px;
        }

        .card {
            border-radius: 12px;
            overflow: hidden;
        }

        .card-header {
            border-bottom: 1px solid #e9ecef;
        }

        .upload-card-header {
            background: #0d6efd;
            color: white;
        }

        .important-note {
            border-radius: 10px;
            border-left: 5px solid #ffc107;
        }

        .important-note i {
            color: #856404;
        }

        .form-label {
            color: #343a40;
        }

        .form-control,
        .form-select {
            border-radius: 8px;
            min-height: 44px;
        }

        .form-control:focus,
        .form-select:focus {
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        }

        .upload-btn {
            min-height: 44px;
            border-radius: 8px;
            font-weight: 600;
        }

        .documents-table th {
            font-size: 13px;
            font-weight: 600;
            color: #495057;
            white-space: nowrap;
        }

        .documents-table td {
            font-size: 14px;
        }

        .file-name {
            max-width: 260px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            display: inline-block;
            vertical-align: middle;
        }

        .document-icon {
            font-size: 20px;
        }

        .empty-state {
            padding: 60px 20px;
        }

        .empty-state-icon {
            font-size: 50px;
            color: #adb5bd;
        }

        .view-btn {
            border-radius: 7px;
        }

        .badge {
            font-weight: 500;
        }

    </style>

</head>


<body>
<div class="container page-container my-5">

    <div class="mb-4">
        <h3 class="page-title mb-1">
            <i class="bi bi-file-earmark-text me-2"></i>
            Permit Documents
        </h3>

        <p class="page-subtitle mb-0">
            Upload and manage documents related to this permit.
        </p>
    </div>

<c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>
        ${success}

        <button type="button"
                class="btn-close"
                data-bs-dismiss="alert">
        </button>
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-circle-fill me-2"></i>
        ${error}

        <button type="button"
                class="btn-close"
                data-bs-dismiss="alert">
        </button>
    </div>
</c:if>

<c:set var="printedPermitUploaded" value="false"/>
<c:set var="safetyBriefingUploaded" value="false"/>

<c:forEach var="document" items="${documents}">

    <c:if test="${document.documentType == 'PRINTED_PERMIT'}">
        <c:set var="printedPermitUploaded" value="true"/>
    </c:if>

    <c:if test="${document.documentType == 'SAFETY_BRIEFING'}">
        <c:set var="safetyBriefingUploaded" value="true"/>
    </c:if>

</c:forEach>

    <!-- DOCUMENT UPLOAD CARDS -->
<c:if test="${permit.status == 'WORK_COMPLETED'}">
    <div class="row g-4 mb-4">
        <!-- PRINTED PERMIT -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-file-earmark-check me-2"></i>
                        Printed Hard Copy
                    </h5>
                </div>
                <div class="card-body p-4">
                    <p class="text-muted small mb-3">
                        Upload the signed hard copy of the permit.
                    </p>
                    <form method="post"
                          enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/documents">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <input type="hidden" name="documentType" value="PRINTED_PERMIT">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Select File
                                <span class="text-danger">*</span>
                            </label>
                            <input type="file"
                                   name="file"
                                   class="form-control"
                                   accept=".pdf,.jpg,.jpeg,.png,.gif,.webp,.doc,.docx"
                                   required>
                            <div class="form-text">
                                PDF, image or Word document
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 upload-btn">
                            <i class="bi bi-upload me-1"></i>
                            Upload Printed Permit
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- SAFETY BRIEFING -->

        <div class="col-lg-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-success text-white py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-shield-check me-2"></i>
                        Safety Briefing
                    </h5>
                </div>
                <div class="card-body p-4">
                    <p class="text-muted small mb-3">
                        Upload the Safety Briefing record.
                    </p>
                    <form method="post"
                          enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/documents">
                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">
                        <input type="hidden"
                               name="documentType"
                               value="SAFETY_BRIEFING">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Select File
                                <span class="text-danger">*</span>
                            </label>

                            <input type="file"
                                   name="file"
                                   class="form-control"
                                   accept=".pdf,.jpg,.jpeg,.png,.gif,.webp,.doc,.docx"
                                   required>

                            <div class="form-text">
                                PDF, image or Word document
                            </div>

                        </div>

                        <button type="submit"
                                class="btn btn-success w-100 upload-btn">

                            <i class="bi bi-upload me-1"></i>
                            Upload Safety Briefing

                        </button>

                    </form>

                </div>

            </div>

        </div>
        <!-- OTHER -->

        <div class="col-lg-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-secondary text-white py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-file-earmark me-2"></i>
                        Other Document
                    </h5>
                </div>

                <div class="card-body p-4">

                    <p class="text-muted small mb-3">
                        Upload any other supporting document.
                    </p>

                    <form method="post"
                          enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/documents">
                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">
                        <input type="hidden"
                               name="documentType"
                               value="OTHER">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Select File
                            </label>
                            <input type="file"
                                   name="file"
                                   class="form-control"
                                   accept=".pdf,.jpg,.jpeg,.png,.gif,.webp,.doc,.docx"
                                   required>
                            <div class="form-text">
                                PDF, image or Word document
                            </div>
                        </div>
                        <button type="submit"
                                class="btn btn-secondary w-100 upload-btn">
                            <i class="bi bi-upload me-1"></i>
                            Upload Other Document
                       </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    </c:if>

    <!-- UPLOADED DOCUMENTS -->
    <div class="card border-0 shadow-sm">

        <!-- CARD HEADER -->
        <div class="card-header bg-white py-3">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h5 class="mb-1 fw-semibold">
                        <i class="bi bi-folder2-open me-2"></i>
                        Uploaded Documents
                    </h5>
                </div>

                <span class="badge bg-primary rounded-pill px-3 py-2">
                    <i class="bi bi-files me-1"></i>
                    Documents
                </span>
            </div>
        </div>
        <!-- CARD BODY -->
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty documents}">
                    <div class="text-center empty-state">
                        <i class="bi bi-file-earmark-x empty-state-icon"></i>
                        <h6 class="mt-3 text-muted">
                            No documents uploaded yet.
                        </h6>
                        <p class="text-muted small mb-0">
                            Uploaded permit documents will appear here.
                        </p>
                    </div>
                </c:when>
                <c:otherwise>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 documents-table">
                            <thead class="table-light">
                            <tr>
                                <th class="ps-4"> Sr.No.</th>
                                <th>Document Type</th>
                                <th> File Name</th>
                                <th> Uploaded By</th>
                                <th> Uploaded At</th>
                                <th class="text-center"> View</th>
                            </tr>
                            </thead>
                            <tbody>

                            <c:forEach items="${documents}" var="document" varStatus="status">
                                <tr>
                                    <td class="ps-4 text-muted">${status.count} </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${document.documentType == 'PRINTED_PERMIT'}">
                                                <span class="badge bg-primary-subtle text-primary px-3 py-2">
                                                    <i class="bi bi-file-earmark-check me-1"></i>
                                                    Printed Permit
                                                </span>
                                            </c:when>
                                            <c:when test="${document.documentType == 'SAFETY_BRIEFING'}">
                                                <span class="badge bg-success-subtle text-success px-3 py-2">
                                                    <i class="bi bi-shield-check me-1"></i>
                                                    Safety Briefing
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary px-3 py-2">
                                                    <i class="bi bi-file-earmark me-1"></i>
                                                    Other
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <i class="bi bi-file-earmark-pdf text-danger document-icon me-2"></i>
                                            <span class="file-name" title="${document.originalFileName}">
                                                ${document.originalFileName}
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <i class="bi bi-person me-1 text-muted"></i>
                                        ${document.uploadedBy}
                                    </td>
                                    <td class="text-muted">
                                        <i class="bi bi-clock me-1"></i>
                                        ${document.uploadedAt}
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/documents/${document.id}"
                                           target="_blank" class="btn btn-sm btn-outline-primary view-btn">
                                            <i class="bi bi-eye me-1"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <c:if test="${permit.status == 'WORK_COMPLETED'}">

        <div class="card border-0 shadow-sm mt-4">

            <div class="card-header bg-white py-3">
                <h5 class="mb-0 fw-semibold">
                    <i class="bi bi-check2-circle me-2"></i>
                    Complete Permit Closure
                </h5>
            </div>

            <div class="card-body p-4">

                <!-- REQUIRED DOCUMENT STATUS -->

                <div class="row g-3 mb-4">

                    <!-- PRINTED PERMIT -->

                    <div class="col-md-6">

                        <div class="border rounded p-3
                                    d-flex justify-content-between
                                    align-items-center">

                            <div>
                                <div class="fw-semibold">
                                    Printed Permit
                                </div>

                                <small class="text-muted">
                                    Mandatory
                                </small>
                            </div>

                            <c:choose>

                                <c:when test="${printedPermitUploaded}">
                                    <span class="badge bg-success">
                                        <i class="bi bi-check-circle me-1"></i>
                                        Uploaded
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="badge bg-danger">
                                        <i class="bi bi-x-circle me-1"></i>
                                        Required
                                    </span>
                                </c:otherwise>

                            </c:choose>

                        </div>

                    </div>


                    <!-- SAFETY BRIEFING -->

                    <div class="col-md-6">

                        <div class="border rounded p-3
                                    d-flex justify-content-between
                                    align-items-center">

                            <div>
                                <div class="fw-semibold">
                                    Safety Briefing
                                </div>

                                <small class="text-muted">
                                    Mandatory
                                </small>
                            </div>

                            <c:choose>

                                <c:when test="${safetyBriefingUploaded}">
                                    <span class="badge bg-success">
                                        <i class="bi bi-check-circle me-1"></i>
                                        Uploaded
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="badge bg-danger">
                                        <i class="bi bi-x-circle me-1"></i>
                                        Required
                                    </span>
                                </c:otherwise>

                            </c:choose>

                        </div>

                    </div>

                </div>


                <!-- VALID TILL + CLOSE -->

                <form method="post"
                      action="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/close"
                      onsubmit="return confirm('Are you sure you want to close this permit?');">

                    <input type="hidden"
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}">


                    <div class="row g-3">

                        <!-- VALID TILL DATE -->

                        <div class="col-md-6">

                            <label class="form-label fw-semibold">
                                Valid Till Date
                                <span class="text-danger">*</span>
                            </label>

                            <input type="date"
                                   name="validTillDate"
                                   class="form-control"
                                   required>

                        </div>


                        <!-- VALID TILL TIME -->

                       <!-- <div class="col-md-6">

                            <label class="form-label fw-semibold">
                                Valid Till Time
                                <span class="text-danger">*</span>
                            </label>

                            <input type="time" name="validTillTime" class="form-control"
                                   required>
                        </div>

                    </div> -->

                     <div class="col-md-6">

                                            <label class="form-label fw-semibold">
                                                Valid Till Time
                                                <span class="text-danger">*</span>
                                            </label>

                                            <input type="time"
                                                   name="validTillTime"
                                                   class="form-control"
                                                   required>

                                        </div>

                                    </div>
                    <!-- CLOSE BUTTON -->

                    <div class="mt-4 d-flex justify-content-end">

                        <c:choose>

                            <c:when test="${printedPermitUploaded && safetyBriefingUploaded}">

                                <button type="submit"
                                        class="btn btn-success">

                                    <i class="bi bi-lock-fill me-1"></i>
                                    Close Permit

                                </button>

                            </c:when>

                            <c:otherwise>

                                <button type="button"
                                        class="btn btn-secondary"
                                        disabled>

                                    <i class="bi bi-lock me-1"></i>
                                    Close Permit

                                </button>

                            </c:otherwise>

                        </c:choose>

                    </div>


                </form>


                <!-- WARNING -->

                <c:if test="${!printedPermitUploaded || !safetyBriefingUploaded}">

                    <div class="alert alert-warning mt-3 mb-0">

                        <i class="bi bi-exclamation-triangle me-2"></i>

                        Printed Permit and Safety Briefing documents
                        are required before closing the permit.

                    </div>

                </c:if>

            </div>

        </div>

    </c:if>
</div>

<!-- Bootstrap JS -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>

