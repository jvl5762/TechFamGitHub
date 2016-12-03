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
	// This jsp file allows a user to rate another user,
	// which inserts that information into the rating table
	//--------------------------------------------------------------------
	// input: supplier_id of the user rating and username 
	//        of the user being rated (in that order)
	// output: if rating was succesful
	//--------------------------------------------------------------------
	// databases and fields used: 
	//     suppliers - supplier_id (this is given)
	//     register_user - username (stored in result_username)
	//     rating - rating_id, explanation, value, username, supplier_id
	//--------------------------------------------------------------------
	
	String DATABASE_NAME = "techfamforever";
	String DATABASE_USERNAME = "root";
	String DATABASE_PASSWORD = "TechFam";
	String DATABASE_CONNECT_STRING = "jdbc:mysql://localhost:3306/" + DATABASE_NAME + 
			"?autoReconnect=true&useSSL=false";
	String DRIVER_LOC = "com.mysql.jdbc.Driver";
	String SUCCESS_LABEL = "AddSales_Item";
	String CHECK_USER_BOUGH_SQL = 	"SELECT transaction_id, R.username "+
								  	"FROM sale S, credit_card C, register_users R, sales_item I " +
									"WHERE S.credit_card_number = C.number AND " +
			      					"C.username = R.username AND " +
			      					"S.item_id = I.item_id AND " +
			      					"I.supplier_id = ? and " +
				  					"R.username = ?";
	
	Connection con = null;
	PreparedStatement check_username, select_rating_id, insert_rating, check_user_bought;
	ResultSet result_check, result_max_rating_id, result_user_bought;
	int increment_id;
	int supplier_id;
	String username;
	
	try{
		// check if the user has already given a rating to this user before -  deny rating if true
		con = DriverManager.getConnection(DATABASE_CONNECT_STRING, DATABASE_USERNAME, DATABASE_PASSWORD);
		supplier_id = Integer.parseInt(request.getParameter("supplier_id"));
		username =  request.getParameter("username");
		
		check_username = con.prepareStatement("SELECT username FROM rating WHERE username = ? AND supplier_id = ?");
		check_username.setString(1, request.getParameter("username"));
		check_username.setInt(2, Integer.parseInt(request.getParameter("supplier_id")));
		result_check = check_username.executeQuery();
		
		check_user_bought = con.prepareStatement(CHECK_USER_BOUGH_SQL);
		check_user_bought.setInt(1, supplier_id);
		check_user_bought.setString(2, username);
		result_user_bought = check_user_bought.executeQuery();
		
		if (result_check.next() || !result_user_bought.next()) {
			session.setAttribute(SUCCESS_LABEL, "Fail");
		}else{
		
			// obtain max rating_id and increment by one - this is the latest rating's id
			select_rating_id = con.prepareStatement("SELECT MAX(rating_id) FROM rating");
			result_max_rating_id = select_rating_id.executeQuery();
			result_max_rating_id.next();
			increment_id = result_max_rating_id.getInt(1) + 1;
			
			
			// insert rating for that user
			insert_rating = con.prepareStatement("INSERT INTO rating VALUES (?,?,?,?,?)");
			insert_rating.setInt(1, increment_id);
			insert_rating.setString(2, request.getParameter("explanation"));
			insert_rating.setFloat(3, Float.parseFloat(request.getParameter("value")));
			insert_rating.setString(4,username);
			insert_rating.setInt(5, supplier_id);	// supplier_id of the user being rated
			insert_rating.executeUpdate();	// result_ratings contains all ratings for user
			session.setAttribute(SUCCESS_LABEL, "Success");
		}
	}catch(Exception e){
		try{
			e.printStackTrace();
			if(con != null){
				con.rollback();
			}
		}catch(Exception e2){}
		
		session.setAttribute(SUCCESS_LABEL, "Fail");
		
	}finally{
		if(con != null){
			con.close();
		}
	}
	
	//String redirectURL = String.format("Profile.jsp?supplier_id=%s", request.getParameter("supplier_id"));
	//response.sendRedirect(redirectURL);

	String redirectURL = "MegaForm.jsp";
	response.sendRedirect(redirectURL);
%>