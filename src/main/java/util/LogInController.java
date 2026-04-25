package util;

import java.io.IOException;
import customer.Customer;
import customer.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import staff.Staff;
import staff.StaffDAO;


@WebServlet("/LogInController")
public class LogInController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LogInController() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("loginCustomer".equals(action)) {
                loginCustomer(request, response);
            } else if ("loginStaff".equals(action)) {
                loginStaff(request, response);
            } else {
                response.sendRedirect("log_in.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
    
    //Log In Customer
    private void loginCustomer(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String username = request.getParameter("custUsername");
        String password = request.getParameter("custPassword");

        Customer cust = new Customer();
        cust.setCustUsername(username);
        cust.setCustPassword(password);

        cust = CustomerDAO.loginCustomer(cust);

        if (cust != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("cusID", cust.getCusID());
            session.setAttribute("custUsername", cust.getCustUsername());
            session.setAttribute("custEmail", cust.getCustEmail());
            response.sendRedirect("dashboard/dashboardCustomer.jsp");
        } else {
            request.setAttribute("errorMsg", "Invalid username or password.");
            request.getRequestDispatcher("log_in.jsp").forward(request, response);
        }
    }


    //Log In Staff
    private void loginStaff(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String username = request.getParameter("staffUsername");
        String password = request.getParameter("staffPassword");

        Staff staff = new Staff();
        staff.setUsername(username);
        staff.setPassword(password);

        staff = StaffDAO.loginStaff(staff);
        if (staff != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("staffID", staff.getStaffID());
            session.setAttribute("staffUsername", staff.getUsername());
            session.setAttribute("staffRole", staff.getRole());
            if ("PHARMACIST".equals(staff.getRole())) {
                response.sendRedirect("dashboard/dashboardPharmacist.jsp");
            } else if ("MANAGER".equals(staff.getRole())) {
                response.sendRedirect("dashboard/dashboardManager.jsp");
            } else {
                response.sendRedirect("dashboard/dashboardStaff.jsp");
            }
        } else {
            request.setAttribute("errorMsg", "Invalid username or password.");
            request.getRequestDispatcher("log_in.jsp").forward(request, response);
        }
    }
}