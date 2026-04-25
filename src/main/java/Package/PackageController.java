package Package;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.annotation.MultipartConfig;
import java.io.InputStream;

/**
 * Servlet implementation class PackageController
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
@WebServlet("/package/PackageController")
public class PackageController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public PackageController() {
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

			switch (action) {

			case "image":
				showImage(request, response);
				return; // VERY IMPORTANT

			case "list":
				listPackage(request, response);
				return;

			case "view":
				listAvailablePackage(request, response);
				return;

			case "edit":
				showEditForm(request, response);
				return;
			case "viewPackage":
				listPackageManager(request,response);
			default:
				listPackage(request, response);
				return;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void listPackageManager(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		List<Package> packages = PackageDAO.getAvailablePackage();

		// Ensure packages is never null
		if (packages == null) {
			packages = new ArrayList<>();
		}

		request.setAttribute("packages", packages);
		request.getRequestDispatcher("/package/viewpackageManager.jsp").forward(request, response);
	}

	private void showImage(HttpServletRequest request, HttpServletResponse response) throws Exception {

		int id = Integer.parseInt(request.getParameter("id"));
		byte[] img = PackageDAO.getPackageImage(id);

		if (img != null) {
			response.setContentType("image/jpeg");
			response.getOutputStream().write(img);
		}
	}

	private void listAvailablePackage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		List<Package> packages = PackageDAO.getAvailablePackage();

		// Ensure packages is never null
		if (packages == null) {
			packages = new ArrayList<>();
		}

		request.setAttribute("packages", packages);
		request.getRequestDispatcher("/package/viewpackageCus.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
//		doGet(request,response);
		String packageID = request.getParameter("packageID");

		try {
			if (packageID == null || packageID.isEmpty()) {
				addPackage(request, response);
			} else {
				updatePackage(request, response);

			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// LIST all package
	private void listPackage(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		// TODO Auto-generated method stub
		List<Package> packages = PackageDAO.getAllPackage();

		// Ensure packages is never null
		if (packages == null) {
			packages = new ArrayList<>();
		}

		request.setAttribute("packages", packages);
		request.getRequestDispatcher("/package/viewpackageStaff.jsp").forward(request, response);

		// if (staffID != null) {
		// request.getRequestDispatcher("viewpackageStaff.jsp").forward(request,
		// response);
		// } else request.getRequestDispatcher("viewpackage.jsp").forward(request,
		// response);
	}

	// SHOW edit form for a package
	private void showEditForm(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {

		int packageID = Integer.parseInt(request.getParameter("packageID"));
		// Get the package to be edited
		Package selectedPackage = PackageDAO.getPackagebyId(packageID);
		// Get ALL packages for default listing)
		List<Package> packages = PackageDAO.getAllPackage();
		// ensure list is never null
		if (packages == null) {
			packages = new ArrayList<>();
		}
		request.setAttribute("packages", packages); // for package list
		request.setAttribute("selectedPackage", selectedPackage); // optional (if needed)
		RequestDispatcher dispatcher = request.getRequestDispatcher("/package/viewpackageStaff.jsp");
		dispatcher.forward(request, response);
	}

	// ADD a new package
	private void addPackage(HttpServletRequest request, HttpServletResponse response)
			throws IOException, SQLException, ServletException {
		// TODO Auto-generated method stub
		String packageName = request.getParameter("packageName");
		Part filePart = request.getPart("packagePic");
		InputStream inputStream = null;
		if (filePart != null) {
			inputStream = filePart.getInputStream();
		}
		Double packagePrice = Double.parseDouble(request.getParameter("packagePrice"));
		String bfrReq = request.getParameter("bfrReq");
		String isExist = request.getParameter("isExist");

		Package packages = new Package();
		packages.setPackageName(packageName);
		packages.setPackagePic(inputStream);
		packages.setPackagePrice(packagePrice);
		packages.setBfrReq(bfrReq);
		packages.setIsExist(isExist);

		PackageDAO.addPackage(packages);
		HttpSession session = request.getSession();
		session.setAttribute("message", "Package added successfully!");
		response.sendRedirect("PackageController?action=list");

	}

	// UPDATE an existing package
	private void updatePackage(HttpServletRequest request, HttpServletResponse response)
			throws IOException, SQLException, ServletException {

		int packageID = Integer.parseInt(request.getParameter("packageID"));
		String packageName = request.getParameter("packageName");
		double packagePrice = Double.parseDouble(request.getParameter("packagePrice"));
		String bfrReq = request.getParameter("bfrReq");
		String isExist = request.getParameter("isExist");

		Part filePart = request.getPart("packagePic");
		InputStream inputStream = (filePart != null && filePart.getSize() > 0) ? filePart.getInputStream() : null;

		Package p = new Package();
		p.setPackageID(packageID);
		p.setPackageName(packageName);
		p.setPackagePrice(packagePrice);
		p.setBfrReq(bfrReq);
		p.setIsExist(isExist);
		p.setPackagePic(inputStream);

		PackageDAO.updatePackage(p);

		response.sendRedirect("PackageController?action=list");	
	}
}
