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

			<form action="resultController" method="post" id="resultForm">
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
						<c:forEach var="field" items="${fields}">

							<div class="mb-3">

								<label class="form-label">${field.fieldLabel} </label>

								<c:choose>

									<c:when test="${field.fieldType == 'VARCHAR2'}">
										<input type="text" name="${field.fieldName}"
											class="form-control rounded-pill" onkeyup="checkText(this)" required>
										<small class="text-danger d-none error-msg"> Text only. Numbers and
											symbols are not allowed. </small>
									</c:when>

									<c:when test="${field.fieldType == 'CHAR'}">
										<input type="text" name="${field.fieldName}"
											class="form-control rounded-pill" required>
									</c:when>

									<c:when
										test="${field.fieldType == 'DOUBLE' || field.fieldType == 'DECIMAL'}">
										<input type="number" step="any" name="${field.fieldName}"
											class="form-control rounded-pill" required>
										<small class="text-danger d-none error-msg"> Please enter number
											(decimal allowed). </small>
									</c:when>

									<c:when test="${field.fieldType == 'NUMBER'}">
										<input type="number" name="${field.fieldName}"
											class="form-control rounded-pill"
											onkeyup="checkNumber(this)" required>
										<small class="text-danger d-none error-msg"> Whole number only. </small>
									</c:when>

									<c:otherwise>
										<input type="text" name="${field.fieldName}"
											class="form-control rounded-pill" required>
									</c:otherwise>

								</c:choose>

							</div>

						</c:forEach>
						<div class="mb-3">
							<label class="form-label">Comment :</label>
							<textarea name="comment" class="form-control rounded-pill"
								rows="3" cols="40" placeholder="ENTER" required></textarea>
						</div>
					</div>
				</div>
				<div class="text-center mt-4">
					<a
						href="${pageContext.request.contextPath}/appointment/AppointmentController?action=listStaff"
						class="btn px-4 me-3"
						style="background-color: #17a2b8; color: white;">Back</a>
					<button type="submit" class="btn px-4"
						style="border: 1px solid #17a2b8; color: #17a2b8; background-color: transparent;">Submit</button>
				</div>
			</form>
		</div>
	</div>
</body>
<script>

function checkText(input){

    let error = 
        input.parentElement.querySelector(".error-msg");


    if(/[^a-zA-Z\s]/.test(input.value)){

        error.style.display = "block";

        input.classList.add("is-invalid");

    } else {

        error.style.display = "none";

        input.classList.remove("is-invalid");
    }

}



function checkNumber(input){

    let error = 
        input.parentElement.querySelector(".error-msg");


    if(/\D/.test(input.value)){

        error.style.display = "block";

        input.classList.add("is-invalid");

    } else {

        error.style.display = "none";

        input.classList.remove("is-invalid");
    }

}

document.addEventListener("DOMContentLoaded", function () {

    const form = document.getElementById("resultForm");

    form.addEventListener("submit", function (event) {

        let inputs = form.querySelectorAll("input[required], select[required], textarea[required]");
        let isValid = true;

        inputs.forEach(input => {
            if (!input.value.trim()) {
                isValid = false;
                input.style.border = "1px solid red"; // highlight empty field
            } else {
                input.style.border = "";
            }
        });

        if (!isValid) {
            event.preventDefault();

            Swal.fire({
                icon: 'warning',
                title: 'Missing Information',
                text: 'Please fill in the required field',
                confirmButtonColor: '#009FA5'
            });
        }
    });

});
</script>
</html>