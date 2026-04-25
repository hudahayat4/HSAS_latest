package staff;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.ConnectionManager;
import util.Password;

import java.io.IOException;
import java.io.InputStream;

public class StaffDAO {
    private static Connection connection = null;

    //Login Staff (JANGAN LUPA UBAH BALIK NANTI)
    public static Staff loginStaff(Staff staff) {
        Staff result = null;
        String query = "SELECT staffID, NRIC, managerID, name, PhoneNo, DOB, email, role " +
                       "FROM staff WHERE username=? AND password=?";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, staff.getUsername());
            ps.setString(2, Password.md5Hash(staff.getPassword()));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    result = new Staff();
                    result.setStaffID(rs.getInt("staffID"));
                    result.setNRIC(rs.getString("NRIC"));
                    result.setManagerID(rs.getInt("managerID"));
                    result.setName(rs.getString("name"));
                    result.setPhoneNo(rs.getString("PhoneNo"));
                    result.setDOB(rs.getDate("DOB"));
                    result.setEmail(rs.getString("email"));
                    result.setRole(rs.getString("role"));
                    result.setUsername(staff.getUsername()); // simpan username asal
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }


    public static void createStaffAccount(Staff staff) throws SQLException, IOException {
        // --- 1️⃣ Generate raw password from NRIC ---
        String nric = staff.getNRIC();
        if (nric == null || nric.isEmpty()) {
            throw new IllegalArgumentException("NRIC cannot be null or empty");
        }

        // --- 3️⃣ Insert staff into database ---
        String query = "INSERT INTO JuzCare.staff(NRIC, managerID, name, phoneNo, username, password, DOB, profilePic, email, role) VALUES (?,?,?,?,?,?,?,?,?,?)";

        connection = ConnectionManager.getConnection();
        PreparedStatement ps = connection.prepareStatement(query);

        ps.setString(1, staff.getNRIC());
        ps.setInt(2, staff.getManagerID());
        ps.setString(3, staff.getName());
        ps.setString(4, staff.getPhoneNo());
        ps.setString(5, staff.getUsername());
        ps.setString(6, staff.getPassword());
        ps.setDate(7, staff.getDOB());

        InputStream profilePicStream = staff.getProfilePic();
        if (profilePicStream != null) {
            ps.setBinaryStream(8, profilePicStream, profilePicStream.available());
        } else {
            ps.setNull(8, java.sql.Types.BLOB);
        }

        ps.setString(9, staff.getEmail());
        ps.setString(10, staff.getRole());

        int rowsInserted = ps.executeUpdate();
        System.out.println("Rows inserted: " + rowsInserted);

        ps.close();
        if (profilePicStream != null) profilePicStream.close();
    }

	public static Staff getStaffById(int staffId) {
		// TODO Auto-generated method stub
		Staff s = null;
		
		String query = "SELECT * FROM staff WHERE staffID = ?";
		try(Connection con = ConnectionManager.getConnection();
			PreparedStatement ps = con.prepareStatement(query)){
				ps.setInt(1, staffId);
				try(ResultSet rs = ps.executeQuery()){
					if(rs.next()) {
						s = new Staff();
						
						s.setName(rs.getString("name"));
						s.setEmail(rs.getString("email"));
						s.setNRIC(rs.getString("NRIC"));
						s.setUsername(rs.getString("username"));
						s.setPassword(rs.getString("password"));
						s.setDOB(rs.getDate("DOB"));
						s.setPhoneNo(rs.getString("PhoneNo"));
						s.setRole(rs.getString("role"));
					}
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
			
			return s;
	}

	public static void updateStaffProfile(Staff s) throws SQLException {
	    // TUKAR: staffPhone -> phoneNo , staffEmail -> email
	    String sql = "UPDATE staff SET phoneNo = ?, email = ? WHERE staffID = ?";
	    
	    try (Connection con = ConnectionManager.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        
	        ps.setString(1, s.getPhoneNo());
	        ps.setString(2, s.getEmail());
	        ps.setInt(3, s.getStaffID());
	        
	        int rowsUpdated = ps.executeUpdate();
	        
	        if (rowsUpdated > 0) {
	            System.out.println("DEBUG: Staff Update SUCCESSFUL for ID: " + s.getStaffID());
	        } else {
	            System.out.println("DEBUG: Staff Update FAILED. No record found for ID: " + s.getStaffID());
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        throw e;
	    }
	}
	
	public static boolean updatePassword(int staffID, String newPassword) {
	    String sql = "UPDATE staff SET password = ? WHERE staffID = ?";
	    try (Connection con = ConnectionManager.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        
	        ps.setString(1, newPassword);
	        ps.setInt(2, staffID);
	        
	        return ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	
	public static List<Staff> getAllStaff() {
	    List<Staff> staffList = new ArrayList<>();

	    try {
	    	String query = "SELECT * FROM staff";
	    	connection = ConnectionManager.getConnection();
	         PreparedStatement ps = connection.prepareStatement(query);
	         ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Staff s = new Staff();
	            s.setStaffID(rs.getInt("staffID"));
	            s.setName(rs.getString("name"));
	            s.setRole(rs.getString("role"));
	            s.setEmail(rs.getString("email"));
	            s.setPhoneNo(rs.getString("phoneNo"));
	            // Tambah field lain jika perlu
	            staffList.add(s);
	        }
	        ps.close();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return staffList;
	}
	
	
}
