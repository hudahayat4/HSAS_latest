package Result;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import Package.DynamicField;
import Package.Package;
import appointment.appointment;
import jakarta.servlet.http.HttpServletRequest;
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
	        "a.appointmentID, a.apptDate, a.apptTime, " +
	        "s.name AS pharmacistName, " +
	        "p.packageName " +
	        "FROM result r " +
	        "JOIN appointment a ON r.appointmentID = a.appointmentID " +
	        "JOIN package p ON a.packageID = p.packageID " +
	        "JOIN staff s ON a.staffID = s.staffID " +
	        "WHERE r.appointmentID = ?";

	    try (
	        Connection conn = ConnectionManager.getConnection();
	        PreparedStatement ps = conn.prepareStatement(query)
	    ) {

	        ps.setInt(1, appointmentID);

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {

	            result = new Result();

	            result.setResultId(rs.getInt("resultID"));
	            result.setAppointmentId(rs.getInt("appointmentID"));
	            result.setResultDate(rs.getDate("resultDate"));
	            result.setResultComment(rs.getString("resultComment"));

	            appointment apt = new appointment();

	            apt.setAppointmentID(rs.getInt("appointmentID"));
	            apt.setApptDate(rs.getDate("apptDate"));
	            apt.setApptTime(rs.getTimestamp("apptTime"));
	            apt.setPharmacistName(rs.getString("pharmacistName"));
	            apt.setPackageName(rs.getString("packageName"));

	            result.setApt(apt);

	            Map<String, String> packageValues =
	                    getPackageResultValues(
	                            result.getResultId(),
	                            apt.getPackageName());

	            System.out.println("PACKAGE VALUES = " + packageValues);

	            result.setPackageValues(packageValues);
	            
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return result;
	}
	
	
	public static Map<String, String> getPackageResultValues(
	        int resultID,
	        String packageName) {

	    Map<String, String> values = new LinkedHashMap<>();

	    String tableName = packageName.replaceAll("\\s+", "");

	    String sql = "SELECT * FROM " + tableName + " WHERE RESULTID = ?";

	    System.out.println("==============================");
	    System.out.println("TABLE = " + tableName);
	    System.out.println("RESULT ID = " + resultID);
	    System.out.println("SQL = " + sql);

	    try (
	        Connection conn = ConnectionManager.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql)
	    ) {

	        ps.setInt(1, resultID);

	        ResultSet rs = ps.executeQuery();

	        ResultSetMetaData meta = rs.getMetaData();

	        if (rs.next()) {

	            for (int i = 1; i <= meta.getColumnCount(); i++) {

	                String columnName = meta.getColumnName(i);
	                String value = rs.getString(i);

	                values.put(columnName, value);
	            }

	        } else {
	            System.out.println("NO DATA FOUND");
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }


	    System.out.println("PACKAGE VALUES = " + values);

	    return values;
	}

	public static List<DynamicField> getPackageColumns(
	        String packageName) {

	    List<DynamicField> fields =
	            new ArrayList<>();

	    String tableName =
	            packageName.replaceAll("\\s+", "");

	    String sql =
	            "SELECT * FROM " + tableName + " WHERE 1=0";

	    try (
	        Connection conn =
	                ConnectionManager.getConnection();

	        PreparedStatement ps =
	                conn.prepareStatement(sql);

	        ResultSet rs =
	                ps.executeQuery()
	    ) {

	        ResultSetMetaData meta =
	                rs.getMetaData();

	        for(int i = 1;
	            i <= meta.getColumnCount();
	            i++) {

	            String columnName =
	                    meta.getColumnName(i);

	            String columnType =
	                    meta.getColumnTypeName(i);

	            if(!columnName.equalsIgnoreCase("resultID")) {

	                fields.add(
	                    new DynamicField(
	                        columnName,
	                        columnType));
	            }
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    }

	    return fields;
	}



	public static void savePackageResult(
	        int resultID,
	        String packageName,
	        HttpServletRequest request) {

	    String tableName = packageName.replaceAll("\\s+", "");

	    try (Connection conn = ConnectionManager.getConnection()) {

	        String sqlMeta =
	                "SELECT * FROM " + tableName + " WHERE 1=0";

	        PreparedStatement metaPs =
	                conn.prepareStatement(sqlMeta);

	        ResultSet rs =
	                metaPs.executeQuery();

	        ResultSetMetaData meta =
	                rs.getMetaData();

	        StringBuilder columns =
	                new StringBuilder("resultID");

	        StringBuilder placeholders =
	                new StringBuilder("?");

	        List<String> values =
	                new ArrayList<>();

	        for (int i = 1; i <= meta.getColumnCount(); i++) {

	            String columnName = meta.getColumnName(i);

	            if (columnName.equalsIgnoreCase("RESULTID"))
	                continue;

	            columns.append(",").append(columnName);
	            placeholders.append(",?");

	            String value = request.getParameter(columnName);

	            System.out.println("COLUMN = " + columnName);
	            System.out.println("VALUE = " + value);

	            values.add(value);
	        }

	        String sql =
	                "INSERT INTO " + tableName +
	                " (" + columns + ")" +
	                " VALUES (" + placeholders + ")";

	        PreparedStatement ps =
	                conn.prepareStatement(sql);

	        ps.setInt(1, resultID);

	        for (int i = 0; i < values.size(); i++) {
	            ps.setString(i + 2, values.get(i));
	        }
	        

	        ps.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

}
