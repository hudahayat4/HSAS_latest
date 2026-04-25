package Result;

import java.sql.Date;

import appointment.appointment;

import java.io.Serializable;

public class Result implements Serializable {
	
	private static final long serialVersionUID = 1L;


	private int resultId;
	private int appointmentId;
	private Date resultDate;
	private String resultComment;
	private HBA1C hba1c;
	private Lipid lipid;
	private UricAcid uricacid;
	private appointment apt;
	
	//default constructor 
	public Result() {}
	
	//parameterized constructor 
	public Result( int resultId, int appointmentId,
	 Date resultDate, String resultComment) {
		this.setResultId(resultId);
		this.setAppointmentId(appointmentId);
		this.setResultDate(resultDate);
		this.setResultComment(resultComment);
	}

	public int getResultId() {
		return resultId;
	}

	public void setResultId(int resultId) {
		this.resultId = resultId;
	}

	public Date getResultDate() {
		return resultDate;
	}

	public void setResultDate(Date resultDate) {
		this.resultDate = resultDate;
	}

	public String getResultComment() {
		return resultComment;
	}

	public void setResultComment(String resultComment) {
		this.resultComment = resultComment;
	}

	public int getAppointmentId() {
		return appointmentId;
	}

	public void setAppointmentId(int appointmentId) {
		this.appointmentId = appointmentId;
	}

	public HBA1C getHba1c() {
		return hba1c;
	}

	public void setHba1c(HBA1C hba1c) {
		this.hba1c = hba1c;
	}

	public Lipid getLipid() {
		return lipid;
	}

	public void setLipid(Lipid lipid) {
		this.lipid = lipid;
	}

	public UricAcid getUricacid() {
		return uricacid;
	}

	public void setUricacid(UricAcid uricacid) {
		this.uricacid = uricacid;
	}

	public appointment getApt() {
		return apt;
	}

	public void setApt(appointment apt) {
		this.apt = apt;
	}
	
}
