<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Book Appointment</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
<link href="https://cdn.lineicons.com/5.0/lineicons.css"
	rel="stylesheet">

<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/viewapt.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">

<style type="text/css">
<%@include file="../css/bookAppointment.css"%>
</style>
</head>

<body>

	<%@ include file="../header.jsp"%>

	<div class="container text-center">

		<form method="post" action="AppointmentController">

			<!-- HIDDEN VALUES -->
			<input type="hidden" id="customerID" name="customerID"
				value="<%=session.getAttribute("cusID")%>"> <input
				type="hidden" id="packageId" name="packageId"> <input
				type="hidden" id="apptDate" name="apptDate"> <input
				type="hidden" id="apptTime" name="apptTime">

			<!-- STEPPER -->
			<div class="stepper-wrapper">
				<div class="stepper-line"></div>
				<div class="stepper">
					<div class="step active">
						<div class="step-circle">1</div>
						<div class="step-label">Package</div>
					</div>
					<div class="step">
						<div class="step-circle">2</div>
						<div class="step-label">Date</div>
					</div>
					<div class="step">
						<div class="step-circle">3</div>
						<div class="step-label">Confirm</div>
					</div>
				</div>
			</div>

			<!-- STEP 1 : PACKAGE -->
			<div class="section active">
				<div class="row justify-content-center mb-3">
					<c:forEach var="p" items="${packages}">
						<div class="col-md-3 package-card"
							onclick="selectPackage(this,'${p.packageID}','${p.packageName}')">
							<img
								src="${pageContext.request.contextPath}/appointment/AppointmentController?action=image&id=${p.packageID}"
								width="80" height="60">
							<div>${p.packageName}</div>
							<div class="package-price">RM ${p.packagePrice}</div>
							<div class="check-icon">
								<i class="bi bi-check-lg"></i>
							</div>
						</div>
					</c:forEach>
				</div>
			</div>

			<!-- STEP 2 : DATE -->
			<div class="section">
				<div class="row justify-content-center g-4 align-items-stretch">

					<!-- CALENDAR -->
					<div class="col-md-6 col-lg-5 d-flex">
						<div class="card h-100 w-100">
							<div class="calendar-toolbar">
								<button type="button" class="prev month-btn">
									<i class="bi bi-chevron-left"></i>
								</button>
								<div class="current-month"></div>
								<button type="button" class="next month-btn">
									<i class="bi bi-chevron-right"></i>
								</button>
							</div>
							<div class="calendar-body">
								<ul class="calendar-weekdays">
									<li>Sun</li>
									<li>Mon</li>
									<li>Tue</li>
									<li>Wed</li>
									<li>Thu</li>
									<li>Fri</li>
									<li>Sat</li>
								</ul>
								<ul class="calendar-dates"></ul>
							</div>
						</div>
					</div>

					<!-- TIME SLOTS -->
					<div class="col-md-6 col-lg-5 d-flex">
						<div class="card h-100 w-100 p-3">
							<h6 class="mb-3 text-center">Select Time</h6>
							<ul class="time-slots">
								<li>08:00</li>
								<li>08:15</li>
								<li>08:30</li>
								<li>08:45</li>
								<li>09:00</li>
								<li>09:15</li>
								<li>09:30</li>
								<li>09:45</li>
								<li>10:00</li>
								<li>10:15</li>
								<li>10:30</li>
								<li>10:45</li>
								<li>11:00</li>
								<li>11:15</li>
								<li>11:30</li>
								<li>11:45</li>
								<li>12:00</li>
								<li>12:15</li>
								<li>12:30</li>
								<li>12:45</li>
								<li>13:00</li>
								<li>13:15</li>
								<li>13:30</li>
								<li>13:45</li>
								<li>14:00</li>
								<li>14:15</li>
								<li>14:30</li>
								<li>14:45</li>
								<li>15:00</li>
								<li>15:15</li>
								<li>15:30</li>
								<li>15:45</li>
								<li>16:00</li>
								<li>16:15</li>
								<li>16:30</li>
								<li>16:45</li>
								<li>17:00</li>
								<li>17:15</li>
								<li>17:30</li>
								<li>17:45</li>
								<li>18:00</li>
								<li>18:15</li>
								<li>18:30</li>
								<li>18:45</li>
								<li>19:00</li>
								<li>19:15</li>
								<li>19:30</li>
								<li>19:45</li>
							</ul>
						</div>
					</div>

				</div>
			</div>

			<!-- STEP 3 : BUTTONS -->
			<div class="d-flex justify-content-center gap-3 mt-5 mb-5">
				<button type="button" class="btn btn-secondary previous"
					onclick="prevStep()">Back</button>
				<button type="button" class="btn nexts" style="background: #17a2b8; color: white;" onclick="nextStep()">Next</button>
			</div>

		</form>

		<!-- STEP 3 : CONFIRM -->
		<div class="section">
			<h5>Confirmation</h5>
			<div class="receipt-card">
				<div class="header-center">
					<img src="${pageContext.request.contextPath}/image/logo.png"
						alt="JuzCare" class="logo">
					<h3 class="thank-you-text">Thank you for your appointment in
						JuzCare Pharmacy</h3>
				</div>
				<div class="appointment-meta">
					<p class="section-title-small">DETAIL APPOINTMENT</p>
					<div class="date-time-row">
						<span id="confirmDate">📅 -</span> 
						<span id="confirmDate">🕒 -</span>
					</div>
					<hr>
				</div>

				<div class="patient-info">
					<p>
						<strong>Name :</strong> ${apt.customerName}
					</p>
					<p>
						<strong>Package :</strong><span id="confirmPackage">-</span>
					</p>
					<p>
						<strong>Pharmacist :</strong> ${apt.pharmacistName}
					</p>
					<p>
						<strong>Price :</strong> RM
						<fmt:formatNumber value="${apt.packagePrice}" type="number"
							minFractionDigits="2" maxFractionDigits="2" />
					</p>
				</div>

				<div class="terms">
					<p>
						<strong>Term &amp; Condition :</strong>
					</p>
					<ol>
						<li>Your appointment is confirmed once booking is made.</li>
						<li>Cancellations must be 24 hours before.</li>
					</ol>
				</div>
			</div>
		</div>

	</div>

	<%@ include file="../footer.jsp"%>
	<script src="../js/bookAppointment.js"></script>
	<script>
	const nextBtn = document.querySelector(".nexts");
	nextBtn.type = "button"; // never "submit" yet


	nextBtn.addEventListener("click", function(e) {
	    if (currentStep === 1) { // Step 1 = date/time step
	        e.preventDefault(); // stop any default submission

	        const pkg = document.getElementById("confirmPackage").innerText;
	        const date = document.getElementById("apptDate").value;
	        const time = document.getElementById("apptTime").value;

	        Swal.fire({
	            title: "Confirm Appointment?",
	            html: `<b>Package:</b> ${pkg}<br><b>Date:</b> ${date}<br><b>Time:</b> ${time}`,
	            icon: "question",
	            showCancelButton: true,
	            confirmButtonColor: "#17a2b8",
	            cancelButtonColor: "#d33",
	            confirmButtonText: "Yes, Book it!"
	        }).then((result) => {
	            if (result.isConfirmed) {
	                // Only submit **after user clicks Yes**
	                e.target.closest("form").submit();
	            }
	        });
	    } else {
	        // Step 0 → just go to next step
	        currentStep++;
	        updateUI();
	    }
	});


	</script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>