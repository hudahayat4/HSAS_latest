document.addEventListener('DOMContentLoaded', function() {
    // 1. SELECT ELEMENTS
    const form = document.getElementById('registrationForm');
    const nameInput = document.getElementById('custName');
    const icInput = document.getElementById('cusNRIC');
    const phoneInput = document.getElementById('custPhoneNo');
    const emailInput = document.getElementById('custEmail');
    const usernameInput = document.getElementById('custUsername');
    const passwordInput = document.getElementById('custPassword');
    const togglePassword = document.getElementById('togglePassword');
    const eyeIcon = document.getElementById('eyeIcon');
    const fileInput = document.getElementById('custProfilePic');
    const agreeCheckbox = document.getElementById('iAgree');

    // Error placeholders
    const icErrorDiv = document.getElementById('icError');
    const emailErrorDiv = document.getElementById('emailError');
    const usernameErrorDiv = document.getElementById('usernameError');

    // 2. REAL-TIME INPUT RESTRICTIONS
    nameInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^a-zA-Z\s]/g, '');
    });

    icInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    phoneInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9+]/g, '');
    });

    // 3. PASSWORD VISIBILITY TOGGLE
    if (togglePassword) {
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            eyeIcon.classList.toggle('bi-eye-fill');
            eyeIcon.classList.toggle('bi-eye-slash-fill');
        });
    }

    // 4. CLEAR ERROR ON FOCUS/INPUT
    icInput.addEventListener("focus", () => icErrorDiv.textContent = "");
    icInput.addEventListener("input", () => icErrorDiv.textContent = "");

    emailInput.addEventListener("focus", () => emailErrorDiv.textContent = "");
    emailInput.addEventListener("input", () => emailErrorDiv.textContent = "");

    usernameInput.addEventListener("focus", () => usernameErrorDiv.textContent = "");
    usernameInput.addEventListener("input", () => usernameErrorDiv.textContent = "");

    // 5. FORM SUBMISSION VALIDATION
    form.addEventListener('submit', function(event) {
        let isValid = true;

        // Reset inline error messages
        icErrorDiv.textContent = "";
        emailErrorDiv.textContent = "";
        usernameErrorDiv.textContent = "";

        // Validate IC (Must be exactly 12 digits)
        const icValue = icInput.value.trim();
        if (icValue.length !== 12) {
            icErrorDiv.textContent = "IC Number must consist of exactly 12 digits.";
            isValid = false;
        }

        // Validate Phone Number (10-15 digits)
        const phoneValue = phoneInput.value.trim();
        if (phoneValue.length < 10 || phoneValue.length > 15) {
            alert("Please enter a valid phone number (10-15 digits).");
            isValid = false;
        }

		// Validate File Size (Max 5MB)
		if (fileInput.files.length === 0) {
		    Swal.fire({
		        icon: 'error',
		        title: 'Upload Error',
		        text: 'Please upload an image.',
		        confirmButtonText: 'OK'
		    });
		    isValid = false;
		} else {
		    const fileSize = fileInput.files[0].size / 1024 / 1024; // MB
		    if (fileSize > 5) {
		        Swal.fire({
		            icon: 'error',
		            title: 'Upload Error',
		            text: 'The uploaded image exceeds the 5MB size limit.',
		            confirmButtonText: 'OK'
		        });
		        isValid = false;
		    }
		}


        // Validate Terms and Conditions Checkbox
        if (!agreeCheckbox.checked) {
            alert("You must agree to the terms and conditions.");
            isValid = false;
        }

        // Stop form submission if invalid
        if (!isValid) {
            event.preventDefault();
        }
    });
});
