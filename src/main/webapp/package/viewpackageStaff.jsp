<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Package Staff</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/viewpackageStaff.css">

<link rel="stylesheet" href="../css/sideStaff.css">
<style>
.availability-btn {
	width: 110px; /* Adjust width as needed to fit longest text */
	text-align: center;
	pointer-events: none; /* Not clickable */
}
</style>
</head>

<body>
	<%
	String message = (String) session.getAttribute("message");
	if (message != null) {
	%>

	<div class="d-flex justify-content-center mt-3">
		<div id="success-alert"
			class="alert alert-success alert-dismissible fade show shadow-sm"
			role="alert" style="width: 100%; max-width: 600px;">

			<strong>Success!</strong>
			<%=message%>
		</div>
	</div>

	<script type="text/javascript">
        setTimeout(function () {
            let alertElement = document.getElementById('success-alert');
            if (alertElement) {
                let bsAlert = new bootstrap.Alert(alertElement);
                bsAlert.close(); // This removes the alert from the screen
                
                // OPTIONAL: If you literally meant "Reload the entire page", use this line instead:
                // window.location.reload(); 
            }
        }, 1000); // 5000ms = 5 seconds
    </script>

	<%
	session.removeAttribute("message");
	}
	%>
	<div class="wrapper">

		<%@ include file="../sideStaff.jsp"%>
		<div class="main-container">

			<div class="content-wrapper">
				<div class="content-card">

					<h1 class="page-title">Health Screening Packages</h1>

					<input type="text" id="package-search" class="form-control mb-3"
						placeholder="Search">

					<!-- Add Button -->
					<div class="add-btn-wrapper">
						<button class="btn"
							style="background: #009FA5; color: white; margin-bottom: 20px;"
							data-bs-toggle="modal" data-bs-target="#addModal">+ Add
							New Package</button>
					</div>

					<!-- PACKAGE LIST -->
					<c:choose>
						<c:when test="${empty packages}">
							<div class="alert alert-info">No package available.</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="p" items="${packages}">
								<div class="package-card">
									<img class="me-3"
										src="${pageContext.request.contextPath}/package/PackageController?action=image&id=${p.packageID}"
										width="80" height="60">

									<div class="package-details">
										<strong>${p.packageName}</strong><br> RM
										<fmt:formatNumber value="${p.packagePrice}"
											minFractionDigits="2" />
									</div>
									<div class="me-2">
										<c:choose>
											<c:when test="${p.isExist == 'YES'}">
												<span class="btn btn-success btn-sm availability-btn"
													style="pointer-events: none;">Available</span>
											</c:when>
											<c:otherwise>
												<span class="btn btn-danger btn-sm availability-btn"
													style="pointer-events: none;">Not Available</span>
											</c:otherwise>
										</c:choose>
									</div>

									<button class="btn btn-sm btn-info ms-auto"
										style="background: white; color: black;"
										data-bs-toggle="modal" data-bs-target="#updateModal"
										data-id="${p.packageID}" data-name="${p.packageName}"
										data-price="${p.packagePrice}" data-bfr="${p.bfrReq}"
										data-exist="${p.isExist}">Update</button>
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
						<form id="addPackageForm"
							action="${pageContext.request.contextPath}/package/PackageController"
							method="post" enctype="multipart/form-data">

							<!-- Name & Price -->
							<div class="row">
								<div class="col-md-6 mb-3 position-relative">
									<label class="col-form-label">Name:</label> <input type="text"
										class="form-control" id="packageName"
										placeholder="Health Screening Type" name="packageName">
									<span class="error-icon"><i
										class="bi bi-exclamation-triangle-fill"></i></span>
									<div class="error-message">Enter a package name.</div>
								</div>

								<div class="col-md-6 mb-3 position-relative">
									<label class="col-form-label">Price:</label> <input
										type="number" class="form-control" id="packagePrice"
										placeholder="RM" name="packagePrice"> <span
										class="error-icon"><i
										class="bi bi-exclamation-triangle-fill"></i></span>
									<div class="error-message">Enter a valid price.</div>
								</div>
							</div>

							<!-- Image (Left) + Right Side Content -->
							<div class="row">
								<!-- LEFT: Image -->
								<div class="col-md-4 mb-3 position-relative">
									<label class="form-label">Picture:</label> <input
										class="form-control" type="file" id="packagePic"
										name="packagePic"> <span class="error-icon"><i
										class="bi bi-exclamation-triangle-fill"></i></span>
									<div class="error-message">Upload a picture.</div>
								</div>

								<!-- RIGHT: Fasting + Availability -->
								<div class="col-md-8">
									<div class="row">
										<!-- Fasting -->
										<div class="col-md-6 mb-3 position-relative">
											<label class="col-form-label">Fasting:</label><br> <input
												class="form-check-input" type="radio" name="bfrReq"
												value="YES"> Yes <input
												class="form-check-input ms-3" type="radio" name="bfrReq"
												value="NO"> No <span class="error-icon"><i
												class="bi bi-exclamation-triangle-fill"></i></span>
											<div class="error-message">Select fasting option.</div>
										</div>

										<!-- Availability -->
										<div class="col-md-6 mb-3 position-relative">
											<label class="col-form-label">Availability:</label><br>
											<input class="form-check-input" type="radio" name="isExist"
												value="YES"> Yes <input
												class="form-check-input ms-3" type="radio" name="isExist"
												value="NO"> No <span class="error-icon"><i
												class="bi bi-exclamation-triangle-fill"></i></span>
											<div class="error-message">Select availability option.</div>
										</div>
									</div>
								</div>
							</div>

							<!-- Dynamic Table -->
							<table class="table table-bordered align-middle"
								id="dynamicTable">
								<thead>
									<tr>
										<th style="width: 100px;">Action</th>
										<th>Field Name</th>
										<th>Value</th>
									</tr>
								</thead>
								<tbody>
									<tr class="dynamic-row">
										<!-- Buttons -->
										<td>
											<button type="button" class="btn btn-success btn-sm"
												onclick="addRow()">+</button>
											<button type="button" class="btn btn-danger btn-sm"
												onclick="removeRow(this)">-</button>
										</td>

										<!-- Field Name -->
										<td><input type="text" class="form-control"
											name="fieldName[]" placeholder="e.g. Blood Test"></td>

										<!-- Value -->
										<td><input type="text" class="form-control"
											name="fieldValue[]" placeholder="e.g. Included"></td>
									</tr>
								</tbody>
							</table>

							<!-- Submit -->
							<div class="mb-3">
								<button type="submit" class="btn w-100"
									style="background: #009FA5; color: white;">Submit</button>
							</div>

						</form>
					</div>

					<script>
					function addRow() {
					    let row = `
					    <tr class="dynamic-row">
					        <td>
					            <button type="button" class="btn btn-success btn-lg" onclick="addRow()">+</button>
					            <button type="button" class="btn btn-danger btn-lg" onclick="removeRow(this)">-</button>
					        </td>
					        <td>
					            <input type="text" class="form-control" name="fieldName[]" placeholder="e.g. Blood Test">
					        </td>
					        <td>
					            <input type="text" class="form-control" name="fieldValue[]" placeholder="e.g. Included">
					        </td>
					    </tr>
					    `;

					    document.querySelector("#dynamicTable tbody")
					        .insertAdjacentHTML("beforeend", row);
					}

					function removeRow(btn) {
					    let row = btn.closest("tr");

					    // prevent deleting last row
					    if (document.querySelectorAll("#dynamicTable tbody tr").length > 1) {
					        row.remove();
					    }
					}
</script>
				</div>
			</div>
		</div>


		<!-- UPDATE MODAL -->
		<div class="modal fade" id="updateModal" tabindex="-1">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">

					<div class="modal-header">
						<h5 class="modal-title">Update Package</h5>
						<button class="btn-close" data-bs-dismiss="modal"></button>
					</div>

					<div class="modal-body">
						<form
							action="${pageContext.request.contextPath}/package/PackageController"
							method="post" enctype="multipart/form-data">

							<input type="hidden" name="action" value="update"> <input
								type="hidden" name="packageID" id="u_packageID">

							<div class="mb-3">
								<label class="form-label">Package Name</label> <input
									type="text" class="form-control" name="packageName"
									id="u_packageName">
							</div>

							<div class="mb-3">
								<label class="form-label">Price</label> <input type="number"
									class="form-control" name="packagePrice" id="u_packagePrice">
							</div>

							<div class="mb-3">
								<label class="form-label">Package Image</label> <input
									type="file" class="form-control" name="packagePic">
							</div>

							<div class="mb-3">
								<label class="form-label">Fasting Required</label><br> <input
									type="radio" name="bfrReq" value="YES" id="u_bfr_yes">
								Yes <input type="radio" name="bfrReq" value="NO" id="u_bfr_no">
								No
							</div>

							<div class="mb-3">
								<label class="form-label">Package Availability</label><br>
								<input type="radio" name="isExist" value="YES" id="u_exist_yes">
								Yes <input type="radio" name="isExist" value="NO"
									id="u_exist_no"> No
							</div>

							<button type="button" id="confirmUpd" class="btn w-100"
								style="background: #009FA5; color: white;">Update</button>

						</form>
					</div>

				</div>
			</div>
		</div>
	</div>




	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

	<script>
	document.addEventListener("DOMContentLoaded", function () {

	    // ---------------- Package Search ----------------
	    document.getElementById('package-search').addEventListener('input', function () {
	        const filter = this.value.toLowerCase();
	        document.querySelectorAll('.package-card').forEach(card => {
	            const name = card.querySelector('strong').innerText.toLowerCase();
	            card.style.display = name.includes(filter) ? 'flex' : 'none';
	        });
	    });

	    // ---------------- Update Modal ----------------
	    const updateModalEl = document.getElementById('updateModal');
	    const updateModal = bootstrap.Modal.getOrCreateInstance(updateModalEl);

	    updateModalEl.addEventListener('show.bs.modal', function (event) {
	        const button = event.relatedTarget;

	        document.getElementById('u_packageID').value = button.dataset.id;
	        document.getElementById('u_packageName').value = button.dataset.name;
	        document.getElementById('u_packagePrice').value = button.dataset.price;

	        document.getElementById('u_bfr_yes').checked = button.dataset.bfr === 'YES';
	        document.getElementById('u_bfr_no').checked  = button.dataset.bfr === 'NO';

	        document.getElementById('u_exist_yes').checked = button.dataset.exist === 'YES';
	        document.getElementById('u_exist_no').checked  = button.dataset.exist === 'NO';
	    });

	    // ---------------- Update Confirmation ----------------
	    const confirmButton = document.getElementById("confirmUpd");
	    const updateForm = document.querySelector("#updateModal form");
	    const contextPath = "${pageContext.request.contextPath}";

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
	            } else {
	                updateModal.hide();
	                window.location.href = contextPath + "/package/PackageController?action=list";
	            }
	        });
	    });

	    // ---------------- Add Modal Validation ----------------
	 // Get the form
	    const form = document.getElementById('addPackageForm');

	    // --- Fields ---
	    const packageName = document.getElementById('packageName');
	    const packagePrice = document.getElementById('packagePrice');
	    const packagePic = document.getElementById('packagePic');
	    const bfrYes = document.getElementById('bfrYes');
	    const bfrNo = document.getElementById('bfrNo');
	    const existYes = document.getElementById('existYes');
	    const existNo = document.getElementById('existNo');

	    // --- Submit Validation ---
	    form.addEventListener('submit', function(event) {
	        let isValid = true;

	        // Package Name
	        if (!packageName.value.trim()) {
	            packageName.parentElement.classList.add('error-active');
	            isValid = false;
	        } else {
	            packageName.parentElement.classList.remove('error-active');
	        }

	        // Price
	        if (!packagePrice.value || packagePrice.value <= 0) {
	            packagePrice.parentElement.classList.add('error-active');
	            isValid = false;
	        } else {
	            packagePrice.parentElement.classList.remove('error-active');
	        }

	        // Picture
	        if (!packagePic.value) {
	            packagePic.parentElement.classList.add('error-active');
	            isValid = false;
	        } else {
	            packagePic.parentElement.classList.remove('error-active');
	        }

	        // Fasting Radio
	        if (!bfrYes.checked && !bfrNo.checked) {
	            bfrYes.parentElement.classList.add('error-active');
	            isValid = false;
	        } else {
	            bfrYes.parentElement.classList.remove('error-active');
	        }

	        // Exist Radio
	        if (!existYes.checked && !existNo.checked) {
	            existYes.parentElement.classList.add('error-active');
	            isValid = false;
	        } else {
	            existYes.parentElement.classList.remove('error-active');
	        }

	        // Prevent submission if invalid
	        if (!isValid) {
	            event.preventDefault();
	            event.stopPropagation();
	        }
	    });

	    // --- Live Remove Error on Input ---
	    packageName.addEventListener('input', function() {
	        if (packageName.value.trim() !== '') {
	            packageName.parentElement.classList.remove('error-active');
	        }
	    });

	    packagePrice.addEventListener('input', function() {
	        if (packagePrice.value && packagePrice.value > 0) {
	            packagePrice.parentElement.classList.remove('error-active');
	        }
	    });

	    packagePic.addEventListener('change', function() {
	        if (packagePic.value) {
	            packagePic.parentElement.classList.remove('error-active');
	        }
	    });

	    [bfrYes, bfrNo].forEach(radio => {
	        radio.addEventListener('change', function() {
	            if (bfrYes.checked || bfrNo.checked) {
	                bfrYes.parentElement.classList.remove('error-active');
	            }
	        });
	    });

	    [existYes, existNo].forEach(radio => {
	        radio.addEventListener('change', function() {
	            if (existYes.checked || existNo.checked) {
	                existYes.parentElement.classList.remove('error-active');
	            }
	        });
	    });


	});

</script>
</body>
</html>
