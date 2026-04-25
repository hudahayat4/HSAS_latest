<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer Dashboard | JuzCare</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardCustomer.css">

</head>
<body>

    <%@ include file="../header.jsp"%>

    <div class="dashboard-container">
        
        <div class="welcome-section animate-card delay-1">
            <h1>Hi, <%= (session.getAttribute("custUsername") != null) ? session.getAttribute("custUsername") : "Valued Customer" %>.</h1>
            <p>Welcome back to JuzCare. Here is your health overview.</p>
        </div>

        <div class="dashboard-grid">
            
            <div class="left-col">
                
                <div class="banner-box animate-card delay-2">
                    <h2>WE LISTEN. WE CARE. WE SERVE.</h2>
                    <p>Your health journey matters to us. Check our latest updates and offers designed just for you.</p>
                    <i class="fas fa-heartbeat" style="position:absolute; right: 20px; bottom: 20px; font-size: 60px; opacity: 0.2;"></i>
                </div>

                <div class="product-section animate-card delay-3">
                    <div class="styled-card">
                        <div class="card-header">
                            <i class="fas fa-star"></i> Featured Products
                        </div>
                        <div class="card-body" style="display: block; padding: 20px 0;"> 
                            <div class="carousel-wrapper">
                                <button class="carousel-btn left" id="prevBtn"><i class="fas fa-chevron-left"></i></button>
                                <button class="carousel-btn right" id="nextBtn"><i class="fas fa-chevron-right"></i></button>
                                
                                <div class="carousel-track-container">
                                    <ul class="carousel-track" id="track">
                                        <li class="product-card">
                                            <img src="${pageContext.request.contextPath}/image/1.png" alt="Product 1">
                                        </li>
                                        <li class="product-card">
                                            <img src="${pageContext.request.contextPath}/image/2.png" alt="Product 2">
                                        </li>
                                        <li class="product-card">
                                            <img src="${pageContext.request.contextPath}/image/3.png" alt="Product 3">
                                        </li>
                                        <li class="product-card">
                                            <img src="${pageContext.request.contextPath}/image/4.png" alt="Product 4">
                                        </li>
                                        <li class="product-card">
                                            <img src="${pageContext.request.contextPath}/image/5.png" alt="Product 5">
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <div class="info-box-container">
                
                <div class="styled-card animate-card delay-2">
                    <div class="card-header">
                        <i class="far fa-calendar-check"></i> Upcoming Appointment
                    </div>
                    <div class="card-body">
                         <% 
                            String apptTime = (String)session.getAttribute("apptTime");
                            String displayTime = (apptTime != null) ? apptTime : "Not scheduled";
                        %>
                        <h5><%= displayTime %></h5>
                        <div class="countdown-badge" id="countdown">Loading...</div>
                    </div>
                </div>

                <div id="recent-results-card" class="styled-card animate-card delay-3">
                    <div class="card-header">
                        <i class="fas fa-file-medical-alt"></i> Recent Results
                    </div>
                    <div class="card-body">
                        <% 
                            String resultComment = (String)session.getAttribute("resultComment");
                            if (resultComment != null && !resultComment.trim().isEmpty()) {
                        %>
                            <p style="font-size: 16px; color: var(--primary); font-weight:600;"><%= resultComment %></p>
                        <% } else { %>
                            <p>Your result will display after the appointment.</p>
                        <% } %>
                        
                        <img src="${pageContext.request.contextPath}/image/result_icon.jpg" class="results-placeholder-img" alt="Healthy Life">
                    </div>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="../footer.jsp"%>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // --- CAROUSEL LOGIC ---
        const track = document.getElementById('track');
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');
        const cards = document.querySelectorAll('.product-card');

        let currentIndex = 0;
        const totalCards = cards.length;
        
        let cardsToShow = 3;
        if (window.innerWidth <= 600) cardsToShow = 1;
        else if (window.innerWidth <= 900) cardsToShow = 2;

        window.addEventListener('resize', () => {
            if (window.innerWidth <= 600) cardsToShow = 1;
            else if (window.innerWidth <= 900) cardsToShow = 2;
            else cardsToShow = 3;
            updateCarousel();
        });

        function updateCarousel() {
            const containerWidth = document.querySelector('.carousel-track-container').offsetWidth;
            const gap = 20; 
            
            const cardWidth = (containerWidth - (gap * (cardsToShow - 1))) / cardsToShow;
            const moveAmount = (cardWidth + gap) * currentIndex;
            
            track.style.transform = `translateX(-${moveAmount}px)`;
            
            prevBtn.style.visibility = (currentIndex === 0) ? "hidden" : "visible";
            nextBtn.style.visibility = (currentIndex >= totalCards - cardsToShow) ? "hidden" : "visible";
        }

        nextBtn.addEventListener('click', () => {
            if (currentIndex < totalCards - cardsToShow) {
                currentIndex++;
                updateCarousel();
            }
        });

        prevBtn.addEventListener('click', () => {
            if (currentIndex > 0) {
                currentIndex--;
                updateCarousel();
            }
        });

        updateCarousel();


        // --- COUNTDOWN LOGIC ---
        var apptString = "<%= (session.getAttribute("apptTime") != null) ? session.getAttribute("apptTime") : "" %>";
        var countdownElem = document.getElementById("countdown");

        if(apptString === "") {
            countdownElem.innerHTML = "No upcoming appointment";
            countdownElem.style.borderColor = "#ccc";
            countdownElem.style.color = "#999";
        } else {
            var countDownDate = new Date(apptString).getTime();
            
            if (isNaN(countDownDate)) {
                 countdownElem.innerHTML = "Ready";
            } else {
                var x = setInterval(function() {
                    var now = new Date().getTime();
                    var distance = countDownDate - now;

                    if (distance < 0) {
                        clearInterval(x);
                        countdownElem.innerHTML = "Appointment Started";
                        return;
                    }
                    var days = Math.floor(distance / (1000 * 60 * 60 * 24));
                    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    countdownElem.innerHTML = "Starts in: " + days + "d " + hours + "h";
                }, 1000);
            }
        }
    });
</script>
</body>
</html>