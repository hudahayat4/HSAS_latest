package Result;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

import appointment.appointment;

/**
 * Servlet implementation class resultController
 */
@WebServlet("/result/resultController")
public class resultController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public resultController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String action = request.getParameter("action");

	    try {
	        if (action == null) {
	            viewForm(request, response);
	            return;
	        }

	        switch (action) {
	        	case "view":
	        		viewResult(request, response);
	        		break;
	            case "list":
	                listResult(request, response);
	                break;
	            case "viewMore":
	            	viewMore(request,response);
	            	break;
	            default:
	                viewForm(request, response);
	                break;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}


	private void viewMore(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {

	    String appointmentIdStr = request.getParameter("appointmentID");

	    if (appointmentIdStr != null) {
	        int appointmentID = 0;
	        try {
	            appointmentID = Integer.parseInt(appointmentIdStr);
	        } catch (NumberFormatException e) {
	            response.sendRedirect("resultController?action=list");
	            return;
	        }

	        // Call DAO
	        Result result = ResultDAO.getResultByAppointmentId(appointmentID);

	        if (result != null) {
	            // Set Appointment object for JSP
	            request.setAttribute("apt", result.getApt());
	            // Also set full Result object
	            request.setAttribute("result", result);

	            request.getRequestDispatcher("/result/viewresult.jsp").forward(request, response);
	        } else {
	            response.sendRedirect("resultController?action=list");
	        }

	    } else {
	        response.sendRedirect("resultController?action=list");
	    }
	}



	private void viewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String appointmentIdStr = request.getParameter("appointmentID");

	    if (appointmentIdStr != null) {
	        int appointmentID = 0;
	        try {
	            appointmentID = Integer.parseInt(appointmentIdStr);
	            appointment apt = ResultDAO.getAppointment(appointmentID);
	            // Set Appointment object for JSP
	            request.setAttribute("apt", apt);

	            request.getRequestDispatcher("/result/createResult.jsp").forward(request, response);
	        } catch (NumberFormatException e) {
	            response.sendRedirect("${pageContext.request.contextPath}/appointment/appointmentController?action=listStaff");
	            return;
	        }
	    }
	}

	

	private void listResult(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
		// TODO Auto-generated method stub
		Integer customerID = (Integer) request.getSession().getAttribute("cusID");
		if(customerID != null)
		{

			List<appointment> appointments = ResultDAO.getAllResult(customerID);
			
			request.setAttribute("appointments", appointments);
			request.getRequestDispatcher("/result/listresult.jsp").forward(request, response);
		}
	}
	
	private void viewResult(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String appointmentIdStr = request.getParameter("appointmentID");

	    if (appointmentIdStr != null) {
	        int appointmentID = 0;
	        try {
	            appointmentID = Integer.parseInt(appointmentIdStr);
	        } catch (NumberFormatException e) {
	            response.sendRedirect("resultController?action=gincu");
	            return;
	        }

	        // Call DAO
	        Result result = ResultDAO.getResultByAppointmentId(appointmentID);

	        if (result != null) {
	            // Set Appointment object for JSP
	            request.setAttribute("apt", result.getApt());
	            // Also set full Result object
	            request.setAttribute("result", result);

	            request.getRequestDispatcher("/result/viewresultPharmacist.jsp").forward(request, response);
	        } else {
	            response.sendRedirect("resultController?action=list");
	        }

	    } else {
	        response.sendRedirect("resultController?action=list");
	    }
	}
	
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		createResult(request,response);
		
	}

	private void createResult(HttpServletRequest request, HttpServletResponse response) {
	    try {
	        // 1. Get appointment ID
	        int appointmentID = Integer.parseInt(request.getParameter("appointmentID"));

	        appointment apt = ResultDAO.getAppointment(appointmentID);
	        String packageName = apt.getPackageName();
	        // 2. Create parent Result

	        Date date = Date.valueOf(request.getParameter("date"));
	        String comment = request.getParameter("comment");

	        Result result = new Result();
	        result.setAppointmentId(appointmentID);
	        result.setResultDate(date);
	        result.setResultComment(comment);

	        // Save Result and get generated ID
	        int generatedResultID = ResultDAO.addResult(result);
	        if (generatedResultID == -1) {
	            System.out.println("Failed to save result");
	            return;
	        }

	        // 3. Save child based on package
	        switch (packageName) {
	            case "Uric Acid":
	                UricAcid uric = new UricAcid();
	                uric.setResultId(generatedResultID);
	                uric.setRiskIndicator(request.getParameter("riskIndicator"));
	                uric.setUricLevelRange(request.getParameter("uricLevelRange"));
	                ResultDAO.addUricAcidResult(uric);
	                break;

	            case "HBA1c":
	                HBA1C hba = new HBA1C();
	                hba.setResultId(generatedResultID);
	                hba.setDiabetesRiskLevel(request.getParameter("diabetes"));
	                hba.setHBa1cTreShold(Double.parseDouble(request.getParameter("threshold")));
	                ResultDAO.addHBA1cResult(hba);
	                break;

	            case "Lipid":
	                Lipid lipid = new Lipid();
	                lipid.setResultId(generatedResultID);
	                lipid.setHdlCholesterol(Double.parseDouble(request.getParameter("hdl")));
	                lipid.setLdlCholesterol(Double.parseDouble(request.getParameter("ldl")));
	                lipid.setLipidPanelDetails(request.getParameter("details"));
	                ResultDAO.addLipidResult(lipid);
	                break;
	        }

	        response.sendRedirect(request.getContextPath() + "/appointment/AppointmentController?action=listStaff");

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
	
	
}
