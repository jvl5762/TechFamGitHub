<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="test.AddReview"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<%
	// NOTE THAT ABOVE WHERE THE IMPORT = TEST.ADDREVIEW MIGHT CHANGE DEPENDING ON WHICH PACKAGE YOU PUT
	// THE JAVA FILE IN

	// HOW TO CREATE THE ADDREVIEW CLASS
	AddReview ar = new AddReview();
	String return_val = ar.addNewReview("abby1", "4", "5", "moo");
	
	//IF return_val == success then the item was added correctly
	// otherwise return_val holds a string of what went wrong
	// you may want to print this out to the user to check for errors
	if(return_val.equals("success")){
		out.println("yippee\n");
	}else{
		out.println(return_val);
	}
	
	// Use this to get all reviews for supplier 4
	ResultSet rs = ar.getReviews("4");
	// check if rs is null first
	if(rs != null){
		// cycle through all reviews and get the elements you want
		// note that these print statements are currently formatted pretty badly
		// you may want to change how it prints or add the strings to some sort of template
		while(rs.next()){
			out.println(rs.getString("username") + " | Rating: " + rs.getFloat("value") );
			out.println(rs.getString("explanation") + "\n");
		}
		
		try{
			// always close rs when finished if not null
			rs.close();
		}catch(Exception e){}
	}
	
%>
</body>
</html>