<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
	<%
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/techfam?autoReconnect=true&useSSL=false","root", "noclown1");
	PreparedStatement insertt;
	int thing;
	insertt = con.prepareStatement("INSERT INTO name" + " VALUES (?,?)");
	insertt.setString(1, request.getParameter("name"));
	insertt.setString(2, request.getParameter("number"));
	thing = insertt.executeUpdate();
	//user and pass are root
	
	//here we create our query
	Statement mystmt = con.createStatement();
	
	
	ResultSet result = mystmt.executeQuery("select * from name");
	
	//while(result.next()){
	//	System.out.println(result.getString("name") + ", " + result.getString("number"));
	//	newuser.name = result.getString("name");
	//	newuser.id = result.getString("number");
	//}

%>
<p style='color:red'> This is new dataset</p>
<table style='width:100%'>
<tr>
    <th>Name</th>
    <th>ID</th> 
  </tr>
  <%while(result.next()){%>
  <tr>
    <td><%= result.getString("name") %></td>
    <td><%= result.getString("number") %></td> 
  </tr>
  <% } %>

  </table>
</body>
</html>