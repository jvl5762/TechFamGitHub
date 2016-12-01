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
	// This jsp file displays the desired items depending on the user's search. Filters include keywords, 
	// price range, state, and size.
	//----------------------------------------------------------------------------------------------------------
	// input: any number of the following (all are in text form):
	//	keyword
	//	bottom price range
	//	top price range
	//	state
	//	size
	// output: the fields below (except the id's) - stored in ResultSet results;
	//----------------------------------------------------------------------------------------------------------
	// databases and fields used: 
	//     	Sales_Item - count, brand, list_price, state, name
	//	Footwear - size
	//	category - category_id, category_name
	//     	suppliers - supplier_id, name
	//----------------------------------------------------------------------------------------------------------
	
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement select_items, select_categories;
	ResultSet result_items, result_categories;
	
	
	select_items = con.prepareStatement("SELECT S.brand, S.count, S.list_price, S.name, S.state, F.size, C.category_name, SU.name " + 
				"FROM sales_item S, footwear F, category C, suppliers SU " + 
				"WHERE S.item_id = F.item_id AND S.supplier_id = SU.supplier_id AND S.category_id = ?");
	select_items.setString(1, request.getParameter("category_id"));

	
	select_categories = con.prepareStatement("SELECT category_name, description FROM category WHERE category_id = (SELECT parent_id FROM category WHERE category_id = ?) OR parent_id = ?");
	select_categories.setString(1, request.getParameter("category_id"));	//parent_id of current category
	select_categories.setString(2, request.getParameter("category_id"));
	
	
	result_items = select_items.executeQuery();
	result_categories = select_categories.executeQuery();
	
// this is just a test display - remove before final product				
%>

<p style='color:red'> This is the user</p>
<table style='width:100%'>
<tr>
    <th>Name</th>
    <th>ID</th> 
  </tr>
  <%while(result_categories.next()){%>
  <tr>
    <td><%= result_categories.getString("category_name") %></td>
    <td><%= result_categories.getString("description") %></td>
  </tr>
  <% } %>

  </table>
</body>