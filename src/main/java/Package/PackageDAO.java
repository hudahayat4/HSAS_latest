package Package;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import java.io.IOException;
import java.io.InputStream;

import util.ConnectionManager;

public class PackageDAO {
	private static Connection connection = null;

	public static void addPackage(Package packages) throws SQLException, IOException {
		System.out.println("DAO: addPackage called"); // <- first line
		String query = "INSERT INTO package(packageName, packagePic, packagePrice, bfrReq, isExist) VALUES (?,?,?,?,?)";

		try (Connection connection = ConnectionManager.getConnection();
				PreparedStatement ps = connection.prepareStatement(query)) {

			ps.setString(1, packages.getPackageName());

			InputStream profilePicStream = packages.getPackagePic();
			if (profilePicStream != null) {
				ps.setBinaryStream(2, profilePicStream, profilePicStream.available());
			} else {
				ps.setNull(2, java.sql.Types.BLOB);
			}

			ps.setDouble(3, packages.getPackagePrice());
			ps.setString(4, packages.getBfrReq());
			ps.setString(5, packages.getIsExist());

			int rows = ps.executeUpdate();
			System.out.println(rows + " row(s) inserted successfully.");
		}
	}
	public static byte[] getPackageImage(int id) throws SQLException {
	    byte[] image = null;

	    String sql = "SELECT packagePic FROM package WHERE packageID=?";
	    try (Connection conn = ConnectionManager.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, id);
	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            image = rs.getBytes("packagePic");
	        }
	    }
	    return image;
	}

	//SELECT - get all bookings

	public static List<Package> getAllPackage()  throws SQLException{
		// TODO Auto-generated method stub
		List<Package> packages = new ArrayList<>();
		
		try{
			String query = "SELECT * FROM package";
			connection = ConnectionManager.getConnection();
			PreparedStatement ps = connection.prepareStatement(query);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Package p= new Package();
				p.setPackageID(rs.getInt("packageID"));
				p.setPackagePic(rs.getBinaryStream("packagePic"));
				p.setPackageName(rs.getString("packageName"));
				p.setPackagePrice(rs.getDouble("packagePrice"));
				p.setBfrReq(rs.getString("bfrReq"));
				p.setIsExist(rs.getString("isExist"));
				packages.add(p);
				
			}
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return packages;
		
	}

	
	// READ - Get a package by ID
		 public static Package getPackagebyId(int packageID) throws SQLException{
			// TODO Auto-generated method stub
			Package p = null;
			try{
				String query = "SELECT * FROM package WHERE packageID = ?";
				connection = ConnectionManager.getConnection();
				PreparedStatement ps = connection.prepareStatement(query);
				ps.setInt(1, packageID);
				ResultSet rs = ps.executeQuery();

				while (rs.next()) {
					p = new Package();
					p.setPackageID(rs.getInt("packageID"));
					p.setPackagePic(rs.getBinaryStream("packagePic"));
					p.setPackageName(rs.getString("packageName"));
					p.setPackagePrice(rs.getDouble("packagePrice"));
					p.setBfrReq(rs.getString("bfrReq"));
					p.setIsExist(rs.getString("isExist"));
					
					
				}
				rs.close();
				ps.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return p;
		 }
		 
	 public static void updatePackage(Package p) throws SQLException, IOException {
		 String sqlWithImage = "UPDATE package SET packageName=?, packagePic=?, packagePrice=?, bfrReq=?, isExist=? WHERE packageID=?";
		    String sqlWithoutImage = "UPDATE package SET packageName=?, packagePrice=?, bfrReq=?, isExist=? WHERE packageID=?";

		    try (Connection connection = ConnectionManager.getConnection()) {
		        PreparedStatement ps;

		        if (p.getPackagePic() != null) { // user uploaded a new image
		            ps = connection.prepareStatement(sqlWithImage);
		            ps.setString(1, p.getPackageName());
		            ps.setBinaryStream(2, p.getPackagePic(), p.getPackagePic().available());
		            ps.setDouble(3, p.getPackagePrice());
		            ps.setString(4, p.getBfrReq());
		            ps.setString(5, p.getIsExist());
		            ps.setInt(6, p.getPackageID());
		        } else { // keep existing image
		            ps = connection.prepareStatement(sqlWithoutImage);
		            ps.setString(1, p.getPackageName());
		            ps.setDouble(2, p.getPackagePrice());
		            ps.setString(3, p.getBfrReq());
		            ps.setString(4, p.getIsExist());
		            ps.setInt(5, p.getPackageID());
		        }

		        ps.executeUpdate();
		        ps.close();
	        }
	    }

	public static List<Package> getAvailablePackage() {
		// TODO Auto-generated method stub
List<Package> packages = new ArrayList<>();
		
		try{
			String query = "SELECT * FROM package WHERE isExist='YES'";
			connection = ConnectionManager.getConnection();
			PreparedStatement ps = connection.prepareStatement(query);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Package p= new Package();
				p.setPackageID(rs.getInt("packageID"));
				p.setPackagePic(rs.getBinaryStream("packagePic"));
				p.setPackageName(rs.getString("packageName"));
				p.setPackagePrice(rs.getDouble("packagePrice"));
				packages.add(p);
				
			}
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return packages;
	}

}	
