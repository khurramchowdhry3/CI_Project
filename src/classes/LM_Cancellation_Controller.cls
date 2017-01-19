public with sharing class LM_Cancellation_Controller extends LM_ComponentController {
	
    private Operation__c o;
    
    public override void extendedSetterActions() 
    {	
        if(!bIsComponentInitialized){	//The setter is called multiple times and we don't want to overwrite if initialization is already done
        
            super.extendedSetterActions();
            o = ((LM_EventProcessor_Controller)pageController).o;
            
            if ( !rulesEngine.Allow_Cancellation__c || rulesEngine.Cancellation_Period__c == null )
            {
                infoMessage = 'The product assigned to this loan does not allow for cancellation.';
                disableCalculation();
            }
            else if ( CRMS_Util.AddBusinessDays(o.Loan_Disbursed_Date__c, Integer.valueOf(rulesEngine.Cancellation_Period__c)) < Date.today() )
            {
                infoMessage = 'The cancellation period of ' + String.valueOf(rulesEngine.Cancellation_Period__c) + ' days has expired.';
                disableCalculation();
            }
            else
            {
                bIsCalculationActive = false;
                ((LM_EventProcessor_Controller)pageController).bIsSignOffVisible = true;
                
                lme.Event_Date__c = Date.today();             
                calloutCalculate();
                
                lme.Event_Amount__c = getCancellationTotal();
            }
            
        }
    }
    
    private void calloutCalculate()
    {       
        String getParams = '?LoanId=' + lme.Operation__c +
            '&EventType=' + lme.Event_Type__c.replaceAll(' ', '%20') +
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
    
    public string getAccummulatedFees()
    {
        system.debug(cr);
        return string.valueOf(cr.AccFeesAmount + cr.AccFeesVatAmount) + ' (incl. VAT ' + string.valueOf(cr.AccFeesVatAmount) + ')';
    }
    
    public string getCancellationFee()
    {
        return string.valueOf(cr.EventFeeAmount + cr.EventFeeVATAmount) + ' (incl. VAT ' + string.valueOf(cr.EventFeeVATAmount) + ')';
    }
    
    public decimal getCancellationTotal()
    {
        return cr.PrincipalAmount + cr.AccFeesAmount + 
            (lme.Waive_Fee__c ? 0 : (cr.EventFeeAmount + cr.EventFeeVATAmount)) +
            (cr.AccFeesAmount + cr.AccFeesVATAmount);
    }
}