<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
	<%
	
	//-------------------------------------------------------------------------------------------------------
	// input - username, password, name, phone_number, app_num, street_address, city, state, zip, 
	//         credit_card_name, credit_card_number, type, expiration
	//-------------------------------------------------------------------------------------------------------
	// databases and fields used: suppliers - supplier_id, name, email
	// 					  register_users - username, password, age, gender, income, supplier_id
	//					  address - address_id, app_num, street_address, city, state, zip, supplier_id
	//					  phone - phone_number
	//					  credit_card - number, name, type, expiration
	//-------------------------------------------------------------------------------------------------------
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement incrementID, insert_supplier, insert_register_user, insert_address, insert_phone, insert_card;
	ResultSet result;
	int new_supplier_ID, new_address_ID;
	
	//find largest supplier_id and increment it by one - this is the new users ID
	incrementID = con.prepareStatement("SELECT MAX(supplier_id) FROM suppliers");
	result = incrementID.executeQuery();
	
	//insert new user info in suppliers table
	if (result.next()) {
		new_supplier_ID = result.getInt(1) + 1;
		
		insert_supplier = con.prepareStatement("INSERT INTO suppliers " + "VALUES (?,?,?)");
		insert_supplier.setInt(1, new_supplier_ID);
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
		insert_register_user.setInt(6, new_supplier_ID);
		insert_register_user.executeUpdate();
		
		
		//insert new user info into address
		incrementID = con.prepareStatement("SELECT MAX(supplier_id) FROM suppliers");
		result = incrementID.executeQuery();
		result.next();
		new_address_ID = result.getInt(1) + 1;
	
		insert_address = con.prepareStatement("INSERT INTO address " + "VALUES (?,?,?,?,?,?,?)");
		insert_address.setInt(1, new_address_ID);
		insert_address.setString(2, request.getParameter("app_num"));
		insert_address.setString(3, request.getParameter("street_address"));
		insert_address.setString(4, request.getParameter("city"));
		insert_address.setString(5, request.getParameter("state"));
		insert_address.setInt(6, Integer.parseInt(request.getParameter("zip")));
		insert_address.setInt(7, new_supplier_ID);
		insert_address.executeUpdate();
		
		
		// insert new phone number
		insert_phone = con.prepareStatement("INSERT INTO phone " + "VALUES (?)");
		insert_phone.setInt(1, Integer.parseInt(request.getParameter("phone_number")));
		insert_phone.executeUpdate();
		
		
		// insert credit card
		insert_card = con.prepareStatement("INSERT INTO credit_card " + "VALUES (?,?,?,?)");
		insert_card.setInt(1, Integer.parseInt(request.getParameter("credit_card_number")));
		insert_card.setString(2, request.getParameter("credit_card_name"));
		insert_card.setString(3, request.getParameter("type"));
		insert_card.setDate(4, java.sql.Date.valueOf("2013-09-04"));
		insert_card.executeUpdate();
	}
	
	
	
%>
