<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>My Permits</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

</head>


<body class="bg-light">


<div class="container my-5">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white  d-flex justify-content-between  align-items-center">
            <h3 class="mb-0"> My Permits </h3>
            <a href="${pageContext.request.contextPath}/issuer/permits/new" class="btn btn-light">
                 Create New Permit
            </a>
        </div>
    </div>
    <c:if test="${not empty success}">
        <div class="alert alert-success">
            ${success}
        </div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-body">
            <c:choose>
                <c:when test="${empty permits}">
                    <div class="alert alert-info mb-0">
                        You have not created any permits yet.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                  <th>Sr. No.</th>
                                <th>Permit Number</th>
                                <th>Permit Type</th>
                                <th>Acceptor</th>
                                <th>Contractor</th>
                                <th>Valid Date</th>
                                <th> Status</th>
                                <th>Current Stage</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${permits}" var="permit" varStatus="status">
                                <tr>
                                     <td>${status.count}</td>
                                    <td><strong> ${permit.permitNumber} </strong></td>
                                    <td> ${permit.permitType} </td>
                                    <td> ${permit.acceptorName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${permit.contractorDeployed}">
                                                <span class="badge bg-success">
                                                    Yes
                                                </span>
                                                <c:if test="${not empty permit.contractorName}">
                                                    <br>
                                                    <small>
                                                        ${permit.contractorName}
                                                    </small>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">
                                                    No
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <!-- Valid Date -->
                                    <td>
                                         ${permit.formattedValidOnDate}
                                    </td>
                                    <!-- Status -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${permit.status == 'DRAFT'}">
                                                <span class="badge bg-secondary">
                                                    DRAFT
                                                </span>
                                            </c:when>
                                            <c:when test="${permit.status == 'ACCEPTOR_VERIFICATION'}">
                                                <span class="badge bg-warning text-dark">
                                                    ACCEPTOR VERIFICATION
                                                </span>
                                            </c:when>
                                            <c:when  test="${permit.status == 'RETURNED'}">
                                                <span class="badge bg-danger">
                                                    RETURNED
                                                </span>
                                            </c:when>
                                            <c:when test="${permit.status == 'ACCEPTOR_VERIFIED'}">
                                                <span class="badge bg-success">
                                                    ACCEPTOR VERIFIED
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-info">
                                                    ${permit.status}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <!-- Current Stage -->
                                    <td>
                                        <span class="badge bg-info">${permit.currentStage}
                                        </span>
                                    </td>
                                    <!-- Action -->
                                    <td>
                                     <c:if test="${permit.status == 'DRAFT' || permit.status == 'ACCEPTOR_VERIFICATION'}">
                                    <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}"
                                                class="btn btn-sm btn-primary">
                                            View
                                        </a>
                                         </c:if>
                                        <!-- Returned -->
                                        <c:if test="${permit.status == 'RETURNED'}">
                                            <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/edit"
                                                    class="btn btn-sm btn-danger mt-1">
                                                Correct &amp; Edit
                                            </a>
                                        </c:if>

                                            <!-- ACCEPTOR VERIFIED -->
                                         <c:if test="${permit.status == 'ACCEPTOR_VERIFIED'}">
                                                <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/assessment"
                                                        class="btn btn-sm btn-success mt-1">
                                                    Start Assessment
                                                </a>
                                            </c:if>
                                            <c:if test="${permit.status == 'ISSUER_APPROVAL'}">

                                                <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/approval"
                                                   class="btn btn-warning btn-sm">
                                                    Review &amp; Approve
                                                </a>

                                            </c:if>

                                             <!-- Print -->
                                                <c:if test="${permit.status == 'READY_FOR_PRINT'}">

                                                    <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/print"
                                                       class="btn btn-dark btn-sm"
                                                       target="_blank">
                                                        Print
                                                    </a>

                                                </c:if>

                                                <c:if test="${permit.status == 'FINAL_VERIFICATION'}">

                                                    <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/final-verification"
                                                       class="btn btn-warning btn-sm">
                                                       Close
                                                    </a>
                                                </c:if>

                                                <c:if test="${permit.status == 'CLOSED'}">
                                                     <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/full-view"
                                                               class="btn btn-primary btn-sm">
                                                               View </a>
                                                </c:if>
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