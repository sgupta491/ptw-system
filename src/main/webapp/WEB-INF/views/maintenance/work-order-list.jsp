<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <title>Maintenance Work Order List</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"   rel="stylesheet">
    <jsp:include page="/WEB-INF/views/common/toast.jsp"/>
    <style>

        body {
            background-color: #f5f6f8;
        }

        .page-wrapper {
            max-width: 1300px;
            margin: 30px auto;
            padding: 0 15px;
        }

        .page-title {
            font-weight: 600;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .table th {
            white-space: nowrap;
        }

        .table td {
            vertical-align: middle;
        }

        .empty-box {
            padding: 50px;
            text-align: center;
            color: #6c757d;
        }

    </style>

</head>

<body>

<div class="page-wrapper">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="page-title mb-1">
                Maintenance Work Orders list
            </h3>

        </div>

    </div>

    <div class="card">
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty workOrders}">

                    <div class="table-responsive">

                        <table class="table table-bordered table-hover mb-0">

                            <thead class="table-light">

                            <tr>

                                <th>#</th>
                                <th>Work Order No.</th>
                                <th>Permit No.</th>
                                 <th>Requester</th>
                                <th>Request Date</th>
                                <th>Location</th>
                                <th>Work To Be Done By</th>
                                <th>Maintenance Type</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach  items="${workOrders}" var="workOrder" varStatus="status">
                                <tr>
                                    <td> ${status.count} </td>
                                    <td> <strong> ${workOrder.woNumber}</strong> </td>
                                    <td>${workOrder.permitNumber}</td>
                                    <td>${workOrder.requesterName}</td>
                                    <td>${workOrder.requestDate}</td>
                                    <td>${workOrder.workLocation}</td>
                                    <td>${workOrder.workToBeDoneBy} </td>
                                    <td>${workOrder.maintenanceType}</td>
                                    <td>
                                        <span class="badge bg-light text-dark border"">
                                            ${workOrder.status}
                                        </span>
                                    </td>
                                    <td><a href="${pageContext.request.contextPath}/maintenance/work-orders/${workOrder.id}"
                                                class="btn btn-primary btn-sm">
                                           View
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-box">
                        <h5>
                            No Pending Work Orders
                        </h5>
                        <p class="mb-0">
                            There are currently no pending electrical
                            isolation work requests.
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>
</body>

</html>