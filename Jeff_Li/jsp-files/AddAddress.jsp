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
	
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement select_address_id, insert_address;
	ResultSet result, result_max_id;
	int increment_id;
	
	
	// obtain max address_id and increment by one - this is the address_id
	select_address_id = con.prepareStatement("SELECT MAX(address_id) FROM address");
	result_max_id = select_address_id.executeQuery();
	result_max_id.next();
	increment_id = result_max_id.getInt(1) + 1;
	
	
	// insert rating for that user
	insert_address = con.prepareStatement("INSERT INTO address VALUES (?,?,?,?,?)");
	insert_address.setInt(1, increment_id);
	insert_address.setString(2, request.getParameter("app_num"));
	insert_address.setString(3, request.getParameter("street_address"));
	insert_address.setString(4, request.getParameter("city"));
	insert_address.setString(5, request.getParameter("state"));
	insert_address.setInt(6, Integer.parseInt(request.getParameter("zip")));
	insert_address.setInt(7, Integer.parseInt(request.getParameter("supplier_id")));
	insert_address.executeUpdate();
%>