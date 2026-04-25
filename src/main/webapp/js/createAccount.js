document.addEventListener('DOMContentLoaded', function() {
    // 1. SELECT ELEMENTS
    const form = document.getElementById('registrationForm');
    const nameInput = document.getElementById('custName');
    const icInput = document.getElementById('cusNRIC');
    const phoneInput = document.getElementById('custPhoneNo');
    const passwordInput = document.getElementById('custPassword');
    const togglePassword = document.getElementById('togglePassword');
    const eyeIcon = document.getElementById('eyeIcon');
    const fileInput = document.getElementById('custProfilePic');
    const agreeCheckbox = document.getElementById('iAgree');

    // 2. REAL-TIME INPUT RESTRICTIONS
    
    // Name: Allow only letters (A-Z, a-z) and spaces
    nameInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^a-zA-Z\s]/g, '');
    });

    // IC Number: Allow only numbers (0-9)
    icInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    // Phone Number: Allow only numbers and the '+' symbol
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

    // 4. FORM SUBMISSION VALIDATION
    form.addEventListener('submit', function(event) {
        let isValid = true;
        let errorMessage = "";

        // Validate IC (Must be exactly 12 digits)
        const icValue = icInput.value.trim();
        if (icValue.length !== 12) {
            errorMessage += "• IC Number must consist of exactly 12 digits.\n";
            isValid = false;
        }

        // Validate Phone Number (Minimum 10 digits)
        const phoneValue = phoneInput.value.trim();
        if (phoneValue.length < 10 || phoneValue.length > 15) {
            errorMessage += "• Please enter a valid phone number (10-15 digits).\n";
            isValid = false;
        }

        // Validate File Size (Max 10MB)
        if (fileInput.files.length > 0) {
            const fileSize = fileInput.files[0].size / 1024 / 1024; // Convert to MB
            if (fileSize > 10) {
                errorMessage += "• The uploaded image exceeds the 10MB size limit.\n";
                isValid = false;
            }
        }

        // Validate Terms and Conditions Checkbox
        if (!agreeCheckbox.checked) {
            errorMessage += "• You must agree to the terms and conditions.\n";
            isValid = false;
        }

        // If any validation fails, stop form submission
        if (!isValid) {
            event.preventDefault(); 
            alert("Please correct the following errors:\n\n" + errorMessage);
        }
    });
});