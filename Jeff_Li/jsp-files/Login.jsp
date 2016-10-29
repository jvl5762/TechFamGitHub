<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
	<%
	//---------------------------------------------------------------
	// This jsp file handles the login of existing users. The
	// register_users table is checked to see if username-password 
	// combination exists.
	//---------------------------------------------------------------
	// databases and fields used: register_user - username, password
	// return: if login was successful or failed
	//---------------------------------------------------------------
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement verify;
	
	verify = con.prepareStatement("SELECT username, password FROM register_users WHERE username = ? AND password = SHA1(?)");
	verify.setString(1, request.getParameter("username"));
	verify.setString(2, request.getParameter("password"));

	ResultSet result = verify.executeQuery();
	
	// if result has an entry, then login was successful - else login failed
	if (result.next()) {
		//System.out.println("success");
	}
	else {
		//System.out.println("fail");
	}
	
%>
