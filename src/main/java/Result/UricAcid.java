package Result;

import java.io.Serializable;

public class UricAcid extends Result implements Serializable {
	private static final long serialVersionUID = 1L;
	private String riskIndicator;
	private String UricLevelRange;
	
	public UricAcid() {
		super();
	}
	
	public String getRiskIndicator() {
		return riskIndicator;
	}
	public void setRiskIndicator(String riskIndicator) {
		this.riskIndicator = riskIndicator;
	}
	public String getUricLevelRange() {
		return UricLevelRange;
	}
	public void setUricLevelRange(String UricLevelRange) {
		this.UricLevelRange = UricLevelRange;
	}
	
}
