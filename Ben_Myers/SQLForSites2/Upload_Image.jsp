<%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>

<%@page import="javax.sql.*"%>

<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>

<%Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
//--------------------------------------------------------------------
//required inputs: 	item_id (Integer) 	- item id of item being auctioned
//					color (String)		- color of picture
//					file image
//output: if adding the item was a success
//--------------------------------------------------------------------
String DATABASE_NAME = "techfamforever";
String DATABASE_USERNAME = "root";
String DATABASE_PASSWORD = "TechFam";
String DATABASE_CONNECT_STRING = "jdbc:mysql://localhost:3306/" + DATABASE_NAME + 
			"?autoReconnect=true&useSSL=false";
String DRIVER_LOC = "com.mysql.jdbc.Driver";

String SUCCESS_LABEL = "moo";

String IMAGE_DIRECTORY_DIR = "C:\\temp";

Connection con = null;
PreparedStatement select_image_id, insert_image, insert_has_image;
ResultSet result_max_id;

File imageFile = null;
String file_path = null;
Integer increment_id = null; 
Integer item_id = null;
String color = null;
FileItem realimage = null;

try{
	if(ServletFileUpload.isMultipartContent(request)){
		
		con = DriverManager.getConnection(DATABASE_CONNECT_STRING, DATABASE_USERNAME, DATABASE_PASSWORD);
		
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// Maybe set factory size limits
		
		// get context
		ServletContext context = this.getServletConfig().getServletContext();
		
		// set place to stor image temporarily
		factory.setRepository((File) context.getAttribute("javax.servlet.context.tempdir"));
		
		// uploads files
		ServletFileUpload upload = new ServletFileUpload(factory);
		
		
		// Set up directory to store data
		File uploadDir = new File(IMAGE_DIRECTORY_DIR);
		
		System.out.println(uploadDir.exists());
		if(uploadDir.exists()){
			List<FileItem> items = upload.parseRequest(request);

			for(FileItem image : items){
				
				if (image.isFormField()) {
					String fieldname = image.getFieldName();
					String fieldvalue = image.getString();
					
					if(fieldname.equals("item_id")){
						item_id = Integer.parseInt(fieldvalue);
					}else{
						color = fieldvalue;
					}
					
				}else{
				
					imageFile = new File(image.getName());
					file_path = IMAGE_DIRECTORY_DIR + File.separator + imageFile.getName();
					realimage = image;
				}
			}
			
			if(imageFile != null && item_id != null && color != null && realimage != null){
			
				// obtain max sales_item_id and increment by one - this is the latest sales_item_id
	
				select_image_id = con.prepareStatement("SELECT MAX(img_id) FROM Image");
	
				result_max_id = select_image_id.executeQuery();
	
				result_max_id.next();
	
				increment_id = result_max_id.getInt(1) + 1;
				
				// insert image
				int i = imageFile.getName().lastIndexOf(".");
				String name;
				if(i > 0){
					name = increment_id.toString() + imageFile.getName().substring(i);
				}else{
					name = increment_id.toString();
				}
				
				insert_image = con.prepareStatement("INSERT INTO image VALUES (?,?)");
				insert_image.setInt(1, increment_id);
				insert_image.setString(2, name);
				insert_image.executeUpdate();
				
				// insert has_image
				
				insert_has_image = con.prepareStatement("INSERT INTO has_visual VALUES (?,?,?)");
				insert_has_image.setInt(1, item_id);
				insert_has_image.setInt(2, increment_id);
				insert_has_image.setString(3, color);
				insert_has_image.executeUpdate();
			
				realimage.write(new File(file_path));
				session.setAttribute(SUCCESS_LABEL, "Success");
			}
			
		}
	}
	
}catch(Exception e){
	try{
		e.printStackTrace();
		if(con != null){
			con.rollback();
		}
	}catch(Exception e2){}
	session.setAttribute(SUCCESS_LABEL, "Fail");
}finally{
	if(con != null){
		con.close();
	}
}

String redirectURL = "upload_file_form.jsp";

response.sendRedirect(redirectURL);


%>
</body>
</html>