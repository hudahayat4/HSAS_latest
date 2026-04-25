<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - JuzCare</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root {
            --primary-color: #3CACAE;
            --hover-color: #2a8c8d;
            --bg-gradient: linear-gradient(135deg, #d8eeee 0%, #a8dadc 100%);
            --card-bg: #ffffff;
            --error-color: #e74c3c;
            --success-color: #28a745;
            --success-bg: #d4edda;
            --success-border: #c3e6cb;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg-gradient);
            height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            width: 100%;
            max-width: 400px;
            background-color: var(--card-bg);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            text-align: center;
            margin: 20px;
        }

        .icon-box {
            font-size: 50px;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        h2 {
            color: #333;
            font-weight: 600;
            margin-bottom: 10px;
        }

        p {
            color: #777;
            font-size: 14px;
            margin-bottom: 25px;
        }

        .input-group {
            position: relative;
            margin-bottom: 15px;
            text-align: left;
        }

        .input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
        }

        /* Class khas untuk icon toggle password di sebelah kanan */
        .input-group .toggle-password {
            left: auto;
            right: 15px;
            cursor: pointer;
            z-index: 2; /* Pastikan ia berada di atas input */
        }
        
        /* Ubah warna bila hover supaya user tahu boleh klik */
        .input-group .toggle-password:hover {
            color: var(--primary-color);
        }

        input[type="password"], input[type="text"] {
            width: 100%;
            padding: 12px 40px 12px 45px;
            border: 2px solid #eee;
            border-radius: 8px;
            box-sizing: border-box;
            outline: none;
            transition: 0.3s;
            font-family: inherit;
        }

        input:focus {
            border-color: var(--primary-color);
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        button:hover {
            background-color: var(--hover-color);
            transform: translateY(-2px);
        }

        .error-msg {
            color: var(--error-color);
            font-size: 12px;
            margin-top: 5px;
            display: none;
            text-align: left;
        }

        /* CSS untuk mesej success (Hijau) */
        .success-box {
            background-color: var(--success-bg);
            color: #155724;
            border: 1px solid var(--success-border);
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: left;
            font-size: 14px;
            display: none; /* Hidden by default */
            align-items: center;
        }

        .success-box i {
            color: var(--success-color);
            margin-right: 10px;
            font-size: 18px;
        }

        /* CSS untuk link Back to Login */
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #777;
            text-decoration: none;
            font-size: 14px;
            transition: 0.3s;
        }

        .back-link:hover {
            color: var(--primary-color);
            text-decoration: underline;
        }
        
        .back-link i {
            margin-right: 5px;
        }

        /* Animation */
        .container {
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="icon-box">
            <i class="fas fa-key"></i>
        </div>
        
        <h2>Reset Password</h2>
        <p>Please enter your new password below.</p>

        <!-- Kotak Mesej Success (Akan muncul lepas submit) -->
        <div id="successMessage" class="success-box">
            <i class="fas fa-check-circle"></i>
            <span>Password has been successfully updated.</span>
        </div>

        <form id="resetForm" method="POST" action="http://localhost:8081/PassResetService/reset/update">
            
            <input type="hidden" name="token" value="<%= request.getParameter("token") %>">

            <div class="input-group">
                <!-- Icon Mangga (Hiasan) -->
                <i class="fas fa-lock"></i>
                
                <input type="password" id="newPassword" name="newPassword" placeholder="New Password" required>
                
                <!-- Icon Mata (Butang Fungsi) -->
                <i class="fas fa-eye-slash toggle-password" onclick="togglePass('newPassword', this)"></i>
            </div>

            <div class="input-group">
                <i class="fas fa-check-circle"></i>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
                
                <!-- Icon Mata (Butang Fungsi) -->
                <i class="fas fa-eye-slash toggle-password" onclick="togglePass('confirmPassword', this)"></i>
                
                <span id="matchError" class="error-msg">Passwords do not match!</span>
            </div>
            
            <button type="submit">Update Password</button>

            <!-- Link Back to Login -->
            <a href="login.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Login
            </a>
        </form>
    </div>

    <script>
        // Fungsi untuk sorok/lihat password
        function togglePass(id, icon) {
            const input = document.getElementById(id);
            
            if (input.type === "password") {
                input.type = "text";
                icon.classList.replace("fa-eye-slash", "fa-eye");
            } else {
                input.type = "password";
                icon.classList.replace("fa-eye-slash", "fa-eye");
            }
        }

        // Validasi dan Success Message
        const form = document.getElementById('resetForm');
        const newPass = document.getElementById('newPassword');
        const confirmPass = document.getElementById('confirmPassword');
        const errorMsg = document.getElementById('matchError');
        const successBox = document.getElementById('successMessage');

        form.onsubmit = function(e) {
            // Reset state
            errorMsg.style.display = 'none';
            successBox.style.display = 'none';
            confirmPass.style.borderColor = '#eee';

            // Check if passwords match
            if (newPass.value !== confirmPass.value) {
                e.preventDefault(); // Halang hantar borang
                errorMsg.style.display = 'block';
                confirmPass.style.borderColor = '#e74c3c';
                form.classList.add('shake');
                setTimeout(() => form.classList.remove('shake'), 500);
                return false;
            }

            // SIMULASI SUCCESS (Untuk paparan sahaja)
            // Dalam sistem sebenar, anda mungkin redirect atau tunjuk ini selepas server response.
            // Di sini saya preventDefault supaya anda boleh nampak mesej hijau tu muncul.
            e.preventDefault(); 
            successBox.style.display = 'flex'; // Paparkan kotak hijau
            
            // Nota: Buang 'e.preventDefault()' di atas jika anda mahu form ini betul-betul submit ke server.
            return true;
        };

        // Hilangkan error bila user mula menaip semula
        confirmPass.oninput = function() {
            errorMsg.style.display = 'none';
            confirmPass.style.borderColor = '#eee';
        };
    </script>

</body>
</html>