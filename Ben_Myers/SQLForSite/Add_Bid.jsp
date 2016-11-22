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
//					amount (Float)					- amount to bid
//					username (String)				- username of person bidding
//					credit_card(Long)				- number of credit card user is paying with
//					address_id(Int)					- address for credit card payment
//					is_auto (Boolean)				- is auto bid True or False
//					max_amount (Float)				- max ammount you are willing to bid

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

int TIME_TO_CANCEL = 60*60*24;

Connection con = null;
PreparedStatement select_bid_id, add_to_bid;
ResultSet result_max_id;

int bid_id;
boolean is_auto;
int max_amount;

try{
	con = DriverManager.getConnection(DATABASE_CONNECT_STRING, DATABASE_USERNAME, DATABASE_PASSWORD);
		
	// get Max bid id
	
	is_auto = Boolean.parseBoolean(request.getParameter("is_auto"));
	
	select_bid_id = con.prepareStatement("SELECT MAX(bid_id) FROM Bid");

	result_max_id = select_bid_id.executeQuery();

	result_max_id.next();

	bid_id = result_max_id.getInt(1) + 1;
	
	// add item to Bid
	
	add_to_bid = con.prepareStatement("INSERT INTO Bid VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	
	add_to_bid.setInt(1, bid_id);
	
	add_to_bid.setFloat(2, Float.parseFloat(request.getParameter("amount")));
	
	add_to_bid.setLong(3, System.currentTimeMillis() + TIME_TO_CANCEL);
	
	add_to_bid.setInt(4, Integer.parseInt(request.getParameter("item_id")));
	
	add_to_bid.setLong(5, Long.parseLong(request.getParameter("auction_timestamp_start")));
	
	add_to_bid.setString(6, request.getParameter("username"));
	
	add_to_bid.setLong(7, Long.parseLong(request.getParameter("credit_card")));
	
	add_to_bid.setInt(8, Integer.parseInt(request.getParameter("address_id")));
	
	add_to_bid.setBoolean(9, is_auto);
	
	if(is_auto){
		add_to_bid.setFloat(10, Float.parseFloat(request.getParameter("max_amount")));
	}else{
		add_to_bid.setNull(10, java.sql.Types.DECIMAL);
	}
	
	add_to_bid.executeUpdate();
	
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
		
// redirect to previous page
// String redirectURL = String.format("Profile.jsp?supplier_id=%s", request.getParameter("supplier_id"));

String redirectURL = "BuyProductForm.jsp";
		
response.sendRedirect(redirectURL);

%>
</body>
</html>