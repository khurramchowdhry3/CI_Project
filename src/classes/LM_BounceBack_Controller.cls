public with sharing class LM_BounceBack_Controller extends LM_ComponentController
{
    public String bbRepaymentMethod { get; set; }
    public Operation__c o {get; set;}
    private Decimal eventAmount {get; set;}
    
    public override void extendedSetterActions()
    { 
        if(!bIsComponentInitialized) //The setter is called multiple times and we don't want to overwrite if initialization is already done
        {            
            super.extendedSetterActions();
            o = ((LM_EventProcessor_Controller)pageController).o;
        
            List<Loan_Management_Event__c> bbList = [SELECT Id, Operation__c, Event_Amount__c, Event_Date__c, Event_End_Date__c, Event_Process_Method__c, Event_Type__c, Event_Loan_Term__c, 
                                                            Payment_Received__c, Principal_Allocation__c, Interest_Allocation__c, Waive_Fee__c 
                                                     FROM Loan_Management_Event__c 
                                                     WHERE Operation__c =: lme.Operation__c
                                                     AND Event_Type__c =: lme.Event_Type__c
                                                     AND Event_Date__c =: Date.today()
                                                     AND IsApproved__c =: false
                                                    ];
            
            if (bbList.size() == 1)
            {
                
                lme = bbList[0];                
                if (rulesEngine != null)
                    bbRepaymentMethod = rulesEngine.Repayment_method__c;
            }
            else
            {      
                disableCalculation();
                infoMessage = 'There are no bounce backs for this loan, which require processing';
            }
        }
    }
    
    
    public List<SelectOption> getEventProcessMethods()
    {
        List<SelectOption> options = new List<SelectOption>();        
        options.add(new SelectOption('', '--None--'));
        options.add(new SelectOption('Manual', 'Manual'));
        if (o.Status__c != 'Paused' && o.Status__c != 'Pending Completion' && o.Status__c != 'Pending Cancellation')
        	options.add(new SelectOption(bbRepaymentMethod, bbRepaymentMethod));
        
        return options;
    }
    
    public void processMethodSelected()
    {
        if (lme.Event_Process_Method__c == 'Manual')
        {
            bIsCalculationActive = false;
            ((LM_EventProcessor_Controller)pageController).bIsSignOffVisible = true;
            calloutCalculate();
            lme.Event_Amount__c = getTotalAmount();
        }
        else
            bIsCalculationActive = true;
    }
    
	private void calloutCalculate()
    {       
        String getParams = '?LoanId=' + lme.Operation__c +
            '&EventType=' + 'Bounce Back'.replaceAll(' ', '%20') +
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
    
    public decimal getTotalAmount()
    {
        return eventAmount +
            (lme.Waive_Fee__c ? 0 : (cr.EventFeeAmount + cr.EventFeeVATAmount));
    }
    
    
}