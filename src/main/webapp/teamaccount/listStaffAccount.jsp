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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
									<img class="me-3"
										src="${pageContext.request.contextPath}/teamaccount/StaffController?action=image&id=${s.staffID}"
										width="80" height="80"
										style="border-radius: 50%; object-fit: cover;"
										alt="Profile Picture"
										onerror="this.src='${pageContext.request.contextPath}/image/blank-profile-picture.png';">
								</div>
								<div class="name-meta">
									<span class="member-name">${s.name}</span> <span
										class="member-role">${s.role}</span>
								</div>
							</div>
							<a
								href="${pageContext.request.contextPath}/teamaccount/StaffController?action=viewMember&staffID=${s.staffID}"
								class="btn btn-outline-primary">View Details</a>
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

<%
String successMessage = (String) session.getAttribute("successMessage");

if(successMessage != null){
%>

<script>
window.onload = function() {

    Swal.fire({
        toast: true,
        position: 'top-end',
        icon: 'success',
        title: '<%= successMessage %>',
        showConfirmButton: false,
        timer: 2500
    });

}
</script>

<%
session.removeAttribute("successMessage");
}
%>
</html>