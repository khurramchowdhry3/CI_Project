public with sharing class LM_EventProcessor_Controller extends PageControllerBase
{
    public Operation__c o { get; set; }
    public LM_CalculationResult cr { get; set; }
    public String EventType 
    { 
        get; 
     	set
        {
            if (EventType != value)
            {
                EventType = value;
                bIsSchedulePanelVisible = false;
                bIsSignOffVisible = false;
                bIsAgreed = false;
                //cr = null; 
            }
        }
    }
    
    public Loan_Management__c rules { get; set; }
    public boolean bIsSchedulePanelVisible { get; set;}
    public boolean bIsSignOffVisible { get; set; }
    public boolean bIsAgreed { get; set; }
    
    public List<LMS_CalculationFieldDescriptor> lstCalculationResultValues { get {
        return lstCalculationResultValues;
    } set; }
    
    public transient LM_ComponentController componentController { get; set; }
    
    public override void setComponentController(ComponentControllerBase compController)
    {
        componentController = (LM_ComponentController)compController;
    }
    
    public LM_EventProcessor_Controller(LM_LoanDetails_Controller parentController)
    {              
        o = parentController.o;
        //cr = new LM_CalculationResult();
        //cr.lme = new Loan_Management_Event__c();
        
        if(parentController.rules != null)
        	rules = parentController.rules;
        
        bIsSchedulePanelVisible = false;
        bIsSignOffVisible = false;
        bIsAgreed = false;
    }
    
    public boolean getCalculationPanelVisibility()
    {
        if (componentController != null)
            return (EventType != 'None') && componentController.bIsCalculationActive;
        
        return false;
    }
    
    public List<SelectOption> getEventTypes()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('None','--None--'));
        if (o.Status__c == 'Defaulted')
            options.add(new SelectOption('Debt Collection','Debt Collection'));
        else if (o.Status__c == 'Completed')
            options.add(new SelectOption('Renewal','Renewal'));
        else if (o.Status__c == 'Pending Completion' || o.Status__c == 'Paused' || o.Status__c == 'Pending Cancellation')
            options.add(new SelectOption('Bounce Back','Bounce Back'));
        else
        {
            Schema.DescribeFieldResult fieldResult = Loan_Management_Event__c.Event_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry p : ple)
                if ((p.getValue() != 'Completion' && p.getValue() != 'Resume' && p.getValue() != 'Renewal' && p.getValue() != 'Reject' &&
                    p.getValue() != 'Cancel Payment Holiday' && p.getValue() != 'Cancel Change Collection Amount' && p.getValue() != 'Waive Accummulated Fees' && p.getValue() != 'Default') && 
                    ((o.Status__c != 'Disbursed') || 
                     (o.Status__c == 'Disbursed' && (p.getValue() == 'One off' || p.getValue() == 'Payment Holiday' || p.getValue() == 'Change Collection Amount' 
                                                     || p.getValue() == 'Cancellation' || p.getValue() == 'Early Repayment'))))
                    options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        
        return options;
    }
    
    
    public PageReference Calculate()
    {
        Loan_Management_Event__c lme = componentController.lme;
        
        String getParams = '?LoanId=' + lme.Operation__c +
            '&EventType=' + lme.Event_Type__c.replaceAll(' ', '%20') +
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

        return null;
    }
    
    public void processResponse(string response)
    {
        if(response == null)
       	{
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Http request failed');
           ApexPages.addMessage(myMsg);
           return;
       	}
        system.debug(response);
        lstCalculationResultValues = new List<LMS_CalculationFieldDescriptor>();
        
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
        cr.lme = componentController.lme;
           
        if(cr.Result == 'Error')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, cr.Reason);
            ApexPages.addMessage(myMsg);       
            
        }
        else
        {
            lstCalculationResultValues = LMS_Constants.mapEventTypeCalculationFields.get(EventType);
            bIsSchedulePanelVisible = true;
            bIsSignOffVisible = true;
        }
    }
       
    public PageReference SignOff()
    {
        System.debug('DANI');
        Loan_Management_Event__c lme = componentController.lme;
        if(cr == null)			// If eventType IN ('Early Repayment', 'Cancellation', 'One off Full Amount', 'Debt Collection'), the Calculation is done in the corresponding controller
            cr = componentController.cr;
        
        lme.IsApproved__c = true;
        lme.ApprovedBy__c = UserInfo.getUserId();
        lme.Approval_Date__c = Datetime.now();       
        
        if(lme.Event_Type__c == 'Early Repayment')
            lme.Event_Amount__c = cr.PrincipalAmount;
        else if (lme.Event_Type__c == 'Change Collection Amount' && lme.Event_End_Date__c == null)
            lme.Event_End_Date__c = o.Final_Repayment_Date__c;
        
        if (lme.Event_Type__c == 'Change Collection Amount' || lme.Event_Type__c == 'Payment Holiday')
            lme.Effective_Date__c = lme.Event_Date__c;
        else if (lme.Event_Type__c == 'Bounce Back' && lme.Event_Process_Method__c == 'Manual')
            lme.Effective_Date__c = null;
        
        upsert lme;
        
        if (lme.Event_Type__c == 'Top-up' || lme.Event_Type__c == 'Restructure')
        {
            Operation__c operation = new Operation__c(id = lme.Operation__c, Status__c = cr.LoanStatus);
            update operation;
            
            DeactivateOngoingEvent();
            CloneOpportunity();
        }
        else if (lme.Event_Type__c == 'Renewal')
            CloneOpportunity();
        else if (lme.Event_Type__c ==  'Debt Collection')
        {
            o.Loan_Outstanding_Principal__c = cr.PrincipalAmount + cr.EventFeeAmount + cr.EventFeeVATAmount;
            o.Loan_Outstanding_Interest__c = cr.InterestAmount;
            o.Loan_Outstanding_VAT_Amount__c = cr.InterestVATAmount;
            
            update o;
        }
        else if (lme.Event_Type__c == 'Early Repayment' || lme.Event_Type__c == 'Cancellation' || (lme.Event_Type__c == 'One off' && lme.Event_Process_Method__c == 'Full Amount'))
        {
            o.Status__c = cr.LoanStatus;
            o.Final_Repayment_Date__c = Date.valueOf(cr.LoanEndDate);
            o.Remaining_Number_of_Repayments__c = 0;
            o.Loan_Outstanding_Interest__c = 0;
            o.Loan_Outstanding_Principal__c = 0;
            o.Loan_Outstanding_VAT_Amount__c = 0;
            o.Outstanding_Fees__c = 0;
            o.Outstanding_Fees_VAT__c = 0;
            update o;
        }
        else if ((lme.Event_Type__c  == 'Bounce Back' && lme.Event_Process_Method__c != 'Manual') || lme.Event_Type__c == 'Payment Holiday' || lme.Event_Type__c == 'One off' || lme.Event_Type__c == 'Change Collection Amount' )
        {
            if (lme.Event_Type__c  == 'Bounce Back' && lme.Event_Process_Method__c != 'Manual' && lme.Waive_Fee__c == false)
            {
                o.Outstanding_Fees__c = cr.AccFeesAmount + cr.EventFeeAmount;
                o.Outstanding_Fees_VAT__c = cr.AccFeesVatAmount + cr.EventFeeVATAmount;
            }
            
            if (lme.Event_Type__c == 'Payment Holiday')
                o.Number_Payment_Holidays__c = o.Number_Payment_Holidays__c + 1;
                
            o.Final_Repayment_Date__c = Date.valueOf(cr.LoanEndDate);
            o.Actual_Interest_Amount__c = cr.ActualTotalInterestAmount;
            o.Actual_VAT_Amount__c = cr.ActualTotalVATAmount;
            o.Loan_Outstanding_Interest__c = cr.InterestAmount;
            o.Loan_Outstanding_VAT_Amount__c = cr.InterestVATAmount;
            o.Loan_Outstanding_Principal__c = cr.PrincipalAmount;
            o.Actual_Number_of_Repayments__c = cr.ActualTotalRepaymentsNum;
            o.Remaining_Number_of_Repayments__c = cr.RepaymentsNum;
            o.Actual_Repayment_Per_Installment__c = cr.RepaymentPerInstallment;
            
            update o;
        }
        
        PageReference p = new PageReference('/apex/LM_LoanDetails');
        p.getParameters().put('Id', lme.Operation__c);
        p.setRedirect(true);
        return p;
    }
    
    public void CloneOpportunity()
    {
        System.debug(cr);
        //Operation__c o = [Select Id, Opportunity__c, Status__c from Operation__c where Id =: lme.Operation__c];
        String q = CRMS_SObjectUtility.generateQueryForClone(o.Opportunity__c);
        
        Opportunity oldOpp = (Opportunity)Database.query(q);
        Opportunity cloneOpp = oldOpp.clone(false, true);
        
        if(EventType == 'Top-up' || EventType == 'Restructure')
        {
            cloneOpp.Amount = cr.PrincipalAmount;
            cloneOpp.Program_Product_ASO__c = cr.ProgramProductSFId;
        }
        if(EventType == 'Renewal')
        {
            o.Status__c = 'Renewed';
            update o; 
        }
        
        cloneOpp.Type = EventType;
        cloneOpp.Probability = null;
        cloneOpp.StageName = 'In Progress';
        cloneOpp.Application_ID2__c = 'UNIQUE'; // A WF will set the correct Application ID
        cloneOpp.Documents_Processed__c = false;
        cloneOpp.Required_Documents_Received__c = false;
        cloneOpp.Documents_Received_Kofax__c = '';
        cloneOpp.Related_Operation__c = o.Id;
        
        //Elisaveta, 2016-05-03: LMS-285 - Opprotunity is getting "(Won) Signed"
        cloneOpp.Application_Form_Completed__c = false;
        cloneOpp.Signed_Application_Form_Received__c = false;
        cloneOpp.Signed_Application_Form_Received_Date__c = null;
        cloneOpp.Contract_Signed__c = false;
        cloneOpp.Contract_Signed_Date__c = null;
        cloneOpp.Contract_End_Date__c = null;        
        
        List <RecordType> oppApplicationRecTypes = new List<RecordType>();
        oppApplicationRecTypes = [SELECT Id, Name FROM RecordType Where SobjectType  = 'Opportunity' And Name Like '%Application%'];
        for(RecordType rt : oppApplicationRecTypes)
        {
            if(rt.name.contains(oldOpp.Country__c))
            {
                cloneOpp.RecordTypeId = rt.Id;
                break;
            }
        }
        
        insert cloneOpp;
    }
    
    public void DeactivateOngoingEvent()
    {
        List<Loan_Management_Event__c> ongoingLME = [SELECT Id, IsActive__c, Event_Type__c, Event_Date__c
                                               		 FROM Loan_Management_Event__c WHERE Operation__c = :o.Id AND Event_Type__c IN ('Payment Holiday', 'Change Collection Amount') 
                                                     	AND IsActive__c = :true AND Event_Date__c <= :componentController.lme.Effective_Date__c
                                                     	AND Event_End_Date__c >= :componentController.lme.Effective_Date__c];
        if(ongoingLME.size() > 0)
        {
            for(Loan_Management_Event__c event :ongoingLME)
            {
                event.IsActive__c = false;
                update event;
                
                Loan_Management_Event__c cancelLME = new Loan_Management_Event__c();
                cancelLME.Operation__c = o.Id;
                cancelLME.Related_Event_Id__c = event.Id;
                cancelLME.Event_Type__c = 'Cancel ' + event.Event_Type__c;
                cancelLME.Event_Process_Method__c = 'Auto';
                cancelLME.IsActive__c = true;
                cancelLME.Event_Date__c = componentController.lme.Event_Date__c;//Date.today();
                cancelLME.Effective_Date__c = componentController.lme.Effective_Date__c;
                cancelLME.IsApproved__c = true;
                cancelLME.ApprovedBy__c = UserInfo.getUserId();
                cancelLME.Approval_Date__c = Datetime.now();
                insert cancelLME;                
            }
        }
    }
    
}