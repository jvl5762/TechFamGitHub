 <%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>

<%@page import="javax.sql.*"%>

<%@page import="java.util.HashMap"%>

<%@page import="java.util.ArrayList"%>

<%Class.forName("com.mysql.jdbc.Driver"); %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<% 
String DATABASE_NAME = "techfamforever";
String DATABASE_USERNAME = "root";
String DATABASE_PASSWORD = "TechFam";
String DATABASE_CONNECT_STRING = "jdbc:mysql://localhost:3306/" + DATABASE_NAME + 
			"?autoReconnect=true&useSSL=false";
String DRIVER_LOC = "com.mysql.jdbc.Driver";

Connection con = null;
PreparedStatement select_categories, select_address;
ResultSet result_categories = null, result_address;
HashMap<String, ArrayList<Integer>> result_hash = new HashMap<String, ArrayList<Integer>>();
HashMap<Integer, String> id_to_name = new HashMap<Integer, String>();
HashMap<Integer, String> address = new HashMap<Integer, String>();

String size;
String big_group;
String small_group;
int category;
int supplier_id = 1;

String category_sql = 	"SELECT DISTINCT C2.category_name, C4.category_name, C4.category_id " +
						"FROM category C1, category C2, category C3, category C4 " +
						"WHERE C1.parent_id IS NULL AND " +
						"C2.parent_id = C1.category_id AND " + 
						"C3.parent_id = C2.category_id AND " +
						"C4.parent_id = C3.category_id";

String address_sql = "SELECT address_id, street_address FROM address where supplier_id = ?";


// Checking success and failures
if(session.getAttribute("AddSales_Item") == null){
	System.out.println("None");
}else if (session.getAttribute("AddSales_Item").equals("Success")){
	System.out.println("Success");
}else{
	System.out.println("Fail");
}

session.setAttribute("AddSales_Item", null);

try{
	con = DriverManager.getConnection(DATABASE_CONNECT_STRING, DATABASE_USERNAME, DATABASE_PASSWORD);

	// obtain max sales_item_id and increment by one - this is the latest sales_item_id

	select_categories = con.prepareStatement(category_sql);

	result_categories = select_categories.executeQuery();
	
	while(result_categories.next()){	
		big_group = result_categories.getString(1);
		small_group = result_categories.getString(2);
		category = result_categories.getInt(3);
		
		if(result_hash.get(big_group) == null){
			result_hash.put(big_group, new ArrayList<Integer>());
		}
		
		result_hash.get(big_group).add(category);
		
		id_to_name.put(category, small_group);
	}
	
	select_address = con.prepareStatement(address_sql);
	select_address.setInt(1, supplier_id);
	result_address = select_address.executeQuery();
	
	while(result_address.next()){
		address.put(result_address.getInt(1), result_address.getString(2));
	}
	
}catch(Exception e){
	try{
		if(con != null){
			con.rollback();
		}
	}catch(Exception e2){}
}finally{
	if(con != null){
		con.close();
	}
}
%>


<p>Add Sales Item</p>
<form action="AddSales_Item.jsp" method="post">
	<p>Count: <input type="quantity" name="count" min="1" required/></p>
	<p>Brand: <input type="text" name="brand" maxlength="40" required/></p>
	<p>List Price: <input type="number" name="list_price" min="0" max="99999.99" required/></p>
	<p>State: <select name = "state">
		<option value="new">New</option>
		<option value="old">Old</option>
	</select></p>
	<p>Description: <input type="text" name="description" maxlength="999" required/></p>
	<p>Name: <input type="text" name="name" required/></p>
	<p>Reserved Price: <input type="number" name="reserved_price" min="0" max = "99999.99" required/></p>
	<p>Size (if shoe): <input type="text" name="size" maxlength="40"/></p>
	<p>Category: <select name = "category_id">
		<% for(String group : result_hash.keySet()){%>
			<optgroup label= <%= group%>>
			<% for(Integer cat_id : result_hash.get(group)){ %>
				<option value=<%= cat_id.toString()%>><%= id_to_name.get(cat_id)%></option>
			<%} %>
			</optgroup>
		<%} %>
	</select></p>
	<p>Address: <select name = "address_id">
		<%for(Integer add_id : address.keySet()){ %>
			<option value=<%= add_id.toString()%>><%= address.get(add_id) %></option>
		<%} %>
	</select></p>
	<input type="hidden" name="supplier_id" value="1"/>
<input type="submit"/>
</form>

<p></p>
<form action="Direct_Buy_Item.jsp">
	<input type="hidden" name="item_id" value="1"/>
	<input type="hidden" name="amount" value="1"/>
	<input type="hidden" name="credit_card" value="379580062526777"/>
	<p>Address: <select name = "address_id">
		<%for(Integer add_id : address.keySet()){ %>
			<option value=<%= add_id.toString()%>><%= address.get(add_id) %></option>
		<%} %>
	</select></p>
	<input type="submit"/>
</form>

<p></p>
<p>Start Auction: NEED TO CHECK IF RESERVE PRICE EXISTS</p>
<form action="Start_Auction.jsp">
	<input type="hidden" name="item_id" value="6"/>
	<input type="hidden" name="timestamp_end" value="991480099318321"/>
	<input type="submit"/>
</form>

<p></p>
<p>End Auction</p>
<form action="EndAuction.jsp">
	<input type="hidden" name="item_id" value="6"/>
	<input type="hidden" name="auction_timestamp_start" value="1480777672"/>
	<input type="submit"/>
</form>

<p></p>
<p>Add Bid</p>
<form action="Add_Bid.jsp" method="post">
<input type="hidden" name="item_id" value="10" />
<input type="hidden" name="auction_timestamp_start" value="1480775830" />
Amount :<input type="text" name="amount"/>
<input type="hidden" name="credit_card" value="379580062565888" />
<input type="hidden" name="address_id" value="5" />
Is Auto: <input type="text" name="is_auto"/>
Max: <input type="text" name="max_amount" />
<input type="submit"/>
</form>

<p></p>
<p>Cancel Bid</p>
<form action="CancelBid.jsp" method="post">
<input type="hidden" name="item_id" value="10" />
<input type="hidden" name="auction_timestamp_start" value="1480775830" />
<input type="text" name="bid_id"/>
<input type="submit"/>
</form>

<p></p>
<p>Update Bid</p>
<form action="UpdateBid.jsp" method="post">
<input type="hidden" name="item_id" value="10" />
<input type="hidden" name="auction_timestamp_start" value="1480775830" />
ID: <input type="text" name="bid_id"/>
Amount: <input type="text" name="amount"/>
<input type="submit"/>
</form>

<p></p>
<p>Add User Rating</p>
<form action="AddComment.jsp" method="post">
Supplier id: <input type="text" name="supplier_id" />
Explanation: <input type="text" name="explanation" />
Value: <input type="text" name="value"/>
User: <input type="text" name="username"/>
<input type="submit"/>
</form>

<p></p>
<p>Add Item Review</p>
<form action="AddItemReview.jsp" method="post">
Item id: <input type="text" name="item_id" />
Explanation: <input type="text" name="explanation" />
Value: <input type="text" name="value"/>
User: <input type="text" name="username"/>
<input type="submit"/>
</form>
</body>
</html>