<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Update Profile | JuzCare</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/updateprofile.css?v=2">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/sideStaff.css">
</head>
<body>
	<style>
.my-rounded-popup {
	border-radius: 20px !important;
	padding: 2rem !important;
	font-family: 'Poppins', sans-serif;
}

.my-confirm-btn {
	background-color: #008080 !important;
	color: white !important;
	border: none !important;
	padding: 10px 30px !important;
	border-radius: 8px !important;
	margin-left: 10px !important;
	font-weight: 500 !important;
	cursor: pointer;
}

.my-cancel-btn {
	background-color: #f1f1f1 !important;
	color: #666 !important;
	border: none !important;
	padding: 10px 30px !important;
	border-radius: 8px !important;
	font-weight: 500 !important;
	cursor: pointer;
}
</style>
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
							<i class="fas fa-user"></i>
						</div>
						<div class="name-meta">
							<h1>${staff.name}</h1>
							<p>${staff.email}</p>
						</div>
					</div>
				</div>

				<form action="StaffController?action=updateProfile" method="POST">
					<div class="form-grid">
						<div class="form-group">
							<label>Full Name</label> <input type="text" value="${staff.name}"
								readonly class="locked-field">
						</div>

						<div class="form-group">
							<label>Phone</label> <input type="text" name="PhoneNo"
								value="${staff.phoneNo}" class="editable-field" required>
						</div>

						<div class="form-group">
							<label>Email Address</label> <input type="email" name="email"
								value="${staff.email}" class="editable-field" required>
						</div>

						<div class="form-group">
							<label>Age</label> <input type="text" value="28" readonly
								class="locked-field">
						</div>

						<div class="form-group">
							<label>Date of Birth</label> <input type="text"
								value="${staff.DOB}" readonly class="locked-field">
						</div>

						<div class="form-group">
							<label>IC Number</label> <input type="text" value="${staff.NRIC}"
								readonly class="locked-field">
						</div>
					</div>

					<div class="btn-save-container">
						<a href="StaffController?action=view" class="btn-cancel-link">Cancel</a>
						<button type="submit" class="btn-save-main">Save Changes</button>
					</div>
				</form>
			</div>
		</main>

	</div>
	<script>
// Cari form berdasarkan tag form atau ID (Contoh: id="staffUpdateForm")
const staffForm = document.querySelector('form'); 

if(staffForm) {
    staffForm.onsubmit = function(e) {
        e.preventDefault(); // Stop form daripada terus submit
        
        Swal.fire({
            title: 'Confirm Changes?',
            text: 'Are you sure you want to update the staff details?',
            icon: 'question',
            iconColor: '#008080',
            showCancelButton: true,
            confirmButtonText: 'Yes, Update',
            cancelButtonText: 'Cancel',
            reverseButtons: true,
            
            // Menggunakan class CSS yang sama supaya seragam
            customClass: {
                popup: 'my-rounded-popup',
                confirmButton: 'my-confirm-btn',
                cancelButton: 'my-cancel-btn'
            },
            buttonsStyling: false 
        }).then((result) => {
            if (result.isConfirmed) {
                // Jika user tekan 'Yes', barulah submit form secara manual
                this.submit();
            }
        });
    };
}
</script>
</body>
</html>