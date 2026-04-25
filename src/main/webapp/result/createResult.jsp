<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet" href="../css/sideStaff.css">
<title>Create Result</title>
<style>
@import
	url('https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800&display=swap')
	;
</style>
</head>
<body>
	<div class="wrapper">
		<%@ include file="../sidePharmacist.jsp"%>
		<h5 class="text-center fw-bold mb-4" style="color: #17a2b8;">Add
			Result</h5>
		<div class="container mt-5" style="max-width: 900px;">
			<div class="card mb-4">
				<div class="card-body">
					<div class="row mb-2">
						<div class="col-md-4 fw-bold">Appointment Date :</div>
						<div class="col-md-8 text-start">
							<fmt:formatDate value="${apt.apptDate}" pattern="dd/MM/yyyy" />
						</div>
					</div>
					<div class="row mb-2">
						<div class="col-md-4 fw-bold">Appointment Time :</div>
						<div class="col-md-8 text-start">
							<fmt:formatDate value="${apt.apptTime}" pattern="HH:mm" />
						</div>
					</div>
					<div class="row mb-2">
						<div class="col-md-4 fw-bold">Pharmacist Name :</div>
						<div class="col-md-8 text-start">${apt.pharmacistName}</div>
					</div>
				</div>
			</div>

			<form action="resultController" method="post">
				<div class="card">
					<input type="hidden" name="appointmentID"
						value="${apt.appointmentID}">
					<div class="card-body">
						<jsp:useBean id="now" class="java.util.Date" />
						<fmt:formatDate var="currentDateString" value="${now}"
							pattern="yyyy-MM-dd" />

						<div class="mb-3">
							<label class="form-label">Date : </label> <input type="date"
								name="date" class="form-control rounded-pill"
								value="${currentDateString}" readonly>
						</div>
						<c:choose>

							<c:when test="${apt.packageName == 'Uric Acid'}">
								<div class="mb-3">
									<label class="form-label">Risk Indicator</label> <select
										name="riskIndicator" class="form-select rounded-pill">
										<option value="" selected disabled>Select Risk Level</option>
										<option value="Low">Low</option>
										<option value="Medium">Medium</option>
										<option value="High">High</option>
									</select>
								</div>

								<div class="mb-3">
									<label class="form-label">Uric Level Range</label> <input
										type="text" name="uricLevelRange"
										class="form-control rounded-pill">
								</div>
							</c:when>

							<c:when test="${apt.packageName == 'Lipid'}">
								<div class="mb-3">
									<label class="form-label">HDL Cholesterol</label> <input
										type="number" name="hdl" class="form-control rounded-pill" step="any" min="0">
								</div>

								<div class="mb-3">
									<label class="form-label">Lipid Panel Details</label> <input
										type="text" name="details" class="form-control rounded-pill">
								</div>
								<div class="mb-3">
									<label class="form-label">LDL Cholesterol</label> <input
										type="number" name="ldl" class="form-control rounded-pill"  step="any" min="0">
								</div>
							</c:when>

							<c:when test="${apt.packageName == 'HBA1c'}">
								<div class="mb-3">
									<label class="form-label">Diabetes Risk Level</label> <input
										type="text" name="diabetes"
										class="form-control rounded-pill">
								</div>
								<div class="mb-3">
									<label class="form-label">HBA1c Threshold</label> <input
										type="number" name="threshold"
										class="form-control rounded-pill" step="any" min="0">
								</div>
							</c:when>

						</c:choose>
						<div class="mb-3">
							<label class="form-label">Comment :</label>
							<textarea name="comment" class="form-control rounded-pill"
								rows="3" cols="40" placeholder="ENTER"></textarea>
						</div>
					</div>
				</div>
				<div class="text-center mt-4">
					<a href="${pageContext.request.contextPath}/appointment/AppointmentController?action=listStaff" class="btn px-4 me-3"
						style="background-color: #17a2b8; color: white;">Back</a>
					<button type="submit" class="btn px-4"
						style="border: 1px solid #17a2b8; color: #17a2b8; background-color: transparent;">Submit</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>