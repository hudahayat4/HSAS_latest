<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg">
		<div class="container-fluid">
			<a class="navbar-brand" href="#"><img src="../image/logo.png"
				style="width: 120px; height: 50px;"></a>

			<button class="navbar-toggler" type="button"
				data-bs-toogle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav mx-auto align-items-center">
					<li class="nav-item"><a
						class="nav-link ${param.action == null ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard/dashboardCustomer.jsp">HOME</a>
					</li>
					<li class="nav-item"><a
						class="nav-link ${param.action == 'package' ? 'active' : ''}"
						href="${pageContext.request.contextPath}/appointment/AppointmentController?action=package">BOOKING</a>
					</li>		
					<li class="nav-item"><a
						class="nav-link ${param.action == 'list' && pageContext.request.requestURI.contains('result') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/result/resultController?action=list">RESULT</a>
					</li>
					<li class="nav-item"><a
						class="nav-link ${param.action == 'list' && pageContext.request.requestURI.contains('appointment') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/appointment/AppointmentController?action=list">APPOINTMENT</a>
					</li>
					<li class="nav-item"><a class="nav-link ${param.action == 'view' && pageContext.request.requestURI.contains('package') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/package/PackageController?action=view">PACKAGE</a>
					</li>
					<li class="nav-item"><a
						class="nav-link ${param.action == 'view' && pageContext.request.requestURI.contains('account') ? 'active' : ''}"
						href="${pageContext.request.contextPath}/account/CustomerController?action=view">SETTING</a>
					</li>
				</ul>
				<ul class="navbar-nav align-items-center">
					<c:choose>
						<%-- Check if the session attribute 'cusID' is null or empty --%>
						<c:when test="${empty sessionScope.cusID}">
							<li class="nav-item"><a class="nav-link logout"
								href="${pageContext.request.contextPath}/log_in.jsp"> Login
							</a></li>
						</c:when>

						<%-- If customer IS logged in, show Log Out --%>
						<c:otherwise>
							<li class="nav-item"><a class="nav-link logout"
								id="logoutBtn" href="${pageContext.request.contextPath}/LogOutController"> Log Out </a></li>
						</c:otherwise>
					</c:choose>
				</ul>
			</div>
		</div>
	</nav>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>