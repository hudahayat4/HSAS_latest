<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Team Member | JuzCare</title>

<link
	href="https://cdn.jsdelivr.net/npm/@sweetalert2/theme-bootstrap-4/bootstrap-4.css"
	rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/viewTeamAccount.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/sideStaff.css">
<style>
/* Essential modal styles kept here to ensure it works */
.custom-modal {
	display: none;
	position: fixed;
	z-index: 9999;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
	align-items: center;
	justify-content: center;
}

.modal-box {
	background: white;
	padding: 30px;
	border-radius: 15px;
	width: 100%;
	max-width: 450px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

.password-container {
	position: relative;
	display: flex;
	align-items: center;
}

.password-container input {
	padding-right: 40px; /* Make space for the icon */
}

.toggle-password {
	position: absolute;
	right: 15px;
	cursor: pointer;
	color: #666;
	z-index: 10;
}
/* --- 2. SWEETALERT CUSTOM DESIGN (Confirm Update Box) --- */
.my-rounded-popup {
	border-radius: 20px !important;
	padding: 2rem !important;
}

.my-confirm-btn {
	background-color: #008080 !important;
	color: white !important;
	border: none !important;
	padding: 12px 30px !important;
	border-radius: 10px !important;
	margin-left: 10px !important;
	font-weight: 500 !important;
	cursor: pointer;
}

.my-cancel-btn {
	background-color: #f1f1f1 !important;
	color: #666 !important;
	border: none !important;
	padding: 12px 30px !important;
	border-radius: 10px !important;
	font-weight: 500 !important;
	cursor: pointer;
}
</style>
</head>
<body>
	<div class="wrapper">

		<c:if test="${staff.role eq 'MANAGER'}">
			<jsp:include page="../sideManager.jsp" />
		</c:if>

		<c:if test="${staff.role eq 'PHARMACIST'}">
			<jsp:include page="../sidePharmacist.jsp" />
		</c:if>

		<c:if test="${staff.role != 'MANAGER' && staff.role != 'PHARMACIST'}">
			<jsp:include page="../sideStaff.jsp" />
		</c:if>


		<main class="content-wrapper">
			<div class="profile-container">

				<div class="profile-header">
					<div class="user-info">
						<div class="avatar-circle">
							<img class="me-3"
								src="${(staff.profilePic == null || staff.profilePic == '') 
                ? pageContext.request.contextPath.concat('/image/blank-profile-picture.png') 
                : pageContext.request.contextPath.concat('/account/AccountController?action=image&id=').concat(staff.profilePic)}"
								width="80" height="80"
								style="border-radius: 50%; object-fit: cover;"
								onerror="this.src='${pageContext.request.contextPath}/image/blank-profile-picture.png';">
						</div>
						<div class="name-meta">
							<h1>${ staff.name }</h1>
							<p>${ staff.email }</p>
						</div>
					</div>

					<div class="action-buttons">
						<a href="StaffController?action=edit" class="btn-edit-link">Edit</a>
						<button type="button" class="link-password-btn"
							onclick="toggleModal(true)">Change Password</button>
					</div>
				</div>

				<div class="form-grid">
					<div class="form-group">
						<label>Full Name</label> <input type="text" id="name" readonly
							value="${ staff.name }" class="locked-field">
					</div>
					<div class="form-group">
						<label>Phone</label> <input type="text" id="phoneNo" readonly
							value="${ staff.phoneNo }" class="locked-field">
					</div>
					<div class="form-group">
						<label>Email Address</label> <input type="email" id="email"
							value="${ staff.email }" readonly class="locked-field">
					</div>
					<jsp:useBean id="now" class="java.util.Date" />
					<fmt:formatDate var="currentYear" value="${now}" pattern="yyyy" />
					<fmt:parseDate var="parsedBirthDate" value="${staff.DOB}"
						pattern="yyyy-MM-dd" />
					<fmt:formatDate var="birthYear" value="${parsedBirthDate}"
						pattern="yyyy" />
					<c:set var="calculatedAge" value="${currentYear - birthYear}" />
					<div class="form-group">
						<label>Age</label> <input type="text"
							value="${not empty staff.DOB ? calculatedAge : 'N/A'}" readonly
							class="locked-field">
					</div>
					<div class="form-group">
						<label>Date of Birth</label> <input type="text"
							value="<fmt:formatDate value="${staff.DOB}" pattern="dd/MM/yyyy" />"
							readonly class="locked-field">
					</div>
					<div class="form-group">
						<label>IC Number</label> <input type="text" id="NRIC" readonly
							value="${ staff.NRIC }" class="locked-field">
					</div>
				</div>

				<div class="d-flex justify-content-end mt-4">
					<a href="${pageContext.request.contextPath}/dashboard/dashboardStaff.jsp" class="btn btn-outline-danger"
						style="border-radius: 10px; padding: 8px 30px; font-weight: bold; text-decoration: none;">
						Back to List </a>
				</div>
			</div>
		</main>

		<div id="passwordModal" class="custom-modal">
			<div class="modal-box">
				<h3 class="mb-4 text-center">Change Password</h3>
				<form id="changePasswordForm"
					action="StaffController?action=changePassword" method="POST">

					<div class="mb-3">
						<label class="form-label fw-bold">Current Password</label>
						<div class="password-container">
							<input type="password" name="currentPassword"
								class="form-control" id="currPass" required> <i
								class="fas fa-eye toggle-password"
								onclick="toggleVisibility('currPass', this)"></i>
						</div>
					</div>

					<div class="mb-3">
						<label class="form-label fw-bold">New Password</label>
						<div class="password-container">
							<input type="password" name="newPassword" id="newPassword"
								class="form-control" required minlength="8"> <i
								class="fas fa-eye toggle-password"
								onclick="toggleVisibility('newPassword', this)"></i>
						</div>
						<small class="text-muted">Must be at least 8 characters,
							with 1 uppercase letter and 1 number.</small>
					</div>

					<div class="mb-4">
						<label class="form-label fw-bold">Confirm New Password</label>
						<div class="password-container">
							<input type="password" name="confirmPassword"
								class="form-control" id="confPass" required> <i
								class="fas fa-eye toggle-password"
								onclick="toggleVisibility('confPass', this)"></i>
						</div>
					</div>

					<div class="d-flex justify-content-end gap-2">
						<button type="button" class="btn btn-light"
							onclick="toggleModal(false)">Cancel</button>
						<button type="submit" class="btn btn-primary"
							style="background-color: #008080; border: none;">Update</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<script>
        // Use a single function for show and hide
        function toggleModal(show) {
            const modal = document.getElementById('passwordModal');
            if(modal) {
                modal.style.display = show ? 'flex' : 'none';
            }

document.addEventListener('DOMContentLoaded', function() {
    
    // --- 1. FETCH PROFILE DATA ---
    // Pastikan ini jalan dulu supaya input tak kosong
    fetch('StaffController?action=view&json=true')
    .then(res => res.json())
    .then(data => {
        if(data) {
            if(document.getElementById('name')) document.getElementById('name').value = data.name || "";
            if(document.getElementById('email')) document.getElementById('email').value = data.email || "";
            if(document.getElementById('DOB')) document.getElementById('DOB').value = data.DOB || "";
            if(document.getElementById('NRIC')) document.getElementById('NRIC').value = data.NRIC || "";
            if(document.getElementById('phoneNo')) document.getElementById('phoneNo').value = data.phoneNo || "";
            
            // Kemaskini teks di header (sebelah avatar)
            const headerName = document.querySelector('.name-meta h1');
            const headerEmail = document.querySelector('.name-meta p');
            if(headerName) headerName.innerText = data.name || "";
            if(headerEmail) headerEmail.innerText = data.email || ""
        }
    })
    .catch(err => console.error("Fetch error:", err));

    // --- 2. CHANGE PASSWORD LOGIC (Validation & Confirmation) ---
    const passwordForm = document.getElementById('changePasswordForm');
    if (passwordForm) {
        passwordForm.addEventListener('submit', function(e) {
            e.preventDefault();

            const newPass = document.getElementById('newPassword').value;
            const confirmPass = document.getElementById('confPass').value;

            // Regex for characteristics
            const passwordPattern = /^(?=.*[A-Z])(?=.*\d).{8,}$/;

            if (!passwordPattern.test(newPass)) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Password Too Weak',
                    html: `<div style="text-align: left; padding-left: 20px;">
                            Please meet these requirements:
                            <ul>
                                <li>Minimum 8 characters</li>
                                <li>At least one uppercase letter (A-Z)</li>
                                <li>At least one number (0-9)</li>
                            </ul>
                           </div>`,
                    confirmButtonColor: '#008080',
                    target: document.getElementById('passwordModal')
                });
                return; 
            }

            if (newPass !== confirmPass) {
                Swal.fire({
                    icon: 'error',
                    title: 'Mismatch',
                    text: 'Passwords do not match.',
                    confirmButtonColor: '#008080',
                    target: document.getElementById('passwordModal')
                });
                return;
            }

            // Clean look: Hide modal before confirmation
            toggleModal(false); 

            Swal.fire({
                title: 'Confirm Update?',
                text: 'Are you sure you want to change your password?',
                icon: 'question',
                iconColor: '#008080',
                showCancelButton: true,
                confirmButtonText: 'Yes, Update',
                cancelButtonText: 'Cancel',
                reverseButtons: true,
                customClass: {
                    popup: 'my-rounded-popup',
                    confirmButton: 'my-confirm-btn',
                    cancelButton: 'my-cancel-btn'
                },
                buttonsStyling: false
            }).then((result) => {
                if (result.isConfirmed) {
                    passwordForm.submit(); 
                } else {
                    toggleModal(true); 
                }
            });
        });
    }

    // --- 3. FEEDBACK STATUS AFTER REFRESH ---
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');
    if (status) {
        if (status === 'success') {
            Swal.fire({
                toast: true,
                position: 'top',
                icon: 'success',
                title: 'Profile updated successfully!',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true
            });
        } 
        else if (status === 'passwordUpdated') {
            Swal.fire({
                icon: 'success',
                title: 'Success!',
                text: 'Password has been updated.',
                confirmButtonColor: '#008080'
            });
        }
        window.history.replaceState({}, document.title, window.location.pathname);
    }
});

// --- HELPER FUNCTIONS (Outside DOMContentLoaded) ---
function toggleModal(show) {
    const modal = document.getElementById('passwordModal');
    if (modal) modal.style.display = show ? 'flex' : 'none';
}

function toggleVisibility(inputId, iconElement) {
    const input = document.getElementById(inputId);
    if (input) {
        input.type = input.type === "password" ? "text" : "password";
        iconElement.classList.toggle("fa-eye");
        iconElement.classList.toggle("fa-eye-slash");
    }
}

window.onclick = function(event) {
    const modal = document.getElementById('passwordModal');
    if (event.target === modal) toggleModal(false);
}
</script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>