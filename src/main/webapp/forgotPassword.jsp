<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - JuzCare</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root {
            --primary-color: #3CACAE;
            --hover-color: #2a8c8d;
            --bg-gradient: linear-gradient(135deg, #d8eeee 0%, #a8dadc 100%);
            --card-bg: #ffffff;
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
            margin-bottom: 30px;
        }

        .input-group {
            position: relative;
            margin-bottom: 20px;
            text-align: left;
        }

        .input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            transition: 0.3s;
        }

        input[type="email"] {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #eee;
            border-radius: 8px;
            box-sizing: border-box;
            outline: none;
            transition: 0.3s;
            font-family: inherit;
        }

        input[type="email"]:focus {
            border-color: var(--primary-color);
        }

        input[type="email"]:focus + i {
            color: var(--primary-color);
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
            box-shadow: 0 4px 6px rgba(60, 172, 174, 0.2);
        }

        button:hover {
            background-color: var(--hover-color);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(60, 172, 174, 0.3);
        }

        .footer-links {
            margin-top: 25px;
            font-size: 13px;
        }

        .footer-links a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .footer-links a:hover {
            text-decoration: underline;
        }

        /* Animasi masuk */
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
            <i class="fas fa-lock-open"></i>
        </div>
        
        <h2>Forgot Password?</h2>
        <p>No worries, enter your email below and we'll send you a link to reset your password.</p>

        
        <!-- MICROSERVICE -->
        <form method="POST" action="http://localhost:8081/PassResetService/reset/request">
            <div class="input-group">
                <input type="email" id="email" name="email" required placeholder="Enter your email">
                <i class="fas fa-envelope"></i>
            </div>
            
            <button type="submit">Send Reset Link</button>
        </form>

        <div class="footer-links">
            <a href="login.jsp"><i class="fas fa-arrow-left"></i> Back to Login</a>
        </div>
    </div>

</body>
</html>