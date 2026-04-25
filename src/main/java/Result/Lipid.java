package Result;
import java.io.Serializable;

public class Lipid extends Result implements Serializable {

	private static final long serialVersionUID = 1L;
	private Double hdlCholesterol;
	private String lipidPanelDetails;
	private Double ldlCholesterol;
	
	public Lipid() {
		super();
	}
	
	public Double getHdlCholesterol() {
		return hdlCholesterol;
	}
	public void setHdlCholesterol(Double hdlCholesterol) {
		this.hdlCholesterol = hdlCholesterol;
	}
	public String getLipidPanelDetails() {
		return lipidPanelDetails;
	}
	public void setLipidPanelDetails(String lipidPanelDetails) {
		this.lipidPanelDetails = lipidPanelDetails;
	}
	public Double getLdlCholesterol() {
		return ldlCholesterol;
	}
	public void setLdlCholesterol(Double ldlCholesterol) {
		this.ldlCholesterol = ldlCholesterol;
	}
}
