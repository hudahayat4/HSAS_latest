<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Appointment | JuzCare</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/viewapt.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
</head>
<body>

    <%@ include file="../header.jsp" %>

    <div class="appointment-container">
        
        <div class="breadcrumb-area">
            <strong>Appointment Details</strong>
        </div>

        <div class="receipt-card">
            <div class="header-center">
                <img src="${pageContext.request.contextPath}/image/logo.png" alt="JuzCare" class="logo">
                <h3 class="thank-you-text">Thank you for your appointment in JuzCare Pharmacy</h3>
            </div>
            <div class="appointment-meta">
                <p class="section-title-small">DETAIL APPOINTMENT</p>
                <div class="date-time-row">
                    <span>📅 <fmt:formatDate value="${apt.apptDate}" pattern="dd/MM/yyyy" /></span>
                    <span>🕒 <fmt:formatDate value="${apt.apptTime}" pattern="HH:mm" /></span>
                </div>
                <hr>
            </div>

            <div class="patient-info">
                <p><strong>Name :</strong> ${apt.customerName}</p>
                <p><strong>Package :</strong> ${apt.packageName}</p>
                <p><strong>Pharmacist :</strong> ${apt.pharmacistName}</p>
                <p><strong>Price :</strong> RM <fmt:formatNumber value="${apt.packagePrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></p>
            </div>

            <div class="terms">
                <p><strong>Term &amp; Condition :</strong></p>
                <ol>
                    <li>Your appointment is confirmed once booking is made.</li>
                    <li>Cancellations must be 24 hours before.</li>
                </ol>
            </div>
        </div>

        <div class="button-group-action">
            <a href="${pageContext.request.contextPath}/appointment/AppointmentController?action=list" class="btn-cancel-custom">Back to List</a>
            <button type="button" class="btn-medical-custom" onclick="window.print()">Print Receipt</button>
        </div>
    </div>

    <%@ include file="../footer.jsp" %>

</body>
</html>