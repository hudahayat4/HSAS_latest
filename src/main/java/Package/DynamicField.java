package Package;

public class DynamicField {

    private String fieldName;
    private String fieldType;
    private String fieldLabel;

    public DynamicField(String fieldName, String fieldType) {
        this.fieldName = fieldName;
        this.fieldType = fieldType;
        this.fieldLabel = formatFieldName(fieldName);
    }

    public String getFieldName() {
        return fieldName;
    }

    public String getFieldType() {
        return fieldType;
    }

    public String getFieldLabel() {
        return fieldLabel;
    }

    public void setFieldLabel(String fieldLabel) {
        this.fieldLabel = fieldLabel;
    }

    public static String formatFieldName(String name) {

        if (name == null || name.isEmpty()) {
            return "";
        }

        String formatted = name
            .replaceAll("([A-Z]+)([A-Z][a-z])", "$1 $2")
            .replaceAll("_", " ")
            .toLowerCase();

        return formatted.substring(0, 1).toUpperCase()
                + formatted.substring(1);
    }
}