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
 * Controller class to make request for Loan Schedule Items to AMP DWH for current Opertion..
 *
 */ 

public with sharing class LMS_LoanSchedule {
	
	private final Operation__c Operation;
	public string Client	{get; set;}
	public string mimetype	{get; set;}{
		mimetype = 'application/vnd.pdf#Loan-Schedule.pdf';
	}
	public boolean VATNotZero {get; set;}{
		VATNotZero = true;
	}	
	
	public LMS_LoanSchedule(LM_LoanDetails_Controller DetailController){		
		Operation = DetailController.o;				
	} 
	
	/*	 
     *  Method to request for Loan Schedule Items from AMP DWH for Current Opertion
     *  Serialize the JSON response into Wrapper Class object  
     *  Return Null and show appropriate Error Message in case of 
     *	Mising required parameter, Null Response or on Error in response.     
     *     
     */ 
	
	public list<LMS_LoanScheduleWrapper> getLoanScheduleItems(){		
		string ScheduleResponse = LMS_Callout.CallOutGET(LMS_Constants.LoanScheduleEndPoint, '?LoanId='+Operation.Id);	
		Client = Operation.Account__r.Name;
		
		if(ScheduleResponse != null){
			Map<String, Object> DeserializedResponseMap = (Map<String, Object>)JSON.deserializeUntyped(ScheduleResponse);
			
			if(!(string.valueOf(DeserializedResponseMap.get('results')).equals('()'))){				
				string ResponseResult = JSON.serialize(DeserializedResponseMap.get('results'));
				list<LMS_LoanScheduleWrapper> ScheduleItems = (list<LMS_LoanScheduleWrapper>)JSON.deserialize(ResponseResult, list<LMS_LoanScheduleWrapper>.class);
				if(ScheduleItems[0].result != 'error'){
					CheckForZeroValue(ScheduleItems);
					return ScheduleItems;
				}else ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ScheduleItems[0].message));					
			}			
		}else ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failed getting HTTP request'));
		return null;
	}
	
	private void CheckForZeroValue(list<LMS_LoanScheduleWrapper> Items){
		Decimal maxVat, minVat;
		minVat = maxVat = Items[0].interestVATAmount;		
		for(LMS_LoanScheduleWrapper wrap : Items){						
			if(wrap.interestVATAmount > maxVat)
				maxVat = wrap.interestVATAmount;
			if(wrap.interestVATAmount < minVat)
				minVat = wrap.interestVATAmount;																			
		}
		
		if(minVat == 0 && maxVat == 0){
			VATNotZero = false;
		}
	}
}