<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Appointment Record | JuzCare</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/listapt.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">


<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
	<%@ include file="../header.jsp"%>

	<div class="appointment-container">
		<h2 class="section-title" style="text-align: center; margin: 30px 0; color: #333;">
			Appointment Record
		</h2>

		<div class="appointment-list">
			<c:forEach var="apt" items="${appointments}">
				<div class="appointment-card">
					<div class="appointment-date">
						<span class="day"><fmt:formatDate value="${apt.apptDate}" pattern="EEEE" /></span> 
						<span class="date"><fmt:formatDate value="${apt.apptDate}" pattern="dd" /></span>
					</div>

					<div class="appointment-info">
						<div class="time-row">
							<i class="far fa-clock"></i> 
							<span class="text"><fmt:formatDate value="${apt.apptTime}" pattern="HH:mm" /></span>
						</div>
						<div class="patient-row">
							<i class="fas fa-user"></i> 
							<span class="text">${apt.customerName}</span>
						</div>
					</div>

					<div class="appointment-package">
						<p class="package-name">${apt.packageName}</p>
						<p class="package-date">
							<fmt:formatDate value="${apt.apptDate}" pattern="dd/MM/yyyy" />
						</p>
					</div>

					<div class="appointment-action">
						<a href="AppointmentController?action=view&appointmentID=${apt.appointmentID}" class="btn-view" title="View" style="text-decoration:none;">
							<i class="fas fa-eye"></i>
						</a>

						<button class="btn-delete" data-id="${apt.appointmentID}">
							<i class="fas fa-trash-alt"></i>
						</button>
					</div>
				</div>
			</c:forEach>

			<c:if test="${empty appointments}">
				<div style="text-align: center; padding: 50px; color: #888;">
					<p>No appointment records found.</p>
				</div>
			</c:if>
		</div>
	</div>

	<%@ include file="../footer.jsp"%>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

	<script>
	document.addEventListener("DOMContentLoaded", function () {
	    const deleteButtons = document.querySelectorAll(".btn-delete");

	    deleteButtons.forEach(button => {
	        button.addEventListener("click", function () {
	            const appointmentId = this.getAttribute("data-id");

	            Swal.fire({
	                title: "Are you sure?",
	                text: "You won’t be able to undo this.",
	                icon: "warning",
	                showCancelButton: true,
	                confirmButtonColor: "#3085d6",
	                cancelButtonColor: "#d33",
	                confirmButtonText: "Yes, cancel it!",
	                cancelButtonText: "No"
	            }).then((result) => {
	                if (result.isConfirmed) {
	                    // Show success alert first
	                    Swal.fire(
	                        "Deleted!",
	                        "Appointment has been canceled.",
	                        "success"
	                    ).then(() => {
	                        // Redirect after user clicks OK
	                        window.location.href = "AppointmentController?action=cancel&appointmentID=" + appointmentId;
	                    });
	                }
	            });
	        });
	    });
	});

	</script>

</body>
</html>
