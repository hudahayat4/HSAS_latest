package Result;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import appointment.appointment;
import util.ConnectionManager;

public class ResultDAO {
	public static appointment getAppointment(int appointmentID) {
		appointment apt = null;
		String sql = "SELECT a.*, c.custName, p.packageName, p.packagePrice, s.name AS staffName "
				+ "FROM appointment a " + "JOIN customer c ON a.cusID = c.cusID "
				+ "JOIN package p ON a.packageID = p.packageID " + "JOIN staff s ON a.staffID = s.staffID "
				+ "WHERE a.appointmentID = ?";

		try (Connection conn = ConnectionManager.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, appointmentID);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					apt = new appointment();
					apt.setAppointmentID(rs.getInt("appointmentID"));
					apt.setApptDate(rs.getDate("apptDate"));
					apt.setApptTime(rs.getTimestamp("apptTime"));

					// Set additional fields for viewapt.jsp
					apt.setCustomerName(rs.getString("custName"));
					apt.setPackageName(rs.getString("packageName"));
					apt.setPackagePrice(rs.getDouble("packagePrice"));
					apt.setPharmacistName(rs.getString("staffName"));
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return apt;
	}

	

	public static int addResult(Result result) {
	    String sql = "INSERT INTO result (resultDate, resultComment, appointmentID) VALUES (?, ?, ?)";
	    
	    try (Connection con = ConnectionManager.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) { // No need for RETURN_GENERATED_KEYS here
	        
	        ps.setDate(1, result.getResultDate());
	        ps.setString(2, result.getResultComment());
	        ps.setInt(3, result.getAppointmentId());
	        
	        int rows = ps.executeUpdate();

	        if (rows > 0) {
	            // WORKAROUND: Manually get the last inserted ID
	            // Be careful: This grabs the absolute latest ID in the table. 
	            // In high-traffic apps, this might grab someone else's ID, but for now it will work.
	            try (PreparedStatement ps2 = con.prepareStatement("SELECT MAX(resultID) FROM result");
	                 ResultSet rs = ps2.executeQuery()) {
	                if (rs.next()) {
	                    return rs.getInt(1);
	                }
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return -1;
	}
	
	public static void addUricAcidResult(UricAcid uric) {
	    // Note: We are inserting 'resultID' manually.
	    // We assume 'resultID' is the PK and FK in this table.
	    String sql = "INSERT INTO uricacid (resultID, uricLevelRange, riskIndicator) VALUES (?, ?, ?)";
	    
	    try (Connection con = ConnectionManager.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        
	        // 🔴 THIS IS THE LINK
	        // We take the ID we set in the controller and push it to the DB
	        ps.setInt(1, uric.getResultId()); 
	        
	        ps.setString(2, uric.getUricLevelRange());
	        ps.setString(3, uric.getRiskIndicator());
	        
	        ps.executeUpdate();
	        System.out.println("Uric Acid result added successfully for ID: " + uric.getResultId());
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}

	public static void addHBA1cResult(HBA1C hba) {
	    // SQL: resultID is inserted manually (PK & FK)
	    String sql = "INSERT INTO hba1c (resultID, diabetesRiskLevel, hBa1cThreshold) VALUES (?, ?, ?)";
	    
	    try (Connection con = ConnectionManager.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        
	        // 1. LINK: Set the ID (This ID comes from the parent Result table)
	        ps.setInt(1, hba.getResultId()); 
	        
	        // 2. Set other fields
	        ps.setString(2, hba.getDiabetesRiskLevel());
	        ps.setDouble(3, hba.getHBa1cTreShold());
	        
	        ps.executeUpdate();
	        System.out.println("HBA1c result added successfully for ID: " + hba.getResultId());
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}

	public static void addLipidResult(Lipid lipid) {
	    // SQL: resultID is inserted manually (PK & FK)
	    String sql = "INSERT INTO lipid (resultID, hdlCholesterol, ldlCholesterol, lipidPanelDetails) VALUES (?, ?, ?, ?)";
	    
	    try (Connection con = ConnectionManager.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        
	        // 1. LINK: Set the ID
	        ps.setInt(1, lipid.getResultId());
	        
	        // 2. Set other fields
	        ps.setDouble(2, lipid.getHdlCholesterol());
	        ps.setDouble(3, lipid.getLdlCholesterol());
	        ps.setString(4, lipid.getLipidPanelDetails());
	        
	        ps.executeUpdate();
	        System.out.println("Lipid result added successfully for ID: " + lipid.getResultId());
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}



	public static List<appointment> getAllResult(int cusID)  throws SQLException{
		// TODO Auto-generated method stub
		List<appointment> appointments = new ArrayList<>();
		String sql = "SELECT a.*, p.packageName,c.custName FROM appointment a "
				+ "JOIN package p ON a.packageID = p.packageID " + "JOIN customer c ON a.cusID = c.cusID "
				+ "WHERE a.cusID = ? AND a.apptTime < CURRENT_TIMESTAMP ORDER BY a.apptDate DESC";

		try (Connection conn = ConnectionManager.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, cusID);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				appointment apt = new appointment();
				apt.setAppointmentID(rs.getInt("appointmentID"));
				apt.setApptDate(rs.getDate("apptDate"));
				apt.setApptTime(rs.getTimestamp("apptTime"));
				apt.setPackageName(rs.getString("packageName"));
				apt.setCustomerName(rs.getString("custName"));
				appointments.add(apt);
			}
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return appointments;
	}
	
	public static Result getResultByAppointmentId(int appointmentID) {
	    Result result = null;

	    String query =
	        "SELECT " +
	        "r.resultID, r.resultDate, r.resultComment, " +
	        "a.appointmentID, a.apptDate, a.apptTime, s.name AS pharmacistName, " +
	        "p.packageName, " +
	        "u.UricLevelRange, u.riskIndicator, " +
	        "l.hdlCholesterol, l.ldlCholesterol, l.lipidPanelDetails, " +
	        "h.diabetesRiskLevel, h.hba1cThreshold " +
	        "FROM result r " +
	        "JOIN appointment a ON r.appointmentID = a.appointmentID " +
	        "JOIN package p ON a.packageID = p.packageID " +
	        "JOIN staff s ON a.staffID = s.staffID " +
	        "LEFT JOIN UricAcid u ON r.resultID = u.resultID " +
	        "LEFT JOIN lipid l ON r.resultID = l.resultID " +
	        "LEFT JOIN HbA1c h ON r.resultID = h.resultID " +
	        "WHERE r.appointmentID = ?";

	    try (Connection conn = ConnectionManager.getConnection();
	         PreparedStatement ps = conn.prepareStatement(query)) {

	        ps.setInt(1, appointmentID);

	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {

	                result = new Result();
	                result.setResultId(rs.getInt("resultID"));
	                result.setAppointmentId(rs.getInt("appointmentID"));
	                result.setResultDate(rs.getDate("resultDate"));
	                result.setResultComment(rs.getString("resultComment"));

	                // ===== Create Appointment object =====
	               appointment apt = new appointment();
	                apt.setAppointmentID(rs.getInt("appointmentID"));
	                apt.setApptDate(rs.getDate("apptDate"));
	                apt.setApptTime(rs.getTimestamp("apptTime"));
	                apt.setPharmacistName(rs.getString("pharmacistName")); // matches alias in query
	                apt.setPackageName(rs.getString("packageName"));
	                result.setApt(apt);

	                // ===== Optional children =====
	                if (rs.getObject("uricLevelRange") != null) {
	                    UricAcid ua = new UricAcid();
	                    ua.setResultId(result.getResultId());
	                    ua.setResultDate(result.getResultDate());
	                    ua.setResultComment(result.getResultComment());
	                    ua.setUricLevelRange(rs.getString("UricLevelRange"));
	                    ua.setRiskIndicator(rs.getString("riskIndicator"));
	                    result.setUricacid(ua);
	                }

	                if (rs.getObject("hdlCholesterol") != null) {
	                    Lipid lipid = new Lipid();
	                    lipid.setResultId(result.getResultId());
	                    lipid.setResultDate(result.getResultDate());
	                    lipid.setResultComment(result.getResultComment());
	                    lipid.setHdlCholesterol(rs.getDouble("hdlCholesterol"));
	                    lipid.setLdlCholesterol(rs.getDouble("ldlCholesterol"));
	                    lipid.setLipidPanelDetails(rs.getString("lipidPanelDetails"));
	                    result.setLipid(lipid);
	                }

	                if (rs.getObject("hba1cThreshold") != null) {
	                    HBA1C hba1c = new HBA1C();
	                    hba1c.setResultId(result.getResultId());
	                    hba1c.setResultDate(result.getResultDate());
	                    hba1c.setResultComment(result.getResultComment());
	                    hba1c.setHBa1cTreShold(rs.getDouble("hba1cThreshold"));
	                    hba1c.setDiabetesRiskLevel(rs.getString("diabetesRiskLevel"));
	                    result.setHba1c(hba1c);
	                }
	            }
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return result;
	}

}
