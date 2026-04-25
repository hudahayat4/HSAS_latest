<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile | JuzCare</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/updateprofile.css?v=1.2">
    <link rel="stylesheet" href="../css/footer.css">
    <link rel="stylesheet" href="../css/header.css">
</head>
<body>

    <%@ include file="../header.jsp" %>

    <main class="content-wrapper">
    <div class="profile-container">
        <div class="profile-header">
            <div class="user-info">
               <div class="avatar-circle">
                   <img class="me-3"
							src="${(customer.custProfilePic == null || customer.custProfilePic == '') 
                ? pageContext.request.contextPath.concat('/image/blank-profile-picture.png') 
                : pageContext.request.contextPath.concat('/account/AccountController?action=image&id=').concat(customer.custProfilePic)}"
							width="80" height="80"
							style="border-radius: 50%; object-fit: cover;"
							onerror="this.src='${pageContext.request.contextPath}/image/blank-profile-picture.png';">
					</div>
                <div class="name-meta">
                    <h1>${customer.custName}</h1>
                    <p>${customer.custEmail}</p>
                </div>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/account/CustomerController" method="POST">
            <input type="hidden" name="action" value="updateAccount">
            
            <div class="form-grid">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" value="${customer.custName}" readonly class="locked-field">
                </div>

                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" name="custPhoneNo" value="${customer.custPhoneNo}" class="editable-field" required>
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="custEmail" value="${customer.custEmail}" class="editable-field" required>
                </div>

                <jsp:useBean id="now" class="java.util.Date" />
				<fmt:formatDate var="currentYear" value="${now}" pattern="yyyy" />
				<fmt:parseDate var="parsedBirthDate" value="${customer.DOB}"
					pattern="yyyy-MM-dd" />
				<fmt:formatDate var="birthYear" value="${parsedBirthDate}"
					pattern="yyyy" />
				<c:set var="calculatedAge" value="${currentYear - birthYear}" />
				<div class="form-group">
					<label>Age</label> <input type="text" value="${not empty customer.DOB ? calculatedAge : 'N/A'}" readonly
						class="locked-field">
				</div>
				<div class="form-group">
					<label>Date of Birth</label> <input type="text"
						value="<fmt:formatDate value="${customer.DOB}" pattern="dd/MM/yyyy" />" readonly class="locked-field">
				</div>
            
                <div class="form-group">
                    <label>IC Number</label>
                    <input type="text" name="cusNRIC" value="${customer.cusNRIC}" readonly class="locked-field">
                </div>
            </div>

            <div class="btn-save-container">
                <a href="${pageContext.request.contextPath}/account/CustomerController?action=view" class="btn-cancel-link">Cancel</a>
                <button type="submit" class="btn-save-main">Save Changes</button>
            </div>
        </form>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
const updateForm = document.querySelector('form');
if(updateForm) {
    updateForm.onsubmit = function(e) {
        e.preventDefault();
        
        Swal.fire({
            title: 'Confirm Save',
            text: 'Ensure your details are correct before proceeding.',
            icon: 'question',
            iconColor: '#008080',
            showCancelButton: true,
            confirmButtonText: 'Save',
            cancelButtonText: 'Cancel',
            reverseButtons: true,
            
            // Panggil class yang kita buat dalam fail CSS tadi
            customClass: {
                popup: 'my-rounded-popup',
                confirmButton: 'my-confirm-btn',
                cancelButton: 'my-cancel-btn'
            },
            buttonsStyling: false 
        }).then((result) => {
            if (result.isConfirmed) {
                this.submit();
            }
        });
    };
}
</script>

    <%@ include file="../footer.jsp" %>
</body>
</html>