<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="../header.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/viewaccount.css">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>



<style>

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


    /* Force sidebar to stay expanded */
    .sidebar-container,
    .side-nav,
    nav.sidebar {
        width: 280px !important;
        min-width: 280px !important;
 }
    
    /* Force sidebar text to show */
    .sidebar-container .nav-label,
    .sidebar-container span,
    .side-nav span {
        display: inline !important;
        opacity: 1 !important;
        visibility: visible !important;
}

.password-container {
	position: relative;
	display: flex;
	align-items: center;
}

.password-container input {
	padding-right: 40px;
}

.toggle-password {
	position: absolute;
	right: 15px;
	cursor: pointer;
	color: #666;
	z-index: 10;
}

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



<div
	class="main-content d-flex align-items-center justify-content-center"
	style="min-height: 85vh; padding: 40px 20px; width: 100%;">
	<main class="content-wrapper" style="width: 100%; max-width: 1000px;">
		<div class="profile-container">

			<div class="profile-header">
				<div class="user-info">

					<%-- Avatar --%>
					<div class="avatar-circle">
						<c:choose>
							<c:when test="${not empty customer.custProfilePic}">
								<img
									src="${pageContext.request.contextPath}/account/CustomerController?action=image&id=${customer.cusID}"
									alt="Profile Picture" width="80" height="80"
									style="border-radius: 50%; object-fit: cover;"
									onerror="this.src='${pageContext.request.contextPath}/image/blank-profile-picture.png';">
							</c:when>
							<c:otherwise>
								<img
									src="${pageContext.request.contextPath}/image/blank-profile-picture.png"
									alt="Profile Picture" width="80" height="80"
									style="border-radius: 50%; object-fit: cover;">
							</c:otherwise>
						</c:choose>
					</div>

					<div class="name-meta">
						<h1>${customer.custName}</h1>
						<p>${customer.custEmail}</p>
					</div>
				</div>

				<div class="action-buttons">
					<a href="CustomerController?action=edit" class="btn-edit-link">Edit</a>
					<button type="button" class="link-password-btn"
						onclick="toggleModal(true)">Change Password</button>
				</div>
			</div>

			<%-- Profile Fields (Dah dibetulkan mengikut bean Customer Java anda) --%>
			<div class="form-grid">
				<div class="form-group">
					<label>Full Name</label> <input type="text" readonly
						value="${customer.custName}" class="locked-field">
				</div>
				<div class="form-group">
					<label>Phone</label> <input type="text" readonly
						value="${customer.custPhoneNo}" class="locked-field">
				</div>
				<div class="form-group">
					<label>Email Address</label> <input type="email" readonly
						value="${customer.custEmail}" class="locked-field">
				</div>

				<%-- Age Calculation --%>
				<jsp:useBean id="now" class="java.util.Date" />
				<fmt:formatDate var="currentYear" value="${now}" pattern="yyyy" />
				<fmt:parseDate var="parsedBirthDate" value="${customer.DOB}"
					pattern="yyyy-MM-dd" />
				<fmt:formatDate var="birthYear" value="${parsedBirthDate}"
					pattern="yyyy" />
				<c:set var="calculatedAge" value="${currentYear - birthYear}" />

				<div class="form-group">
					<label>IC Number</label> <input type="text" readonly
						value="${customer.cusNRIC}" class="locked-field">
				</div>
				<div class="form-group">
					<label>Date of Birth</label> <input type="text"
						value="<fmt:formatDate value="${customer.DOB}" pattern="dd/MM/yyyy" />"
						readonly class="locked-field">
				</div>
				<div class="form-group">
					<label>Age</label> <input type="text"
						value="${not empty customer.DOB ? calculatedAge : 'N/A'}" readonly
						class="locked-field">
				</div>
				
			</div>

			<div class="d-flex justify-content-end mt-4">
				<a
					href="${pageContext.request.contextPath}/dashboard/dashboardCustomer.jsp"
					class="btn btn-outline-danger"
					style="border-radius: 10px; padding: 8px 30px; font-weight: bold; text-decoration: none;">
					Back </a>
			</div>

		</div>
	</main>
</div>

<%-- Change Password Modal --%>
<div id="passwordModal" class="custom-modal">
	<div class="modal-box">
		<h3 class="mb-4 text-center">Change Password</h3>
		<form id="changePasswordForm" action="CustomerController"
			method="POST">
			<input type="hidden" name="action" value="changePassword">

			<div class="mb-3">
				<label class="form-label fw-bold">Current Password</label>
				<div class="password-container">
					<input type="password" name="currentPassword" id="currPass"
						class="form-control" required> <i
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
					<input type="password" name="confirmPassword" id="confPass"
						class="form-control" required> <i
						class="fas fa-eye toggle-password"
						onclick="toggleVisibility('confPass', this)"></i>
				</div>
			</div>

			<div class="d-flex justify-content-end gap-2">
				<button type="button" class="btn btn-light"
					onclick="toggleModal(false)">Cancel</button>
				<button type="submit" class="btn"
					style="background-color: #008080; color: white; border: none;">Update</button>
			</div>
		</form>
	</div>
</div>


<script>
document.addEventListener('DOMContentLoaded', function () {

    // --- CHANGE PASSWORD VALIDATION ---
    const passwordForm = document.getElementById('changePasswordForm');
    if (passwordForm) {
        passwordForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const newPass = document.getElementById('newPassword').value;
            const confirmPass = document.getElementById('confPass').value;
            const passwordPattern = /^(?=.*[A-Z])(?=.*\d).{8,}$/;

            if (!passwordPattern.test(newPass)) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Password Too Weak',
                    html: `<div style="text-align:left; padding-left:20px;">
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

    // --- STATUS FEEDBACK AFTER REDIRECT ---
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');

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
    } else if (status === 'passwordUpdated') {
        Swal.fire({
            icon: 'success',
            title: 'Success!',
            text: 'Password has been updated.',
            confirmButtonColor: '#008080',
            customClass: { popup: 'my-rounded-popup' }
        });
    } else if (status === 'wrongpass') {
        Swal.fire({
            icon: 'error',
            title: 'Failed',
            text: 'Current password is incorrect.',
            confirmButtonColor: '#d33'
        });
    } else if (status === 'mismatch') {
        Swal.fire({
            icon: 'error',
            title: 'Failed',
            text: 'Passwords do not match.',
            confirmButtonColor: '#d33'
        });
    }

    if (status) {
        window.history.replaceState({}, document.title, window.location.pathname);
    }
});

// --- HELPER FUNCTIONS ---
function toggleModal(show) {
    const modal = document.getElementById('passwordModal');
    if (modal) modal.style.display = show ? 'flex' : 'none';
}

function toggleVisibility(inputId, iconElement) {
    const input = document.getElementById(inputId);
    if (input) {
        input.type = input.type === 'password' ? 'text' : 'password';
        iconElement.classList.toggle('fa-eye');
        iconElement.classList.toggle('fa-eye-slash');
    }
}

window.onclick = function (event) {
    const modal = document.getElementById('passwordModal');
    if (event.target === modal) toggleModal(false);
};
</script>


</body>
</html>
