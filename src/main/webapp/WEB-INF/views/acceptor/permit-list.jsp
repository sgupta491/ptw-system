<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pending Permits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0"> Pending Permit Verification
            </h3>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty permits}">
                    <div class="alert alert-info"> No permits are pending for verification.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-bordered
                                      table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                              <th>Sr. No.</th>
                               <th>Permit Number</th>
                                <th>Permit Type</th>
                                <th>Issuer</th>
                                <th>Contractor</th>
                                <th>Valid Date</th>
                                <th>Status </th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${permits}" var="permit" varStatus="status">
                                <tr>
                                     <td>${status.count}</td>
                                    <td>${permit.permitNumber}</td>
                                    <td>${permit.permitType}</td>
                                    <td>${permit.issuerName}</td>
                                    <td><c:choose>
                                            <c:when test="${permit.contractorDeployed}">
                                                ${permit.contractorName}
                                            </c:when>
                                            <c:otherwise>No </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td> ${permit.formattedValidOnDate} </td>
                                    <td>
                                     <c:choose>
                                            <c:when test="${permit.status == 'ACCEPTOR_VERIFICATION'}">
                                                <span class="badge bg-info">
                                                    ACCEPTOR VERIFICATION
                                                </span>
                                            </c:when>

                                            <c:when test="${permit.status == 'READY_FOR_PRINT'}">
                                                <span class="badge bg-success">
                                                    READY FOR PRINT
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge bg-secondary">
                                                    ${permit.status}
                                                </span>
                                            </c:otherwise>
                                      </c:choose>
                                    </td>
                                    <td>
                                    <c:if test="${permit.status == 'ACCEPTOR_VERIFICATION'}">
                                    <a href="${pageContext.request.contextPath}/acceptor/permits/${permit.id}" class="btn btn-primary btn-sm">
                                            Verify
                                        </a>
                                    </c:if>
                                        <c:if test="${permit.status == 'READY_FOR_PRINT'}">
                                            <a href="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/start-work"
                                                  class="btn btn-success btn-sm">
                                                   Accept &amp; Start Work
                                               </a>
                                        </c:if>
                                        <c:if test="${permit.status == 'ACTIVE'}">
                                            <a href="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/completion"
                                               class="btn btn-warning btn-sm">
                                                Work Completion
                                            </a>

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