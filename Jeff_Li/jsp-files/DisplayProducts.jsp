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
	//			keyword
	//			bottom price range
	//			top price range
	//			state
	//			size
	// output: the fields below (except the id's) - stored in ResultSet results;
	//----------------------------------------------------------------------------------------------------------
	// databases and fields used: 
	//     	Sales_Item - count, brand, list_price, state, name
	//	Footwear - size
	//	category - category_id, category_name
	//     	suppliers - supplier_id, name
	//----------------------------------------------------------------------------------------------------------
	
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement select_items, select_category, select_supplier;
	ResultSet results;
	boolean validate = true;
	
	String sql_query = "SELECT S.brand, S.count, S.list_price, S.name, S.state, F.size, C.category_name, SU.name " + 
				"FROM sales_item S, footwear F, category C, suppliers SU " + 
				"WHERE S.item_id = F.item_id AND S.category_id = C.category_id AND S.supplier_id = SU.supplier_id ";

	
	// search keywords in name, brand, item description, category name, category description, supplier name
	if (request.getParameter("keyword").length() > 0) {
		sql_query += "AND (S.name LIKE '%" + request.getParameter("keyword") + "%' " + 
				"OR S.brand LIKE '%" + request.getParameter("keyword") + "%' " + 
				"OR S.description LIKE '%" + request.getParameter("keyword") + "%' " +
				"OR C.category_name LIKE '%" + request.getParameter("keyword") + "%' " +
				"OR C.description LIKE '%" + request.getParameter("keyword") + "%' " +
				"OR SU.name LIKE '%" + request.getParameter("keyword") + "%') ";
	}
	
	// bottom end of price range
	if (request.getParameter("bottom_price").length() > 0) {
		// error handling if price range is not a number
		try {
			Long.parseLong(request.getParameter("bottom_price"));
	    	}
	    	catch(NumberFormatException e) {
	        	validate = false;
	    	}
		if (validate) {
			sql_query += "AND S.list_price >= " + Long.parseLong(request.getParameter("bottom_price")) + " ";
		} 
		else {
			validate = true;
		}
	}
	
	// top end of price range
	if (request.getParameter("top_price").length() > 0) {
		// error handling if price range is not a number
		try {
			Long.parseLong(request.getParameter("top_price"));
	    	}
	    	catch(NumberFormatException e) {
	        	validate = false;
	    	}
		if (validate) {
			sql_query += "AND S.list_price <= " + Long.parseLong(request.getParameter("top_price")) + " ";
		} 
		else {
			validate = true;
		}
	}
	
	// search by state
	if (request.getParameter("state").length() > 0) {
		sql_query += "AND S.state = '" + request.getParameter("state") + "' ";
	}
	
	// search by size - trouble with how to do this because the sizes are ranges in char form
	if (request.getParameter("size").length() > 0) {
		sql_query += "AND F.size = '" + request.getParameter("size") + "' ";
	}
	
	select_items = con.prepareStatement(sql_query);
	results = select_items.executeQuery();

	
// this is just a test display - remove before final product				
%>

<p style='color:red'> This is the user</p>
<table style='width:100%'>
<tr>
    <th>Name</th>
    <th>ID</th> 
  </tr>
  <%while(results.next()){%>
  <tr>
    <td><%= results.getString("name") %></td>
    <td><%= results.getString("brand") %></td> 
    <td><%= results.getString("list_price") %></td>
    <td><%= results.getString("state") %></td>
    <td><%= results.getString("count") %></td>
  </tr>
  <% } %>

  </table>
</body>
