package customer;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;
import java.io.InputStream;

public class Customer implements Serializable {
	private static final long serialVersionUID = 1L;
	private int cusID;
	private String cusNRIC;
	private String custName;
	private String custEmail;
	private InputStream custProfilePic;
	private Date DOB;
	private String custUsername;
	private String custPassword;
	private String custPhoneNo;
	private String verificationCode;
	private Timestamp verificationExpiry;
	private String custVerified;
	
	public int getCusID() {
		return cusID;
	}
	public void setCusID(int cusID) {
		this.cusID = cusID;
	}
	public String getCusNRIC() {
		return cusNRIC;
	}
	public void setCusNRIC(String cusNRIC) {
		this.cusNRIC = cusNRIC;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public String getCustEmail() {
		return custEmail;
	}
	public void setCustEmail(String custEmail) {
		this.custEmail = custEmail;
	}
	public InputStream getCustProfilePic() { 
		return custProfilePic; 
		} 
	public void setCustProfilePic(InputStream custProfilePic) {
		this.custProfilePic = custProfilePic;
		}
	public Date getDOB() {
		return DOB;
	}
	public void setDOB(Date dOB) {
		DOB = dOB;
	}
	public String getCustUsername() {
		return custUsername;
	}
	public void setCustUsername(String custUsername) {
		this.custUsername = custUsername;
	}
	public String getCustPassword() {
		return custPassword;
	}
	public void setCustPassword(String custPassword) {
		this.custPassword = custPassword;
	}
	public String getCustPhoneNo() {
		return custPhoneNo;
	}
	public void setCustPhoneNo(String custPhoneNo) {
		this.custPhoneNo = custPhoneNo;
	}
	public String getVerificationCode() {
		return verificationCode;
	}
	public void setVerificationCode(String verificationCode) {
		this.verificationCode = verificationCode;
	}
	public Timestamp getVerificationExpiry() {
		return verificationExpiry;
	}
	public void setVerificationExpiry(Timestamp verificationExpiry) {
		this.verificationExpiry = verificationExpiry;
	}
	public String getCustVerified() {
		return custVerified;
	}
	public void setCustVerified(String custVerified) {
		this.custVerified = custVerified;
	}
}
