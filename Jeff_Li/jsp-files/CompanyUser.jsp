<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<title>Welcome Company User</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="http://www.w3schools.com/lib/w3.css">
<body>

<%
	
	//----------------------------------------------------------------------------
	// This jsp file displays ups information for company user
	//----------------------------------------------------------------------------
	// input: no input - only need to sign in with correct username and password
	// output: a page with shipping information
	//----------------------------------------------------------------------------
	// databases and fields used: 
	//     address
	//	sale
	//     ups
	//----------------------------------------------------------------------------
	
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement select_sale, select_ups, select_address;
	ResultSet result_sale, result_ups, result_address;
	String auction_or_sale;
	String query_sale = "select * from sale";
	String query_ups = "select * from ups";
	String query_address = "select * from address where address_id in (select shipping_address_id from sale)";
	
	select_sale = con.prepareStatement(query_sale);
	select_ups = con.prepareStatement(query_ups);
	select_address = con.prepareStatement(query_address);
	
	result_sale = select_sale.executeQuery();
	result_ups = select_ups.executeQuery();
	result_address = select_address.executeQuery();
	
%>

<div class="w3-panel w3-card w3-light-grey"><p>Current Shipping Information</p></div>
<table class="w3-table w3-striped w3-bordered w3-border w3-hoverable" style="width:100%;">
		<thead>
	<tr>
	<th>transaction_id</th>
	<th>item_id</th>
	<th>Purchase Date</th>
	<th>Apartment Number</th>
	<th>Street Address</th>
	<th>City</th>
	<th>State</th>
	<th>Zip</th>
	<th>Shipping Date</th>
	<th>Delivery Status</th>
	<th>Change Status</th>
	</tr>
	</thead>
	<%while(result_ups.next()){%>
  <tr>
  	<%result_sale.next(); %>
  	<td><%= result_sale.getString("transaction_id") %></td>
  	<td><%= result_sale.getString("item_id") %></td>
    <td><%= result_sale.getString("date") %></td>
    <%result_address.next(); %>
    <td><%= result_address.getString("app_num") %></td>
    <td><%= result_address.getString("street_address") %></td>
    <td><%= result_address.getString("city") %></td>
    <td><%= result_address.getString("state") %></td>
    <td><%= result_address.getString("zip") %></td>
    <td><%= result_ups.getString("shipping_date") %></td>
    <td><%= result_ups.getString("shipping_method") %></td>
    <td><button class="ChangeDelivery">change</button></td>
  </tr>
  <%} %>
  </table>
