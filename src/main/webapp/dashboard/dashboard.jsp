<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacist Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
</head>
<body>


    <div class="main-container">
        <div class="top-row">
            <div class="pharmacy-banner">
                <img src="../image/logo.png" alt="JuzCare Pharmacy">
            </div>

            <div class="card appointments-card">
                <div class="card-header">
                    <h3>Upcoming Appointments</h3>
                    <a href="#" class="view-all">View All ></a>
                </div>
                
                <div class="calendar-nav">
                    <span id="current-month">Oct 2025</span>
                    <div class="arrows">
                        <button id="prevMonth"></button>
                        <button id="nextMonth"></button>
                    </div>
                </div>

                <div id="appointment-list" class="appointment-list">
                    </div>
            </div>
        </div>

        <div class="card prescription-container">
            <div class="card-header">
                <h3>Upcoming reminder prescription</h3>
                <a href="#" class="view-all">View All ></a>
            </div>
            <div id="prescription-grid" class="prescription-grid">
                </div>
        </div>
    </div>

    <script src="dashboard.js"></script>
 
</body>
</html>