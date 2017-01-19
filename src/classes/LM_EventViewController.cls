public class LM_EventViewController 
{
    private Loan_Management__c rules { get; set; }
    public Date EffectiveDate { get; set; }
    private LM_CalculationResult cr { get; set; }
    
    public Loan_Management_Event__c lme 
    { 
        get; 
        set
        {
            if (lme != value)
            {
                lme = value;
                
                rules = [SELECT Notification_days__c FROM Loan_Management__c WHERE Program_Product_ASO__c =: lme.Operation__r.Program_Product_ASO__c][0];
        		EffectiveDate = CRMS_Util.AddBusinessDays(Date.today(), Integer.valueOf(rules.Notification_days__c) + 1);
            }
        }
   	}
    
    
	public PageReference CancelEvent()
    {
        Loan_Management_Event__c cancelLME = new Loan_Management_Event__c();
        cancelLME.Event_Type__c = 'Cancel ' + lme.Event_Type__c;
        cancelLME.Operation__c = lme.Operation__c;
        cancelLME.Related_Event_Id__c = lme.Id;
        cancelLME.Event_Date__c = Date.today();
        cancelLME.Effective_Date__c = EffectiveDate;
        
        cancelLME.Approval_Date__c = DateTime.now();
        cancelLME.ApprovedBy__c = UserInfo.getUserId();
        cancelLME.IsApproved__c = true;
        
        calloutCalculate(cancelLME);
        
        insert cancelLME;
        
        lme.IsActive__c = false;
        update lme;
        
        Operation__c o = new Operation__c(id = lme.Operation__c, 
                                          Final_Repayment_Date__c = Date.valueOf(cr.LoanEndDate),
                                          Loan_Outstanding_Interest__c = cr.InterestAmount,
                                          Loan_Outstanding_VAT_Amount__c = cr.InterestVATAmount
                                         );
        update o;
        
        PageReference p = new PageReference('/apex/LM_LoanDetails');
        p.getParameters().put('Id', lme.Operation__c);
        p.setRedirect(true);
        return p;
    }
    
    public boolean getIsCancelDisabled()
    {
        return EffectiveDate > lme.Event_End_Date__c;
    }
    
    private void calloutCalculate(Loan_Management_Event__c lme)
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
        //cr.lme = lme;
           
        if(cr.Result == 'Error')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, cr.Reason);
            ApexPages.addMessage(myMsg);       
            
        }
    }
}