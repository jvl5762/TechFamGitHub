<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
	<%
	
	// input: supplier_id
	// output: the fields below
	// databases used: suppliers, register_user, rating
	// fields used: name, username, age, gender, income, value
	
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "root");
	PreparedStatement select_user;
	ResultSet result;
	int return_value = 0;
	
	//find largest supplier_id and increment it by one - this is the new users ID
	select_user = con.prepareStatement("SELECT s.name, ru.username, ru.age, ru.gender, ru.income, r.value " + 
					   "FROM suppliers s, register_users ru, rating r " + 
					   "WHERE s.supplier_id = ? and ru.supplier_id = ? and r.supplier_id = ?");
	select_user.setInt(1, Integer.parseInt(request.getParameter("supplier_id")));
	select_user.setInt(2, Integer.parseInt(request.getParameter("supplier_id")));
	select_user.setInt(3, Integer.parseInt(request.getParameter("supplier_id")));
	
	// result contains desired user information
	result = select_user.executeQuery();
	
%>

<p style='color:red'> This is the user</p>
<table style='width:100%'>
<tr>
    <th>Name</th>
    <th>ID</th> 
  </tr>
  <%while(result.next()){%>
  <tr>
    <td><%= result.getString("name") %></td>
    <td><%= result.getString("username") %></td> 
    <td><%= result.getString("age") %></td>
    <td><%= result.getString("gender") %></td>
    <td><%= result.getString("income") %></td>
    <td><%= result.getString("value") %></td>
  </tr>
  <% } %>

  </table>
</body>
