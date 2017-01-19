/**
 * AMP Loan Management System
 * 
 * This file is part of the AMP Loan Management Project
 * Loan Management System for Sales & Admin Peoples.
 *
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Controller class to make request for Loan Ledger Items to AMP DWH for current Opertion.
 *
 */ 
public with sharing class LMS_LoanLedger {
	
	private final Operation__c Operation;
	public string Client	{get; set;}	
    public String ResponseResult {get; set;}
		
	public LMS_LoanLedger(LM_LoanDetails_Controller DetailController){		
		Operation = DetailController.o;
	} 
	
	/*
     *  Method to request for Loan Ledger Items from AMP DWH for Current Opertion
     *  Serialize/Deserialize the JSON response into Wrapper Class object  
     *  Return Null and show appropriate Error Message in case of 
     *	Mising required parameter, Null Response or on Error in response.     
     *     
     */     
	
	public list<LMS_LoanLedgerWrapper> getLoanLedgerItems(){
			
		string LedgerResponse = LMS_Callout.CallOutGET(LMS_Constants.LoanLedgerEndPoint,'?LoanId='+Operation.Id);	
		Client = Operation.Account__r.Name;		
		if(LedgerResponse != null){
			Map<String, Object> DeserializedResponseMap = (Map<String, Object>)JSON.deserializeUntyped(LedgerResponse);
			
			if(!(string.valueOf(DeserializedResponseMap.get('results')).equals('()'))){
				ResponseResult = JSON.serialize(DeserializedResponseMap.get('results'));
				list<LMS_LoanLedgerWrapper> LedgerItems = (list<LMS_LoanLedgerWrapper>)JSON.deserialize(ResponseResult, list<LMS_LoanLedgerWrapper>.class);
				if(LedgerItems[0].result != 'error'){
					return LedgerItems;
				}else ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,LedgerItems[0].message));					
			}
		}else ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failed getting HTTP request'));		
		return null;
	}	
}