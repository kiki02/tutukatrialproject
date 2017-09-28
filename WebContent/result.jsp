<%@page import="com.tutuka.trialproject.CloseMatchData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tutuka.trialproject.CoreProcessingService"%>
<%@page import="com.tutuka.trialproject.ComparisonResult"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    
    <link rel="stylesheet" href="https://www.tutuka.com/assets/styles/website/structure.css">
    <link rel="icon" type="image/png" href="https://www.tutuka.com/assets/images/favicon.png" />
    
	<title>Tutuka Trial Project</title>
</head>
<%
	ComparisonResult ComparisonResult = (ComparisonResult) session.getAttribute("comparisonResult");
%>
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
        <div class="row" style="background-color:#e8f2e8">
            <h2 class="text-center" style="font-size:36px; font-weight:bold">COMPARISON RESULTS</h2>
        </div>
        <div class="row" style="padding-top:20px">
            <div class="row">
                <div class="col-lg-6">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title" style="font-size:24px; font-weight:bold"><%=ComparisonResult.filePath_1%></h3>
                        </div>
                        <div class="panel-body" style="font-size:18px">
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>Total Records: </label>
                                </div>
                                <div class="col-lg-6">
                                    <label><%=ComparisonResult.totalRecords_1%></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>Matching Records: </label>
                                </div>
                                <div class="col-lg-6">
                                    <label><%=ComparisonResult.matchingRecords_1%></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>Unmatched Records: </label>
                                </div>
                                <div class="col-lg-6">
                                    <label><%=ComparisonResult.unmatchingRecords_1%></label>
                                </div>
                            </div>
                            <!-- <button class="btn btn-danger btn-block" type="button" id="btnClickReport" style="font-size:17px; background-color:#bc6e6b">Unmatched Report</button> -->
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title" style="font-size:24px; font-weight:bold"><%= ComparisonResult.filePath_2 %></h3>
                        </div>
                        <div class="panel-body" style="font-size:18px">
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>Total Records: </label>
                                </div>
                                <div class="col-lg-6">
                                    <label><%= ComparisonResult.totalRecords_2 %></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>Matching Records: </label>
                                </div>
                                <div class="col-lg-6">
                                    <label><%= ComparisonResult.matchingRecords_2 %></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6">
                                    <label>Unmatched Records: </label>
                                </div>
                                <div class="col-lg-6">
                                    <label><%= ComparisonResult.unmatchingRecords_2 %></label>
                                </div>
                            </div>
                            <!-- <button class="btn btn-danger btn-block" type="button" id="btnClickReport" style="font-size:17px; background-color:#bc6e6b">Unmatched Report</button> -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="panel panel-info">
                <style>
                    .table-hover > tbody > tr:hover {
                      background-color: #D2D2D2;
                    }
                </style>
                <div class="panel-heading">
                    <h3 class="panel-title" style="font-size:24px; font-weight:bold">Unmatched Report for <%=ComparisonResult.filePath_1%></h3>
                </div>
                <div class="panel-body" style="font-size:14px">
                    <!-- <div class="table-responsive"> -->
                        <table id="resultTable1" class="table table-bordered table-striped table-hover">
                            <thead class="thead-inverse">
                                <tr>
                                    <th>#</th>
                                    <th>Date</th>
                                    <th>Reference</th>
                                    <th>Amount</th>
                                    <th>ID</th>
                                    <th>Narrative</th>
                                    <th>View</th>
                                </tr>
                            </thead>
                            <tbody>
                            	<% for(int i = 0; i < ComparisonResult.unmatchingTransaction_1.size(); i+=1) { 
                            			String[] lineContent = ComparisonResult.unmatchingTransaction_1.get(i).lineContent.split(",");
                            	%>
							        <tr>
							        	<th scope="row"><%=i%></th>
							            <td><%=lineContent[CoreProcessingService.TRANSACTION_DATE]%></td>
							            <td><%= lineContent.length > CoreProcessingService.MAX_INDEX ? lineContent[CoreProcessingService.WALLET_REFERENCE] : "" %></td>
						            	<td><%=lineContent[CoreProcessingService.TRANSACTION_AMOUNT]%></td>
							            <td><%=lineContent[CoreProcessingService.TRANSACTION_ID]%></td>
							            <td><%=lineContent[CoreProcessingService.TRANSACTION_NARRATIVE]%></td>
							            <td>
				                            <button class="btn btn-info btn-sm" data-id="<%=i%>" onClick="openModal(this,1)">
				                                 <span class="glyphicon glyphicon-eye-open"></span>
				                            </button>
				                        </td>
							        </tr>
							    <% } %>
                            </tbody>
                        </table>
                    <!-- </div> -->
                </div>
            </div>
        </div>
        <div class="row">
            <div class="panel panel-info">
                <style>
                    .table-hover > tbody > tr:hover {
                      background-color: #D2D2D2;
                    }
                </style>
                <div class="panel-heading">
                    <h3 class="panel-title" style="font-size:24px; font-weight:bold">Unmatched Report for <%=ComparisonResult.filePath_2%></h3>
                </div>
                <div class="panel-body" style="font-size:14px">
                    <!-- <div class="table-responsive"> -->
                        <table id="resultTable2" class="table table-bordered table-striped table-hover">
                            <thead class="thead-inverse">
                                <tr>
                                    <th>#</th>
                                    <th>Date</th>
                                    <th>Reference</th>
                                    <th>Amount</th>
                                    <th>ID</th>
                                    <th>Narrative</th>
                                    <th>View</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(int i = 0; i < ComparisonResult.unmatchingTransaction_2.size(); i+=1) { 
                            			String[] lineContent = ComparisonResult.unmatchingTransaction_2.get(i).lineContent.split(",");
                            	%>
							        <tr>
							        	<th scope="row"><%=i%></th>
							            <td><%=lineContent[CoreProcessingService.TRANSACTION_DATE]%></td>
							            <td><%= lineContent.length > CoreProcessingService.MAX_INDEX ? lineContent[CoreProcessingService.WALLET_REFERENCE] : "" %></td>
						            	<td><%=lineContent[CoreProcessingService.TRANSACTION_AMOUNT]%></td>
							            <td><%=lineContent[CoreProcessingService.TRANSACTION_ID]%></td>
							            <td><%=lineContent[CoreProcessingService.TRANSACTION_NARRATIVE]%></td>
							            <td>
											<button class="btn btn-info btn-sm" data-id="<%=i%>" onClick="openModal(this,2)">
				                                 <span class="glyphicon glyphicon-eye-open"></span>
				                            </button>
				                        </td>
							        </tr>
							    <% } %>
                            </tbody>
                        </table>
                    <!-- </div> -->
                </div>
            </div>
        </div>
    </div>
     <!-- Modal -->
     <style>
     	.modal-dialog {
		     width: 80%;
		}
     </style>
    <div class="modal " id="closeMatchingDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <h4 class="modal-title" id="closeMatchingDetailModalLabel">List of Close Matching Transactions</h4>
                </div>
                <div class="modal-body" style="font-size: 90%;">
                	<table class="table table-bordered table-striped table-hover">
                		<caption style="border: inherit; background-color: lightgrey;">
				            <span class="align-left"><strong>Reference Unmatched Transaction</strong></span>
				        </caption>
                        <thead class="thead-inverse">
                            <tr>
                                <th>#</th>
                                <th>Date</th>
                                <th>Reference</th>
                                <th>Amount</th>
                                <th>ID</th>
                                <th>Narrative</th>
                            </tr>
                        </thead>
                        <tbody id="unmatchedTransaction">
                        </tbody>
                    </table>
                	<table id="CloseMatchingTable" class="table table-bordered table-striped table-hover">
                		<caption style="border: inherit; background-color: lightgrey;">
				            <span class="align-left"><strong>Close Matching Transactions</strong></span>
				        </caption>
                        <thead class="thead-inverse">
                            <tr>
                                <th>#</th>
                                <th>Date</th>
                                <th>Reference</th>
                                <th>Amount</th>
                                <th>ID</th>
                                <th>Narrative</th>
                                <th>MatchingRate</th>
                            </tr>
                        </thead>
                        <tbody id="closeMatchingDetail">
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
                </div>
            </div>
        </div>
    </div>
</body>
<script>
	var global_Comparison_result = JSON.parse('<%= session.getAttribute("comparisonResultStr") %>');
	//console.log(global_Comparison_result);
    $(document).ready(function() {
        $('#resultTable1').DataTable({autoWidth: true});
        $('#resultTable2').DataTable({autoWidth: true});
        $('#CloseMatchingTable').DataTable({autoWidth: true,  "lengthMenu": [3, 6, 9]});
    } );
    function openModal(element,type) {
   	  	var rowIdx = element.getAttribute("data-id");
   	  	var matchingList = null;
   	  	var unmatchedLineContent = null;
   	  	if (type == 1) {
   	  		matchingList = global_Comparison_result.unmatchingTransaction_1[rowIdx].closeMatchRecords;
   	  		unmatchedLineContent = global_Comparison_result.unmatchingTransaction_1[rowIdx].lineContent.split(",");
   	  	} else if (type == 2) {
   	  		matchingList = global_Comparison_result.unmatchingTransaction_2[rowIdx].closeMatchRecords;
   	  		unmatchedLineContent = global_Comparison_result.unmatchingTransaction_2[rowIdx].lineContent.split(",");
   	  	} else {
   	  		return;
   	  	}
   	  	
   	 	if ($.fn.DataTable.isDataTable("#CloseMatchingTable")) {
  		  $('#CloseMatchingTable').DataTable().clear().destroy();
  		}
   	 	
   	  	var matchingListTable = '';
   	  	for(var i=0;i<matchingList.length;i++) {
   	  		var lineContent = matchingList[i].lineContent.split(",");
   	  		matchingListTable += '<tr>' +
	        	'<th scope="row">' + i + '</th>' +
	            '<td>' + lineContent[<%=CoreProcessingService.TRANSACTION_DATE%>] + '</td>' +
	            '<td>' + ((lineContent.length > <%=CoreProcessingService.MAX_INDEX%>) ? lineContent[<%=CoreProcessingService.WALLET_REFERENCE%>] : '') + '</td>' +
	            '<td>' + lineContent[<%=CoreProcessingService.TRANSACTION_AMOUNT%>] + '</td>' +
	            '<td>' + lineContent[<%=CoreProcessingService.TRANSACTION_ID%>] + '</td>' +
	            '<td>' + lineContent[<%=CoreProcessingService.TRANSACTION_NARRATIVE%>] + '</td>' +
	            '<td>' + matchingList[i].matchingRate.toFixed(2) + '</td>' +
	        '</tr>';
   	  	}
   		document.getElementById("closeMatchingDetail").innerHTML = matchingListTable;
   		
   		document.getElementById("unmatchedTransaction").innerHTML = '<tr>' +
		    	'<th scope="row">0</th>' +
		        '<td>' + unmatchedLineContent[<%=CoreProcessingService.TRANSACTION_DATE%>] + '</td>' +
		        '<td>' + ((unmatchedLineContent.length > <%=CoreProcessingService.MAX_INDEX%>) ? unmatchedLineContent[<%=CoreProcessingService.WALLET_REFERENCE%>] : '') + '</td>' +
		        '<td>' + unmatchedLineContent[<%=CoreProcessingService.TRANSACTION_AMOUNT%>] + '</td>' +
		        '<td>' + unmatchedLineContent[<%=CoreProcessingService.TRANSACTION_ID%>] + '</td>' +
		        '<td>' + unmatchedLineContent[<%=CoreProcessingService.TRANSACTION_NARRATIVE%>] + '</td>' +
		    '</tr>';
   		$('#closeMatchingDetailModal').modal('show');

   		$('#CloseMatchingTable').DataTable({autoWidth: true, "lengthMenu": [3, 6, 9]});
   	}
</script>
</html>