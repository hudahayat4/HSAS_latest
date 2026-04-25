package staff;

import java.io.Serializable;
import java.sql.Date;
import java.io.InputStream;

public class Staff implements Serializable{
	
	private static final long serialVersionUID = 1L;
	private String NRIC;
	private int staffID;
	private int managerID;
	private String name;
	private String PhoneNo;
	private String username;
	private String password;
	private Date DOB;
	private InputStream profilePic;
	private String email;
	private String role;
	
	
	public Staff() {}


	public String getNRIC() {
		return NRIC;
	}


	public void setNRIC(String nRIC) {
		NRIC = nRIC;
	}
	
	public int getStaffID() {
		return staffID;
	}


	public void setStaffID(int staffID) {
		this.staffID = staffID;
	}
	


	public int getManagerID() {
		return managerID;
	}


	public void setManagerID(int managerID) {
		this.managerID = managerID;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public String getPhoneNo() {
		return PhoneNo;
	}


	public void setPhoneNo(String PhoneNo) {
		this.PhoneNo = PhoneNo;
	}


	public String getUsername() {
		return username;
	}


	public void setUsername(String username) {
		this.username = username;
	}


	public String getPassword() {
		return password;
	}


	public void setPassword(String password) {
		this.password = password;
	}


	public Date getDOB() {
		return DOB;
	}


	public void setDOB(Date dOB) {
		DOB = dOB;
	}


	public InputStream getProfilePic() {
		return profilePic;
	}


	public void setProfilePic(InputStream profilePic) {
		this.profilePic = profilePic;
	}


	public String getEmail() {
		return email;
	}


	public void setEmail(String email) {
		this.email = email;
	}


	public String getRole() {
		return role;
	}


	public void setRole(String role) {
		this.role = role;
	}


	
}