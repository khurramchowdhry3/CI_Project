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
 * Loan Management OneOff Event Controller extension Class to OneOff the Loan Ammount.
 * This controller class enforce the sharing rules for the current user. 
 */
 
public with sharing class LM_OneOff_Controller extends LM_ComponentController{
	
    private Operation__c o;
    public Date oneOffDate {get; set;}
    public Boolean payFullAmount {get; set;}
    public Boolean disableAmountInput {get; set;}
    
	public override void extendedSetterActions() 
    {	
        if(!bIsComponentInitialized){	//The setter is called multiple times and we don't want to overwrite if initialization is already done
        
            super.extendedSetterActions();
            o = ((LM_EventProcessor_Controller)pageController).o;
            
            payFullAmount = false;
            disableAmountInput = null;
            lme.Event_Date__c = Date.today();
            
            calloutCalculate();
        }
    }
	
	public list<selectOption> getEventProcessMethods(){
		
		list<selectOption> Methods = new list<selectOption>();
		Methods.add(new selectoption('None' , '--None--'));
		Methods.add(new selectoption('Keep Installment', 'Keep Installment'));
		Methods.add(new selectoption('Keep Term', 'Keep Term'));		
		return Methods;		
	}
    
    private void calloutCalculate()
    {       
        String getParams = '?LoanId=' + lme.Operation__c +
            '&EventType=' + 'One Off Full Amount'.replaceAll(' ', '%20') +
            '&EventStartDate=' + CRMS_Util.DateToString(lme.Event_Date__c, LMS_Constants.DATE_FORMAT_DWH) +
            '&EventEndDate=' + CRMS_Util.DateToString(lme.Event_End_Date__c, LMS_Constants.DATE_FORMAT_DWH) +
            '&EventAmount=' + lme.Event_Amount__c +
            '&LoanTerm=' + (lme.Event_Loan_Term__c == null ? '' : lme.Event_Loan_Term__c.substring(4, 7).replaceAll(' ', '')) +
            '&EventProcessMethod=' + (lme.Event_Process_Method__c == null ? '' : lme.Event_Process_Method__c.replaceAll(' ', '%20')) +
            '&PaymentReceived=' + lme.Payment_Received__c +
            '&PrincipalAllocation=' + lme.Principal_Allocation__c +
            '&InterestAllocation=' + lme.Interest_Allocation__c;  
        
        string calculateResponse = LMS_Callout.CallOutGET(LMS_Constants.endpointValue, getParams);
        processResponse(calculateResponse);
    }
    
    public void processResponse(string response)
    {
        if(response == null)
       	{
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Http request failed');
           ApexPages.addMessage(myMsg);
           return;
       	}
                
        Map<String, Object> responseMap =  (Map<String, Object>)JSON.deserializeUntyped(response); 
        List<Object> responseResultsList = (List<Object>)responseMap.get('results');
        
        if (responseResultsList == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The calculation request failed');
           	ApexPages.addMessage(myMsg);
           	return;
        }
        
        Map<String, Object> resultsMap = (Map<String, Object>)responseResultsList[0];          
        
        String responseResultJSON = JSON.serialize(responseMap.get('results'));
        cr = ((List<LM_CalculationResult>)JSON.deserialize(responseResultJSON, List<LM_CalculationResult>.class))[0];
        cr.lme = lme;
           
        if(cr.Result == 'Error')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, cr.Reason);
            ApexPages.addMessage(myMsg);       
            
        }
    }
    
    public void calloutEffectiveDate()
    {
        string tmpEventType = lme.Event_Process_Method__c == 'Full Amount' ? 'One Off Full Amount' : lme.Event_Type__c;
        
        string getParams = '?LoanId=' + lme.Operation__c + 
                            '&StartDate=' + CRMS_Util.DateToString(Date.today(), LMS_Constants.DATE_FORMAT_DWH) +
                            '&Days=' + String.valueOf(Integer.valueOf(rulesEngine.Notification_days__c) + 1) +
                            '&EventType=' + tmpEventType.replaceAll(' ', '%20');
        
        lme.Effective_Date__c = Date.valueOf(((string)LMS_Callout.GetResultsMapFromResponse(LMS_Callout.CallOutGET(LMS_Constants.FirstRepDayEndPoint, getParams)).get('repaymentDay')).replace('T', ' '));
        
    }
    
    public void calcFullAmount()
    {
        if(payFullAmount)
        {
            calloutCalculate();
            lme.Event_Amount__c = getOneOffTotal();
            lme.Event_Process_Method__c = 'Full Amount';
            calloutEffectiveDate();
            
            bIsCalculationActive = false;
            ((LM_EventProcessor_Controller)pageController).bIsSignOffVisible = true;
            ((LM_EventProcessor_Controller)pageController).bIsSchedulePanelVisible = false;
        }
        else
        {
            lme.Event_Process_Method__c = null;
            calloutEffectiveDate();
            
            bIsCalculationActive = true;
            ((LM_EventProcessor_Controller)pageController).bIsSignOffVisible = false;
        }
    }
    
    public string getAccummulatedFees()
    {
        return string.valueOf(cr.AccFeesAmount + cr.AccFeesVatAmount) + ' (incl. VAT ' + string.valueOf(cr.AccFeesVatAmount) + ')';
    }
    
    public string getOneOffFee()
    {
        return string.valueOf(cr.EventFeeAmount + cr.EventFeeVATAmount) + ' (incl. VAT ' + string.valueOf(cr.EventFeeVATAmount) + ')';
    }
    
    public decimal getOneOffTotal()
    {
        return cr.PrincipalAmount + cr.AccFeesAmount + 
            (lme.Waive_Fee__c ? 0 : (cr.EventFeeAmount + cr.EventFeeVATAmount)) +
            (cr.AccFeesAmount + cr.AccFeesVATAmount);
    } 
}