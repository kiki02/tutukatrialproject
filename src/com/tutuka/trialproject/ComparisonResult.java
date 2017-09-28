package com.tutuka.trialproject;

import java.util.ArrayList;

public class ComparisonResult {
	public String filePath_1;
	public int totalRecords_1;
	public int matchingRecords_1;
	public int unmatchingRecords_1;
	public ArrayList<UnmatchingTransactions> unmatchingTransaction_1;
	
	public String filePath_2;
	public int totalRecords_2;
	public int matchingRecords_2;
	public int unmatchingRecords_2;
	public ArrayList<UnmatchingTransactions> unmatchingTransaction_2;
	
	public ComparisonResult() {
		super();
		// TODO Auto-generated constructor stub
		totalRecords_1 = 0;
		matchingRecords_1 = 0;
		unmatchingRecords_1 = 0;
		unmatchingTransaction_1 = new ArrayList<UnmatchingTransactions>();
		
		totalRecords_2 = 0;
		matchingRecords_2 = 0;
		unmatchingRecords_2 = 0;
		unmatchingTransaction_2 = new ArrayList<UnmatchingTransactions>();
	}
}
