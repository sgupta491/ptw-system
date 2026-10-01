<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Permits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container my-5" style="max-width: 1600px;">
    <!-- HEADER -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h3 class="mb-1">
                        My Permits
                    </h3>
                    <div class="text-muted">
                     <!-- Issuer Dashboard -->
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/issuer/permits/new"  class="btn btn-primary">
                    + Create New Permit
                </a>
            </div>
        </div>
    </div>

    <!-- EMPTY -->
    <c:choose>
        <c:when test="${empty permits}">
            <div class="card shadow-sm">
                <div class="card-body text-center py-5">
                    <h5 class="text-muted">
                        No permits found
                    </h5>
                    <p class="text-muted mb-0">
                        Your permits will appear here.
                    </p>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- TABLE -->
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>

                                <th> Permit No.</th>
                                <th> Permit Type </th>
                                <th>Acceptor</th>
                                <th> Proposed Work </th>
                                <th> Valid On Date</th>
                                <th> Valid Till Date</th>
                                <th> Status </th>
                                <th class="text-center">  Action</th>
                                 <th>View Documents</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="permit" items="${permits}">
                                <tr>
                                    <td> <strong> ${permit.displayPermitNumber} </strong> </td>
                                    <td>${permit.permitType}</td>
                                    <td><div>${permit.acceptorName}</div>
                                    </td>
                                    <td>
                                        <div style="max-width:280px;"
                                                class="text-truncate">
                                            ${permit.proposedWork}
                                        </div>
                                    </td>
                                    <td> ${permit.validOnDate} </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty permit.validTillFormatted}">
                                               ${permit.validTillFormatted}
                                            </c:when>
                                            <c:otherwise>
                                                —
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                       <span class="badge bg-light text-dark border">
                                           ${permit.status}
                                      </span>
                                    </td>
                                    <td class="text-center">
                                        <!-- Section B pending -->
                                        <c:if test="${permit.status == 'PERMIT_IN_PROGRESS'}">
                                            <a  href="${pageContext.request.contextPath}/issuer/permits/${permit.id}"
                                                    class="btn btn-sm btn-outline-primary">
                                                View
                                            </a>
                                        </c:if>
                                        <!-- Acceptor completed Section B -->
                                        <c:if test="${permit.status == 'PERMIT_ISSUED'}">
                                            <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/assessment"
                                                    class="btn btn-sm btn-success">
                                                Assessement
                                            </a>
                                        </c:if>

                                        <!-- Electrical -->
                                        <c:if test="${permit.status == 'ELECTRICAL_ISOLATION'}">
                                            <a   href="${pageContext.request.contextPath}/issuer/permits/${permit.id}"
                                                    class="btn btn-sm btn-warning">
                                                View
                                            </a>
                                        </c:if>
                                        <!-- Work in progress -->
                                        <c:if test="${permit.status == 'WORK_IN_PROGRESS' || (permit.status == 'EXTENDED' && permit.extensionUsed) }">
                                            <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}"
                                                    class="btn btn-sm btn-primary">
                                                View
                                            </a>
                                            <!--
                                                Mark Work Completed button
                                                will be added after the
                                                completion endpoint is reworked.
                                            -->
                                        </c:if>
                                        <!-- Work completed -->
                                        <c:if test="${permit.status == 'WORK_COMPLETED'}">
                                            <a  href="${pageContext.request.contextPath}/issuer/permits/${permit.id}"
                                                    class="btn btn-sm btn-info">
                                                View
                                            </a>
                                            <div class="small text-muted mt-1">
                                                Awaiting Acceptor documents
                                            </div>
                                        </c:if>
                                        <!-- Closed -->
                                        <c:if test="${permit.status == 'CLOSED'}">
                                            <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/full-view"
                                                    class="btn btn-sm btn-dark">
                                                View
                                            </a>
                                        </c:if>

                                        <c:if test="${permit.status == 'EXTENSION_REQUESTED'}">
                                            <!-- Accept Extension -->
                                            <form method="post" action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/accept-extension"
                                                  style="display:inline;">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                <button type="submit" class="btn btn-success btn-sm"
                                                onclick="return confirm('Are you sure you want to accept this extension?');">
                                                    Accept Extension
                                                </button>
                                            </form>
                                            <!-- Reject Extension -->
                                            <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#rejectExtensionModal${permit.id}">
                                                Reject Extension
                                            </button>
                                        </c:if>

                                        <c:if test="${permit.status == 'EXTENDED' && !permit.extensionUsed}">
                                            <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/extension-form"
                                               class="btn btn-primary btn-sm">
                                                Print Extension Form
                                            </a>
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <c:if test="${permit.status == 'CLOSED'}">
                                            <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/documents"
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-folder2-open me-1"></i>
                                                View Documents
                                            </a>
                                        </c:if>
                                        <c:if test="${permit.status != 'CLOSED'}">
                                            <span class="text-muted">—</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>

                        <!-- Reject Extension Modals -->
                        <c:forEach var="permit" items="${permits}">
                            <div class="modal fade"   id="rejectExtensionModal${permit.id}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">
                                                Reject Extension
                                            </h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                            </button>
                                        </div>
                                        <form method="post"  action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/reject-extension">
                                         <div class="modal-body">
                                                <div class="mb-3">
                                                    <label class="form-label">
                                                        Rejection Remark
                                                    </label>
                                                    <textarea name="rejectionRemark"  class="form-control" rows="3"
                                                       placeholder="Enter rejection remark (optional)"></textarea>
                                                </div>
                                                <input type="hidden"  name="${_csrf.parameterName}" value="${_csrf.token}">
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"  data-bs-dismiss="modal"> Cancel
                                                </button>
                                                <button type="submit" class="btn btn-danger">Reject Extension
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                            </div>

                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>