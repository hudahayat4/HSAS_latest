<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/sideStaff.css">
<link href="https://cdn.lineicons.com/5.0/lineicons.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<title>sidebar staff</title>
</head>
<body>
    <aside id="sidebar">
    <div class="d-flex align-items-center sidebar-header">
    	<button id="toggle-btn" type="button">
				<i class="lni lni-menu-hamburger-1"></i>
    	</button>

    	<div class="sidebar-logo-text">
    	     <img src="${pageContext.request.contextPath}/image/Juzcare.jpg" alt="logo" class="sidebar-logo-img">
    	     <p>JUZCARE'S STAFF</p>
    	</div>
	</div>
      <ul class="sidebar-nav">
      <li class="sidebar-item">
       		 <a href="${pageContext.request.contextPath}/dashboard/dashboardStaff.jsp" class="sidebar-link">
       		 	<i class="lni lni-dashboard-square-1"></i>
       		 	<span>Dashboard</span>
       		 </a>
       	</li>
       <li class="sidebar-item">
       		 <a href="${pageContext.request.contextPath}/package/PackageController?action=list" class="sidebar-link">
       		 	<i class="lni lni-file-multiple"></i>
       		 	<span>Package</span>
       		 </a>
       	</li>
       	 <li class="sidebar-item">
       		 <a href="javascript:void(0)" class="sidebar-link">
       		 	<i class="lni lni-user-multiple-4"></i>
       		 	<span>Appointment</span>
       		 </a>
       	</li>
    <li class="sidebar-item">
        <a href="${pageContext.request.contextPath}/teamaccount/StaffController?action=view" class="sidebar-link">
            <i class="lni lni-gear-1"></i>
            <span>Settings</span>
        </a>
    </li>
     </ul>
     <div class="sidebar-footer">
     
         <a href="${pageContext.request.contextPath}/LogOutController" class="sidebar-link">
            <i class="lni lni-exit"></i>
            <span>Log out</span>
        </a>
     </div>
      
    </aside>
  
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>


</body>
</html>