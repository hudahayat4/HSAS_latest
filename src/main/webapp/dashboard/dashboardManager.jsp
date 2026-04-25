<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%-- Import your specific package where ConnectionManager is located --%>
<%@ page import="util.ConnectionManager"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manager Dashboard | JuzCare</title>

<!-- External Resources -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/dashboardManager.css?v=1.1">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="../css/sideStaff.css">


</head>
<body>

	<%
	// Initialize data variables
	int totalCustomer = 0;
	int totalTeams = 0;
	int totalPackages = 0;
	int totalAppointments = 0;

	Connection conn = null;
	try {
		// Using your ConnectionManager directly
		conn = ConnectionManager.getConnection();
		
		PreparedStatement psCustomer = conn.prepareStatement("SELECT COUNT(cusID) FROM customer");
		ResultSet rsCustomer = psCustomer.executeQuery();
		if (rsCustomer.next())
			totalCustomer = rsCustomer.getInt(1);
		// 2. Total Teams
		PreparedStatement psTeam = conn.prepareStatement("SELECT COUNT(staffID) FROM staff");
		ResultSet rsTeam = psTeam.executeQuery();
		if (rsTeam.next())
			totalTeams = rsTeam.getInt(1);

		// 3. Total Packages
		PreparedStatement psPkg = conn.prepareStatement("SELECT COUNT(*) FROM package");
		ResultSet rsPkg = psPkg.executeQuery();
		if (rsPkg.next())
			totalPackages = rsPkg.getInt(1);

		// 4. Total Appointments
		PreparedStatement psApt = conn.prepareStatement("SELECT COUNT(*) FROM appointment");
		ResultSet rsApt = psApt.executeQuery();
		if (rsApt.next())
			totalAppointments = rsApt.getInt(1);

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (conn != null)
			conn.close();
	}
	%>


	<div class="wrapper">


		<%@ include file="../sideManager.jsp"%>
		<div class="dashboard-container">
			<div class="mb-4">
				<h1 class="fw-bold h3">Manager Dashboard</h1>
			</div>

			<!-- 4 Stats Cards -->
			<div class="row g-4 mb-4">
				<div class="col-md-3">
					<div class="stat-card">
						<div class="icon-circle bg-rev">
							<i class="fas fa-coins"></i>
						</div>
						<div>
							<small class="text-muted fw-bold">TOTAL CUSTOMER</small>
							<h4 class="m-0 fw-bold">
								<%=totalCustomer%></h4>
						</div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="stat-card">
						<div class="icon-circle bg-team">
							<i class="fas fa-users-cog"></i>
						</div>
						<div>
							<small class="text-muted fw-bold">ACTIVE TEAMS</small>
							<h4 class="m-0 fw-bold text-center"><%=totalTeams%></h4>
						</div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="stat-card">
						<div class="icon-circle bg-pkg">
							<i class="fas fa-box"></i>
						</div>
						<div>
							<small class="text-muted fw-bold">TOTAL PACKAGES</small>
							<h4 class="m-0 fw-bold"><%=totalPackages%></h4>
						</div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="stat-card">
						<div class="icon-circle bg-apt">
							<i class="fas fa-calendar-alt"></i>
						</div>
						<div>
							<small class="text-muted fw-bold">APPOINTMENTS</small>
							<h4 class="m-0 fw-bold"><%=totalAppointments%></h4>
						</div>
					</div>
				</div>
			</div>

			<!-- Charts Section -->
			<div class="row g-4">
				<div class="col-lg-8">
					<div class="chart-card">
						<h6 class="fw-bold mb-4">Monthly Appointment Trends</h6>
						<canvas id="appointmentsChart" height="120"></canvas>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="chart-card">
						<h6 class="fw-bold mb-4">Package Popularity</h6>
						<canvas id="packageChart"></canvas>
					</div>
				</div>
			</div>

			<!-- Action Buttons -->
			<div class="mt-5 pt-4 border-top">
				<h5 class="fw-bold mb-3">Management Controls</h5>
				<div class="d-flex flex-wrap gap-3">
					<a href="${pageContext.request.contextPath}/teamaccount/createStaffAccount.jsp" class="btn-custom"><i
						class="fas fa-user-plus"></i> Create Team Account</a> <a
						href="${pageContext.request.contextPath}/teamaccount/StaffController?action=list" class="btn-outline"><i
						class="fas fa-id-card"></i> View Staff Records</a> <a
						href="${pageContext.request.contextPath}/package/PackageController?action=viewPackage"  class="btn-outline"><i
						class="fas fa-layer-group"></i> Manage Packages</a>
				</div>
			</div>
		</div>
	</div>



	<script>
		const ctxApt = document.getElementById('appointmentsChart').getContext(
				'2d');
		new Chart(ctxApt, {
			type : 'line',
			data : {
				labels : [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun' ],
				datasets : [ {
					label : 'Bookings',
					data : [ 15, 22, 18, 30, 28, 40 ],
					borderColor : '#12939a',
					backgroundColor : 'rgba(18, 147, 154, 0.1)',
					fill : true,
					tension : 0.4
				} ]
			}
		});

		const ctxPkg = document.getElementById('packageChart').getContext('2d');
		new Chart(ctxPkg, {
			type : 'doughnut',
			data : {
				labels : [ 'HBA1C', 'LIPID PROFILE', 'BLOOD URIC ACID' ],
				datasets : [ {
					data : [ 30, 50, 20 ],
					backgroundColor : [ '#12939a', '#1e90ff', '#ef6c00' ]
				} ]
			},
			options : {
				plugins : {
					legend : {
						position : 'bottom'
					}
				}
			}
		});
	</script>
</body>
</html>