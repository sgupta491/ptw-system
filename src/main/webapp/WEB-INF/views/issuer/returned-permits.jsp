<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Returned Permits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="card shadow-sm">
        <div class="card-header bg-danger text-white">
            <h4 class="mb-0"> Returned Permits </h4>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty permits}">
                    <div class="alert alert-info">
                        No returned permits.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                            <tr>
                                <th>Permit Number</th>
                                <th>Permit Type</th>
                                <th>Acceptor</th>
                                <th>Valid Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${permits}" var="permit">
                                <tr>
                                    <td> ${permit.permitNumber}</td>
                                    <td> ${permit.permitType}</td>
                                    <td> ${permit.acceptorName}</td>
                                    <td>${permit.validOnDate}</td>
                                    <td> <span class="badge bg-danger">
                                            RETURNED
                                        </span>
                                    </td>
                                    <td> <a href="${pageContext.request.contextPath}/issuer/permits/${permit.id}/edit" class="btn btn-primary btn-sm">
                                            Correct &amp; Edit
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