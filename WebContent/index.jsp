<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://www.tutuka.com/assets/styles/website/structure.css">
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link rel="icon" type="image/png" href="https://www.tutuka.com/assets/images/favicon.png" />
        
        <title>Tutuka Trial Project</title>
	</head>
	<body>
		<style>
			#header h2.logo {
			    background: url(https://www.tutuka.com/assets/images/website/sprite.png);
			    background-position: 0 0;
			    display: block;
			    height: 80px;
			    text-indent: -9999px;
			    width: 250px;
			}
		</style>
		<div class="container">
		  <div id="header" style="display: block; height: 80px; margin-bottom: 20px">
		    <div class="row">
		      <div class="span4" style="width: 300px; float: left; margin-left: 20px; display: block">
		        <a>
		          <h2 class="logo">Tutuka</h2>
		        </a>
		      </div>
		    </div>
		  </div>
		</div>
        <div class="container">
            <div class="row" style="background-color:#bce8f1">
                <h2 class="text-center" style="font-weight:bold">SELECT TRANSACTION FILES TO COMPARE</h2>
            </div>
            <div class="row" style="padding-top:20px">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class = "panel-title">Input data</h3>
                    </div>
                    <div class="panel-body">
                        <form action="result" method="post" enctype="multipart/form-data">
                            <div class="form-group">
                              <label for="txtInputFile">Select file 1: </label>
                              <div class="input-group">
                                <input type="file" accept=".csv" id="inputFile" name="inputFile" style="display: none">
                                <input type="text" value="Choose file..." class="form-control" id="txtInputFile" readonly>
                                <span class="input-group-btn">
                                    <button class="btn btn-default" type="button" id="btnBrowseFile">Browse...</button>
                                </span>
                              </div>
                            </div>
                            
                            <div class="form-group">
                              <label for="txtInputFile2">Select file 2: </label>
                              <div class="input-group">
                                <input type="file" accept=".csv" id="inputFile2" name="inputFile2" style="display: none">
                                <input type="text" value="Choose file..." class="form-control" id="txtInputFile2" readonly>
                                <span class="input-group-btn">
                                    <button class="btn btn-default" type="button" id="btnBrowseFile2">Browse...</button>
                                </span>
                              </div>
                            </div>
                            <button type="submit" class="btn btn-primary btn-block">Submit</button>
                        </form>
                    </div>
                    <script>
                        $('#btnBrowseFile, #txtInputFile').on('click', function() {
                          $('#inputFile').trigger("click");
                        });
                        $('#inputFile').change(function() {
                          var file_name = this.value.replace(/\\/g, '/').replace(/.*\//, '');
                          $('#txtInputFile').val(file_name);
                        });
                        
                        $('#btnBrowseFile2, #txtInputFile2').on('click', function() {
                          $('#inputFile2').trigger("click");
                        });
                        $('#inputFile2').change(function() {
                          var file_name = this.value.replace(/\\/g, '/').replace(/.*\//, '');
                          $('#txtInputFile2').val(file_name);
                        });
                    </script>
                </div>
            </div>
        </div>
    </body>
</html>