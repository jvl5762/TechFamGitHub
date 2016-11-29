 <%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>

<%@page import="javax.sql.*"%>

<%Class.forName("com.mysql.jdbc.Driver"); %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<body>

<%

//--------------------------------------------------------------------

// This jsp file allows a user to bid on an item in an auction

//--------------------------------------------------------------------

// required inputs: item_id (Integer) 		 		- item id of item being auctioned
// 					auction_timestamp_start(Long) 	- timestamp for start of given auction
//					bid_id (Integer)				- item_id
//					amount (Float)					- amount to bid

// output: if adding the item was a success

//--------------------------------------------------------------------

// databases and fields used: 
	
// Bid	-	all fields

//--------------------------------------------------------------------
String DATABASE_NAME = "techfamforever";
String DATABASE_USERNAME = "root";
String DATABASE_PASSWORD = "TechFam";
String DATABASE_CONNECT_STRING = "jdbc:mysql://localhost:3306/" + DATABASE_NAME + 
			"?autoReconnect=true&useSSL=false";
String DRIVER_LOC = "com.mysql.jdbc.Driver";

float AMOUNT_TO_ADD = 2.0f;

Connection con = null;
PreparedStatement get_end_time, select_bid_data, update_bid, select_highest_bid;
ResultSet result_end_time, result_bid_data, result_highest_bid;

int bid_id;
int item_id;
boolean is_auto;
float highest_bid;
float new_amount;
float old_amount;
Float max_amount;
long end_time;
long start_time;

try{
	con = DriverManager.getConnection(DATABASE_CONNECT_STRING, DATABASE_USERNAME, DATABASE_PASSWORD);
	
	// get parameters
	item_id = Integer.parseInt(request.getParameter("item_id"));
	
	bid_id = Integer.parseInt(request.getParameter("bid_id"));
	
	start_time = Long.parseLong(request.getParameter("auction_timestamp_start"));
	
	// get the end time for the auction			
	get_end_time = con.prepareStatement("SELECT timestamp_end FROM Auction WHERE timestamp_start = ? AND item_id = ?");
	
	get_end_time.setLong(1, start_time);
	
	get_end_time.setInt(2, item_id);
	
	result_end_time = get_end_time.executeQuery();
	
	result_end_time.next();
	
	end_time = result_end_time.getLong(1);

	// if the timelimit for the auction has not been reached
	if(end_time >= System.currentTimeMillis()){
		
		// get old amount and is_auto status
		select_bid_data = con.prepareStatement("SELECT amount, is_auto, max_amount FROM Bid " +
												"WHERE bid_id = ? AND item_id = ? AND auction_timestamp_start = ?");
		select_bid_data.setInt(1, bid_id);
		
		select_bid_data.setInt(2, item_id);
		
		select_bid_data.setLong(3, start_time);
		
		result_bid_data = select_bid_data.executeQuery();

		result_bid_data.next();
		
		old_amount = result_bid_data.getInt(1);

		is_auto = result_bid_data.getBoolean(2);
	
		max_amount = result_bid_data.getFloat(3);

		if(is_auto){
			
			new_amount = old_amount + AMOUNT_TO_ADD;
			
			if(new_amount > max_amount){
				new_amount = max_amount;
			}
			
		}else{	
			new_amount = Float.parseFloat(request.getParameter("amount"));
		}
		
		// get highest bid
		
		select_highest_bid = con.prepareStatement("SELECT MAX(amount) FROM Bid " +
				"WHERE item_id = ? AND auction_timestamp_start = ?");
		
		select_highest_bid.setInt(1, item_id);
		
		select_highest_bid.setLong(2, start_time);
		
		result_highest_bid = select_highest_bid.executeQuery();
		
		result_highest_bid.next();
		
		highest_bid = result_highest_bid.getFloat(1);
		
		if(new_amount > highest_bid){
			update_bid = con.prepareStatement("UPDATE Bid SET amount = ? " +
					"WHERE bid_id = ? AND item_id = ? AND auction_timestamp_start = ?");
			
			update_bid.setFloat(1, new_amount);
			
			update_bid.setInt(2, bid_id);
			
			update_bid.setInt(3, item_id);
			
			update_bid.setLong(4, start_time);
		
			update_bid.executeUpdate();
		}
		
	}
	
}catch(Exception e){
	try{
		e.printStackTrace();
		if(con != null){
			con.rollback();
		}
	}catch(Exception e2){}
}finally{
	if(con != null){
		con.close();
	}
}

//result_bid_data.next();
//max_amount = result_bid_data.getFloat(1);
		
// redirect to previous page
// String redirectURL = String.format("Profile.jsp?supplier_id=%s", request.getParameter("supplier_id"));

String redirectURL = "NonAutoUpdateForm.jsp";
		
response.sendRedirect(redirectURL);

%>
</body>
</html>