<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
	
<%
	
	//----------------------------------------------------------------------------------------------------------
	// This jsp file displays the customer service page
	//----------------------------------------------------------------------------------------------------------
	// input: none
	// output: the fields below (except the id) - stored in ResultSet result_service;
	//----------------------------------------------------------------------------------------------------------
	// databases and fields used: 
	//     	customer_service - customer_service_id, email, faqs, phone_number
	//----------------------------------------------------------------------------------------------------------
	
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement select_service;
	ResultSet result_service;
	
	
	select_service = con.prepareStatement("SELECT * FROM customer_service");
	result_service = select_service.executeQuery();
	
// this is just a test display - remove before final product				
%>

<p style='color:red'> This is the user</p>
<table style='width:100%'>
<tr>
    <th>Name</th>
    <th>ID</th> 
  </tr>
  <%while(result_service.next()){%>
  <tr>
    <td><%= result_service.getString("faqs") %></td>
    <td><%= result_service.getString("email") %></td>
    <td><%= result_service.getString("phone_number") %></td>
  </tr>
  <% } %>

  </table>
</body>
