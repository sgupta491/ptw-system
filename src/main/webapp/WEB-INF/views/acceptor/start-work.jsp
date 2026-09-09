<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Start Work</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

</head>

<body class="bg-light">

<div class="container my-5">

    <div class="card shadow-sm border-0">

        <div class="card-header bg-success text-white">

            <h4 class="mb-0">
                Permit Acceptance &amp; Work Start
            </h4>

        </div>

        <div class="card-body">

            <div class="row g-3 mb-4">

                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Permit Number
                    </label>

                    <div class="form-control bg-light">
                        ${permit.permitNumber}
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Permit Type
                    </label>

                    <div class="form-control bg-light">
                        ${permit.permitType}
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Equipment Number
                    </label>

                    <div class="form-control bg-light">
                        ${permit.equipmentNumber}
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">
                        Location
                    </label>

                    <div class="form-control bg-light">
                        ${permit.location}
                    </div>
                </div>

            </div>

            <div class="alert alert-warning">

                <strong>Important:</strong>

                Confirm that the printed permit has been reviewed
                and the required hardcopy signatures have been obtained,
                including Section G.

            </div>

            <form method="post"
                  action="${pageContext.request.contextPath}/acceptor/permits/${permit.id}/start-work">

                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">

                <div class="d-flex justify-content-end">

                    <button type="submit"
                            class="btn btn-success btn-lg">

                        Confirm Acceptance &amp; Start Work

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>

</body>
</html>