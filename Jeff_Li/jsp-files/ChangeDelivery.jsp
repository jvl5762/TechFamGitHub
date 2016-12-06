<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<title>My Profile</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="http://www.w3schools.com/lib/w3.css">
<body>

<%
	
	//----------------------------------------------------------------------------
	// This jsp file displays sale and ups information for company user
	//----------------------------------------------------------------------------
	// input: no input - only need to sign in with correct username and password
	// output: if adding was succesful
	//----------------------------------------------------------------------------
	// databases and fields used: 
	//     sale
	//     ups
	//----------------------------------------------------------------------------
	
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement insert_ups;
	ResultSet result_ups;
	String query_ups = "update ups set shipping_method = ? where transaction_id = ?";
	
	insert_ups = con.prepareStatement("update ups set shipping_method = ? where shipping_id = ?");
	insert_ups.setString(1, request.getParameter("shipping_method"));
	insert_ups.setLong(2, Long.parseLong(request.getParameter("transaction_id")));
	insert_ups.executeUpdate();
	
%>