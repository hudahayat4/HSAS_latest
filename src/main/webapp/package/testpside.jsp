<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Package Staff</title>

<link rel="stylesheet" href="../css/sideStaff.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/viewpackageStaff.css">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


</head>

<body>

<div class="wrapper">
    <%@ include file="../sideStaff.jsp"%>
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


<!-- ADD MODAL -->
	<div class="modal fade" id="addModal" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered">
	<div class="modal-content">
	<div class="modal-header">
    	<h5>Add Package</h5>
    	<button class="btn-close" data-bs-dismiss="modal"></button>
	</div>
		<div class="modal-body">
			<form action="${pageContext.request.contextPath}/package/PackageController" method="post" enctype="multipart/form-data">
    			<div class="mb-3">
				<label for="recipient-name" class="col-form-label">Package Name:</label>
	 			<input type="text" class="form-control" id="packageName" placeholder="Health Screening Type" name="packageName">
				</div>
				<div class="mb-3">
				<label for="message-text" class="col-form-label">Price:</label>
				<input type="number" class="form-control" id="packagePrice" placeholder="RM" name="packagePrice">
				</div>
				<div class="mb-3">
				<label for="formFile" class="form-label">Default file input example</label> 
				<input class="form-control" type="file" id="packagePic" name="packagePic">
				</div>
				<div class="mb-3">
				<label for="message-text" class="col-form-label">Fasting:</label><br>
				<input class="form-check-input" type="radio" name="bfrReq" id="exampleRadios1" value="YES"> 
				<label class="form-check-label" for="exampleRadios1"> Yes </label> 
				<input class="form-check-input" type="radio" name="bfrReq" id="No" value="NO"> <label class="form-check-label" for="exampleRadios2"> No </label>
				</div>
				<div class="mb-3">
				<label for="message-text" class="col-form-label">Exist:</label><br>
				<input class="form-check-input" type="radio" name="isExist" id="isExist" value="YES"> 
				<label class="form-check-label" for="exampleRadios1"> Yes </label> 
				<input class="form-check-input" type="radio" name="isExist" id="No" value="NO">
				<label class="form-check-label"	for="isExist"> No </label>
				</div>
				<div class="mb-3">
				<button type="submit" class="btn w-100" style="background: #009FA5; color: white;">Submit</button>
				</div>
			</form>
		</div>
	</div>
</div>
</div>

<!-- UPDATE MODAL --><div class="modal fade" id="updateModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title">Update Package</h5>
        <button class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <form action="${pageContext.request.contextPath}/package/PackageController" method="post" enctype="multipart/form-data">

          <input type="hidden" name="action" value="update">
          <input type="hidden" name="packageID" id="u_packageID">

          <div class="mb-3">
            <label class="form-label">Package Name</label>
            <input type="text" class="form-control" name="packageName" id="u_packageName">
          </div>

          <div class="mb-3">
            <label class="form-label">Price</label>
            <input type="number" class="form-control" name="packagePrice" id="u_packagePrice">
          </div>

          <div class="mb-3">
            <label class="form-label">Package Image</label>
            <input type="file" class="form-control" name="packagePic">
          </div>

          <div class="mb-3">
            <label class="form-label">Fasting Required</label><br>
            <input type="radio" name="bfrReq" value="YES" id="u_bfr_yes"> Yes
            <input type="radio" name="bfrReq" value="NO" id="u_bfr_no"> No
          </div>

          <div class="mb-3">
            <label class="form-label">Exist</label><br>
            <input type="radio" name="isExist" value="YES" id="u_exist_yes"> Yes
            <input type="radio" name="isExist" value="NO" id="u_exist_no"> No
          </div>

         <button type="button" id="confirmUpd" class="btn w-100" style="background:#009FA5;color:white;">
    	Update
    	</button>

        </form>
      </div>

    </div>
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
<script>
const updateModal = document.getElementById('updateModal');

updateModal.addEventListener('show.bs.modal', function (event) {
    const button = event.relatedTarget;

    document.getElementById('u_packageID').value = button.dataset.id;
    document.getElementById('u_packageName').value = button.dataset.name;
    document.getElementById('u_packagePrice').value = button.dataset.price;

    document.getElementById('u_bfr_yes').checked = button.dataset.bfr === 'YES';
    document.getElementById('u_bfr_no').checked  = button.dataset.bfr === 'NO';

    document.getElementById('u_exist_yes').checked = button.dataset.exist === 'YES';
    document.getElementById('u_exist_no').checked  = button.dataset.exist === 'NO';
});
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const confirmButton = document.getElementById("confirmUpd");
    const updateForm = document.querySelector("#updateModal form");
    const updateModalEl = document.getElementById("updateModal");
    const updateModal = bootstrap.Modal.getOrCreateInstance(updateModalEl);

    confirmButton.addEventListener("click", function () {

        Swal.fire({
            title: "Are you sure?",
            text: "Do you want to update this package?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#009FA5",
            cancelButtonColor: "#d33",
            confirmButtonText: "Yes, update",
            cancelButtonText: "Cancel"
        }).then((result) => {

            if (result.isConfirmed) {
                updateForm.submit(); 
            } 
            else {
                updateModal.hide(); 
            }

        });
    });

});
</script>
<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>

</body>
</html>
