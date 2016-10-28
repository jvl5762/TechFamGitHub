package test;
import java.sql.*;
import javax.sql.*;

public class AddReview {
	
	// YOU MAY NEED TO MODIFY THESE, THIS IS MY TABLE, USERNAME, AND PASSWORD FOR MY TABLE
	// YOUR TABLE MAY BE DIFFERENT
	public static final	String DATABASE_NAME = "techfamforever";
	public static final String DATABASE_USERNAME = "root";
	public static final String DATABASE_PASSWORD = "TechFam";
	public static final String DATABASE_CONNECT_STRING = "jdbc:mysql://localhost:3306/" + DATABASE_NAME + 
			"?autoReconnect=true&useSSL=false";
	public static final String DRIVER_LOC = "com.mysql.jdbc.Driver";
	
	// MAX SIZE THE DESCRIPTION CAN BE
	public static final int MAX_DESCRIPTION_SIZE = 128;
	
	// SQL STATEMENTS ADDING RATING
	public static final String CHECK_IF_EXIST_SQL = "SELECT * FROM Rating R WHERE R.username = ? And R.supplier_id = ?";
	public static final String GET_HIGHEST_RATING_SQL = "SELECT MAX(rating_id) FROM Rating R WHERE R.supplier_id = ?";
	public static final String ADD_RATING_SQL = "INSERT INTO Rating VALUES (?,?,?,?,?)";
	
	// SQL STATEMENT FOR GETTING RATINGS
	public static final String GET_RATINGS_FOR_SUPPLIER = "SELECT * FROM Rating R WHERE R.supplier_id = ?";
	
	// CONSTANT STRING TO RETURN WHEN SUCCELSSFULLY ADDED NEW ENTRY
	public static final String SUCCESS_STRING = "success";
	
	public AddReview(){}
	
	public String addNewReview(String username, String seller_id_str, String rating_str, String description) {
		// STRING TO BE RETURNED
		String return_statement = "";
		
		// CONVERT STRING PARAMETERS TO PROPER FORM
		Integer seller_id = Integer.parseInt(seller_id_str);
		Float rating = Float.parseFloat(rating_str);
		Integer ratingID = 1;
		
		
		// USED FOR CONNECTING TO DATABASE
		Connection con = null;
		PreparedStatement check_if_exists = null;
		PreparedStatement getHighestRatingID = null;
		PreparedStatement addRating = null;
		
		
		// MAKE SURE NO PARAMETER IS NULL
		if(username == null || seller_id == null || rating == null || description == null){
			return "Missing parameter";
		}
		
		// MAKE SURE DESCRIPTION IS FILLED OUT
		if(description.isEmpty()){
			return "Empty Description, Please enter a comment";
		}
		
		// MAKE SURE DESCRIPTION IS NOT TOO LONG
		if(description.length()>MAX_DESCRIPTION_SIZE){
			return "Description size is too large";
		}
		
		try{
			// CONNECT TO DATABASE
			Class.forName(DRIVER_LOC);
			con = DriverManager.getConnection(DATABASE_CONNECT_STRING,DATABASE_USERNAME, DATABASE_PASSWORD);
			
			// CREATE SQL STATEMENT TO CHECK THAT THE USER HAS NOT ALREADY MADE A REVIEW FOR THE SELLER
			check_if_exists = con.prepareStatement(CHECK_IF_EXIST_SQL);
			check_if_exists.setString(1, username);
			check_if_exists.setInt(2, seller_id);
			ResultSet existingEntries = check_if_exists.executeQuery();
			
			// IF USER ALREADY SUBMITTED THEN RETURN STATEMENT THAT SAYS SO
			if(existingEntries.next()){
				return_statement = "User Already submitted";
			}else{
				try{
					
					// GET THE HIGHEST RATING ID AND MAKE THE NEXT RATING_ID +1 THAT RATING
					// NOTE WE MAY WANT TO GET RID OF RATING ID IN THE FUTURE
					getHighestRatingID = con.prepareStatement(GET_HIGHEST_RATING_SQL);
					getHighestRatingID.setInt(1, seller_id);
					existingEntries = getHighestRatingID.executeQuery();
					
					// IF RATING_ID ALREADY EXISTS, ADD 1 TO IT, OTHERWISE DEFAULT TO 1
					if(existingEntries.next()){
						ratingID = existingEntries.getInt("MAX(rating_id)") + 1;
					}
				
					try{
						// ADD RATING
						addRating = con.prepareStatement(ADD_RATING_SQL);
						addRating.setInt(1, ratingID);
						addRating.setString(2, description);
						addRating.setFloat(3, rating);
						addRating.setString(4, username);
						addRating.setInt(5, seller_id);
						addRating.executeUpdate();
						
						// RETURN THIS IF RATING ADD IS SUCCESS
						return_statement = SUCCESS_STRING;
					}catch(Exception e){
						return_statement = "Failed to add";
					}
				}catch(Exception e){
					return_statement = "Failed to get Highest Rating";
				}
			}
		}catch(Exception e){
			return_statement = "Check if existing entry failed";
		}finally{
			try{
				con.close();
			}catch(Exception e){}
		}
		
		// RETURN THE STATEMENT OF SUCCESS OR THE ERROR MESSAGE
		return return_statement;
	}

	public ResultSet getReviews(String seller_id_str){
		// CONVERT SELLER ID TO AN INTEGER
		Integer seller_id = Integer.parseInt(seller_id_str);
		
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try{
			// CONNECT TO DATABASE
			Class.forName(DRIVER_LOC);
			con = DriverManager.getConnection(DATABASE_CONNECT_STRING,DATABASE_USERNAME, DATABASE_PASSWORD);
			
			// GET ALL RATING INFO FOR GIVEN SUPPLIER
			ps = con.prepareStatement(GET_RATINGS_FOR_SUPPLIER);
			ps.setInt(1, seller_id);
			rs = ps.executeQuery();
		}catch(Exception e){
			try{
				con.close();
			}catch(Exception e2){}
		}
		
		// RETURN SUPPLIER INFO
		return rs;
	}
	
}
