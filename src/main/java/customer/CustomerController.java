package customer;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;

@WebServlet("/account/CustomerController")
@MultipartConfig(maxFileSize =  5242880)
public class CustomerController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public CustomerController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		try {
			if ("view".equals(action) || "setting".equals(action) || "viewAccount".equals(action)) {
				viewaccount(request, response);
				return;
			} else if ("edit".equals(action)) {
				updateaccount(request, response);
				return;
			} else if("image".equals(action)) {
				showImage(request,response);
				return;
			} else {
				response.sendRedirect(request.getContextPath() + "/log_in.jsp");
				return;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServletException(ex);
		}
	}

	private void showImage(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, IOException {

		int id = Integer.parseInt(request.getParameter("id"));
		byte[] img = CustomerDAO.getCustomerImage(id);

		if (img != null) {
			response.setContentType("image/jpeg");
			response.getOutputStream().write(img);
		}
	}

	private void updateaccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession(false);
		int cusID = (int) session.getAttribute("cusID");

		Customer c = CustomerDAO.getCustomerById(cusID);
		request.setAttribute("customer", c);

		request.getRequestDispatcher("updateaccount.jsp").forward(request, response);
	}

	private void viewaccount(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		
		HttpSession session = request.getSession(false);
		
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/log_in.jsp");
			return;
		}
		
		Object idObj = session.getAttribute("cusID"); 
		if (idObj == null) {
			idObj = session.getAttribute("custID"); 
		}
		
		if (idObj == null) {
			response.sendRedirect(request.getContextPath() + "/log_in.jsp");
			return;
		}

		try {
			int custID = Integer.parseInt(idObj.toString().trim());
			Customer customer = CustomerDAO.getCustomerById(custID);

			if (customer == null) {
				customer = new Customer();
				customer.setCusID(custID);
				customer.setCustName("User " + custID);
				customer.setCustEmail("No Email Provided");
			}

			request.setAttribute("customer", customer);
			RequestDispatcher dispatcher = request.getRequestDispatcher("viewaccount.jsp");
			dispatcher.forward(request, response);
			return;
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new ServletException("Ralat Sebenar Di Dalam viewaccount: " + e.getMessage(), e);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");

		try {
			if ("createAccount".equals(action)) {
				createAccount(request, response);
			} 
			else if ("updateAccount".equals(action)) {
				HttpSession session = request.getSession(false);
				if (session == null || session.getAttribute("cusID") == null) {
					response.sendRedirect(request.getContextPath() + "/log_in.jsp");
					return;
				}

				String cusIDStr = session.getAttribute("cusID").toString();
				int cusID = Integer.parseInt(cusIDStr.trim());

				// Email validation
				String custEmail = request.getParameter("custEmail");
				if (custEmail == null || !custEmail.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
					response.sendRedirect("CustomerController?action=edit&status=invalidemail");
					return;
				}
				
				String custName = request.getParameter("custName");
				if (custName == null || !custName.matches("[a-zA-Z\\s]+")) {
					response.sendRedirect("CustomerController?action=edit&status=invalidname");
					return;
				}
				
				// BAHAGIAN UPDATE YANG DAH DIBETULKAN & BERSIH
				Customer c = new Customer();
				c.setCusID(cusID);
				c.setCustName(custName);
				c.setCusNRIC(request.getParameter("cusNRIC"));  // ← correct
				c.setCustPhoneNo(request.getParameter("custPhoneNo")); 
				c.setCustEmail(custEmail);

				Part filePart = request.getPart("profilePic");
				if (filePart != null && filePart.getSize() > 0) {
					c.setCustProfilePic(filePart.getInputStream());
				}

				CustomerDAO.updateprofile(c);
				response.sendRedirect("CustomerController?action=view&status=success");
				return;
			} 
			else if ("changePassword".equals(action)) {
				HttpSession session = request.getSession(false);
				Integer customerId = (Integer) session.getAttribute("cusID");

				if (session == null || session.getAttribute("cusID") == null) {
					response.sendRedirect(request.getContextPath() + "/login.jsp");
					return;
				}

				String currentPass = request.getParameter("currentPassword");
				String newPass = request.getParameter("newPassword");
				String confirmPass = request.getParameter("confirmPassword");

				Customer c = CustomerDAO.getCustomerById(customerId);

				// --- 1. ADJUST PASSWORD JADI HASH (MD5) ---
				java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
				md.update(currentPass.getBytes());
				byte[] byteData = md.digest();
				StringBuilder sb = new StringBuilder();
				for (byte b : byteData) {
					sb.append(Integer.toString((b & 0xff) + 0x100, 16).substring(1));
				}
				String hashedCurrent = sb.toString();

				if (c != null && c.getCustPassword().equals(hashedCurrent)) {
					if (newPass != null && newPass.equals(confirmPass)) {
						// --- 2. HASH PASSWORD BARU ---
						md.reset();
						md.update(newPass.getBytes());
						byte[] newByteData = md.digest();
						StringBuilder sbNew = new StringBuilder();
						for (byte b : newByteData) {
							sbNew.append(Integer.toString((b & 0xff) + 0x100, 16).substring(1));
						}
						CustomerDAO.updatePassword(customerId, sbNew.toString());
						response.sendRedirect("CustomerController?action=view&status=passwordUpdated");
					} else {
						// Mismatch
						response.sendRedirect("CustomerController?action=view&status=mismatch");
					}
				} else {
					// Wrong password
					response.sendRedirect("CustomerController?action=view&status=wrongpass");
				}
			} else if ("requestCode".equals(action)) {
				requestCode(request, response);
			} else if ("confirmCode".equals(action)) {
				confirmCode(request, response);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new ServletException(e);
		} 
	}

	private void createAccount(HttpServletRequest request, HttpServletResponse response) 
	        throws IOException, ServletException {

	    // 1. Ambil Parameter
	    String cusNRIC = request.getParameter("cusNRIC");
	    String custName = request.getParameter("custName");
	    String custEmail = request.getParameter("custEmail");
	    String dobStr = request.getParameter("DOB");
	    String custPhoneNo = request.getParameter("custPhoneNo");
	    String custUsername = request.getParameter("custUsername");
	    String custPassword = request.getParameter("custPassword");

	    // 2. SERVER-SIDE VALIDATION
	    // Memastikan IC hanya nombor dan tepat 12 digit jika JS dipintas
	    if (cusNRIC == null || !cusNRIC.matches("\\d{12}")) {
	        sendError(request, response, "Invalid IC Number. Must be 12 digits.");
	        return;
	    }
	    
	    // Memastikan Nama tidak mengandungi nombor
	    if (custName == null || !custName.matches("[a-zA-Z\\s]+")) {
	        sendError(request, response, "Invalid Name. Letters only.");
	        return;
	    }

	    java.sql.Date dob = java.sql.Date.valueOf(dobStr);

	    // 3. PROSES IMEJ
	    Part filePart = request.getPart("custProfilePic");
	    InputStream inputStream = null;
	    if (filePart != null && filePart.getSize() > 0) {
	        // Semak saiz fail di server (5MB)
	        if (filePart.getSize() > 10 * 1024 * 1024) {
	            sendError(request, response, "File size too large. Maximum 10MB.");
	            return;
	        }
	        inputStream = filePart.getInputStream();
	    }

	    // 4. HASH PASSWORD (MD5)
	    String hashedPassword = null;
	    try {
	        java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
	        md.update(custPassword.getBytes());
	        byte[] byteData = md.digest();
	        StringBuilder sb = new StringBuilder();
	        for (byte b : byteData) {
	            sb.append(Integer.toString((b & 0xff) + 0x100, 16).substring(1));
	        }
	        hashedPassword = sb.toString();
	    } catch (java.security.NoSuchAlgorithmException e) {
	        e.printStackTrace();
	    }

	    // 5. SET DATA PADA OBJECT
	    Customer cust = new Customer();
	    cust.setCusNRIC(cusNRIC);
	    cust.setCustName(custName);
	    cust.setCustEmail(custEmail);
	    cust.setDOB(dob);
	    cust.setCustPhoneNo(custPhoneNo);
	    cust.setCustUsername(custUsername);
	    cust.setCustPassword(hashedPassword);
	    cust.setCustProfilePic(inputStream);

	    // 6. SIMPAN KE DATABASE
	    try {
	    	// Check duplicate username
	        if (CustomerDAO.isUsernameExist(cust.getCustUsername())) {
	            request.setAttribute("usernameError", "Username already exists");
	            request.getRequestDispatcher("register.jsp").forward(request, response);
	            return;
	        }

	        // Check duplicate IC
	        if (CustomerDAO.isICExist(cust.getCusNRIC())) {
	            request.setAttribute("icError", "IC Number already exists");
	            request.getRequestDispatcher("register.jsp").forward(request, response);
	            return;
	        }

	        // Check duplicate Email
	        if (CustomerDAO.isEmailExist(cust.getCustEmail())) {
	            request.setAttribute("emailError", "Email already exists");
	            request.getRequestDispatcher("register.jsp").forward(request, response);
	            return;
	        }
	        
	        //Kalau semua okay, simpan ke DB
	        CustomerDAO.createAccount(cust);
	        System.out.println("createAccount → Account created in DB: " + cust.getCustEmail());
	        
	        // Simpan dalam session untuk kegunaan verifyAccount.jsp
	        request.getSession().setAttribute("tempCustomer", cust);
	        response.sendRedirect(request.getContextPath() + "/account/verifyAccount.jsp");
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        sendError(request, response, "Database error: Failed to create account.");
	    }
	}

	private void sendError(HttpServletRequest request, HttpServletResponse response, String message) 
			throws ServletException, IOException {
		request.setAttribute("alertMessage", message);
		request.setAttribute("alertType", "danger");
		request.getRequestDispatcher("create_account.jsp").forward(request, response);
	}
	
	private void requestCode(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, IOException, ServletException {
		
		Customer cust = (Customer) request.getSession().getAttribute("tempCustomer");
		
		if (cust == null) {
			request.setAttribute("alertMessage", "Session expired. Please register again.");
			request.setAttribute("alertType", "danger");
			request.getRequestDispatcher("verifyAccount.jsp").forward(request, response);
			return;
		}

		String email = cust.getCustEmail();
		VerifyService service = new VerifyService();
		String resultMessage = service.generateAndSendCode(email);
		request.setAttribute("alertMessage", resultMessage);
		request.setAttribute("alertType", "success");

		request.getRequestDispatcher("verifyAccount.jsp").forward(request, response);
	}

	private void confirmCode(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, IOException, ServletException {
		
		Customer cust = (Customer) request.getSession().getAttribute("tempCustomer");
		
		if (cust == null) {
			request.setAttribute("alertMessage", "Session expired. Please register again.");
			request.setAttribute("alertType", "danger");
			request.getRequestDispatcher("/account/verifyAccount.jsp").forward(request, response);
			return;
		}
		
		String code = request.getParameter("verificationCode");
		if (code != null) {
			code = code.trim();
		}

		VerifyService service = new VerifyService();
		boolean valid = service.verifyCode(cust.getCustEmail(), code);

		if (valid) {
			CustomerDAO.markAsVerified(cust.getCustEmail());
			request.getSession().removeAttribute("tempCustomer");
			response.sendRedirect(request.getContextPath() + "/log_in.jsp");
		} else {
			request.setAttribute("alertMessage", "The code is invalid or has expired.");
			request.setAttribute("alertType", "danger");
			request.getRequestDispatcher("/account/verifyAccount.jsp").forward(request, response);
		}
	}
}