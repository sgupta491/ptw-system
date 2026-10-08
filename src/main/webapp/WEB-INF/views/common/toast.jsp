<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>

#appToastContainer {
        position: fixed;
        top: 20px;
        left: 50%;
          transform: translateX(-50%);
        z-index: 9999;
        min-width: 320px;
        max-width: 450px;
    }

#appToast {
        border: none;
        border-radius: 10px;
        box-shadow: 0 4px 18px rgba(0,0,0,0.20);
    }

.app-toast-success {
        background: #198754;
        color: white;
    }

.app-toast-error {
        background: #dc3545;
        color: white;
    }

 .app-toast-warning {
        background: #ffc107;
        color: #212529;
    }

 .app-toast-info {
        background: #0d6efd;
        color: white;
    }
    @media print {

        #appToastContainer {
            display: none !important;
        }

    }

</style>

<c:if test="${not empty successMessage or not empty errorMessage
             or not empty warningMessage or not empty infoMessage}">

    <div id="appToastContainer">
        <div id="appToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <strong id="appToastTitle" class="me-auto"></strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast">
                </button>
            </div>
            <div id="appToastBody" class="toast-body">
            </div>
        </div>
    </div>

 <script>
 document.addEventListener("DOMContentLoaded", function () {

       const toastElement = document.getElementById("appToast");
       const toastTitle =  document.getElementById("appToastTitle");
       const toastBody = document.getElementById("appToastBody");
       <c:choose>
                <c:when test="${not empty successMessage}">
                    toastTitle.textContent = "Success";
                    toastBody.textContent = "${successMessage}";
                    toastElement.classList.add("app-toast-success");
                </c:when>

                <c:when test="${not empty errorMessage}">
                    toastTitle.textContent = "Failed";
                    toastBody.textContent = "${errorMessage}";
                    toastElement.classList.add("app-toast-error");
                </c:when>
                <c:when test="${not empty warningMessage}">
                    toastTitle.textContent = "Warning";
                    toastBody.textContent = "${warningMessage}";
                    toastElement.classList.add("app-toast-warning");
                </c:when>

                <c:when test="${not empty infoMessage}">
                    toastTitle.textContent = "Information";
                    toastBody.textContent ="${infoMessage}";
                    toastElement.classList.add("app-toast-info");
                </c:when>
            </c:choose>

            const toast = new bootstrap.Toast(
                    toastElement,
                    {
                        delay: 5000
                    }
                );
            toast.show();
        });
    </script>
</c:if>