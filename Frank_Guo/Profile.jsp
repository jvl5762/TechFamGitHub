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
	// This jsp file displays the desired user information, including basic user 
	// info (name, email, etc.) and all the user's ratings.
	//----------------------------------------------------------------------------
	// input: supplier_id
	// output: the fields below (except id's) - stored in ResultSet data below
	//----------------------------------------------------------------------------
	// databases and fields used: 
	//     suppliers - supplier_id, name (stored in result_user)
	//     register_user - username, age, gender, income (stored in result_user)
	//     rating - username, explanation, value (stored in result_ratings)
	//----------------------------------------------------------------------------
	
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "noclown1");
	PreparedStatement select_user, select_ratings;
	ResultSet result_user, result_ratings;
	String name = null;
	String username = null;
	String age = null;
	String gender = null;
	String income = null;
	String lastuser = null;
	String supplier = null;
	// find basic user info
	select_user = con.prepareStatement("SELECT s.name, ru.username, ru.age, ru.gender, ru.income " + 
					   "FROM suppliers s, register_users ru " + 
					   "WHERE s.supplier_id = ? and ru.supplier_id = ?");
	select_user.setInt(1, Integer.parseInt(request.getParameter("supplier_id")));
	select_user.setInt(2, Integer.parseInt(request.getParameter("supplier_id")));
	supplier = request.getParameter("supplier_id");
	
	// result_user contains desired user information
	result_user = select_user.executeQuery();
	
	
	// find all the ratings for that user
	select_ratings = con.prepareStatement("SELECT username, value, explanation " + 
			   		      "FROM rating " + 
			   		      "WHERE supplier_id = ?");
	select_ratings.setInt(1, Integer.parseInt(request.getParameter("supplier_id")));
			
	// result_ratings contains all ratings for user
	result_ratings = select_ratings.executeQuery();
			
	while(result_user.next()){
		name = result_user.getString("name");
		username = result_user.getString("username");
		age = result_user.getString("age");
		gender = result_user.getString("gender");
		income = result_user.getString("income");
	
	
	
// this is just a test display 					
	}%>
<div class="w3-topnav w3-black">
	<a href="Login.html">Home</a>
  	<a href="Login.jsp">Suppliers</a>
 	<a href="#">Link 2</a>
  	<a href="#">Link 3</a>
</div>

<p style='color:red'> This is the user</p>
<table class="w3-table w3-striped w3-bordered w3-border w3-hoverable" style="width:100%;">
<thead>
<tr>
    <th>Name</th>
    <th>username</th> 
    <th>age</th> 
    <th>gender</th> 
    <th>income</th> 
  </tr>
  </thead>

  <tr>
    <td><%= name %></td>
    <td><%= username %></td> 
    <td><%= age %></td>
    <td><%= gender %></td>
    <td><%= income %></td>
  </tr>
</table>
<div class="w3-container">
  <h2>Comments</h2>
</div>
<table class="w3-table w3-striped w3-bordered w3-border w3-hoverable" style="width:100%;">
<thead>
<tr>
	<th>username</th>
	<th>value</th>
	<th>explanation</th>
</tr>
</thead>
    <%while(result_ratings.next()){%>
  <tr>
	 <td><%= result_ratings.getString("username") %></td>
	 <td><%= result_ratings.getString("value") %></td>
	 <td><%= result_ratings.getString("explanation") %></td>
  </tr>
  <%} %>
  </table>
</body>

<form class="w3-form" action="AddComment.jsp">
  <h2>Input Form</h2>
  <p><input class="w3-input" type="hidden" name="username" value="<%=session.getAttribute("UserName")%>"></p>
  <p><input class="w3-input" type="hidden" name="supplier_id" value="<%=request.getParameter("supplier_id")%>"></p>
  <select class="w3-select" name="value">
    <option value="" disabled selected>Rating:</option>
    <option value="1">&#x2605&#x2606&#x2606&#x2606&#x2606</option>
    <option value="2">&#x2605&#x2605&#x2606&#x2606&#x2606</option>
    <option value="3">&#x2605&#x2605&#x2605&#x2606&#x2606</option>
    <option value="4">&#x2605&#x2605&#x2605&#x2605&#x2606</option>
    <option value="5">&#x2605&#x2605&#x2605&#x2605&#x2605</option>
  </select>
  <p><textarea class="w3-input" name="explanation" placeholder="Subject"></textarea></p>
  <p><button class="w3-btn">Submit</button></p>
</form>

