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

import Package.DynamicField;
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

	        int appointmentID;

	        try {
	            appointmentID = Integer.parseInt(appointmentIdStr);
	        } catch (NumberFormatException e) {

	            request.getSession().setAttribute(
	                "errorMessage",
	                "Result is not available yet."
	            );

	            response.sendRedirect("resultController?action=list");
	            return;
	        }

	        // Check whether result exists
	        Result result = ResultDAO.getResultByAppointmentId(appointmentID);

	        if (result != null) {

	            request.setAttribute("apt", result.getApt());
	            request.setAttribute("result", result);

	            request.getRequestDispatcher("/result/viewresult.jsp")
	                   .forward(request, response);

	        } else {

	            request.getSession().setAttribute(
	                "errorMessage",
	                "Result is not available yet."
	            );


	            response.sendRedirect("resultController?action=list");
	        }

	    } else {

	        request.getSession().setAttribute(
	            "errorMessage",
	            "Result is not available yet."
	        );

	        response.sendRedirect("resultController?action=list");
	    }
	}



	private void viewForm(HttpServletRequest request,
	        HttpServletResponse response)
	        throws ServletException, IOException {

	    String appointmentIdStr =
	            request.getParameter("appointmentID");

	    if (appointmentIdStr != null) {

	        try {

	            int appointmentID =
	                    Integer.parseInt(appointmentIdStr);

	            appointment apt =
	                    ResultDAO.getAppointment(appointmentID);

	            List<DynamicField> fields =
	                    ResultDAO.getPackageColumns(
	                            apt.getPackageName());
	            
	            for (DynamicField field : fields) {
	                field.setFieldLabel(DynamicField.formatFieldName(field.getFieldName()));
	            }

	            request.setAttribute("apt", apt);
	            request.setAttribute("fields", fields);

	            request.getRequestDispatcher(
	                    "/result/createResult.jsp")
	                    .forward(request, response);

	        } catch (NumberFormatException e) {
	            e.printStackTrace();
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
	
	private void viewResult(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String appointmentIdStr = request.getParameter("appointmentID");

	    if (appointmentIdStr != null) {

	        int appointmentID;

	        try {
	            appointmentID = Integer.parseInt(appointmentIdStr);
	        } catch (NumberFormatException e) {

	            request.getSession().setAttribute(
	                "errorMessage",
	                "Result is not available yet."
	            );

	            response.sendRedirect(
	                request.getContextPath()
	                + "/appointment/AppointmentController?action=listStaff"
	            );
	            return;
	        }

	        // Check whether result exists
	        Result result = ResultDAO.getResultByAppointmentId(appointmentID);

	        if (result != null) {

	            request.setAttribute("apt", result.getApt());
	            request.setAttribute("result", result);

	            request.getRequestDispatcher("/result/viewresultPharmacist.jsp")
	                   .forward(request, response);

	        } else {

	            request.getSession().setAttribute(
	                "errorMessage",
	                "Result is not available yet."
	            );

	            response.sendRedirect(
	                request.getContextPath()
	                + "/appointment/AppointmentController?action=listStaff"
	            );
	        }

	    } else {

	        request.getSession().setAttribute(
	            "errorMessage",
	            "Result is not available yet."
	        );

	        response.sendRedirect(
	            request.getContextPath()
	            + "/appointment/AppointmentController?action=listStaff"
	        );
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

	private void createResult(HttpServletRequest request,
	        HttpServletResponse response) {

	    try {

	        int appointmentID =
	                Integer.parseInt(request.getParameter("appointmentID"));

	        appointment apt =
	                ResultDAO.getAppointment(appointmentID);

	        Date date =
	                Date.valueOf(request.getParameter("date"));

	        String comment =
	                request.getParameter("comment");

	        Result result = new Result();
	        result.setAppointmentId(appointmentID);
	        result.setResultDate(date);
	        result.setResultComment(comment);

	        int resultID = ResultDAO.addResult(result);

	        if(resultID == -1) {
	            return;
	        }

	        ResultDAO.savePackageResult(
	                resultID,
	                apt.getPackageName(),
	                request);
	        
	        request.getSession().setAttribute(
		    	    "successMessage",
		    	    "Result successfully saved!"
		    	);

	        response.sendRedirect(
	                request.getContextPath()
	                + "/appointment/AppointmentController?action=listStaff");

	    } catch(Exception e) {
	        e.printStackTrace();
	    }
	}
	
	
	
}