public with sharing class LM_DebtCollection_Controller extends LM_ComponentController {

    public Boolean isSuspended {get; set;} 
    public Operation__c op {get; set;}
	public LM_CalculationResult cr { get; set; }
    public string validationMessage { get; set; }
    private decimal fullAmount { get; set; }
    public decimal feeAmount { get; set; }
    public integer isValid { get; set; } // 1 - valid; 2 - valid if fee is waived; 3 - invalid
    public decimal principalLowerLimit { get; set; }
    public decimal principalUpperLimit { get; set; }
    public Integer sliderRatio { get; set; }
      
	public override void extendedSetterActions() 
    {	
    	
        if(!bIsComponentInitialized){	//The setter is called multiple times and we don't want to overwrite if initialization is already done
            super.extendedSetterActions();
            
            op = ((LM_EventProcessor_Controller)pageController).o;
            Loan_Management__c rules = ((LM_EventProcessor_Controller)pageController).rules;
            
            lme.Event_Date__c = Date.Today();
            
            isSuspended = op.Status__c == 'Defaulted' ? true : false;
            bIsCalculationActive = false;
            isValid = 3;
            
            fullAmount = op.Loan_Outstanding_Principal__c + op.Loan_Outstanding_Interest__c + getManualFeeAmount(op.Loan_Outstanding_Principal__c + op.Loan_Outstanding_Interest__c, 'Full');
        }
    }
    
    public PageReference MoveToSuspension ()
    {
        lme.IsApproved__c = true;
        lme.ApprovedBy__c = UserInfo.getUserId();
        lme.Approval_Date__c = Datetime.now();
        lme.Event_Type__c = 'Default';
        
        string getParams = '?LoanId=' + lme.Operation__c + 
                            '&StartDate=' + CRMS_Util.DateToString(Date.today(), LMS_Constants.DATE_FORMAT_DWH) +
                            '&Days=' + String.valueOf(Integer.valueOf(rulesEngine.Notification_days__c) + 1) +
                            '&EventType=' + 'Default'.replaceAll(' ', '%20');
        
        lme.Effective_Date__c = Date.valueOf(((string)LMS_Callout.GetResultsMapFromResponse(LMS_Callout.CallOutGET(LMS_Constants.FirstRepDayEndPoint, getParams)).get('repaymentDay')).replace('T', ' '));
        
        
        insert lme;
        
        op.Status__c = 'Defaulted';
        op.Remaining_Number_of_Repayments__c = 0;
        update op;
        
        PageReference p = new PageReference('/apex/LM_LoanDetails');
        p.getParameters().put('Id', op.Id);
        p.setRedirect(true);
        return p;
    }
    
    public Integer ResetSliderValue()
    {
        decimal decValue;
        
        if (lme.Principal_Allocation__c == null || lme.Principal_Allocation__c < Math.floor(principalLowerLimit) || lme.Principal_Allocation__c > Math.ceil(principalUpperLimit))
            decValue = (principalUpperLimit + principalLowerLimit)/2;
        else if (lme.Principal_Allocation__c == principalLowerLimit)
            decValue = Math.floor(principalLowerLimit);
        else if (lme.Principal_Allocation__c == principalUpperLimit)
            decValue = Math.ceil(principalUpperLimit);
        else
            decValue = lme.Principal_Allocation__c;
        
        return Integer.valueOf(string.valueOf(Math.floor(decValue)));
    }
    
    public string RatioString
    {
        get
        {
            return String.valueOf(sliderRatio) + '% - ' + String.valueOf(100 - sliderRatio) + '%';
        }
    }
    
    public decimal getManualFeeAmount(decimal amount, string type)
    {
        if (amount == null || amount == 0)
            return 0;
        
        string getParams = '?LoanId=' + lme.Operation__c + '&Amount=' + amount + '&Type=' + type;
        string response = LMS_Callout.CallOutGET(LMS_Constants.LoanFeesEndPoint, getParams);
        
        if(response == null)
       	{
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Http request failed');
           ApexPages.addMessage(myMsg);
           return 0;
       	}
                
        Map<String, Object> responseMap =  (Map<String, Object>)JSON.deserializeUntyped(response); 
        List<Object> responseResultsList = (List<Object>)responseMap.get('results');
        
        if (responseResultsList == null || responseResultsList.size() == 0)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The fee request failed');
           	ApexPages.addMessage(myMsg);
           	return 0;
        }
        
        Map<String, Object> resultsMap = (Map<String, Object>)responseResultsList[0];  
		return (Decimal)resultsMap.get('manualRepaymentFee');
        
    }
    
    public void AmountChangeAction()
    {
        validationMessage = '';
        isValid = 3;
        bIsCalculationActive = false;
        
        if (lme.Event_Amount__c <= 0)
            validationMessage = 'The entered amount should be higher than 0.';
        else if (lme.Event_Amount__c >= fullAmount)
        {
            validationMessage = 'The entered amount should not be higher than the outstanding amount.';
        }
        else
        {
            isValid = 1;
            bIsCalculationActive = true;
            feeAmount = getManualFeeAmount(lme.Event_Amount__c, 'Split');
            
            if (lme.Event_Amount__c <= feeAmount && lme.Waive_Fee__c == false)
            {
                validationMessage = 'The entered amount should be higher than the fee amount. Please waive the fee, or enter higher amount.';
                isValid = 2;
                bIsCalculationActive = false;
            }  
            
            principalLowerLimit = getPrincipalLowerLimit();
            principalUpperLimit = getPrincipalUpperLimit();
            
            sliderRatio = ResetSliderValue(); 
                        
            UpdateAllocation();
			
        }        
    }
    
    public void UpdateAllocation()
    {
        if (sliderRatio == Math.floor(principalLowerLimit))
            lme.Principal_Allocation__c = principalLowerLimit;
        else if (sliderRatio == Math.ceil(principalUpperLimit))
            lme.Principal_Allocation__c = principalUpperLimit;
        else
            lme.Principal_Allocation__c = sliderRatio;
		
		lme.Interest_Allocation__c = 100 - lme.Principal_Allocation__c;
        
        calloutCalculate();
    }
    
    private decimal getPrincipalLowerLimit()
    {
        if (lme.Event_Amount__c == null || lme.Event_Amount__c == 0 || lme.Event_Amount__c > fullAmount)
            return 0;
        
        decimal ManualFeeAmount = lme.Waive_Fee__c ? 0 : feeAmount;
        decimal minPrincipal = (100 - op.Loan_Outstanding_Interest__c/lme.Event_Amount__c*100) > ManualFeeAmount/lme.Event_Amount__c*100 ? 100 - op.Loan_Outstanding_Interest__c/lme.Event_Amount__c*100 : ManualFeeAmount/lme.Event_Amount__c*100;
        return (minPrincipal < 0) ? 0 : minPrincipal;
    }
    
    private decimal getPrincipalUpperLimit()
    {
        if (lme.Event_Amount__c == null || lme.Event_Amount__c == 0 || lme.Event_Amount__c > fullAmount  )
            return 100;
        
        decimal ManualFeeAmount = lme.Waive_Fee__c ? 0 : feeAmount;
        return ((op.Loan_Outstanding_Principal__c + ManualFeeAmount)/lme.Event_Amount__c*100 > 100) ? 100 : ((op.Loan_Outstanding_Principal__c + ManualFeeAmount)/lme.Event_Amount__c*100);
    }
    
    private void calloutCalculate()
    { 
        if (lme.Event_Amount__c == null || lme.Event_Amount__c == 0)
            return;
        
        String getParams = '?LoanId=' + lme.Operation__c +
            '&EventType=' + 'Manual Payment Allocation'.replaceAll(' ', '%20') +
            '&EventStartDate=' + CRMS_Util.DateToString(lme.Event_Date__c, LMS_Constants.DATE_FORMAT_DWH) +
            '&EventEndDate=' + CRMS_Util.DateToString(lme.Event_End_Date__c, LMS_Constants.DATE_FORMAT_DWH) +
            '&EventAmount=' + lme.Event_Amount__c +
            '&LoanTerm=' + (lme.Event_Loan_Term__c == null ? '' : lme.Event_Loan_Term__c.substring(4, 7).replaceAll(' ', '')) +
            '&EventProcessMethod=' + (lme.Event_Process_Method__c == null ? '' : lme.Event_Process_Method__c.replaceAll(' ', '%20')) +
            '&PaymentReceived=' + lme.Payment_Received__c +
            '&PrincipalAllocation=' + lme.Principal_Allocation__c +
            '&InterestAllocation=' + lme.Interest_Allocation__c +
            '&WaiveFee=' + lme.Waive_Fee__c;  
        
        string calculateResponse = LMS_Callout.CallOutGET(LMS_Constants.endpointValue, getParams);
        processResponse(calculateResponse);
    }
    
    public void processResponse(string response)
    {
        System.debug(response);
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
    
}