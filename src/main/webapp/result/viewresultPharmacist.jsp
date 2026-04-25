<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Result</title>

<link rel="stylesheet" href="../css/sideStaff.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="../css/viewresult.css">
</head>

<body>
<div class="wrapper">
    <%@ include file="../sidePharmacist.jsp"%>

    <div class="main-content px-3">
        
        <div class="result-header d-flex justify-content-between align-items-center">
            <div>
                <h2 class="mb-0 fw-bold">Test Result</h2>
                <p class="mb-0 opacity-75">Patient Medical Record</p>
            </div>
            <i class="bi bi-file-earmark-medical display-5"></i>
        </div>

        <div class="content-card">
            
            <div class="section-title">
                <i class="bi bi-calendar-check"></i> Appointment Details
            </div>
            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="label-text">Appointment Date</div>
                    <div class="value-text">
                        <fmt:formatDate value="${apt.apptDate}" pattern="dd/MM/yyyy"/>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="label-text">Appointment Time</div>
                    <div class="value-text">
                        <fmt:formatDate value="${apt.apptTime}" pattern="HH:mm"/>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="label-text">Pharmacist</div>
                    <div class="value-text">${apt.pharmacistName}</div>
                </div>
            </div>

            <hr class="my-4 opacity-25">

            <div class="section-title">
                <i class="bi bi-clipboard2-pulse"></i> ${apt.packageName} Details
            </div>
            
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="label-text">Result Date</div>
                    <div class="value-text">
                        <fmt:formatDate value="${result.resultDate}" pattern="dd/MM/yyyy"/>
                    </div>
                </div>
            </div>

            <div class="row g-3">
                <c:choose>
                    <c:when test="${apt.packageName == 'Uric Acid'}">
                        <div class="col-md-6">
                            <div class="result-tile">
                                <div class="label-text">Risk Indicator</div>
                                <span class="badge fs-6 mt-2 px-3 py-2
                                    ${result.uricacid.riskIndicator == 'High' ? 'bg-danger' :
                                      result.uricacid.riskIndicator == 'Medium' ? 'bg-warning text-dark' :
                                      'bg-success'}">
                                    ${result.uricacid.riskIndicator}
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="result-tile">
                                <div class="label-text">Uric Level</div>
                                <div class="value-text mt-2">${result.uricacid.uricLevelRange}</div>
                            </div>
                        </div>
                    </c:when>

                    <c:when test="${apt.packageName == 'Lipid'}">
                        <div class="col-md-4">
                            <div class="result-tile">
                                <div class="label-text">HDL Cholesterol</div>
                                <div class="value-text mt-1 text-success">${result.lipid.hdlCholesterol}</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="result-tile">
                                <div class="label-text">LDL Cholesterol</div>
                                <div class="value-text mt-1 text-danger">${result.lipid.ldlCholesterol}</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="result-tile">
                                <div class="label-text">Details</div>
                                <div class="value-text mt-1">${result.lipid.lipidPanelDetails}</div>
                            </div>
                        </div>
                    </c:when>

                    <c:when test="${apt.packageName == 'HBA1c'}">
                        <div class="col-md-6">
                            <div class="result-tile">
                                <div class="label-text">Diabetes Risk</div>
                                <div class="value-text mt-1">${result.hba1c.diabetesRiskLevel}</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="result-tile">
                                <div class="label-text">HBA1c Threshold</div>
                                <div class="value-text mt-1">${result.hba1c.HBa1cTreShold}</div>
                            </div>
                        </div>
                    </c:when>
                </c:choose>
            </div>

            <div class="mt-5">
                <div class="label-text mb-2">Comment</div>
                <div class="comment-box">
                    ${result.resultComment}
                </div>
            </div>

            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/appointment/AppointmentController?action=listStaff" class="btn btn-custom" style="background-color: #17a2b8; color: white;">
                    <i class="bi bi-arrow-left me-2"></i>Back
                </a>
            </div>

        </div>
    </div>
</div>

</body>
</html>