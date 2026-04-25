package staff;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import customer.Customer;
import customer.CustomerDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/teamaccount/StaffController")
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
			default:
				response.sendRedirect("log_in.jsp");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new ServletException(e);
		}
	}

	private void listStaffAccount(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
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
			request.setAttribute("staff", s); // <--- SANGAT PENTING untuk paparkan data kat form
			request.getRequestDispatcher("updateStaffAccount.jsp").forward(request, response);
		} else {
			response.sendRedirect("log_in.jsp");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String action = request.getParameter("action");
		
		// --- LOGIK 1: UPDATE PROFILE ---
		if ("updateProfile".equals(action)) {
			try {
				HttpSession session = request.getSession(false);
				Integer staffID = (session != null) ? (Integer) session.getAttribute("staffID") : null;

				if (staffID != null) {
					Staff s = new Staff();
					s.setStaffID(staffID);
					s.setPhoneNo(request.getParameter("PhoneNo"));
					s.setEmail(request.getParameter("email"));

					StaffDAO.updateStaffProfile(s);
					response.sendRedirect("StaffController?action=view&status=success");
					return;
				}
			} catch (Exception e) {
				e.printStackTrace();
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Update failed");
				return;
			}
		}else if ("changePassword".equals(action)) {
			try {
				HttpSession session = request.getSession(false);
				Integer staffID = (session != null) ? (Integer) session.getAttribute("staffID") : null;

				String newPass = request.getParameter("newPassword");
				String confirmPass = request.getParameter("confirmPassword");

				if (staffID != null && newPass != null && newPass.equals(confirmPass)) {
					boolean success = StaffDAO.updatePassword(staffID, newPass);
					if (success) {
						response.sendRedirect("StaffController?action=view&status=passwordUpdated");
					} else {
						response.sendRedirect("StaffController?action=view&status=error");
					}
				} else {
					response.sendRedirect("StaffController?action=view&status=mismatch");
				}
				return;
			} catch (Exception e) {
				e.printStackTrace();
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Password change failed");
				return;
			}
		}

		// --- LOGIK 3: CREATE ACCOUNT (Kod asal anda) ---
		try {
			createStaffAccount(request, response);
			response.sendRedirect(request.getContextPath() + "/log_in.jsp?status=success");
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
			throws IOException, ServletException, SQLException {
		System.out.print("Connected");
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
		InputStream inputStream = null;
		if (filePart != null) {
			inputStream = filePart.getInputStream();
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
		staff.setProfilePic(inputStream);
		staff.setManagerID(loggedInStaffID);

		StaffDAO.createStaffAccount(staff);
	}

}