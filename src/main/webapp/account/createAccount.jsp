<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Juzcare Pharmacy - Create Account</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="../css/stylesheet.css">
</head>
<body>
    <section class="bg-light p-3 p-md-4 p-xl-5 min-vh-100 d-flex align-items-center bg-cover">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-12 col-md-8 col-lg-6">
            <div class="card border-light-subtle shadow-sm">
                <div class="card-body p-3 p-md-4 p-xl-5">
                    <h2 class="h4 text-center mb-4">Create Account</h2>                   
                    <p class="mb-4 text-secondary text-center">Already registered? <a href="log_in.jsp" class="link-primary text-decoration-none">Log in</a></p>
                    
                    <form action="CustomerController" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="createAccount">
                        
                        <div class="row gy-3 overflow-hidden">
							<div class="col-12">
							  <label for="custUsername" class="form-label">Username</label>
							  <input type="text" class="form-control mb-3" name="custUsername" id="custUsername" placeholder="Enter your username" required>
							</div>
                          
                          <div class="col-12">
						  	<label for="custPassword" class="form-label">Password</label>
						  	<div class="input-group mb-3">
						    	<input type="password" class="form-control" name="custPassword" id="custPassword" placeholder="Enter your password" required>
						    	<span class="input-group-text" id="togglePassword" style="cursor: pointer;">
						      		<i class="bi bi-eye-fill" id="eyeIcon"></i>
						    	</span>
						  	</div>
						  </div>

                          <div class="col-12">
                            <div class="d-grid">
                              <button class="btn btn-dark btn-lg" type="submit">Create Account</button>
                            </div>
                          </div>
                          
                          <div class="col-12">
                            <div class="d-grid">
                              <button class="btn btn-outline-clear btn-lg" type="reset">Clear Form</button>
                            </div>
                          </div>
                        </div>
                      </form>
                </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    
	<script>
	  document.addEventListener("DOMContentLoaded", function() {
	    const passwordInput = document.getElementById("custPassword");
	    const togglePassword = document.getElementById("togglePassword");
	    const eyeIcon = document.getElementById("eyeIcon");
	
	    togglePassword.addEventListener("click", function () {
	      const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
	      passwordInput.setAttribute("type", type);
	
	      if (type === "text") {
	        eyeIcon.classList.remove("bi-eye-slash-fill");
	        eyeIcon.classList.add("bi-eye-fill");
	      } else {
	        eyeIcon.classList.remove("bi-eye-fill");
	        eyeIcon.classList.add("bi-eye-slash-fill");
	      }
	    });
	  });
	</script>
  
</body>
</html>
