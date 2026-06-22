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

public class StaffDAO {

    // Login Staff - Fixed to assign raw byte[] array
    public static Staff loginStaff(Staff staff) {
        Staff result = null;
        String query = "SELECT staffID, NRIC, managerID, name, PhoneNo, DOB, email, role, profilePic " +
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
                    result.setUsername(staff.getUsername()); 
                    
                    // Fixed: Directly pass the byte array stream allocation
                    result.setProfilePic(rs.getBytes("profilePic"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // Create Account - Fixed to insert raw BLOB bytes smoothly
    public static void createStaffAccount(Staff staff) throws SQLException, IOException {
        String nric = staff.getNRIC();
        if (nric == null || nric.isEmpty()) {
            throw new IllegalArgumentException("NRIC cannot be null or empty");
        }

        String query = "INSERT INTO JuzCare.staff(NRIC, managerID, name, phoneNo, username, password, DOB, profilePic, email, role) VALUES (?,?,?,?,?,?,?,?,?,?)";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, staff.getNRIC());
            ps.setInt(2, staff.getManagerID());
            ps.setString(3, staff.getName());
            ps.setString(4, staff.getPhoneNo());
            ps.setString(5, staff.getUsername());
            ps.setString(6, staff.getPassword());
            ps.setDate(7, staff.getDOB());

            // Fixed: Set raw byte sequence into the database mapping matrix
            byte[] profilePicData = staff.getProfilePic();
            if (profilePicData != null && profilePicData.length > 0) {
                ps.setBytes(8, profilePicData);
            } else {
                ps.setNull(8, java.sql.Types.BLOB);
            }

            ps.setString(9, staff.getEmail());
            ps.setString(10, staff.getRole());

            ps.executeUpdate();
        }
    }

    // Get Single Staff Entity - Fixed to assign raw byte[] array
    public static Staff getStaffById(int id) {
        Staff staff = null;
        String sql = "SELECT * FROM staff WHERE staffID = ?";
        
        try (Connection conn = ConnectionManager.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staff = new Staff();
                    staff.setStaffID(rs.getInt("staffID"));
                    staff.setName(rs.getString("name"));
                    staff.setEmail(rs.getString("email"));
                    staff.setPhoneNo(rs.getString("phoneNo"));
                    staff.setDOB(rs.getDate("DOB"));
                    staff.setNRIC(rs.getString("NRIC"));
                    staff.setRole(rs.getString("role"));
                    
                    // Fixed: Map BLOB directly to byte[] property arrays
                    staff.setProfilePic(rs.getBytes("profilePic"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staff;
    }

    // NEW HELPER: Fetch ONLY image bytes for rendering actions on your JSPs
    public static byte[] getProfilePicByID(int id) {
        byte[] imageBytes = null;
        String sql = "SELECT profilePic FROM staff WHERE staffID = ?";
        
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    imageBytes = rs.getBytes("profilePic");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return imageBytes;
    }

    public static void updateStaffProfileFull(Staff s) throws SQLException {
        // If a new profile picture is uploaded, update it. Otherwise, keep the old one.
        boolean hasNewPic = (s.getProfilePic() != null && s.getProfilePic().length > 0);
        String sql = hasNewPic 
            ? "UPDATE staff SET name = ?, phoneNo = ?, email = ?, DOB = ?, NRIC = ?, profilePic = ? WHERE staffID = ?"
            : "UPDATE staff SET name = ?, phoneNo = ?, email = ?, DOB = ?, NRIC = ? WHERE staffID = ?";
        
        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, s.getName());
            ps.setString(2, s.getPhoneNo());
            ps.setString(3, s.getEmail());
            ps.setDate(4, s.getDOB());
            ps.setString(5, s.getNRIC());
            
            if (hasNewPic) {
                ps.setBytes(6, s.getProfilePic());
                ps.setInt(7, s.getStaffID());
            } else {
                ps.setInt(6, s.getStaffID());
            }
            
            ps.executeUpdate();
        }
    }
    
    public static boolean verifyPassword(int staffID, String hashedPassword) {
        String sql = "SELECT * FROM staff WHERE staffID = ? AND password = ?";
        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, staffID);
            ps.setString(2, hashedPassword);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
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
        String query = "SELECT * FROM staff";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Staff s = new Staff();
                s.setStaffID(rs.getInt("staffID"));
                s.setName(rs.getString("name"));
                s.setRole(rs.getString("role"));
                s.setEmail(rs.getString("email"));
                s.setPhoneNo(rs.getString("phoneNo"));
                staffList.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }

    // ================= VALIDATION METHODS =================
    public static boolean isEmailExists(String email) throws Exception {
        String sql = "SELECT 1 FROM staff WHERE email = ?";
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public static boolean isPhoneExists(String phone) throws Exception {
        String sql = "SELECT 1 FROM staff WHERE phoneNo = ?";
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public static boolean isNameExists(String name) throws Exception {
        String sql = "SELECT 1 FROM staff WHERE name = ?";
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }   
}