package staff;

import java.io.IOException;
import java.io.OutputStream;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;
import java.sql.Date;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

// Maps to the viewstaffaccount pathway
@WebServlet({"/teamaccount/StaffController", "/account/AccountController"})
@MultipartConfig
public class StaffController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public StaffController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		try {
			switch (action) {
			case "view":
				viewProfileAccount(request, response);
				break;
			case "edit":
				updateProfileAccount(request, response);
				break;
			case "list":
				listStaffAccount(request, response);
				break;
			case "viewMember":
				viewMember(request,response);
				break;
			case "image": // --- ADDED: Renders BLOB images directly to image sources ---
				renderProfileImage(request, response);
				break;
			case "checkEmail": {
			    String email = request.getParameter("email");
			    boolean exists = StaffDAO.isEmailExists(email);
			    response.setContentType("text/plain");
			    response.getWriter().write(exists ? "exists" : "available");
				break; // Fixed missing break statement here
			    }
			case "checkPhone": {
			    String phone = request.getParameter("phone");
			    boolean exists = StaffDAO.isPhoneExists(phone);
			    response.setContentType("text/plain");
			    response.getWriter().write(exists ? "exists" : "available");
			    break;
			}
			case "checkName": {
			    String name = request.getParameter("name");
			    boolean exists = StaffDAO.isNameExists(name);
			    response.setContentType("text/plain");
			    response.getWriter().write(exists ? "exists" : "available");
			    break;
			}
			default:
				response.sendRedirect(request.getContextPath() + "/log_in.jsp");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new ServletException(e);
		}
	}

	private void viewMember(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    try {
	        int targetStaffID = Integer.parseInt(request.getParameter("staffID"));
	        Staff member = StaffDAO.getStaffById(targetStaffID);
	        request.setAttribute("staff", member);
	        request.getRequestDispatcher("/teamaccount/viewStaffdetails.jsp").forward(request, response);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	    }
	}
	// --- ADDED: Helper method to capture and stream image binary content safely ---
	private void renderProfileImage(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    String idParam = request.getParameter("id");
	    if (idParam != null && !idParam.isEmpty()) {
	        try {
	            int id = Integer.parseInt(idParam);
	            byte[] imgBytes = StaffDAO.getProfilePicByID(id);

	            if (imgBytes != null && imgBytes.length > 0) {
	                response.reset(); // Clear any structural headers or whitespace set prior
	                response.setContentType("image/jpeg"); 
	                response.setContentLength(imgBytes.length);
	                
	                try (OutputStream os = response.getOutputStream()) {
	                    os.write(imgBytes);
	                    os.flush();
	                }
	                return; // Gracefully terminate execution for this asset request
	            }
	        } catch (NumberFormatException e) {
	            e.printStackTrace(); // Safely catch any alphanumeric ID parsing slip-ups
	        }
	    }
	    // If execution reaches here, your JSP's onerror attribute seamlessly deploys the grey avatar
	}

	private void listStaffAccount(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Staff> staffList = StaffDAO.getAllStaff();
		request.setAttribute("staffList", staffList);
		request.getRequestDispatcher("/teamaccount/listStaffAccount.jsp").forward(request, response);
	}

	private void updateProfileAccount(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && session.getAttribute("staffID") != null) {
			int staffId = (int) session.getAttribute("staffID");
			Staff s = StaffDAO.getStaffById(staffId);
			request.setAttribute("staff", s); 
			request.getRequestDispatcher("updateStaffAccount.jsp").forward(request, response);
		} else {
			response.sendRedirect(request.getContextPath() + "/log_in.jsp");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		if ("updateProfile".equals(action)) {
		    try {
		        HttpSession session = request.getSession(false);
		        Integer staffID = (session != null) ? (Integer) session.getAttribute("staffID") : null;

		        if (staffID != null) {
		            Staff s = new Staff();
		            s.setStaffID(staffID);
		            s.setName(request.getParameter("name"));
		            s.setPhoneNo(request.getParameter("PhoneNo"));

		            String email = request.getParameter("email");
		            if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
		                response.sendRedirect(request.getContextPath() + "/teamaccount/StaffController?action=edit&status=invalidemail");
		                return;
		            }
		            s.setEmail(email);  // ← use variable

		            s.setDOB(java.sql.Date.valueOf(request.getParameter("DOB")));
		            s.setNRIC(request.getParameter("NRIC"));

		            // Process image upload part safely
		            Part filePart = request.getPart("profilePic");
		            if (filePart != null && filePart.getSize() > 0) {
		                try (InputStream is = filePart.getInputStream();
		                     ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
		                    byte[] buffer = new byte[1024];
		                    int bytesRead;
		                    while ((bytesRead = is.read(buffer)) != -1) {
		                        baos.write(buffer, 0, bytesRead);
		                    }
		                    s.setProfilePic(baos.toByteArray());
		                }
		            }

		            StaffDAO.updateStaffProfileFull(s);
		            response.sendRedirect("StaffController?action=view&status=success");
		            
		            return;
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Update failed");
		        return;
		    }
		
		} else if ("changePassword".equals(action)) {
		    try {
		        HttpSession session = request.getSession(false);
		        Integer staffID = (session != null) ? (Integer) session.getAttribute("staffID") : null;

		        String currentPass = request.getParameter("currentPassword");
		        String newPass = request.getParameter("newPassword");
		        String confirmPass = request.getParameter("confirmPassword");

		        if (staffID == null) {
		            response.sendRedirect("StaffController?action=view&status=error");
		            return;
		        }

		        if (newPass == null || !newPass.equals(confirmPass)) {
		            response.sendRedirect("StaffController?action=view&status=mismatch");
		            return;
		        }

		        // Hash current password
		        String hashedCurrent = null;
		        try {
		            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
		            md.update(currentPass.getBytes());
		            byte[] byteData = md.digest();
		            StringBuilder sb = new StringBuilder();
		            for (byte b : byteData) {
		                sb.append(Integer.toString((b & 0xff) + 0x100, 16).substring(1));
		            }
		            hashedCurrent = sb.toString();
		        } catch (java.security.NoSuchAlgorithmException e) {
		            e.printStackTrace();
		        }

		        // Verify current password
		        boolean currentCorrect = StaffDAO.verifyPassword(staffID, hashedCurrent);
		        if (!currentCorrect) {
		            response.sendRedirect("StaffController?action=view&status=wrongCurrent");
		            return;
		        }

		        // Hash new password
		        String hashedNew = null;
		        try {
		            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
		            md.update(newPass.getBytes());
		            byte[] byteData = md.digest();
		            StringBuilder sb = new StringBuilder();
		            for (byte b : byteData) {
		                sb.append(Integer.toString((b & 0xff) + 0x100, 16).substring(1));
		            }
		            hashedNew = sb.toString();
		        } catch (java.security.NoSuchAlgorithmException e) {
		            e.printStackTrace();
		        }

		        // Update password
		        boolean success = StaffDAO.updatePassword(staffID, hashedNew);
		        if (success) {
		            response.sendRedirect("StaffController?action=view&status=passwordUpdated");
		        } else {
		            response.sendRedirect("StaffController?action=view&status=error");
		        }
		        return;

		    } catch (Exception e) {
		        e.printStackTrace();
		        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Password change failed");
		        return;
		    }
		}

		// CREATE ACCOUNT LOGIC
		try {
		    createStaffAccount(request, response);
		    request.getSession().setAttribute(
		    	    "successMessage",
		    	    "Staff account successfully stored!"
		    	);

		    	response.sendRedirect(
		    	    request.getContextPath() 
		    	    + "/teamaccount/StaffController?action=list"
		    	);
		    return;
		} catch (Exception e) {
		    e.printStackTrace();
		    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Create failed");
		}
	}

	private void viewProfileAccount(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("staffID") == null) {
			response.sendRedirect(request.getContextPath() + "/log_in.jsp");
			return;
		}
		int staffID = (int) session.getAttribute("staffID");
		Staff staff = StaffDAO.getStaffById(staffID);

		if (staff == null) {
			response.sendRedirect(request.getContextPath() + "/log_in.jsp");
			return;
		}

		request.setAttribute("staff", staff);
		RequestDispatcher dispatcher = request.getRequestDispatcher("viewStaffAccount.jsp");
		dispatcher.forward(request, response);
	}

	private void createStaffAccount(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException, Exception {
		String name = request.getParameter("name");
		String phoneNo = request.getParameter("PhoneNo");
		String email = request.getParameter("email");
		Date dob = Date.valueOf(request.getParameter("DOB"));
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String NRIC = request.getParameter("NRIC");
		String role = request.getParameter("role");
		Part filePart = request.getPart("profilePic");
		Integer loggedInStaffID = (Integer) request.getSession().getAttribute("staffID");
		
		// Fixed: Read file part stream down safely into a clean byte[] structure
		byte[] profilePicBytes = null;
		if (filePart != null && filePart.getSize() > 0) {
			try (InputStream is = filePart.getInputStream();
				 ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
				byte[] buffer = new byte[1024];
				int bytesRead;
				while ((bytesRead = is.read(buffer)) != -1) {
					baos.write(buffer, 0, bytesRead);
				}
				profilePicBytes = baos.toByteArray();
			}
		}

		String hashedPassword = null;
		try {
			java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
			md.update(password.getBytes());
			byte[] byteData = md.digest();
			StringBuilder sb = new StringBuilder();
			for (byte b : byteData) {
				sb.append(Integer.toString((b & 0xff) + 0x100, 16).substring(1));
			}
			hashedPassword = sb.toString();
		} catch (java.security.NoSuchAlgorithmException e) {
			e.printStackTrace();
		}

		Staff staff = new Staff();
		staff.setName(name);
		staff.setPhoneNo(phoneNo);
		staff.setEmail(email);
		staff.setDOB(dob);
		staff.setUsername(username);
		staff.setPassword(hashedPassword);
		staff.setNRIC(NRIC);
		staff.setRole(role);
		staff.setProfilePic(profilePicBytes); // Passing updated byte[] format seamlessly
		staff.setManagerID(loggedInStaffID != null ? loggedInStaffID : 0);

		StaffDAO.createStaffAccount(staff);
	}
}