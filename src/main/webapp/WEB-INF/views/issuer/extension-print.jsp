<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Permit Extension - ${permit.permitNumber}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
     <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/extension-print.css">

</head>

<body>

<div class="page">
    <div class="title">
        Cold Work Permit Extension
    </div>
    <div class="subtitle">
        Work permit can be extended maximum seven consecutive working days.
    </div>

    <!-- PERMIT NUMBER -->
    <div class="permit-number">
        Work Permit Number :
        ${permit.permitNumber}
    </div>

    <!-- SECTION A -->
    <div class="section-title">
        A - General Information
    </div>
    <table class="info-table">
        <tr>
        <td class="label-cell"> Permit Issuer</td>
            <td class="value-cell"> Dept. : ${permit.issuerDepartment} </td>
            <td class="value-cell">Name :  ${permit.issuerName}</td>
        </tr>
        <tr>
            <td class="label-cell"> Permit Acceptor </td>
            <td class="value-cell"> Dept. : ${permit.acceptorDepartment}</td>
            <td class="value-cell">  Name :  ${permit.acceptorName} </td>
        </tr>
        <tr>
            <td class="label-cell">  Proposed Work </td>
            <td class="value-cell"> ${permit.proposedWork}</td>
             <td class="value-cell"></td>
        </tr>
    </table>

    <!-- ORIGINAL SECTION B -->

    <div class="section-title"> B - Work Description </div>

    <table class="info-table">
        <tr>
            <td class="label-cell"> Equipment Number </td>
            <td class="value-cell"> ${permit.equipmentNumber}</td>
            <td class="label-cell"> Location </td>
            <td class="value-cell">${permit.location}</td>
        </tr>
        <tr>
            <td class="label-cell"> Proposed Work in Detail </td>
            <td class="value-cell">${permit.proposedWorkInDetail}</td>
            <td class="label-cell">Valid On Date </td>
            <td class="value-cell"> ${permit.validOnDate} </td>
        </tr>
         <tr>
           <td class="label-cell"> Permit Acceptor: Contractor if deployed</td>
            <td class="value-cell">
               <c:choose>
                <c:when test="${permit.contractorDeployed}">${permit.contractorName}</c:when>
                    <c:otherwise>No</c:otherwise>
                </c:choose>
               </td>
               <td class="label-cell">Sup. Name </td>
              <td class="value-cell"> ${permit.contractorSupervisor}</td>
            </tr>
        <tr>
            <td class="label-cell">Time From</td>
            <td class="value-cell">${permit.timeFrom} </td>
            <td class="label-cell">Time To</td>
            <td class="value-cell"> ${permit.timeTo} </td>
        </tr>
        <tr>
            <td class="label-cell">Lift &amp; Shift by Equipment</td>
            <td class="value-cell">${permit.liftShiftByEquipment}</td>
            <td class="label-cell"> Hazardous Chemical Exposure</td>
            <td class="value-cell">${permit.hazardousChemicalExposure}</td>
        </tr>
        <tr>
            <td class="label-cell">Other Hazard Activity</td>
            <td colspan="3">${permit.otherHazardActivity}</td>
        </tr>
    </table>

    <!-- EXTENSION TABLE -->
    <div class="section-subtitle"> Extensions of Work Permit : </div>

    <table class="extension-table">
        <colgroup>

            <col class="label-col">

            <col class="day-col">
            <col class="day-col">
            <col class="day-col">
            <col class="day-col">
            <col class="day-col">
            <col class="day-col">
            <col class="day-col">

        </colgroup>

        <tbody>
        <!-- DAY -->
                <tr>
                    <td>
                        Day
                    </td>

                    <td class="blank-cell">Day 1</td>
                    <td class="blank-cell">Day 2</td>
                    <td class="blank-cell">Day 3</td>
                    <td class="blank-cell">Day 4</td>
                    <td class="blank-cell">Day 5</td>
                    <td class="blank-cell">Day 6</td>
                    <td class="blank-cell">Day 7</td>

                </tr>
        <!-- DATE -->
        <tr>
            <td>
                Date of extension
            </td>

            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>

        </tr>


        <!-- TIME -->

        <tr>

            <td>
                Time :
                <br>
                From :
                ______ hrs
                <br>
                To :
                ______ hrs
            </td>

            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>

        </tr>


        <!-- HAZARDS -->

        <tr>

            <td>
                Hazards as per C are
                unchanged
                <br>
                sig. of issuer
            </td>

            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>

        </tr>


        <!-- SAFETY -->

        <tr>

            <td>
                Safety precautions as per
                sec. D &amp; E, are
                unchanged -
                sign of issuer
            </td>

            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>

        </tr>


        <!-- APPROVAL -->

        <tr>

            <td>
                Approval after verification
                <br>
                Sign. of issuer
            </td>

            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>

        </tr>


        <!-- SAFETY BRIEFING -->

        <tr>

            <td>
                Safety briefing provided
                to acceptor team
                members.
                <br>
                Sign of issuer
            </td>

            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>

        </tr>


        <!-- ACCEPTOR VERIFICATION -->

        <tr>

            <td>
                Acceptor after verification
                of work condition.
                <br>
                Signature :
            </td>

            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>

        </tr>


        <!-- CONTRACTOR SUPERVISOR -->

        <tr>

            <td>
                Acceptor : supervisor of
                contractor signature :
            </td>

            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>

        </tr>


        <!-- COMPLETION -->

        <tr>

            <td>
                Work completed Yes/No
                <br>
                Further extension
                required Yes/No
                <br>
                Signature of acceptor
            </td>

            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>
            <td class="blank-cell"></td>

        </tr>

        </tbody>

    </table>


    <!-- BUTTONS -->

    <c:if test="${!permit.extensionUsed}">
      <div class="d-flex justify-content-center align-items-center gap-3 mt-4">

          <form method="post"
                action="${pageContext.request.contextPath}/issuer/permits/${permit.id}/extension-form/print"
                class="m-0">

              <input type="hidden"
                     name="${_csrf.parameterName}"
                     value="${_csrf.token}">

              <button type="submit" class="btn btn-primary">
                  Print Extension Form
              </button>

          </form>

          <a href="${pageContext.request.contextPath}/issuer/permits"
             class="btn btn-secondary">
              Back
          </a>

      </div>
    </c:if>

    <c:if test="${permit.extensionUsed}">
       <div class="d-flex justify-content-center align-items-center gap-3 mt-4">

           <button type="button"
                   class="btn btn-primary"
                   onclick="window.print()">
               Print Again
           </button>

           <a href="${pageContext.request.contextPath}/issuer/permits"
              class="btn btn-secondary">
               Back
           </a>

       </div>
    </c:if>
</div>

<!-- AUTO PRINT AFTER SUCCESSFUL PRINT ACTION -->
<c:if test="${autoPrint}">
    <script>
        window.addEventListener("load", function () {
            window.print();
        });
    </script>
</c:if>
</body>
</html>