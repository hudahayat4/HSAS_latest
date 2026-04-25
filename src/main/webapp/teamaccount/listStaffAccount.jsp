<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Team Management | JuzCare</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/listTeamAccount.css?v=1.1">
<link rel="stylesheet" href="../css/sideStaff.css">
</head>
<body>
	<div class="wrapper">
		<%@ include file="../sideManager.jsp"%>
		<main class="list-wrapper">
			<div class="list-container">

				<div class="header-row">
					<h2>Team's Account</h2>
					<button class="add-btn"
						onclick="location.href='createStaffAccount.jsp'">
						<i class="fas fa-plus"></i> Add new team
					</button>
				</div>

				<c:forEach items="${staffList}" var="s">
					<div class="team-card">
						<div class="card-content">
							<div class="member-info">
								<div class="avatar-circle">
									<i class="fas fa-user"></i>
								</div>
								<div class="name-meta">
									<span class="member-name">${s.name}</span> <span
										class="member-role">${s.role}</span>
								</div>
							</div>
							<a href="StaffController?action=view&id=${s.staffID}"
								class="view-btn">View Details</a>
						</div>
					</div>
				</c:forEach>

				<c:if test="${empty staffList}">
					<p style="text-align: center; margin-top: 20px;">No staff
						found.</p>
				</c:if>

			</div>
		</main>
	</div>
</body>
</html>