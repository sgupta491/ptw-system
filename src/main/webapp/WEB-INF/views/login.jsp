<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>PTW - Login</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"  rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">

</head>

<body>

<div class="container">
    <div class="login-wrapper">
        <div class="card login-card">
            <div class="card-body p-4 p-md-5">
                <!-- Title -->
                <div class="text-center mb-4">
                    <h2 class="login-title mb-2">
                        Permit to Work
                    </h2>
                    <p class="text-muted mb-0">
                        Sign in to continue
                    </p>
                </div>
                <!-- Error Message -->
                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show"
                         role="alert">
                        Invalid username or password.
                        <button type="button"
                                class="btn-close"
                                data-bs-dismiss="alert">
                        </button>
                    </div>
                <% } %>

                <!-- Logout Message -->
                <% if (request.getParameter("logout") != null) { %>

                    <div class="alert alert-success alert-dismissible fade show"
                         role="alert">
                        You have been logged out successfully.
                        <button type="button"
                                class="btn-close"
                                data-bs-dismiss="alert">
                        </button>
                    </div>
                <% } %>
                <!-- Login Form -->
                <form action="${pageContext.request.contextPath}/login"
                      method="post">

                      <!-- CSRF Token -->
                          <input type="hidden"
                                 name="${_csrf.parameterName}"
                                 value="${_csrf.token}" />

                    <!-- Username -->
                    <div class="mb-3">
                        <label for="username"
                               class="form-label fw-semibold">
                            Username
                        </label>
                        <input
                            type="text"
                            class="form-control"
                            id="username"
                            name="username"
                            placeholder="Enter username"
                            autocomplete="username"
                            required>
                    </div>


                    <!-- Password -->
                    <div class="mb-4">
                        <label for="password" class="form-label fw-semibold">
                            Password
                        </label>
                        <input type="password" class="form-control"  id="password"
                            name="password"  placeholder="Enter password"
                            autocomplete="current-password" required>

                    </div>

                    <!-- Login Button -->
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary login-btn">
                            Login
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>
</body>
</html>