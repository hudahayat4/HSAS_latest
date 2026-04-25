package appointment;

import java.sql.Date;
import java.sql.Timestamp;

public class appointment {
    private int appointmentID;
    private int packageID;
    private int customerID;
    private int staffID;
    private Date apptDate;
    private Timestamp apptTime;
    private String notiStatus;

    // --- TAMBAH VARIABLE BARU DI SINI ---
    private String customerName;
    private String customerEmail;
    private String packageName;
    private double packagePrice;
    private String pharmacistName;
    
    public appointment() {}

    // GETTERS & SETTERS ASAL (Kekalkan yang sedia ada)
    public int getAppointmentID() { return appointmentID; }
    public void setAppointmentID(int appointmentID) { this.appointmentID = appointmentID; }
    public int getPackageID() { return packageID; }
    public void setPackageID(int packageID) { this.packageID = packageID; }
    public int getCustomerID() { return customerID; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }
    public int getStaffID() { return staffID; }
    public void setStaffID(int staffID) { this.staffID = staffID; }
    public Date getApptDate() { return apptDate; }
    public void setApptDate(Date apptDate) { this.apptDate = apptDate; }
    public Timestamp getApptTime() { return apptTime; }
    public void setApptTime(Timestamp apptTime) { this.apptTime = apptTime; }
    public String getNotiStatus() { return notiStatus; }
	public void setNotiStatus(String notiStatus) { this.notiStatus = notiStatus; }

    // --- BETULKAN SETTERS & GETTERS BARU (Penting untuk DAO & JSP) ---
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    
    public String getCustomerEmail() { return customerEmail; }
	public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
    
    public String getPackageName() { return packageName; }
    public void setPackageName(String packageName) { this.packageName = packageName; }

    public double getPackagePrice() { return packagePrice; }
    public void setPackagePrice(double packagePrice) { this.packagePrice = packagePrice; }

    public String getPharmacistName() { return pharmacistName; }
    public void setPharmacistName(String pharmacistName) { this.pharmacistName = pharmacistName; }

}