<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="util.ConnectionManager" %> <%-- 1. CHANGE THIS TO YOUR ACTUAL PACKAGE --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Initialize variables
    int totalCustomers = 0;
    int totalPackagesCount = 0;
    List<Map<String, String>> availablePackages = new ArrayList<>();

    try (Connection conn = ConnectionManager.getConnection()) {
        
        // 2. Query: Total Customer Count
        String sqlCust = "SELECT COUNT(cusID) FROM customer";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sqlCust)) {
            if (rs.next()) totalCustomers = rs.getInt(1);
        }

        // 3. Query: Total Package Count
        String sqlPkgCount = "SELECT COUNT(packageID) FROM package";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sqlPkgCount)) {
            if (rs.next()) totalPackagesCount = rs.getInt(1);
        }

        // 4. Query: List Available Packages (isExist = 'YES')
        String sqlList = "SELECT * FROM package WHERE isExist = 'YES'";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sqlList)) {
            while (rs.next()) {
                Map<String, String> pkg = new HashMap<>();
                pkg.put("id", rs.getString("packageID"));
                pkg.put("name", rs.getString("packageName")); // CHECK: Actual column name in DB
                pkg.put("price", rs.getString("packagePrice")); // CHECK: Actual column name in DB
                availablePackages.add(pkg);
            }
        }

        // Pass data to the HTML section
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalPackagesCount", totalPackagesCount);
        request.setAttribute("availablePackages", availablePackages);

    } catch (SQLException e) {
        e.printStackTrace(); // Log error to console
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Package Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../css/sideStaff.css">

    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .stat-card { border: none; border-left: 5px solid; border-radius: 10px; }
        .border-customer { border-left-color: #4e73df !important; }
        .border-package { border-left-color: #1cc88a !important; }
        .card-title-custom { font-size: 0.8rem; font-weight: bold; color: #858796; text-transform: uppercase; }
    </style>
</head>
<body>

<div class="wrapper d-flex">
    <%@ include file="../sideStaff.jsp"%>

    <main class="flex-grow-1 px-md-4 py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3">Dashboard</h1>
            <span class="badge bg-white text-dark border p-2 shadow-sm">
                <i class="bi bi-calendar3 me-1"></i> January 2026
            </span>
        </div>

        <div class="row">
            <div class="col-xl-6 col-md-6 mb-4">
                <div class="card stat-card border-customer shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col">
                                <div class="card-title-custom mb-1">Total Customers</div>
                                <div class="h4 mb-0 fw-bold text-gray-800">${totalCustomers}</div>
                            </div>
                            <div class="col-auto">
                                <i class="bi bi-person-plus-fill fa-2x text-primary fs-2"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-6 col-md-6 mb-4">
                <div class="card stat-card border-package shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col">
                                <div class="card-title-custom mb-1">Total Packages</div>
                                <div class="h4 mb-0 fw-bold text-gray-800">${totalPackagesCount}</div>
                            </div>
                            <div class="col-auto">
                                <i class="bi bi-box-fill text-success fs-2"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow mb-4">
            <div class="card-header py-3 bg-white d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-primary">Available Packages (Live)</h6>
               <a href="${pageContext.request.contextPath}/package/PackageController?action=list">
   					 <button type="button" class="btn btn-sm btn-outline-primary">
        				View More
    				</button>
				</a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Package ID</th>
                                <th>Name</th>
                                <th>Monthly Price</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pkg" items="${availablePackages}">
                                <tr>
                                    <td><code>PKG-0${pkg.id}</code></td>
                                    <td class="fw-bold">${pkg.name}</td>
                                    <td>RM ${pkg.price}</td>
                                    <td>
                                        <span class="badge bg-success-subtle text-success border border-success">
                                            Available
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty availablePackages}">
                                <tr>
                                    <td colspan="4" class="text-center py-3 text-muted">No packages currently available.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>