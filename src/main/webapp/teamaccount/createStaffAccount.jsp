<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Team Account</title>

<link rel="stylesheet" href="../css/sideStaff.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<style type="text/css">
body {
	background-color: #E8F3F3;
}

.password-toggle {
	cursor: pointer;
}

.main {
	padding-left: 2rem;
	padding-top: 1rem;
}
</style>
</head>
<body>
	<div class="wrapper">

		<%@ include file="../sideManager.jsp"%>

		<div class="main">
			<h2>Team Member's Personal</h2>
			<h2>Information</h2>
			<form action="StaffController" method="post" id="createStaff"
				enctype="multipart/form-data">
				<div id="alertBox"
					class="alert d-none"
					style="max-width: 400px;" role="alert"></div>
				<input type="hidden" class="form-control" id="staffID"
					name="staffID" value="<%=session.getAttribute("staffID")%>"
					readonly>
				<%
				String status = request.getParameter("status");
				%>

				<%
				if ("emailExists".equals(status)) {
				%>
				<div class="alert alert-danger">Email already exists!</div>
				<%
				}
				%>

				<%
				if ("phoneExists".equals(status)) {
				%>
				<div class="alert alert-danger">Phone number already exists!</div>
				<%
				}
				%>

				<div class="col-md-6">
					<label for="exampleFormControlInput1" class="form-label">Full
						name</label> <input type="text" class="form-control" id="name" name="name"> 
						<small id="nameError" class="text-danger"></small>
				</div>
				<div class="col-md-6">
					<label for="exampleFormControlInput1" class="form-label">Phone</label>
					<input type="text" class="form-control" id="PhoneNo" name="PhoneNo"
						inputmode="numeric" max="11"> <small id="phoneError"
						class="text-danger"></small>
				</div>
				<div class="col-md-6">
					<label for="exampleFormControlInput1" class="form-label">Email
						address</label> <input type="email" class="form-control" id="email"
						name="email"> <small id="emailError" class="text-danger"></small>
				</div>
				<div class="col-md-6">
					<label for="exampleFormControlInput1" class="form-label">Date
						of birth</label> <input type="date" class="form-control" id="DOB"
						name="DOB">
				</div>
				<div class="col-md-6">
					<label for="exampleFormControlInput1" class="form-label">IC
						number</label> <input type="text" class="form-control" id="NRIC"
						name="NRIC">
				</div>
				<br>
				<div class="row">
					<div class="col-md-3">
						<select class="form-select" name="role">
							<option selected disabled>Position</option>
							<option value="STAFF">Staff</option>
							<option value="PHARMACIST">Pharmacist</option>
						</select>
					</div>

					<div class="col-md-3">
						<input class="form-control" type="file" name="profilePic">
					</div>
				</div>
				<div class="mt-4 d-flex justify-content-end gap-2">
					<button type="button" class="btn btn-primary"
						data-bs-target="#exampleModalToggle" data-bs-toggle="modal">Save</button>
					<button type="button" class="btn btn-secondary">Cancel</button>
				</div>

				<div class="modal fade" id="exampleModalToggle" aria-hidden="true"
					aria-labelledby="exampleModalToggleLabel" tabindex="-1">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLabel">Create
									Account</h5>
							</div>
							<div class="modal-body">
								<div class="form-group">
									<label for="recipient-name" class="col-form-label">Username:</label>
									<input type="text" class="form-control" id="username"
										name="username">
								</div>
								<div class="form-group">
									<label for="message-text" class="col-form-label">Password:</label>
									<div class="input-group">
										<input type="password" class="form-control" id="password"
											name="password" readonly> <span
											class="input-group-text password-toggle"
											id="toggleStaffPassword"> <i
											class="bi bi-eye-slash-fill"></i>
										</span>
									</div>
								</div>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary"
									data-bs-dismiss="modal">Cancel</button>
								<button type="submit" class="btn btn-primary" data-bs-dismiss="modal">Save</button>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
	    
	    document.addEventListener("DOMContentLoaded", function () {

	        // ================= ELEMENTS =================
	        const nameInput = document.getElementById("name");
	        const phoneInput = document.getElementById("PhoneNo");
	        const emailInput = document.getElementById("email");

	        const nameError = document.getElementById("nameError");
	        const phoneError = document.getElementById("phoneError");
	        const emailError = document.getElementById("emailError");


	        // ================= FULL NAME =================
	        nameInput.addEventListener("input", function () {
	            let value = this.value;

	            this.value = value.replace(/[^A-Za-z\s]/g, '');

	            if (/[^A-Za-z\s]/.test(value)) {
	                nameError.textContent = "Name must contain letters only (no numbers).";
	            } else {
	                nameError.textContent = "";
	            }
	        });


	        // ================= PHONE =================
	        phoneInput.addEventListener("input", function () {
			    let rawValue = this.value;
			
			    if (/[^0-9]/.test(rawValue)) {
			        phoneError.textContent = "Phone number must contain numbers only";
			    } else {
			        phoneError.textContent = "";
			    }
			
			    this.value = rawValue.replace(/\D/g, '');

			    this.value = rawValue.replace(/\D/g, '').slice(0, 11);
			});


	        phoneInput.addEventListener("blur", function () {
	            const phone = this.value;

	            if (phone.length === 0) return;

	            fetch("StaffController?action=checkPhone&phone=" + phone)
	                .then(res => res.text())
	                .then(data => {
	                    if (data === "exists") {
	                        phoneError.textContent = "Phone number already exists in system.";
	                    } else {
	                        phoneError.textContent = "";
	                    }
	                });
	        });


	        // ================= EMAIL =================
	        emailInput.addEventListener("blur", function () {
	            const email = this.value;

	            if (email.length === 0) return;

	            fetch("StaffController?action=checkEmail&email=" + encodeURIComponent(email))
	                .then(res => res.text())
	                .then(data => {
	                    if (data === "exists") {
	                        emailError.textContent = "Email already exists in system.";
	                    } else {
	                        emailError.textContent = "";
	                    }
	                });
	        });

	        nameInput.addEventListener("blur", function () {
	            const name = this.value;

	            if (name.length === 0) return;

	            fetch("StaffController?action=checkName&name=" + encodeURIComponent(name))
	                .then(res => res.text())
	                .then(data => {
	                    if (data === "exists") {
	                        nameError.textContent = "Name already exists in system.";
	                    } else {
	                        nameError.textContent = "";
	                    }
	                });
	        });

	        // ================= PASSWORD TOGGLE =================
	        function setupToggle(inputId, toggleId) {
	            const input = document.getElementById(inputId);
	            const toggle = document.getElementById(toggleId);

	            toggle.addEventListener('click', () => {
	                const icon = toggle.querySelector('i');

	                if (input.type === 'password') {
	                    input.type = 'text';
	                    icon.classList.replace('bi-eye-slash-fill', 'bi-eye-fill');
	                } else {
	                    input.type = 'password';
	                    icon.classList.replace('bi-eye-fill', 'bi-eye-slash-fill');
	                }
	            });
	        }

	        setupToggle('password', 'toggleStaffPassword');


	        // ================= AUTO PASSWORD =================
	        var modal = document.getElementById('exampleModalToggle');

	        modal.addEventListener('show.bs.modal', function () {
	            var nric = document.getElementById('NRIC').value;
	            document.getElementById('password').value =
	                nric.length >= 8 ? nric.slice(-8) : nric;
	        });

	    });
	    
	    const dobInput = document.getElementById("DOB");
	    const icInput = document.getElementById("NRIC");

	    dobInput.addEventListener("change", function () {
	        let dob = new Date(this.value);

	        if (!isNaN(dob)) {
	            let year = String(dob.getFullYear()).slice(-2);
	            let month = String(dob.getMonth() + 1).padStart(2, '0');
	            let day = String(dob.getDate()).padStart(2, '0');

	            let yymmdd = year + month + day;

	            icInput.value = yymmdd; // auto fill first 6 digits
	        } else {
	            icInput.value = "";
	        }
	    });
	    
	    function showAlert(message, type) {
	        const alertBox = document.getElementById("alertBox");

	        alertBox.className = "alert"; // reset classes
	        alertBox.classList.add("alert-" + type); // success, danger, warning, info
	        alertBox.textContent = message;
	        alertBox.classList.remove("d-none");

	        // auto hide after 3 seconds
	        setTimeout(() => {
	            alertBox.classList.add("d-none");
	        }, 3000);
	    }
	    
	    document.getElementById("createStaff").addEventListener("submit", function (e) {

	        const name = document.getElementById("name").value.trim();
	        const email = document.getElementById("email").value.trim();
	        const phone = document.getElementById("PhoneNo").value.trim();

	        const nameError = document.getElementById("nameError").textContent.trim();
	        const emailError = document.getElementById("emailError").textContent.trim();
	        const phoneError = document.getElementById("phoneError").textContent.trim();

	        // Required fields
	        if (name === "" || email === "" || phone === "") {
	            e.preventDefault();
	            showAlert("Please fill in the required field!", "danger");
	            return;
	        }

	        // Validation errors exist
	        if (nameError !== "" || emailError !== "" || phoneError !== "") {
	            e.preventDefault();
	            return;
	        }

	        // No errors -> form submits normally
	    });
	    </script>

</html>