package com.tutuka.trialproject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;

import com.google.code.externalsorting.ExternalSort;

public class CoreProcessingService {
	private static int ind = 0;
	public static int PROFILE_NAME = ind++;
	public static int TRANSACTION_DATE = ind++;
	public static int TRANSACTION_AMOUNT = ind++;
	public static int TRANSACTION_NARRATIVE = ind++;
	public static int TRANSACTION_DESCRIPTION = ind++;
	public static int TRANSACTION_ID = ind++;
	public static int TRANSACTION_TYPE = ind++;
	public static int WALLET_REFERENCE = ind;
	public static int MAX_INDEX = ind;
	
	public static int matchingThreshold = 70; //70%
	
	public static boolean isFilePathValid(String filePath) {
		if (filePath == null || filePath.equals("") || filePath.length() < 4)
			return false;
		else
			return true;
	}
	
	public static double calculateMatchingRate(String[] line_1, String[] line_2) {
		double ret = 0;
		int max_len = line_1.length;
		
		// We will compare field by field of each transaction
		for (int idx=0;idx<line_1.length;idx++) {
			if (idx >= line_2.length)
				break;
//			if (line_1[idx].equals(line_2[idx]))
//				ret = ret + 1;
			// compute string similarity value
			ret = ret + StringSimilarity.similarity(line_1[idx], line_2[idx]);
		}
		
		if (max_len < line_2.length)
			max_len = line_2.length;
		if (max_len < 1)
			return 0;
			
		return ret*100/max_len;
	}
	
	public static ComparisonResult startCompareFiles(String file1, String file2) {
        File raw_file1 = new File(file1);
        File sorted_file1 = new File(raw_file1.getParent()+File.separator+"sortedfile_"+raw_file1.getName());
        File raw_file2 = new File(file2);
        File sorted_file2 = new File(raw_file2.getParent()+File.separator+"sortedfile_"+raw_file2.getName());
        
        // sorting both of two files
        Comparator<String> comparator_id = new Comparator<String>() {
            public int compare(String r1, String r2){
                return r1.compareTo(r2);
            }
        };
        int maxNumberTempFiles = 1000;
        Charset cs = Charset.defaultCharset();
        boolean distinctValues = false;
        
        // we use 3rd party library for sorting files. This library has a good performance even though the size of input file is large (1GB,...) 
        try {
	        List<File> listTmpFile1 = ExternalSort.sortInBatch(raw_file1, comparator_id, maxNumberTempFiles,cs,null,distinctValues,1) ;
			ExternalSort.mergeSortedFiles(listTmpFile1, sorted_file1, comparator_id,cs, distinctValues);
			
			List<File> listTmpFile2 = ExternalSort.sortInBatch(raw_file2, comparator_id, maxNumberTempFiles,cs,null,distinctValues,1) ;
			ExternalSort.mergeSortedFiles(listTmpFile2, sorted_file2, comparator_id,cs, distinctValues);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        
        // Base on sorted input files, we will start transaction comparison process
        ComparisonResult compResult = new ComparisonResult();
        compResult.filePath_1 = raw_file1.getName();
        compResult.filePath_2 = raw_file2.getName();
        String strLine1 = null;
        String strLine2 = null;
        boolean shouldStop = false;
        try {
            BufferedReader in1 = new BufferedReader(new FileReader(sorted_file1));
            BufferedReader in2 = new BufferedReader(new FileReader(sorted_file2));
            
            strLine1 = in1.readLine();
            compResult.totalRecords_1 = 1;
            if (strLine1 == null) {
            	compResult.totalRecords_1 = 0;
            	while ((strLine2 = in2.readLine()) != null) {
            		compResult.totalRecords_2++;
            		compResult.unmatchingRecords_2++;
            		compResult.unmatchingTransaction_2.add(new UnmatchingTransactions(strLine2));
            	}
            	shouldStop = true;
            }
            if (!shouldStop) {
	            strLine2 = in2.readLine();
	            compResult.totalRecords_2 = 1;
	            if (strLine2 == null) {
	            	compResult.totalRecords_2 = 0;
	            	compResult.unmatchingRecords_1++;
	            	compResult.unmatchingTransaction_1.add(new UnmatchingTransactions(strLine1));
	            	while ((strLine1 = in1.readLine()) != null) {
	            		compResult.totalRecords_1++;
	            		compResult.unmatchingRecords_1++;
	            		compResult.unmatchingTransaction_1.add(new UnmatchingTransactions(strLine1));
	            	}
	            	shouldStop = true;
	            }
            }
 
            // Try to compare line by line of each file. Finally, we will have 2 lists of unmatching transactions for each file
            while (!shouldStop) {	
                int cmpRet = strLine1.compareTo(strLine2);
                
                if (cmpRet == 0) {
                	strLine1 = in1.readLine();
                	if (strLine1 == null) {
                    	while ((strLine2 = in2.readLine()) != null) {
                    		compResult.totalRecords_2++;
                    		compResult.unmatchingRecords_2++;
                    		compResult.unmatchingTransaction_2.add(new UnmatchingTransactions(strLine2));
                    	}
                    	shouldStop = true;
                    	break;
                    } else {
                    	compResult.totalRecords_1++;
                    }
                	strLine2 = in2.readLine();
                	if (strLine2 == null) {
                		compResult.unmatchingRecords_1++;
                		compResult.unmatchingTransaction_1.add(new UnmatchingTransactions(strLine1));
                    	while ((strLine1 = in1.readLine()) != null) {
                    		compResult.totalRecords_1++;
                    		compResult.unmatchingRecords_1++;
                    		compResult.unmatchingTransaction_1.add(new UnmatchingTransactions(strLine1));
                    	}
                    	shouldStop = true;
                    	break;
                    } else {
                    	compResult.totalRecords_2++;
                    }
                } else if (cmpRet > 0) {
                	compResult.unmatchingRecords_2++;
                	compResult.unmatchingTransaction_2.add(new UnmatchingTransactions(strLine2));
                	strLine2 = in2.readLine();
                	if (strLine2 == null) {
                		shouldStop = true;
                		break;
                	}
                	compResult.totalRecords_2++;
                } else if (cmpRet < 0) {
                	compResult.unmatchingRecords_1++;
                	compResult.unmatchingTransaction_1.add(new UnmatchingTransactions(strLine1));
                	strLine1 = in1.readLine();
                	if (strLine1 == null) {
                		shouldStop = true;
                		break;
                	}
                	compResult.totalRecords_1++;
                }
            }
            in1.close();
            in2.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // delete sorted temp files
        sorted_file1.delete();
        sorted_file2.delete();
        
        compResult.matchingRecords_1 = compResult.totalRecords_1 - compResult.unmatchingRecords_1;
        compResult.matchingRecords_2 = compResult.totalRecords_2 - compResult.unmatchingRecords_2;
        
        int lenUnmatchingTransaction_1 = compResult.unmatchingTransaction_1.size();
        int lenUnmatchingTransaction_2 = compResult.unmatchingTransaction_2.size();
        
        // base on unmatching transactions list, we will find the close matched transactions for each unmatching transaction
        // To make this easy, I will separate into 2 steps. One step is for file 1, and another is for file 2.
        // For unmatching records in file 1: looking for any close matches
        for (int i=0;i<lenUnmatchingTransaction_1;i++) {
        	String[] recordLine_1 = compResult.unmatchingTransaction_1.get(i).lineContent.split(",");
        	ArrayList<CloseMatchData> tmpList = new ArrayList<CloseMatchData>();
        	for (int j=0;j<lenUnmatchingTransaction_2;j++) {
        		String[] recordLine_2 = compResult.unmatchingTransaction_2.get(j).lineContent.split(",");
        		
        		CloseMatchData closeData = new CloseMatchData();
        		closeData.lineContent = compResult.unmatchingTransaction_2.get(j).lineContent;
        		closeData.matchingRate = calculateMatchingRate(recordLine_1,recordLine_2);
        		
        		// Should be matched with high rate - matchingThreshold %
        		if (closeData.matchingRate > matchingThreshold)
        			tmpList.add(closeData);
        	}
        	// sorting matching list by descending order of matchingRate
    		Collections.sort(tmpList, new Comparator<CloseMatchData>() {
    	        @Override
    	        public int compare(CloseMatchData data_1, CloseMatchData data_2)
    	        {
    	        	return Double.compare(data_2.matchingRate, data_1.matchingRate);
    	        }
    	    });
    		
    		compResult.unmatchingTransaction_1.get(i).closeMatchRecords.addAll(tmpList);
        }
        
        // For unmatching records in file 2: looking for any close matches
        for (int i=0;i<lenUnmatchingTransaction_2;i++) {
        	String[] recordLine_2 = compResult.unmatchingTransaction_2.get(i).lineContent.split(",");
        	ArrayList<CloseMatchData> tmpList = new ArrayList<CloseMatchData>();
        	for (int j=0;j<lenUnmatchingTransaction_1;j++) {
        		String[] recordLine_1 = compResult.unmatchingTransaction_1.get(j).lineContent.split(",");
        		
        		CloseMatchData closeData = new CloseMatchData();
        		closeData.lineContent = compResult.unmatchingTransaction_1.get(j).lineContent;
        		closeData.matchingRate = calculateMatchingRate(recordLine_2,recordLine_1);
        		
        		// Should be matched with high rate - matchingThreshold %
        		if (closeData.matchingRate > matchingThreshold)
        			tmpList.add(closeData);
        	}
        	// sorting matching list by descending order of matchingRate
    		Collections.sort(tmpList, new Comparator<CloseMatchData>() {
    	        @Override
    	        public int compare(CloseMatchData data_1, CloseMatchData data_2)
    	        {
    	        	return Double.compare(data_2.matchingRate, data_1.matchingRate);
    	        }
    	    });
    		
    		compResult.unmatchingTransaction_2.get(i).closeMatchRecords.addAll(tmpList);
        }
        
        return compResult;
	}
}
