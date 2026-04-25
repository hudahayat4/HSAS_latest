<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Juzcare Pharmacy - Create Account</title>
  <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
  <link rel="stylesheet" href="../css/stylesheet.css">
</head>
<body>
<section class="bg-light p-3 p-md-4 p-xl-5 min-vh-100 d-flex align-items-center bg-cover">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-12 col-md-8 col-lg-6">
        <div class="card border-light-subtle shadow-sm">
          <div class="card-body p-3 p-md-4 p-xl-5">
            <h2 class="h4 text-center mb-4">Create an Account</h2>
            <p class="mb-4 text-secondary text-center">
              Already have an account?
              <a href="log_in.jsp" class="link-primary text-decoration-none">Log in</a>
            </p>

            <!-- Register Form -->
            <form id="registrationForm" action="CustomerController" method="post" enctype="multipart/form-data">
              <input type="hidden" name="action" value="createAccount">

              <div class="row gy-3 overflow-hidden">
                <!-- Name -->
                <div class="col-12">
                  <label for="custName" class="form-label">Name</label>
                  <input type="text" class="form-control" name="custName" id="custName" autocomplete="off" required>
                </div>

                <!-- Email -->
                <div class="col-12">
                  <label for="custEmail" class="form-label">Email</label>
                  <input type="email" class="form-control" name="custEmail" id="custEmail" required>
                </div>

                <!-- Phone No -->
                <div class="col-12">
                  <label for="custPhoneNo" class="form-label">Phone No</label>
                  <input type="text" class="form-control" name="custPhoneNo" id="custPhoneNo" placeholder="Example: 0123456789" required>
                </div>

                <!-- Date of Birth -->
                <div class="col-12">
                  <label for="DOB" class="form-label">Date of Birth</label>
                  <input type="date" class="form-control" name="DOB" id="DOB" required>
                </div>

                <!-- IC Number -->
                <div class="col-12">
                  <label for="cusNRIC" class="form-label">IC Number</label>
                  <input type="text" class="form-control" name="cusNRIC" id="cusNRIC" maxlength="12" placeholder="e.g. 990101105050" required>
                </div>

                <!-- Username -->
                <div class="col-12">
                  <label for="custUsername" class="form-label">Username</label>
                  <input type="text" class="form-control" name="custUsername" id="custUsername" required>
                </div>

                <!-- Password -->
                <div class="col-12">
                  <label for="custPassword" class="form-label">Password</label>
                  <div class="input-group">
                    <input type="password" class="form-control" name="custPassword" id="custPassword" 
                    		pattern=".{8,}" title="Minimum 8 characters" required>
                    <span class="input-group-text" id="togglePassword" style="cursor: pointer;">
                      <i class="bi bi-eye-slash-fill" id="eyeIcon"></i>
                    </span>
                  </div>
                </div>

                <!-- Upload Image -->
                <div class="col-12">
                  <label for="custProfilePic" class="form-label">Upload Image</label>
                  <input type="file" class="form-control" id="custProfilePic" name="custProfilePic" accept="image/*">
                  <small class="text-muted">Max file size: 10MB</small>
                </div>

                <!-- Terms -->
                <div class="col-12">
                  <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="iAgree" id="iAgree" required>
                    <label class="form-check-label text-secondary" for="iAgree">
                      I agree to the <a href="#!" class="link-primary text-decoration-none">terms and conditions</a>
                    </label>
                  </div>
                </div>

                <!-- Buttons -->
                <div class="col-12">
                  <div class="d-grid">
                    <button class="btn btn-dark btn-lg" type="submit">Register</button>
                  </div>
                </div>
                <div class="col-12">
                  <div class="d-grid">
                    <button class="btn btn-outline-secondary btn-lg" type="reset">Clear Form</button>
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
<script src="../js/createAccount.js"></script>
</body>
</html>
