<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Profile | JuzCare</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/viewTeamAccount.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/sideStaff.css">

<style>
body {
	background-color: #ffffff;
	margin: 0;
	padding: 0;
}

.wrapper {
	display: flex !important;
	flex-direction: row;
	min-height: 100vh;
	width: 100%;
}

.wrapper>nav, .wrapper>div:first-child:not(.content-wrapper), aside {
	width: auto !important;
	min-width: unset !important;
	max-width: unset !important;
	flex-shrink: 0 !important;
	background-color: #ffffff;
	border-right: none !important;
}

.content-wrapper {
	flex-grow: 1;
	padding: 40px; 
	padding-top: 60px;
	display: flex;
	justify-content: center; 
	align-items: flex-start; 
	background-color: #ffffff;
	min-width: 0;
	min-height: 100vh;
	box-sizing: border-box;
}

.profile-container {
	width: 100% !important;
	max-width: 1050px !important;
	background: #ffffff;
	padding: 35px;
	border-radius: 15px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.form-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 20px;
	margin-top: 25px;
}

.locked-field {
	background-color: #e9ecef !important;
	cursor: not-allowed;
}

.error-message {
	color: #dc3545;
	font-size: 0.85rem;
	margin-top: 5px;
	display: none;
	font-weight: 500;
}

.form-control.is-invalid {
	border-color: #dc3545 !important;
}

.form-control.is-valid {
	border-color: #198754 !important;
}

.avatar-preview-wrapper {
	position: relative;
	display: inline-block;
}

.upload-overlay-btn {
	position: absolute;
	bottom: 0;
	right: 10px;
	background: #008080;
	color: white;
	border: none;
	border-radius: 50%;
	width: 32px;
	height: 32px;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
}

.sidebar-container img, aside img, nav img {
	max-width: 100% !important;
	height: auto !important;
	display: block;
	margin: 0 auto;
}

.profile-container .form-control {
	padding: 12px 15px !important;
	height: auto !important;
	border-radius: 10px !important;
}
</style>
</head>
<body>
<div class="wrapper">
    <c:choose>
        <c:when test="${staff.role eq 'MANAGER'}"><jsp:include page="../sideManager.jsp" /></c:when>
        <c:when test="${staff.role eq 'PHARMACIST'}"><jsp:include page="../sidePharmacist.jsp" /></c:when>
        <c:otherwise><jsp:include page="../sideStaff.jsp" /></c:otherwise>
    </c:choose>

    <main class="content-wrapper">
        <div class="profile-container">
            <form id="updateProfileForm" action="StaffController?action=updateProfile" method="POST" enctype="multipart/form-data">
                
                <div class="profile-header">
                    <div class="user-info d-flex align-items-center">
                        <div class="avatar-preview-wrapper">
                            <img id="avatarDisplay" class="me-3"
                                 src="${not empty staff.profilePic ? pageContext.request.contextPath.concat('/account/AccountController?action=image&id=').concat(staff.staffID) : pageContext.request.contextPath.concat('/image/blank-profile-picture.png')}"
                                 width="90" height="90" style="border-radius: 50%; object-fit: cover;"
                                 onerror="this.src='${pageContext.request.contextPath}/image/blank-profile-picture.png';">
                            <label for="profilePicInput" class="upload-overlay-btn">
                                <i class="fas fa-camera"></i>
                            </label>
                            <input type="file" id="profilePicInput" name="profilePic" accept="image/*" style="display:none;">
                        </div>
                        <div class="name-meta ms-2">
                            <h1 id="headerNameText" class="h3 m-0 fw-bold text-dark">${staff.name}</h1>
                            <p id="headerEmailText" class="text-muted m-0">${staff.email}</p>
                        </div>
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label fw-semibold text-secondary">Full Name</label> 
                        <input type="text" name="name" id="name" value="${staff.name}" class="form-control" placeholder="e.g. Ahmad Albab" required>
                        <div id="nameError" class="error-message"><i class="fas fa-exclamation-circle"></i> Name field must use alphabets and spaces only.</div>
                    </div>
						<div class="form-group">
							<label class="form-label fw-semibold text-secondary">Phone
								Number</label> <input type="text" name="PhoneNo" id="phoneNo"
								value="${staff.phoneNo}" class="form-control" maxlength="11"
								placeholder="e.g. 0123456789" required>
							<div id="phoneError" class="error-message">
								<i class="fas fa-exclamation-circle"></i> Phone field must
								contain numbers only (10-11 digits).
							</div>
						</div>

						<div class="form-group">
                        <label class="form-label fw-semibold text-secondary">Email Address</label> 
                        <input type="email" name="email" id="email" value="${staff.email}" class="form-control" required>
                        <div id="emailError" class="error-message"><i class="fas fa-exclamation-circle"></i> Please enter a valid email address.</div>
                    </div>

						<div class="form-group">
							<label class="form-label fw-semibold text-secondary">IC
								Number</label> <input type="text" name="NRIC" id="NRIC"
								value="0${staff.NRIC}" class="form-control" maxlength="12"
								placeholder="YYMMDDXXXXXX" required>
							<div id="icError" class="error-message">
								<i class="fas fa-exclamation-circle"></i> IC field must be
								exactly 12 digits (numbers only).
							</div>
						</div>
						<div class="form-group">
                        <label class="form-label fw-semibold text-secondary">Date of Birth</label> 
                        <input type="date" name="DOB" id="DOB" value="${staff.DOB}" class="form-control locked-field" readonly required>
                    </div>
                    <div class="form-group">
                        <label class="form-label fw-semibold text-secondary">Age</label> 
                        <input type="text" id="ageDisplay" class="form-control locked-field" readonly>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-3 mt-4">
                    <a href="StaffController?action=view" class="btn btn-outline-secondary" style="border-radius: 10px; padding: 8px 30px;">Cancel</a>
                    <button type="submit" class="btn btn-primary" style="background-color: #008080; border: none; border-radius: 10px; padding: 8px 30px; font-weight: bold;">
                        Save Changes</button>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('updateProfileForm');
    const nameInput = document.getElementById('name');
    const phoneInput = document.getElementById('phoneNo');
    const emailInput = document.getElementById('email');
    const nricInput = document.getElementById('NRIC');
    const dobInput = document.getElementById('DOB');
    const ageInput = document.getElementById('ageDisplay');
    const fileInput = document.getElementById('profilePicInput');
    const avatarImg = document.getElementById('avatarDisplay');
    
    const headerNameText = document.getElementById('headerNameText');
    const headerEmailText = document.getElementById('headerEmailText');

    const nameError = document.getElementById('nameError');
    const phoneError = document.getElementById('phoneError');
    const icError = document.getElementById('icError');
    const emailError = document.getElementById('emailError');

    // --- 1. LIVE IMAGE PREVIEW ---
    if (fileInput) {
        fileInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    avatarImg.src = e.target.result;
                }
                reader.readAsDataURL(this.files[0]);
            }
        });
    }

    // --- 2. REAL-TIME TESTING (LIVE SYNC & VISUAL ERRORS) ---
    
    // Name: Alphabet + spaces only
    if (nameInput) {
        nameInput.addEventListener('input', function() {
            const value = this.value;
            if (headerNameText) headerNameText.textContent = value.trim() !== "" ? value : "---";

            if (!/^[A-Za-z\s]+$/.test(value) && value !== "") {
                nameError.style.display = 'block';
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else if (value.trim() === "") {
                nameError.style.display = 'block';
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else {
                nameError.style.display = 'none';
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            }
        });
    }

    if (phoneInput) {
        phoneInput.addEventListener('input', function() {
            const value = this.value;
            if (/\D/.test(value) && value !== "") {
                phoneError.style.display = 'block';
                phoneError.innerHTML = '<i class="fas fa-exclamation-circle"></i> Phone field must contain numbers only.';
                this.classList.add('is-invalid'); this.classList.remove('is-valid');
            } else if (value.length > 0 && value.length < 10) {
                phoneError.style.display = 'block';
                phoneError.innerHTML = '<i class="fas fa-exclamation-circle"></i> Phone number is too short (Minimum 10 digits).';
                this.classList.add('is-invalid'); this.classList.remove('is-valid');
            } else if (value.trim() === "") {
                phoneError.style.display = 'block';
                this.classList.add('is-invalid'); this.classList.remove('is-valid');
            } else {
                phoneError.style.display = 'none';
                this.classList.remove('is-invalid'); this.classList.add('is-valid');
            }
        });
    }

 	// Email: validation + sync
    if (emailInput) {
        emailInput.addEventListener('input', function() {
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
            if (headerEmailText) headerEmailText.textContent = this.value.trim() !== '' ? this.value : '---';
        });
    }

// --- 2. REAL-TIME TESTING (LIVE SYNC & VISUAL ERRORS) ---
    
    // Name: Alphabet + spaces only
    if (nameInput) {
        nameInput.addEventListener('input', function() {
            const value = this.value;
            if (headerNameText) headerNameText.textContent = value.trim() !== "" ? value : "---";

            if (!/^[A-Za-z\s]+$/.test(value) && value !== "") {
                nameError.style.display = 'block';
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else if (value.trim() === "") {
                nameError.style.display = 'block';
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else {
                nameError.style.display = 'none';
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            }
        });
    }

    // Phone: Numbers only + Had Limit 10-11 Digit
    if (phoneInput) {
        phoneInput.addEventListener('input', function() {
            const value = this.value;

            if (/\D/.test(value) && value !== "") {
                phoneError.style.display = 'block';
                phoneError.innerHTML = '<i class="fas fa-exclamation-circle"></i> Phone field must contain numbers only.';
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else if (value.length > 0 && value.length < 10) {
                phoneError.style.display = 'block';
                phoneError.innerHTML = '<i class="fas fa-exclamation-circle"></i> Phone number is too short (Minimum 10 digits).';
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else if (value.trim() === "") {
                phoneError.style.display = 'block';
                phoneError.innerHTML = '<i class="fas fa-exclamation-circle"></i> Phone field is required.';
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else {
                phoneError.style.display = 'none';
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            }
        });
    }

 	// Email: validation + sync
    if (emailInput) {
        emailInput.addEventListener('input', function() {
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
            if (headerEmailText) headerEmailText.textContent = this.value.trim() !== '' ? this.value : '---';
        });
    }

 // --- 3. IC ENGINE + DOB & AGE PROCESSING ---
    function parseICDetails() {
        if (!nricInput) return;
        let ic = nricInput.value;
        
        // 1. LIVE ALERT: Sekiranya ada huruf atau simbol ditaip, amaran terus keluar merah!
        if (/\D/.test(ic) && ic !== "") {
            icError.style.display = 'block';
            icError.innerHTML = '<i class="fas fa-exclamation-circle"></i> IC field must contain numbers only. No letters or symbols.';
            nricInput.classList.add('is-invalid');
            nricInput.classList.remove('is-valid');
            clearCalculatedFields();
            return; // Berhenti di sini, jangan proses bawah selagi ada simbol/huruf
        } 
        
        // 2. LIVE ALERT: Sekiranya data bersih (nombor sahaja) tapi belum cukup 12 digit
        else if (ic.length > 0 && ic.length < 12) {
            icError.style.display = 'block';
            icError.innerHTML = '<i class="fas fa-exclamation-circle"></i> IC must be exactly 12 digits (Current: ' + ic.length + ').';
            nricInput.classList.add('is-invalid');
            nricInput.classList.remove('is-valid');
            clearCalculatedFields();
            return;
        }

        // 3. PROSES DATA: Jika cukup 12 digit dan bersih dari huruf/simbol
        if (ic.length === 12) {
            let yearPart = ic.substring(0, 2);
            let monthPart = ic.substring(2, 4);
            let dayPart = ic.substring(4, 6);

            let currentYearShort = new Date().getFullYear() % 100; 
            let century = (parseInt(yearPart) <= currentYearShort) ? "20" : "19";
            let fullYear = century + yearPart;

            let formattedDateStr = fullYear + "-" + monthPart + "-" + dayPart;
            
            let birthDate = new Date(formattedDateStr);
            if (!isNaN(birthDate.getTime())) {
                if (dobInput) dobInput.value = formattedDateStr;

                const today = new Date();
                let age = today.getFullYear() - birthDate.getFullYear();
                const monthDiff = today.getMonth() - birthDate.getMonth();
                if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                if (ageInput) ageInput.value = age >= 0 ? age : 0;
                
                // Tutup alert dan tanda hijau (is-valid) sbb data dah sempurna
                icError.style.display = 'none';
                nricInput.classList.remove('is-invalid');
                nricInput.classList.add('is-valid');
            } else {
                clearCalculatedFields();
                icError.style.display = 'block';
                icError.innerHTML = '<i class="fas fa-exclamation-circle"></i> The birth date values encoded inside this IC are invalid.';
                nricInput.classList.add('is-invalid');
                nricInput.classList.remove('is-valid');
            }
        } else {
            clearCalculatedFields();
        }
    }

    function clearCalculatedFields() {
        if (dobInput) dobInput.value = "";
        if (ageInput) ageInput.value = "";
    }

    if (nricInput) {
        nricInput.addEventListener('input', parseICDetails);
        if (nricInput.value) { parseICDetails(); }
    }

    // --- 4. FORM SUBMISSION WORKHORSE ---
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault(); // Sekat penghantaran automatik serta-merta

            let formIsValid = true;

            const finalName = nameInput.value;
            const finalPhone = phoneInput.value;
            const finalIC = nricInput.value;

            if (!/^[A-Za-z\s]+$/.test(finalName) || finalName.trim() === "") {
                nameError.style.display = 'block';
                nameInput.classList.add('is-invalid');
                formIsValid = false;
            }

         // Ganti yang lama dengan ni:
            if (/\D/.test(finalPhone) || finalPhone.trim() === "" || finalPhone.length < 10) {
                phoneError.style.display = 'block';
                phoneError.innerHTML = '<i class="fas fa-exclamation-circle"></i> Phone number must be 10-11 digits and contain numbers only.';
                phoneInput.classList.add('is-invalid');
                formIsValid = false;
            }

            const emailPattern = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
            if (!emailPattern.test(emailInput.value) || emailInput.value.trim() === '') {
                emailError.style.display = 'block';
                emailInput.classList.add('is-invalid');
                formIsValid = false;
            } else {
                emailError.style.display = 'none';
                emailInput.classList.remove('is-invalid');
            }

            // Semakan Khas untuk IC Number (Mesti 12 digit DAN mesti nombor sahaja)
            if (finalIC.length !== 12 || /\D/.test(finalIC)) {
                icError.style.display = 'block';
                nricInput.classList.add('is-invalid');
                formIsValid = false;
                
                Swal.fire({
                    icon: 'error',
                    title: 'Invalid IC Number',
                    text: 'IC Number must be exactly 12 digits and contain numbers only.',
                    confirmButtonColor: '#008080'
                });
                return; // Berhenti terus jika ralat IC dikesan
            }

            if (!dobInput.value || !ageInput.value) {
                formIsValid = false;
            }

            // Tunjuk error popup am kalau ada input lain tidak sah
            if (!formIsValid) {
                Swal.fire({
                    icon: 'error',
                    title: 'Cannot Save Changes',
                    text: 'Please review the highlighted form elements and correct any typing errors before updating.',
                    confirmButtonColor: '#008080'
                });
                return;
            }

            // Tunjuk popup confirmation jika semua data sah
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
                    confirmButton: 'btn btn-primary px-4 mx-2',
                    cancelButton: 'btn btn-light text-secondary px-4 mx-2'
                },
                buttonsStyling: false
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit(); // Submit borang secara manual
                }
            });
        });
    }
 
    // --- STATUS FEEDBACK DARI CONTROLLER URL ---
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
});
</script>
</body>
</html>