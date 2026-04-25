<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Juzcare Pharmacy - Verify Account</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/stylesheet.css">
</head>
<body>
<section class="bg-light p-3 p-md-4 p-xl-5 min-vh-100 d-flex align-items-center bg-cover">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-12 col-md-8 col-lg-6">
        <div class="card border-light-subtle shadow-sm">
          <div class="card-body p-3 p-md-4 p-xl-5">
            <h2 class="h4 text-center mb-4">Verify Your Email</h2>

            <!-- Papar email dari session -->
            <c:set var="email" value="${sessionScope.tempCustomer.custEmail}" />
            <p class="mb-4 text-secondary text-center">
              Please enter the 6-digit code we sent to <strong>${email}</strong>.
            </p>

            <!-- Confirm Code Form -->
            <form action="CustomerController?action=confirmCode" method="post" class="text-center" onsubmit="combineCode()">
              <div class="text-center">
                <div class="d-flex justify-content-center mb-2">
                  <input type="text" maxlength="1" class="form-control code-input" oninput="moveNext(this)" required>
                  <input type="text" maxlength="1" class="form-control code-input" oninput="moveNext(this)" required>
                  <input type="text" maxlength="1" class="form-control code-input" oninput="moveNext(this)" required>
                  <input type="text" maxlength="1" class="form-control code-input" oninput="moveNext(this)" required>
                  <input type="text" maxlength="1" class="form-control code-input" oninput="moveNext(this)" required>
                  <input type="text" maxlength="1" class="form-control code-input" oninput="moveNext(this)" required>
                </div>
                <div id="errorMsg" class="error-message text-center"></div>
                <input type="hidden" name="verificationCode" id="verificationCode">
                <button type="submit" class="btn btn-dark btn-lg verify-btn mt-3">Verify</button>
              </div>
            </form>

            <!-- Resend link -->
            <div class="text-center mt-3">
              <form id="resendForm" action="CustomerController?action=requestCode" method="post" class="d-inline">
                <span class="text-secondary">Click here to receive code </span>
                <a href="#" id="resendLink" class="resend-link">Send</a>
              </form>
              <div id="cooldownMsg" class="text-secondary mt-2"></div>
            </div>

            <!-- Papar mesej dari controller -->
            <c:if test="${not empty message}">
              <div class="alert alert-info mt-4 text-center">${message}</div>
            </c:if>
            
            <div id="liveAlertPlaceholder" data-message="${alertMessage}" data-type="${alertType}"></div>

          </div>
        </div>
      </div>
    </div>
  </div>
</section>
<script src="${pageContext.request.contextPath}/js/verifyAccount.js"></script>
</body>
<<<<<<< HEAD
</html>
=======
</html>
>>>>>>> main
