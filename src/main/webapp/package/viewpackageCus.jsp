<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Health Screening Packages</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/viewpackageStaff.css">
    <link rel="stylesheet" href="../css/footer.css">
    <link rel="stylesheet" href="../css/header.css">
    
</head>
<body>
<%@ include file="../header.jsp" %>

<div class="main-container">
<div class="content-wrapper">
<div class="content-card">

<h1 class="page-title">Health Screening Packages</h1>

<input type="text" id="package-search" class="form-control mb-3" placeholder="Search">

<!-- PACKAGE LIST -->
<c:choose>
    <c:when test="${empty packages}">
        <div class="alert alert-info">
            No package available.
        </div>
    </c:when>
    <c:otherwise>
        <c:forEach var="p" items="${packages}">
            <div class="package-card">
                <img class="me-3"
                     src="${pageContext.request.contextPath}/package/PackageController?action=image&id=${p.packageID}"
                     width="80" height="60">

                <div class="package-details">
                    <strong>${p.packageName}</strong><br>
                    RM <fmt:formatNumber value="${p.packagePrice}" minFractionDigits="2"/>
                </div>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>

</div>
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.getElementById('package-search').addEventListener('input', function () {
    const filter = this.value.toLowerCase();
    document.querySelectorAll('.package-card').forEach(card => {
        const name = card.querySelector('strong').innerText.toLowerCase();
        card.style.display = name.includes(filter) ? 'flex' : 'none';
    });
});
</script>
 




<%@ include file="../footer.jsp" %>
</body>
</html>