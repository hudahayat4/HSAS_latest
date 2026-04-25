<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pharmacist Dashboard | JuzCare</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/dashboardPharmacist.css">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<link rel="stylesheet" href="../css/sideStaff.css">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
	<div class="wrapper">

		<%@ include file="../sidePharmacist.jsp"%>
		<div class="dashboard-container">

			<header class="welcome-section animate-card delay-1">
				<%
				Integer staffID = (Integer) session.getAttribute("staffID");
				staff.Staff staffObj = null;
				if (staffID != null) {
					staffObj = staff.StaffDAO.getStaffById(staffID);
				}
				%>

				<h1>
					Hi,
					<%=(staffObj != null ? staffObj.getName() : "Beloved Pharmacist")%>.
				</h1>

				<p id="uk-greeting">Wishing you a splendid and productive day
					ahead.</p>
			</header>

			<div class="dashboard-grid">

				<div class="main-content-area">

					<div class="banner-box animate-card delay-1">
						<div class="banner-content">
							<h2>WE LISTEN. WE CARE. WE SERVE.</h2>
							<p>Your dedication to health makes a difference. Check
								today's schedule and lead the journey to wellness.</p>
						</div>
						<i class="fas fa-heartbeat banner-icon"></i>
					</div>

					<div class="styled-card appointment-card animate-card delay-2">
						<div class="card-header">
							<i class="fas fa-calendar-alt"></i> &nbsp;Today's Appointments
						</div>
						<div class="card-body">
							<%
							List<appointment.appointment> appointments = (List<appointment.appointment>) request.getAttribute("appointments");

							if (appointments == null || appointments.isEmpty()) {
							%>
							<div class="free-state">
								<div class="free-state-content">
									<i class="fas fa-mug-hot"></i>
									<h3>You're free today!</h3>
									<p>No appointments scheduled. Perhaps it's time for a
										lovely cup of tea?</p>
								</div>
							</div>
							<%
							} else {
							%>
							<div class="table-responsive">
								<table class="pharmacist-table">
									<thead>
										<tr>
											<th>Customer Name</th>
											<th>Time</th>
											<th>Package</th>
										</tr>
									</thead>
									<tbody>
										<%
										if (appointments != null) {
											for (appointment.appointment app : appointments) {
										%>
										<tr>
											<td><strong><%=app.getCustomerName()%></strong></td>
											<td><span class="time-badge"><%=app.getApptTime()%></span></td>
											<td><%=app.getPackageName()%></td>
										</tr>
										<%
										}
										}
										%>
									</tbody>

								</table>
							</div>
							<%
							}
							%>
						</div>
					</div>
				</div>

				<div class="info-box-container">

					<div class="styled-card stats-card animate-card delay-3">
						<div class="card-header">
							<i class="fas fa-chart-pie"></i> &nbsp;Package Statistics
						</div>
						<div class="card-body">
							<div class="chart-container">
								<canvas id="packageChart"></canvas>
							</div>
						</div>
					</div>

					<div class="styled-card quote-card animate-card delay-3">
						<div class="card-body">
							<i class="fas fa-quote-left"></i>
							<p id="daily-quote">"The art of healing comes from nature,
								not from the physician."</p>
							<small>— Paracelsus</small>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>

	<script>
		const hour = new Date().getHours();
		const greetingElement = document.getElementById('uk-greeting');
		if (hour < 12)
			greetingElement.innerHTML = "Top of the morning to you! Ready for a brilliant day?";
		else if (hour < 17)
			greetingElement.innerHTML = "Good afternoon! Hope your day is going swimmingly.";
		else
			greetingElement.innerHTML = "Good evening! Wrapping up a grand day, are we?";

		const ctx = document.getElementById('packageChart').getContext('2d');
		new Chart(ctx, {
			type : 'doughnut',
			data : {
				labels : [ 'Basic', 'Premium', 'Gold' ],
				datasets : [ {
					data : [ 12, 19, 7 ],
					backgroundColor : [ '#3CACAE', '#D8EEEE', '#333333' ],
					hoverOffset : 4,
					borderWidth : 2,
					borderColor : '#ffffff'
				} ]
			},
			options : {
				responsive : true,
				maintainAspectRatio : false,
				plugins : {
					legend : {
						position : 'bottom',
						labels : {
							font : {
								family : 'Poppins',
								size : 11
							}
						}
					}
				},
				cutout : '70%'
			}
		});
	</script>
</body>
</html>