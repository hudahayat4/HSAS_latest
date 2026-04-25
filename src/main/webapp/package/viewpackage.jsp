<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Health Screening Packages</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/viewpackage.css">
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

<!-- Add Button -->
<div class="add-btn-wrapper">
    <button class="btn" style="background:#009FA5;color:white; margin-bottom: 20px;" data-bs-toggle="modal" data-bs-target="#addModal">+ Add New Package</button>
</div>

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

                <button class="btn btn-sm btn-info ms-auto" style="background:white;color:black;"
                        data-bs-toggle="modal"
                        data-bs-target="#updateModal"
                        data-id="${p.packageID}"
                        data-name="${p.packageName}"
                        data-price="${p.packagePrice}"
                        data-bfr="${p.bfrReq}"
                        data-exist="${p.isExist}">
                    Update
                </button>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>

</div>
</div>
</div>



<script>
    // Tunggu sehingga halaman siap dimuatkan
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('package-search');
        const packageCards = document.querySelectorAll('.package-card');

        // Fungsi ini akan jalan setiap kali anda menaip dalam search bar
        searchInput.addEventListener('input', function() {
            const filter = searchInput.value.toLowerCase().trim();

            packageCards.forEach(card => {
                // Ambil teks nama package di dalam tag <strong>
                const packageName = card.querySelector('.package-label strong').innerText.toLowerCase();

                // Jika nama ada dalam carian, tunjuk. Jika tak, sorok.
                if (packageName.includes(filter)) {
                    card.style.display = ""; // Kembali kepada gaya asal (flex/block)
                } else {
                    card.style.display = "none"; // Sorokkan terus
                }
            });
        });
    });
</script>




<%@ include file="../footer.jsp" %>
</body>
</html>