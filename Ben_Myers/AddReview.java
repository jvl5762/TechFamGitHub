package test;
import java.sql.*;
import javax.sql.*;

public class AddReview {
	public static final	String DATABASE_NAME = "techfamforever";
	public static final String DATABASE_USERNAME = "root";
	public static final String DATABASE_PASSWORD = "TechFam";
	public static final String DATABASE_CONNECT_STRING = "jdbc:mysql://localhost:3306/" + DATABASE_NAME + 
			"?autoReconnect=true&useSSL=false";
	public static final String DRIVER_LOC = "com.mysql.jdbc.Driver";
	
	public static final int MAX_DESCRIPTION_SIZE = 128;
	
	public static final String CHECK_IF_EXIST_SQL = "SELECT * FROM Rating R WHERE R.username = ? And R.supplier_id = ?";
	public static final String GET_HIGHEST_RATING_SQL = "SELECT MAX(rating_id) FROM Rating R WHERE R.supplier_id = ?";
	public static final String ADD_RATING_SQL = "INSERT INTO Rating VALUES (?,?,?,?,?)";
	
	public static final String GET_RATINGS_FOR_SUPPLIER = "SELECT * FROM Rating R WHERE R.supplier_id = ?";
	
	public static final String SUCCESS_STRING = "success";
	
	public AddReview(){}
	
	public String addNewReview(String username, String seller_id_str, String rating_str, String description) {
		
		String return_statement = "";
		
		Integer seller_id = Integer.parseInt(seller_id_str);
		Float rating = Float.parseFloat(rating_str);
		Integer ratingID = 1;
		
		Connection con = null;
		PreparedStatement check_if_exists = null;
		PreparedStatement getHighestRatingID = null;
		PreparedStatement addRating = null;
		
		if(username == null || seller_id == null || rating == null || description == null){
			return "Missing parameter";
		}
		
		if(description.isEmpty()){
			return "Empty Description, Please enter a comment";
		}
		
		if(description.length()>MAX_DESCRIPTION_SIZE){
			return "Description size is too large";
		}
		
		try{
			Class.forName(DRIVER_LOC);
			con = DriverManager.getConnection(DATABASE_CONNECT_STRING,DATABASE_USERNAME, DATABASE_PASSWORD);
			
			check_if_exists = con.prepareStatement(CHECK_IF_EXIST_SQL);
			check_if_exists.setString(1, username);
			check_if_exists.setInt(2, seller_id);
			ResultSet existingEntries = check_if_exists.executeQuery();
			if(existingEntries.next()){
				return_statement = "User Already submitted";
			}else{
				try{
					getHighestRatingID = con.prepareStatement(GET_HIGHEST_RATING_SQL);
					getHighestRatingID.setInt(1, seller_id);
					existingEntries = getHighestRatingID.executeQuery();
					if(existingEntries.next()){
						ratingID = existingEntries.getInt("MAX(rating_id)") + 1;
					}
				
					try{
						System.out.println("start");
						addRating = con.prepareStatement(ADD_RATING_SQL);
						addRating.setInt(1, ratingID);
						addRating.setString(2, description);
						addRating.setFloat(3, rating);
						addRating.setString(4, username);
						addRating.setInt(5, seller_id);
						System.out.println(username);
						addRating.executeUpdate();
						return_statement = SUCCESS_STRING;
					}catch(Exception e){
						System.out.println(e.getMessage());
						return_statement = "Failed to add";
					}
				}catch(Exception e){
					return_statement = "Failed to get Highest Rating";
				}
			}
		}catch(Exception e){
			System.out.println(e.getMessage());
			return_statement = "Check if existing entry failed";
		}finally{
			try{
				con.close();
			}catch(Exception e){}
		}
		
		return return_statement;
	}

	public ResultSet getReviews(String seller_id_str){
		Integer seller_id = Integer.parseInt(seller_id_str);
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			Class.forName(DRIVER_LOC);
			con = DriverManager.getConnection(DATABASE_CONNECT_STRING,DATABASE_USERNAME, DATABASE_PASSWORD);
			ps = con.prepareStatement(GET_RATINGS_FOR_SUPPLIER);
			ps.setInt(1, seller_id);
			rs = ps.executeQuery();
		}catch(Exception e){
			try{
				con.close();
			}catch(Exception e2){}
		}
	
		return rs;
	}
	
}
