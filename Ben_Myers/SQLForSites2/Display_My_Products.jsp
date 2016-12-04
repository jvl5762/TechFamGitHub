<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%@page import="test.Get_Drop_Downs"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar" %>
<%@page import="java.text.SimpleDateFormat" %>
<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<title>TechFam</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="http://www.w3schools.com/lib/w3.css">
<body>
<script>
function DisplayImage() {
    var x = document.createElement("IMG");
    x.setAttribute("src", "2.png");
    x.setAttribute("width", "304");
    x.setAttribute("width", "228");
    x.setAttribute("alt", "image");
    document.body.appendChild(x);
}
</script>
<div class="w3-topnav w3-black">
	<a href="Login.html">Home</a>
  	<a href="Login.jsp">Suppliers</a>
 	<a href="#">Link 2</a>
  	<a href="#">Link 3</a>
</div>
	<%
	String DATABASE_NAME = "techfamforever";
	String DATABASE_USERNAME = "root";
	String DATABASE_PASSWORD = "TechFam";
	String DATABASE_CONNECT_STRING = "jdbc:mysql://localhost:3306/" + DATABASE_NAME + 
			"?autoReconnect=true&useSSL=false";
	String DRIVER_LOC = "com.mysql.jdbc.Driver";
	
	String username = "ben2";
	int supplier_id = 1;
	
	String SQL_ITEMS = 	"SELECT * FROM "+
						"(SELECT * "+
						"FROM sales_item S "+
						"WHERE S.supplier_id = ?) AS T1 "+
						"LEFT JOIN "+ 
						"(SELECT H.item_id as item_id2, I.image, H.color "+
						"FROM has_visual H, image I "+
						"WHERE I.img_id = H.img_id) AS T2 "+
						"ON T1.item_id = T2.item_id2";
	
	Connection con = null;
	PreparedStatement select_items;
	ResultSet result_items = null;
	
	try{
		con = DriverManager.getConnection(DATABASE_CONNECT_STRING, DATABASE_USERNAME, DATABASE_PASSWORD);
		select_items = con.prepareStatement(SQL_ITEMS);
		select_items.setInt(1, supplier_id);
		result_items = select_items.executeQuery();
		System.out.println(result_items);
	
// this is just a test display 					
%>
<div class="w3-container" id='image'/>
<div class="w3-container w3-red">
  <h1>Item Description</h1>
</div>

<div style = "clear:both;">
<table class="w3-table w3-striped w3-bordered w3-border w3-hoverable" style="width:100%;">
<tr>
<th>Image</th>
<th>Item Name</th>
<th>Count</th>
<th>Brand</th>
<th>State</th>
<th>Description</th>
<th>List Price</th>
<th>Reserved Price</th>
</tr>
<%while(result_items != null && result_items.next()){ %>
	<tr>
    <% 
    	String image = result_items.getString("image");
    	if(image == null){
    		image = "null";
    	}
    %>
    <td><%= result_items.getString("image") %></td>
  	<td><%= result_items.getString("name") %></td>
  	<td><%= result_items.getString("count") %></td>
    <td><%= result_items.getString("brand") %></td>
    <td><%= result_items.getString("state") %></td>
    <td><%= result_items.getString("description") %></td>
    <td><%= result_items.getString("list_price") %></td>
    <td><%= result_items.getString("reserved_price") %></td>
    </tr>
<%} %>
</table>
</div>
 <%	
 	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(con != null){
			con.close();
		}
	}
%>
</body>