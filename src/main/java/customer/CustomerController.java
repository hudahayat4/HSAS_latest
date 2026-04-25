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

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;

@WebServlet("/account/CustomerController")
@MultipartConfig(maxFileSize = 10485760)
public class CustomerController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public CustomerController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		try {

			if ("view".equals(action)) {
				viewaccount(request, response);
			} else if ("edit".equals(action)) {
				updateaccount(request, response);
			} else if("image".equals(action)) {
				showImage(request,response);
			} else {
				response.sendRedirect(request.getContextPath() + "/log_in.jsp");
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

	    response.setContentType("image/jpeg");

	    if (img != null && img.length > 0) {
	        response.getOutputStream().write(img);
	    } else {
	        // load default image from server
	        String defaultPath = request.getServletContext()
	                .getRealPath("/image/blank-profile-picture.png");

	        FileInputStream fis = new FileInputStream(defaultPath);

	        byte[] buffer = new byte[fis.available()];
	        fis.read(buffer);
	        fis.close();

	        response.getOutputStream().write(buffer);
	    }

	    response.getOutputStream().flush();
	}

	private void updateaccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession(false);

		// 1. Ambil ID dari session (siapa yang tengah login)
		int cusID = (int) session.getAttribute("cusID");

		// 2. TERUS panggil DAO. Tak perlu buat 'new customer()' sendiri.
		// DAO akan pulangkan objek customer yang lengkap dengan data dari DB.
		Customer c = CustomerDAO.getCustomerById(cusID);

		// 3. Simpan objek tadi untuk kegunaan JSP
		request.setAttribute("customer", c);

		// 4. Pergi ke page edit (Guna forward, jangan lupa .forward)
		request.getRequestDispatcher("updateaccount.jsp").forward(request, response);
	}

	private void viewaccount(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("cusID") == null) {
			response.sendRedirect(request.getContextPath() + "/log_in.jsp");
			return;
		}
		int cusID = (int) session.getAttribute("cusID");
		Customer c = CustomerDAO.getCustomerById(cusID);

		if (c == null) {
			response.sendRedirect(request.getContextPath() + "/log_in.jsp");
			return;
		}

		request.setAttribute("customer", c);
		RequestDispatcher dispatcher = request.getRequestDispatcher("viewaccount.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String action = request.getParameter("action");

	    try { // TRY BESAR BERMULA SINI
	        if ("createAccount".equals(action)) {
	            createAccount(request, response);
	        } 
	        else if ("updateAccount".equals(action)) {
	            HttpSession session = request.getSession();
	            int cusID = (int) session.getAttribute("cusID");

	            Customer c = new Customer();
	            c.setCusID(cusID);
	            c.setCusNRIC(request.getParameter("cusNRIC"));
	            c.setCustPhoneNo(request.getParameter("custPhoneNo"));
	            c.setCustEmail(request.getParameter("custEmail"));

	            CustomerDAO.updateprofile(c);
	            response.sendRedirect("CustomerController?action=view&status=success");
	        } 
	        else if ("changePassword".equals(action)) {
	            HttpSession session = request.getSession();
	            Integer customerId = (Integer) session.getAttribute("cusID");

	            if (customerId == null) {
	                response.sendRedirect("login.jsp");
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
	                    response.sendRedirect("CustomerController?action=view&status=mismatch");
	                }
	            } else {
	                response.sendRedirect("CustomerController?action=view&status=wrongpass");
	            }
	        } else if ("requestCode".equals(action)) {
                requestCode(request, response);
            } else if ("confirmCode".equals(action)) {
                confirmCode(request, response);
            }
	        
	    } catch (Exception e) { // PENUTUP TRY BESAR
	        e.printStackTrace();
	        throw new ServletException(e);
	    } 
	} // PENUTUP METHOD DOPOST

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
	        // Semak saiz fail di server (10MB)
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

	// Method helper untuk hantar error balik ke JSP
	private void sendError(HttpServletRequest request, HttpServletResponse response, String message) 
	        throws ServletException, IOException {
	    request.setAttribute("alertMessage", message);
	    request.setAttribute("alertType", "danger");
	    request.getRequestDispatcher("create_account.jsp").forward(request, response);
	}
	
//BAHAGIAN BAWAH NI SEMUA BERKAITAN DENGAN VERIFY ACCOUNT
	//Request Code
    private void requestCode(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        
        Customer cust = (Customer) request.getSession().getAttribute("tempCustomer");
        
        if (cust == null) {
            request.setAttribute("alertMessage", "Session expired. Please register again.");
            request.setAttribute("alertType", "danger");
            RequestDispatcher rd = request.getRequestDispatcher("verifyAccount.jsp");
            rd.forward(request, response);
            return;
        }

        String email = cust.getCustEmail();

        VerifyService service = new VerifyService();
        String resultMessage = service.generateAndSendCode(email);
        request.setAttribute("alertMessage", resultMessage);
        request.setAttribute("alertType", "success");

        RequestDispatcher rd = request.getRequestDispatcher("verifyAccount.jsp");
        rd.forward(request, response);
    }


    //Confirm Code
    private void confirmCode(HttpServletRequest request, HttpServletResponse response) 
    		throws SQLException, IOException, ServletException {
        
        Customer cust = (Customer) request.getSession().getAttribute("tempCustomer");
        
        if (cust == null) {
            System.out.println("TempCustomer is NULL in confirmCode");
            request.setAttribute("alertMessage", "Session expired. Please register again.");
            request.setAttribute("alertType", "danger");
            RequestDispatcher rd = request.getRequestDispatcher("/account/verifyAccount.jsp");
            rd.forward(request, response);
            return;
        } else {
            System.out.println("TempCustomer email (confirmCode): " + cust.getCustEmail());
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
            RequestDispatcher rd = request.getRequestDispatcher("/account/verifyAccount.jsp");
            rd.forward(request, response);
        }
    }
}
