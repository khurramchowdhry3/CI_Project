/*public class LM_Resume {        
	@InvocableMethod(label='Create Resume Event' description='If TopUp/Restructure is rejected, insert LME Resume')
    public static void createResume(List<ID> opID){
        //calloutCalculateInsertResume(opID[0]);
        System.debug(opId[0]);
        System.enqueueJob(new LM_Resume_Test(opId[0]));
    }
}
*/
public class LM_Resume {

    public Operation__c o {get; set;}
    public Loan_Management__c rulesEngine {get; set;}
    public LM_CalculationResult cr {get; set;}
    private Date resumeDate {get; set;}
    private Date pauseDate {get; set;}
    private Loan_Management_Event__c resumeLME {get; set;}
    private Integer phNum {get; set;}
    
    public LM_Resume (Operation__c op, Loan_Management__c rules)
    {
        o = op;
        rulesEngine = rules;
    }
    
    public void ResumeLoan()
    {
        resumeDate = Date.today(); //Date.newInstance(2016, 12, 19);
        phNum = 0;
        
        String getParams = '?LoanId=' + o.Id + 
                    '&StartDate=' + CRMS_Util.DateToString(resumeDate, LMS_Constants.DATE_FORMAT_DWH) +
                    '&Days=' + String.valueOf(Integer.valueOf(rulesEngine.Notification_days__c) + 1) +
                    '&EventType=' + 'Resume'.replaceAll(' ', '%20');
        
        Date EffectiveDate = Date.valueOf(((string)LMS_Callout.GetResultsMapFromResponse(LMS_Callout.CallOutGET(LMS_Constants.FirstRepDayEndPoint, getParams)).get('repaymentDay')).replace('T', ' '));
    	
        CalloutCalculate();
        
        Loan_Management_Event__c rejectedLME = [SELECT Id, IsActive__c, Operation__r.Program_Product_ASO__c, Notes__c, Event_Date__c FROM Loan_Management_Event__c
                                              	WHERE Operation__c = :o.Id AND IsActive__c = :true AND Event_Type__c IN ('Restructure', 'Top-up')][0];
        pauseDate = rejectedLME.Event_Date__c;
        rejectedLME.IsActive__c = false;
        update rejectedLME;
            
        // Insert Resume Event
        resumeLME = new Loan_Management_Event__c();
        resumeLME.Operation__c = o.Id;
        resumeLME.Related_Event_Id__c = rejectedLME.Id;
        resumeLME.Event_Type__c = 'Resume';
        resumeLME.IsActive__c = true;
        resumeLME.Event_Date__c = resumeDate;
        resumeLME.Effective_Date__c = EffectiveDate; //rejectedLME.Event_Date__c > EffectiveDate ? rejectedLME.Event_Date__c : EffectiveDate;
        resumeLME.IsApproved__c = true;
        resumeLME.ApprovedBy__c = UserInfo.getUserId();
        resumeLME.Approval_Date__c = Datetime.now();
        insert resumeLME;
        
        DeactivateOngoingEvent();

		// Update Loan Amounts
        o.Final_Repayment_Date__c = Date.valueOf(cr.LoanEndDate);
        o.Actual_Interest_Amount__c = cr.ActualTotalInterestAmount;
        o.Actual_VAT_Amount__c = cr.ActualTotalVATAmount;
        o.Loan_Outstanding_Interest__c = cr.InterestAmount;
        o.Loan_Outstanding_VAT_Amount__c = cr.InterestVATAmount;
        o.Actual_Number_of_Repayments__c = cr.ActualTotalRepaymentsNum;
        o.Actual_Repayment_Per_Installment__c = cr.RepaymentPerInstallment;
        o.Remaining_Number_of_Repayments__c = cr.RepaymentsNum;
        o.Number_Payment_Holidays__c = o.Number_Payment_Holidays__c - phNum;
        o.Status__c = cr.LoanStatus;
        update o;    
    }
    
    private void DeactivateOngoingEvent()
    {
        List<Loan_Management_Event__c> ongoingLME = [SELECT Id, IsActive__c, Event_Type__c, Event_Date__c
                                               		 FROM Loan_Management_Event__c WHERE Operation__c = :o.Id AND Event_Type__c IN ('Payment Holiday', 'Change Collection Amount') 
                                                     	AND IsActive__c = :true AND Effective_Date__c > :pauseDate AND Effective_Date__c <= :resumeLME.Effective_Date__c];
        if(ongoingLME.size() > 0)
        {
            for(Loan_Management_Event__c lme :ongoingLME)
            {
                lme.IsActive__c = false;
                update lme;
                
                if (lme.Event_Type__c == 'Payment Holiday')
                    phNum++;
                
                Loan_Management_Event__c cancelLME = new Loan_Management_Event__c();
                cancelLME.Operation__c = o.Id;
                cancelLME.Related_Event_Id__c = lme.Id;
                cancelLME.Event_Type__c = 'Cancel ' + lme.Event_Type__c;
                cancelLME.Event_Process_Method__c = 'Auto';
                cancelLME.IsActive__c = true;
                cancelLME.Event_Date__c = resumeDate;
                cancelLME.Effective_Date__c = resumeDate;
                cancelLME.IsApproved__c = true;
                cancelLME.ApprovedBy__c = UserInfo.getUserId();
                cancelLME.Approval_Date__c = Datetime.now();
                insert cancelLME;                
            }
        }
    }
    
    private void CalloutCalculate()
    {
       	String getParamsCalc = '?LoanId=' + o.Id +
                            '&EventType=' + 'Resume'.replaceAll(' ', '%20') +
                            '&EventStartDate=' + CRMS_Util.DateToString(resumeDate, LMS_Constants.DATE_FORMAT_DWH) +
                            '&EventEndDate=&EventAmount=&LoanTerm=&EventProcessMethod=&PaymentReceived=&PrincipalAllocation=&InterestAllocation=';
        
        string calculateResponse = LMS_Callout.CallOutGET(LMS_Constants.endpointValue, getParamsCalc);
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
           
        if(cr.Result == 'Error')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, cr.Reason);
            ApexPages.addMessage(myMsg);       
            
        }
    }
}