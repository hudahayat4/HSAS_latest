package util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionManager {
	static Connection con;	
	
	//define and initialize database driver for Oracle
	private static final String DB_DRIVER = "oracle.jdbc.driver.OracleDriver";
	//define and initialize database url for Oracle
	private static final String DB_CONNECTION = "jdbc:oracle:thin:@//localhost:1521/freepdb1";
	//define and initialize database user
	private static final String DB_USER = "JuzCare";
	//define and initialize database password
	private static final String DB_PASSWORD = "oracle";

	public static Connection getConnection() {

		try {
			//1. load the driver
			Class.forName(DB_DRIVER);

			try {
				//2. create connection
				con = DriverManager.getConnection(DB_CONNECTION,DB_USER,DB_PASSWORD);
				System.out.println("Connected");
				System.out.println("Connected as user: " + con.getMetaData().getUserName());
			}catch(SQLException e) {
				System.out.println("SQL Error semasa connect:");
				e.printStackTrace();
							}
		}catch(ClassNotFoundException e) {
			System.out.println("Driver tidak jumpa:");
			e.printStackTrace();
		}		
		return con;
	}
}
