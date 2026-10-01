<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <title>Permit Documents</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body class="bg-light">
<div class="container my-5">
    <div class="card shadow-sm border-0">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">
                Permit Documents
            </h4>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty documents}">

                    <div class="alert alert-info">
                        No documents uploaded for this permit.
                    </div>

                </c:when>

                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 documents-table">
                            <thead class="table-light">
                            <tr>
                                <th>Sr. No.</th>
                                <th>Document Type</th>
                                <th>File Name</th>
                                <th>Uploaded By</th>
                                <th>Uploaded At</th>
                                <th>View</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${documents}"
                                       var="document"
                                       varStatus="status">
                                <tr>

                                    <td>
                                        ${status.count}
                                    </td>

                                    <td>
                                        <c:choose>

                                            <c:when test="${document.documentType == 'PRINTED_PERMIT'}">
                                                <span class="badge bg-primary">
                                                    Printed Permit
                                                </span>
                                            </c:when>

                                            <c:when test="${document.documentType == 'SAFETY_BRIEFING'}">
                                                <span class="badge bg-success">
                                                    Safety Briefing
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge bg-secondary">
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

                                    <td>
                                     <i class="bi bi-clock me-1"></i>
                                        ${document.uploadedAt}
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/documents/${document.id}"
                                           target="_blank"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye"></i>
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
</div>
</body>
</html>