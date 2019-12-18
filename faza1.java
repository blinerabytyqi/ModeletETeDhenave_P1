package db_project2;
import java.sql.*;
public class databaza {

	public static void main(String[] args) {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl","C##ELBAKURTESHI","1234");
			Statement st = con.createStatement();
			String sql="select * from Customer";
			ResultSet rs = st.executeQuery(sql);
			while(rs.next())
				System.out.println(rs.getInt(1) + "  " + rs.getString(2) + " " + rs.getString(3) + " " + rs.getString(4) + " " + rs.getString(5));
			con.close();	
		}
		catch (Exception e) {
			System.out.println(e);
		}	
	}
}