<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
	<%
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement incrementID;
	PreparedStatement insert_supplier;
	PreparedStatement insert_register_user;
	ResultSet result;
	int newID;
	
	//find largest supplier_id and increment it by one - this is the new users ID
	incrementID = con.prepareStatement("SELECT MAX(supplier_id) FROM suppliers");
	result = incrementID.executeQuery();
	//insert new user info in suppliers table
	if (result.next()) {
		newID = result.getInt(1) + 1;
		
		insert_supplier = con.prepareStatement("INSERT INTO suppliers " + "VALUES (?,?,?)");
		insert_supplier.setInt(1, newID);
		insert_supplier.setString(2, request.getParameter("email"));
		insert_supplier.setString(3, request.getParameter("name"));
		insert_supplier.executeUpdate();
		
		//insert new user info in register user
		insert_register_user = con.prepareStatement("INSERT INTO register_users " + "VALUES (?,SHA1(?),?,?,?,?)");
		insert_register_user.setString(1, request.getParameter("username"));
		insert_register_user.setString(2, request.getParameter("password"));
		insert_register_user.setInt(3, Integer.parseInt(request.getParameter("age")));
		insert_register_user.setString(4, request.getParameter("gender"));
		insert_register_user.setInt(5, 0);
		insert_register_user.setInt(6, newID);
		insert_register_user.executeUpdate();
	}
	
	
	
%>