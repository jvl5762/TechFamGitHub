<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="test.AddReview"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<%
	AddReview ar = new AddReview();
	String return_val = ar.addNewReview("abby1", "4", "5", "moo");
	if(return_val.equals("success\n")){
		out.println("yippee\n");
	}else{
		out.println(return_val);
	}
	
	ResultSet rs = ar.getReviews("4");
	if(rs != null){
		while(rs.next()){
			out.println(rs.getString("username") + " | Rating: " + rs.getFloat("value") );
			out.println(rs.getString("explanation") + "\n");
		}
		
		try{
			rs.close();
		}catch(Exception e){}
	}
	
%>
</body>
</html>