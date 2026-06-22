<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile | JuzCare</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/updateprofile.css?v=1.2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">

    <style>
        .error-message {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 5px;
            display: none;
            font-weight: 500;
        }
        .form-control.is-invalid { border-color: #dc3545 !important; }
        .form-control.is-valid { border-color: #198754 !important; }

        .avatar-preview-wrapper { position: relative; display: inline-block; }
        .upload-overlay-btn {
            position: absolute; bottom: 0; right: 0;
            background: #008080; color: white; border: none;
            border-radius: 50%; width: 28px; height: 28px;
            display: flex; align-items: center; justify-content: center; cursor: pointer;
        }

        .locked-field {
            background-color: #e9ecef !important;
            cursor: not-allowed;
        }
    </style>
</head>
<body>

<%@ include file="../header.jsp" %>

<main class="content-wrapper">
    <div class="profile-container">

        <form id="updateProfileForm" action="${pageContext.request.contextPath}/account/CustomerController" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="updateAccount">

            <%-- Profile Header --%>
            <div class="profile-header">
                <div class="user-info">
                    <div class="avatar-preview-wrapper">
                        <img id="avatarDisplay" class="me-3"
                             src="${(customer.custProfilePic == null || customer.custProfilePic == '')
    							? pageContext.request.contextPath.concat('/image/blank-profile-picture.png')
    							: pageContext.request.contextPath.concat('/account/CustomerController?action=image&id=').concat(String.valueOf(customer.cusID))}"
                             width="80" height="80"
                             style="border-radius: 50%; object-fit: cover;"
                             onerror="this.src='${pageContext.request.contextPath}/image/blank-profile-picture.png';">
                        <label for="profilePicInput" class="upload-overlay-btn" title="Change Photo">
                            <i class="fas fa-camera" style="font-size: 13px;"></i>
                        </label>
                        <input type="file" id="profilePicInput" name="profilePic" accept="image/*" style="display:none;">
                    </div>
                    <div class="name-meta ms-2">
                        <h1 id="headerNameText">${customer.custName}</h1>
                        <p id="headerEmailText">${customer.custEmail}</p>
                    </div>
                </div>
            </div>

            <%-- Form Fields --%>
            <div class="form-grid">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="custName" id="custName"
                           value="${customer.custName}"
                           class="form-control editable-field" required>
                    <div id="nameError" class="error-message">
                        <i class="fas fa-exclamation-circle"></i> Name must contain alphabets only, no numbers or symbols.
                    </div>
                </div>

					<div class="form-group">
						<label>Phone</label> <input type="text" id="custPhoneNo"
							name="custPhoneNo" maxlength="11" value="${customer.custPhoneNo}"
							class="form-control">
						<div id="phoneError" class="error-message">
							<i class="fas fa-exclamation-circle"></i> Phone must contain
							numbers only, 10-11 digits.
						</div>
					</div>
					<div class="form-group">
						<label>Email Address</label> <input type="email" name="custEmail"
							id="custEmail" value="${customer.custEmail}"
							class="form-control editable-field" required>
						<div id="emailError" class="error-message">
							<i class="fas fa-exclamation-circle"></i> Please enter a valid
							email address.
						</div>
					</div>

					<div class="form-group">
						<label>IC Number</label> <input type="text" name="cusNRIC"
							id="cusNRIC" value="${customer.cusNRIC}"
							class="form-control editable-field" maxlength="12"
							placeholder="YYMMDDXXXXXX" required>
						<div id="icError" class="error-message">
							<i class="fas fa-exclamation-circle"></i> IC must be exactly 12
							digits (numbers only).
						</div>
					</div>

					<div class="form-group">
                    <label>Date of Birth</label>
                    <input type="text" id="dobDisplay" name="DOB"
                           class="form-control locked-field" readonly>
                </div>

                <div class="form-group">
                    <label>Age</label>
                    <input type="text" id="ageDisplay"
                           class="form-control locked-field" readonly>
                </div>

            </div>

            <div class="btn-save-container">
                <a href="${pageContext.request.contextPath}/account/CustomerController?action=view" class="btn-cancel-link">Cancel</a>
                <button type="submit" class="btn-save-main">Save Changes</button>
            </div>

        </form>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {

    const form          = document.getElementById('updateProfileForm');
    const nameInput     = document.getElementById('custName');
    const phoneInput    = document.getElementById('custPhoneNo');
    const emailInput    = document.getElementById('custEmail');
    const nricInput     = document.getElementById('cusNRIC');
    const dobInput      = document.getElementById('dobDisplay');
    const ageInput      = document.getElementById('ageDisplay');
    const fileInput     = document.getElementById('profilePicInput');
    const avatarImg     = document.getElementById('avatarDisplay');
    const headerName    = document.getElementById('headerNameText');
    const headerEmail   = document.getElementById('headerEmailText');
    const nameError     = document.getElementById('nameError');
    const phoneError    = document.getElementById('phoneError');
    const icError       = document.getElementById('icError');
    const emailError    = document.getElementById('emailError');  

    // --- Pre-fill DOB and Age from existing IC on page load ---
    if (nricInput.value.length === 12) { parseICDetails(); }

    // --- 1. Live image preview ---
    fileInput.addEventListener('change', function () {
        if (this.files && this.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) { avatarImg.src = e.target.result; };
            reader.readAsDataURL(this.files[0]);
        }
    });

    // --- 2. Name validation (alphabets + spaces only) ---
    nameInput.addEventListener('input', function () {
        const val = this.value;
        headerName.textContent = val.trim() !== '' ? val : '---';
        if (!/^[A-Za-z\s]+$/.test(val) || val.trim() === '') {
            nameError.style.display = 'block';
            this.classList.add('is-invalid'); this.classList.remove('is-valid');
        } else {
            nameError.style.display = 'none';
            this.classList.remove('is-invalid'); this.classList.add('is-valid');
        }
    });

    phoneInput.addEventListener('input', function () {
        if (/\D/.test(phoneInput.value) || phoneInput.value.trim() === '' || phoneInput.value.length < 10) {
            phoneError.style.display = 'block';
            phoneInput.classList.add('is-invalid');
        } else {
            phoneError.style.display = 'none';
            phoneInput.classList.remove('is-invalid');
        }
    });

 // --- 4. Email validation (live) ---
    emailInput.addEventListener('input', function () {
        const emailPattern = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
        if (!emailPattern.test(this.value) || this.value.trim() === '') {
            emailError.style.display = 'block';
            this.classList.add('is-invalid');
            this.classList.remove('is-valid');
        } else {
            emailError.style.display = 'none';
            this.classList.remove('is-invalid');
            this.classList.add('is-valid');
        }
        // Sync header email text
        headerEmail.textContent = this.value.trim() !== '' ? this.value : '---';
    });

    // --- 5. IC → auto-fill DOB and Age ---
    function parseICDetails() {
        const ic = nricInput.value;

        if (/\D/.test(ic) && ic !== '') {
            icError.style.display = 'block';
            icError.innerHTML = '<i class="fas fa-exclamation-circle"></i> IC must contain numbers only.';
            nricInput.classList.add('is-invalid'); nricInput.classList.remove('is-valid');
            dobInput.value = ''; ageInput.value = ''; return;
        }

        if (ic.length > 0 && ic.length < 12) {
            icError.style.display = 'block';
            icError.innerHTML = '<i class="fas fa-exclamation-circle"></i> IC must be exactly 12 digits (Current: ' + ic.length + ').';
            nricInput.classList.add('is-invalid'); nricInput.classList.remove('is-valid');
            dobInput.value = ''; ageInput.value = ''; return;
        }

        if (ic.length === 12) {
            const yearPart  = ic.substring(0, 2);
            const monthPart = ic.substring(2, 4);
            const dayPart   = ic.substring(4, 6);
            const currentYearShort = new Date().getFullYear() % 100;
            const century   = parseInt(yearPart) <= currentYearShort ? '20' : '19';
            const fullYear  = century + yearPart;
            const birthDate = new Date(fullYear + '-' + monthPart + '-' + dayPart);

            if (!isNaN(birthDate.getTime())) {
                // Format DD/MM/YYYY for display
                dobInput.value = dayPart + '/' + monthPart + '/' + fullYear;

                const today = new Date();
                let age = today.getFullYear() - birthDate.getFullYear();
                const m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) age--;
                ageInput.value = age >= 0 ? age : 0;

                icError.style.display = 'none';
                nricInput.classList.remove('is-invalid'); nricInput.classList.add('is-valid');
            } else {
                dobInput.value = ''; ageInput.value = '';
                icError.style.display = 'block';
                icError.innerHTML = '<i class="fas fa-exclamation-circle"></i> The birth date in this IC is invalid.';
                nricInput.classList.add('is-invalid'); nricInput.classList.remove('is-valid');
            }
        } else {
            dobInput.value = ''; ageInput.value = '';
        }
    }

    nricInput.addEventListener('input', parseICDetails);

    // --- 6. Form submission validation ---
    form.addEventListener('submit', function (e) {
        let valid = true;

        if (!/^[A-Za-z\s]+$/.test(nameInput.value) || nameInput.value.trim() === '') {
            nameError.style.display = 'block';
            nameInput.classList.add('is-invalid');
            valid = false;
        }
        if (/\D/.test(phoneInput.value) || phoneInput.value.trim() === '' || phoneInput.value.length < 10) {
            phoneError.style.display = 'block';
            phoneInput.classList.add('is-invalid');
            valid = false;
        }
        
        const emailPattern = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
        if (!emailPattern.test(emailInput.value) || emailInput.value.trim() === '') {
            emailError.style.display = 'block';
            emailInput.classList.add('is-invalid');
            valid = false;
        } else {
            emailError.style.display = 'none';
            emailInput.classList.remove('is-invalid');
        }
        if (nricInput.value.length !== 12 || /\D/.test(nricInput.value)) {
            icError.style.display = 'block';
            nricInput.classList.add('is-invalid');
            valid = false;
        }

        if (!valid) {
            e.preventDefault();
            Swal.fire({
                icon: 'error',
                title: 'Cannot Save Changes',
                text: 'Please correct the highlighted fields before saving.',
                confirmButtonColor: '#008080'
            });
            return;
        }

        e.preventDefault();
        Swal.fire({
            title: 'Confirm Save',
            text: 'Ensure your details are correct before proceeding.',
            icon: 'question',
            iconColor: '#008080',
            showCancelButton: true,
            confirmButtonText: 'Save',
            cancelButtonText: 'Cancel',
            reverseButtons: true,
            customClass: {
                popup: 'my-rounded-popup',
                confirmButton: 'my-confirm-btn',
                cancelButton: 'my-cancel-btn'
            },
            buttonsStyling: false
        }).then((result) => {
            if (result.isConfirmed) { form.submit(); }
        });
    });
    
});

// --- STATUS FEEDBACK ---
const urlParams = new URLSearchParams(window.location.search);
const status = urlParams.get('status');

if (status === 'invalidemail') {
    Swal.fire({
        icon: 'error',
        title: 'Invalid Email',
        text: 'Please enter a valid email address.',
        confirmButtonColor: '#008080'
    });
} else if (status === 'invalidname') {
    Swal.fire({
        icon: 'error',
        title: 'Invalid Name',
        text: 'Name must contain alphabets only.',
        confirmButtonColor: '#008080'
    });
}

if (status) {
    window.history.replaceState({}, document.title, window.location.pathname);
}

</script>


<%@ include file="../footer.jsp" %>
</body>
</html>
