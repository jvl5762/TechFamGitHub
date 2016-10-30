<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
	<%
	
	//-----------------------------------------------------
	// This jsp file displays the desired user information, 
	// including basic user info (name, email, etc.) 
	// and all the user's ratings.
	//-----------------------------------------------------
	// input: supplier_id
	// output: the fields below + user's avg_rating
	//-----------------------------------------------------
	// databases and fields used: 
	//     suppliers - name
	//     register_user - username, age, gender, income
	//     rating - username, explanation, value
	//-----------------------------------------------------
	
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement select_user, select_ratings, select_count;
	ResultSet result_user, result_ratings, result_count;
	float avg_rating = 0;
	
	// find basic user info
	select_user = con.prepareStatement("SELECT s.name, ru.username, ru.age, ru.gender, ru.income " + 
					   "FROM suppliers s, register_users ru " + 
					   "WHERE s.supplier_id = ? and ru.supplier_id = ?");
	select_user.setInt(1, Integer.parseInt(request.getParameter("supplier_id")));
	select_user.setInt(2, Integer.parseInt(request.getParameter("supplier_id")));
	result_user = select_user.executeQuery();	// result_user contains desired user information
	
	
	// find all the ratings for that user
	select_ratings = con.prepareStatement("SELECT username, value, explanation " + 
			   		      "FROM rating " + 
			   		      "WHERE supplier_id = ?");
	select_ratings.setInt(1, Integer.parseInt(request.getParameter("supplier_id")));	
	result_ratings = select_ratings.executeQuery();	// result_ratings contains all ratings for user
	
	
	// find user's average rating
	select_count = con.prepareStatement("SELECT COUNT(*) FROM rating where supplier_id = ?");
	select_count.setString(1, request.getParameter("supplier_id"));
	result_count = select_count.executeQuery();		// result_count contains number of ratings user has
	result_count.next();
	
	while (result_ratings.next()) {
		avg_rating += Float.parseFloat(result_ratings.getString("value"));
	}
	avg_rating = avg_rating / result_count.getInt(1); //avg user rating
	result_ratings = select_ratings.executeQuery();	// reset result_ratings
	
	
// this is just a test display 					
%>

<p style='color:red'> This is the user</p>
<table style='width:100%'>
<tr>
    <th>Name</th>
    <th>ID</th> 
  </tr>
  <%while(result_user.next()){%>
  <tr>
    <td><%= result_user.getString("name") %></td>
    <td><%= result_user.getString("username") %></td> 
    <td><%= result_user.getString("age") %></td>
    <td><%= result_user.getString("gender") %></td>
    <td><%= result_user.getString("income") %></td>
    <%while(result_ratings.next()){%>
	    <td><%= result_ratings.getString("username") %></td>
	    <td><%= result_ratings.getString("value") %></td>
	    <td><%= result_ratings.getString("explanation") %></td>
	<% } %>
	<td><%= avg_rating %></td>
  </tr>
  <% } %>

  </table>
</body>
