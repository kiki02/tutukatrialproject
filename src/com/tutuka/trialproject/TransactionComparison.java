package com.tutuka.trialproject;

import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.output.*;

import com.google.gson.Gson;

/**
 * Servlet implementation class TransactionComparison
 */
@WebServlet("/result")
public class TransactionComparison extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TransactionComparison() {
        super();
        // TODO Auto-generated constructor stub
    }

    private boolean isMultipart;
    private String filePath;
    private int maxFileSize = 500 * 1024 * 1024; // 500mb
    private int maxMemSize = 4 * 1024; // 4kb
    private File file ;
    
    private ArrayList<String> inputFileArr;
    private ComparisonResult comparisonResult;

    public void init( ){
       // Get the file location where it would be stored.
       filePath = getServletContext().getInitParameter("file-upload"); 
    }
    
    public void doPost(HttpServletRequest request, HttpServletResponse response)
       throws ServletException, java.io.IOException {
    
       // Check that we have a file upload request
       isMultipart = ServletFileUpload.isMultipartContent(request);
       response.setContentType("text/html");
       java.io.PrintWriter out = response.getWriter( );
    
       if( !isMultipart ) {
          out.println("<html>");
          out.println("<head>");
          out.println("<title>Servlet upload</title>");  
          out.println("</head>");
          out.println("<body>");
          out.println("<p>No file uploaded</p>"); 
          out.println("</body>");
          out.println("</html>");
          return;
       }
       
       File tempDir = Files.createTempDirectory("foobar").toFile();
   
       DiskFileItemFactory factory = new DiskFileItemFactory();
    
       // maximum size that will be stored in memory
       factory.setSizeThreshold(maxMemSize);
    
       // Location to save data that is larger than maxMemSize.
       factory.setRepository(tempDir);

       // Create a new file upload handler
       ServletFileUpload upload = new ServletFileUpload(factory);
    
       // maximum file size to be uploaded.
       upload.setSizeMax( maxFileSize );

       try { 
          // Parse the request to get file items.
          List fileItems = upload.parseRequest(request);
 	
          // Process the uploaded file items
          Iterator i = fileItems.iterator();
          
          inputFileArr = new ArrayList<String>();
          
          while ( i.hasNext () ) {
             FileItem fi = (FileItem)i.next();
             if ( !fi.isFormField () ) {
                // Get the uploaded file parameters
//                String fieldName = fi.getFieldName();
                String fileName = fi.getName();
//                String contentType = fi.getContentType();
//                boolean isInMemory = fi.isInMemory();
//                long sizeInBytes = fi.getSize();
                if(fileName.equals("")) {
                	if (inputFileArr.size() == 1) {
                		file = new File(inputFileArr.get(0));
                  	  	file.delete();
                	}
                		
                	
                    out.println("<html>");
                    out.println("<head>");
                    out.println("<title>Servlet upload</title>");  
                    out.println("</head>");
                    out.println("<body>");
                    out.println("<p>Uploading files occurred error, Please check again your selected files!</p>"); 
                    out.println("</body>");
                    out.println("</html>");
                    return;
                 }
             
                // Write the file
                if( fileName.lastIndexOf("\\") >= 0 ) {
                   file = new File( tempDir.getParent() + File.separator + fileName.substring( fileName.lastIndexOf("\\")));
                   //file = File.createTempFile(fileName.substring( fileName.lastIndexOf("\\")),".tmp");
                } else {
                   file = new File( tempDir.getParent() + File.separator + fileName.substring(fileName.lastIndexOf("\\")+1));
                   //file = File.createTempFile(fileName.substring(fileName.lastIndexOf("\\")+1),".tmp");
                }
                fi.write( file ) ;
                
                // add full file path name to array list
                inputFileArr.add(file.getAbsolutePath());
             }
          }
          
          // we expected only 2 files in here
          if (inputFileArr.size() == 2) {
        	  // going to core processing of this project
        	  comparisonResult = CoreProcessingService.startCompareFiles(inputFileArr.get(0), inputFileArr.get(1));
        	  // delete temp upload files
        	  file = new File(inputFileArr.get(0));
        	  file.delete();
        	  file = new File(inputFileArr.get(1));
        	  file.delete();
        	  
        	  // this is for JSP variables
        	  HttpSession session = request.getSession();
        	  session.setAttribute("comparisonResult", comparisonResult);
        	  
        	  // this is for javascript variables
        	  Gson gson = new Gson();
        	  String jsonInString = gson.toJson(comparisonResult);
        	  session.setAttribute("comparisonResultStr", jsonInString);
        	  
        	  request.getRequestDispatcher("/result.jsp").forward(request, response);
          }
      } catch(Exception ex) {
         System.out.println(ex);
      }
   }
       
   public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, java.io.IOException {

      throw new ServletException("GET method used with " +
         getClass( ).getName( )+": POST method required.");
   }
}
