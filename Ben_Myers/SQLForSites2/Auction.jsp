<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
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
	
	String SQL_AUCTION = 
			"SELECT TA.item_id, TA.name, TA.description, TA.category_name, "+
			"TA.timestamp_start, TA.timestamp_end, TA.amount, TP.image FROM " +
			"(SELECT T1.item_id, T1.name, T1.description, T1.category_name, " +
			"T1.timestamp_start, T1.timestamp_end, T2.amount FROM "+
			"(SELECT I.item_id, I.name, I.description, C.category_name, "+
			"A.timestamp_start, A.timestamp_end "+
			"FROM sales_item I, auction A, Category C "+
			"WHERE A.item_id = I.item_id AND "+
			"I.category_id = C.category_id AND "+
			"A.timestamp_end > ?) AS T1 "+
			"LEFT JOIN "+
			"(SELECT item_id, auction_timestamp_start, MAX(amount) as amount "+ 
			"FROM Bid "+
			"group by item_id, auction_timestamp_start) AS T2 "+
			"ON T1.item_id = T2.item_id AND T1.timestamp_start = T2.auction_timestamp_start) TA "+
			"LEFT JOIN "+
			"(SELECT H.item_id, Min(P.image) as image "+
			"FROM has_visual H, image P " +
			"WHERE H.img_id = P.img_id "+
			"group by H.item_id ) AS TP "+
			"ON TA.item_id = TP.item_id";
	
	Connection con = null;
	PreparedStatement select_auction;
	ResultSet result_auction = null;
	
	try{
		con = DriverManager.getConnection(DATABASE_CONNECT_STRING, DATABASE_USERNAME, DATABASE_PASSWORD);
		select_auction = con.prepareStatement(SQL_AUCTION);
		select_auction.setLong(1, System.currentTimeMillis()/1000);
		result_auction = select_auction.executeQuery();
	
// this is just a test display 					
%>
<div class="w3-container" id='image'/>
<div class="w3-container w3-red">
  <h1>Item Description</h1>
</div>
<%while(result_auction != null && result_auction.next()){ %>
<div style = "clear:both;">
<table class="w3-table w3-striped w3-bordered w3-border w3-hoverable" style="width:100%;">
<tr>
    <th>Image</th>
    <th>Item Name</th>
    <th>Description</th> 
    <th>Category</th>
    <th>Start Time</th>
    <th>End Time</th>
    <th>Highest Bid</th>
  </tr>
  <tr>
    <% 
    	String image = result_auction.getString("image");
    	if(image == null){
    		image = "null";
    	}
    	int item_id = result_auction.getInt("item_id");
    	long start = result_auction.getLong("timestamp_start");
    %>
    <td><%= result_auction.getString("image") %></td>
  	<td><%= result_auction.getString("name") %></td>
  	<td><%= result_auction.getString("description") %></td>
    <td><%= result_auction.getString("category_name") %></td>
    <td><%= start%></td>
    <td><%= result_auction.getLong("timestamp_end") %></td>
    <%
    	Float amount = result_auction.getFloat("amount");
    	if(amount == null){

      		amount = 0.0f;
      	}
    %>
    <td><%= amount%></td>
  </tr>
</table>
<form action="Add_Bid.jsp" method="post">
<input type="hidden" name="item_id" value=<%= item_id%> />
<input type="hidden" name="auction_timestamp_start" value=<%=start %> />
Amount :<input type="number" name="amount" min=<%= amount + 2.0f %> />
<input type="hidden" name="credit_card" value="379580062565888" />
<input type="hidden" name="address_id" value="5" />
<input type="hidden" name="is_auto" value="false"/>
<input type="hidden" name="max_amount" value= "0"/>
<input button value="Bid" type="submit"/>
</form>

<form action="Add_Bid.jsp" method="post">
<input type="hidden" name="item_id" value=<%= item_id%> />
<input type="hidden" name="auction_timestamp_start" value=<%=start %> />
<input type="hidden" name="amount" value=<%= amount + 2.0f %> />
<input type="hidden" name="credit_card" value="379580062565888" />
<input type="hidden" name="address_id" value="5" />
<input type="hidden" name="is_auto" value="true"/>
Max Amount :<input type="number" name="max_amount" min=<%= amount + 2.0f %>/>
<input button value="Auto Bid" type="submit"/>
</form>

</div>
 <%} %>
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