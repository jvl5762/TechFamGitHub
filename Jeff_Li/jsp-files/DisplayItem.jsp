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
	// This jsp file displays the desired item information.
	//----------------------------------------------------------------------------------------------------------
	// input: item_id
	// output: the fields below (except the id's) - stored in ResultSet data listed below
	//----------------------------------------------------------------------------------------------------------
	// databases and fields used: 
	//     Sales_Item - item_id, count, brand, list_price, state, description, 
	//                  name, category_id, supplier_id (stored in ResultSet result_item)
	//     category - category_id, description (stored in ResultSet result_category)
	//     suppliers - supplier_id, name (stored in ResultSet result_supplier;)
	//----------------------------------------------------------------------------------------------------------
	
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement select_item, select_category, select_supplier;
	ResultSet result_item, result_category, result_supplier;
	
	// find sales item information
	select_item = con.prepareStatement("SELECT count, brand, list_price, state, description, name, category_id, supplier_id " + 
			   							"FROM sales_item " + 
			   							"WHERE item_id = ?");
	select_item.setInt(1, Integer.parseInt(request.getParameter("item_id")));
	result_item = select_item.executeQuery();
	result_item.next();	// select the item result - this is needed for finding the category and supplier
	
	
	// find category where the item is categorized
	select_category = con.prepareStatement("SELECT description FROM category WHERE category_id = ?");
	select_category.setInt(1, result_item.getInt("category_id"));
	result_category = select_category.executeQuery();
	result_category.next(); // select the category result
	
	
	// find supplier information
	select_supplier = con.prepareStatement("SELECT name FROM suppliers WHERE supplier_id = ?");
	select_supplier.setInt(1, result_item.getInt("supplier_id"));
	result_supplier = select_supplier.executeQuery();
	result_supplier.next(); // select the supplier result
	
	
// this is just a test display 					
%>

<p style='color:red'> This is the user</p>
<table style='width:100%'>
<tr>
    <th>Name</th>
    <th>ID</th> 
  </tr>
  <tr>
  	<td><%= result_item.getString("name") %></td>
  	<td><%= result_supplier.getString("name") %></td>
  	<td><%= result_category.getString("description") %></td>
    <td><%= result_item.getString("brand") %></td> 
    <td><%= result_item.getString("list_price") %></td>
    <td><%= result_item.getString("state") %></td>
    <td><%= result_item.getString("description") %></td>
    <td><%= result_item.getString("count") %></td>
  </tr>
  </table>
</body>
