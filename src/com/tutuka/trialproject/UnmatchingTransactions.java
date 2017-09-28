package com.tutuka.trialproject;

import java.util.ArrayList;
public class UnmatchingTransactions {
	public String lineContent;
	public ArrayList<CloseMatchData> closeMatchRecords;
	
	public UnmatchingTransactions(String line) {
		super();
		// TODO Auto-generated constructor stub
		this.lineContent = line;
		
		closeMatchRecords = new ArrayList<CloseMatchData>();
	}
}
