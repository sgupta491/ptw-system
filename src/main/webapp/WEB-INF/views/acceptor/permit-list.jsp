<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Permit Tasks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5" style="max-width: 1600px;">
    <!-- HEADER -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <div>
                <h3 class="mb-1">
                   Acceptor permit List
                </h3>
            </div>
        </div>
    </div>

    <!-- EMPTY -->
    <c:choose>
        <c:when test="${empty permits}">
            <div class="card shadow-sm">
                <div class="card-body text-center py-5">
                    <h5 class="text-muted">
                        No permits available
                    </h5>
                    <p class="text-muted mb-0">
                        Permits assigned to you will appear here.
                    </p>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th> Permit No.</th>
                                <th> Permit Type</th>
                                <th>Permit Issuer</th>
                                <th>Proposed Work</th>
                                <th> Valid On Date</th>
                                <th> Valid Till Date</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                                <th>View Documents</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="permit" items="${permits}">
                                <tr>
                                    <td> <strong>${permit.displayPermitNumber} </strong></td>
                                    <td>${permit.permitType}</td>
                                    <td><div>${permit.issuerName}</div></td>
                                    <td> <div style="max-width:280px;"class="text-truncate">
                                            ${permit.proposedWork}
                                        </div>
                                    </td>
                                    <td> ${permit.validOnDate} </td>
                                    <td> <c:choose>
                                           <c:when test="${not empty permit.validTillFormatted}">
                                            ${permit.validTillFormatted}
                                           </c:when>
                                           <c:otherwise>
                                            —
                                           </c:otherwise>
                                           </c:choose>
                                          </td>
                                    <td>
                                    <span class="badge bg-light text-dark border">${permit.status} </span>
                                    </td>

                                    <td class="text-center">
                                        <!-- Section B -->
                                        <c:if test="${permit.status == 'PERMIT_ISSUED'}">
                                            <a  href="${pageContext.request.contextPath}/acceptor/permits/${permit.id}"
                                                    class="btn btn-sm btn-primary">
                                                View
                                            </a>
                                        </c:if>

                                        <c:if test="${permit.status == 'PERMIT_IN_PROGRESS'}">
                                            <a href="${pageContext.request.contextPath}/acceptor/permits/${permit.id}"
                                                    class="btn btn-sm btn-success">
                                                Complete Section B
                                            </a>
                                        </c:if>
                                        <!-- Work in progress -->
                                        <c:if test="${permit.status == 'WORK_IN_PROGRESS' || permit.status == 'EXTENSION_REQUESTED' || permit.status == 'EXTENDED'}">
                                            <a  href="${pageContext.request.contextPath}/acceptor/permits/${permit.id}"
                                                    class="btn btn-sm btn-primary">
                                                View
                                            </a>
                                        </c:if>

                                        <!-- Work completed -->
                                        <c:if test="${permit.status == 'WORK_COMPLETED'}">
                                            <a  href="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/documents"
                                                    class="btn btn-sm btn-success">
                                                Upload Documents
                                            </a>
                                        </c:if>
                                         <c:if test="${permit.status == 'WORK_IN_PROGRESS' && permit.currentStage == 'WORK_IN_PROGRESS' && !permit.extensionRequestUsed}">
                                              <form method="post"  action="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/extension-request"
                                                    style="display:inline;">
                                              <input type="hidden"  name="${_csrf.parameterName}"value="${_csrf.token}" />

                                              <button type="submit" class="btn btn-warning btn-sm"
                                              onclick="return confirm('Are you sure you want to request an extension for this permit?');">
                                                  Extension Required
                                               </button>
                                               </form>
                                            </c:if>
                                        <!-- Closed -->
                                        <c:if test="${permit.status == 'CLOSED'}">
                                            <a href="${pageContext.request.contextPath}/acceptor/permits/${permit.id}"
                                                    class="btn btn-sm btn-dark">
                                                View
                                            </a>
                                        </c:if>
                                    </td>
                                    <td class="text-center">

                                        <c:if test="${permit.status == 'WORK_COMPLETED' || permit.status == 'CLOSED'}">
                                            <a href="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/documents"
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-folder2-open me-1"></i>
                                                View Documents
                                            </a>
                                        </c:if>
                                        <c:if test="${permit.status != 'WORK_COMPLETED' && permit.status != 'CLOSED'}">
                                            <span class="text-muted">—</span>
                                        </c:if>

                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>