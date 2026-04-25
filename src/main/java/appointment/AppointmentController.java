package appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.ConnectionManager;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import Package.Package;
import Package.PackageDAO;
import appointment.SendNotificationService;

/**
 * Servlet implementation class AppointmentController
 */
@WebServlet("/appointment/AppointmentController")
public class AppointmentController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AppointmentController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");

		try {
			switch (action) {
			case "package":
				listAvailablePackage(request, response);
				break;
			case "image":
				showImage(request, response);
				break;
			case "view":
				viewAppointment(request, response); // <--- TAMBAH INI
				break;
			case "list":
				listAppointment(request, response);
				break;
			case "cancel":
				cancelAppointment(request, response);
				break;
			case "listStaff":
				listAppointmentStaff(request, response);
				break;
			default:
				listAppointment(request, response);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void listAppointmentStaff(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		Integer staffID = (Integer) request.getSession().getAttribute("staffID");

		if (staffID != null) {

			List<appointment> appointments = AppointmentDAO.getAllAppointmentsByStaffId(staffID);
			request.setAttribute("appointments", appointments);
			request.getRequestDispatcher("/appointment/listaptStaff.jsp").forward(request, response);
		} else {
			response.sendRedirect("../log_in.jsp");
		}
	}

	private void viewAppointment(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String apptIdStr = request.getParameter("appointmentID");

		if (apptIdStr != null) {
			int appointmentID = Integer.parseInt(apptIdStr);
			appointment apt = AppointmentDAO.getAppointmentById(appointmentID);

			if (apt != null) {
				request.setAttribute("apt", apt);
				request.getRequestDispatcher("/appointment/viewapt.jsp").forward(request, response);
			} else {
				response.sendRedirect("AppointmentController?action=list"); // No appointment found
			}

		} else {
			response.sendRedirect("AppointmentController?action=list"); // No ID provided
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		String appointmentID = request.getParameter("appointmentID");
		if (appointmentID == null || appointmentID.isEmpty()) {
			try {
				bookAppointment(request, response);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	private void bookAppointment(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {

		Integer loggedInCustomerID = (Integer) request.getSession().getAttribute("cusID");
		if (loggedInCustomerID == null) {
			throw new ServletException("Customer not logged in!");
		}
		int customerID;
		try {
			customerID = Integer.parseInt(loggedInCustomerID.toString());
		} catch (NumberFormatException e) {
			throw new ServletException("Invalid customerID in session", e);
		}
		String packageIDStr = request.getParameter("packageId");
		if (packageIDStr == null || packageIDStr.isEmpty()) {
			throw new ServletException("No package selected!");
		}
		int packageID;
		try {
			packageID = Integer.parseInt(packageIDStr);
		} catch (NumberFormatException e) {
			throw new ServletException("Invalid packageID format", e);
		}
		String apptDateStr = request.getParameter("apptDate");
		String apptTimeStr = request.getParameter("apptTime");

		if (apptDateStr == null || apptTimeStr == null || apptDateStr.isEmpty() || apptTimeStr.isEmpty()) {
			throw new ServletException("Appointment date or time not selected!");
		}

		Date apptDate;
		Timestamp apptTime;
		try {
			apptDate = Date.valueOf(apptDateStr); // yyyy-MM-dd
			apptTime = Timestamp.valueOf(apptDateStr + " " + apptTimeStr + ":00"); // yyyy-MM-dd HH:mm:ss
		} catch (IllegalArgumentException e) {
			throw new ServletException("Invalid date or time format", e);
		}

		String custEmail = request.getParameter("custEmail");

		List<Integer> staffIDs = new ArrayList<>();
		String sqlStaff = "SELECT staffID FROM staff WHERE role='PHARMACIST'";
		try (Connection conn = ConnectionManager.getConnection();
				PreparedStatement ps = conn.prepareStatement(sqlStaff);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				staffIDs.add(rs.getInt("staffID"));
			}
		}

		if (staffIDs.isEmpty()) {
			throw new ServletException("No staff available!");
		}

		int staffID = staffIDs.get(new Random().nextInt(staffIDs.size()));

		appointment appt = new appointment();
		appt.setCustomerID(customerID);
		appt.setPackageID(packageID);
		appt.setStaffID(staffID);
		appt.setApptDate(apptDate);
		appt.setApptTime(apptTime);
		appt.setCustomerEmail(custEmail);
		AppointmentDAO.bookAppointment(appt);

		// UNTUK TESTING SEND NOTIFICATION
		// SendNotificationService service = new SendNotificationService();
		// service.sendTwoDaysReminder("aqillghaz@gmail.com", "2026-01-19", "19:10");

		response.sendRedirect("AppointmentController?action=list");
	}

	private void showImage(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		byte[] img = AppointmentDAO.getPackageImage(id);

		if (img != null) {
			response.setContentType("image/jpeg");
			response.getOutputStream().write(img);
		}

	}

	private void listAppointment(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, SQLException {
		// 1. Ambil ID customer dari session
		Integer customerID = (Integer) request.getSession().getAttribute("cusID");

		if (customerID != null) {

			List<appointment> appointments = AppointmentDAO.getAllAppointmentsByCustomerId(customerID);
			request.setAttribute("appointments", appointments);
			request.getRequestDispatcher("/appointment/listapt.jsp").forward(request, response);
		} else {
			response.sendRedirect("../log_in.jsp");
		}
	}

	private void listAvailablePackage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		List<Package> packages = AppointmentDAO.getPackageAvailable();

		if (packages == null) {
			packages = new ArrayList<>();
		}

		request.setAttribute("packages", packages);
		request.getRequestDispatcher("/appointment/bookAppointment.jsp").forward(request, response);
	}

	private void cancelAppointment(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, IOException {
		// TODO Auto-generated method stub
		int appointmentID = Integer.parseInt(request.getParameter("appointmentID"));
		AppointmentDAO.cancelAppointment(appointmentID);
		System.out.println("Booking canceled successfully.");
		response.sendRedirect("AppointmentController?action=list");
	}

}
