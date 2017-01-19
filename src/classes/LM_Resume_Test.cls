public class LM_Resume_Test implements Queueable, Database.AllowsCallouts {
    public String operationId {get; set;}
    private LM_CalculationResult cr {get; set;} 
    
    public LM_Resume_Test(Id opId)
    {
        System.debug('In Constr');
        operationId = opId;
    }
    
    public void execute(QueueableContext context) {
        System.debug('DANI');
        System.debug(operationId);
        Loan_Management_Event__c rejectedLME = [SELECT Id, IsActive__c, Operation__r.Program_Product_ASO__c, Notes__c FROM Loan_Management_Event__c
                                                WHERE Operation__c = :operationId AND IsActive__c = :true AND Event_Type__c IN ('Restructure', 'Top-up', 'Payment Holiday')][0];
        
        String notDays = [SELECT Notification_days__c FROM Loan_Management__c WHERE Program_Product_ASO__c = :rejectedLME.Operation__r.Program_Product_ASO__c][0].Notification_days__c;
                
// Callout Calculate
        String calcGetParams = '?LoanId=' + operationId +
                            '&EventType=' + 'Resume'.replaceAll(' ', '%20') +
                            '&EventStartDate=' + CRMS_Util.DateToString(Date.today(), LMS_Constants.DATE_FORMAT_DWH) +
                            '&EventEndDate=&EventAmount=&LoanTerm=&EventProcessMethod=&PaymentReceived=&PrincipalAllocation=&InterestAllocation=';  
        
        string calculateResponse = LMS_Callout.CallOutGET(LMS_Constants.endpointValue, calcGetParams);
       
        Map<String, Object> responseMap =  (Map<String, Object>)JSON.deserializeUntyped(calculateResponse); 
        List<Object> responseResultsList = (List<Object>)responseMap.get('results');
              
        Map<String, Object> resultsMap = (Map<String, Object>)responseResultsList[0];          
        
        String responseResultJSON = JSON.serialize(responseMap.get('results'));
        cr = ((List<LM_CalculationResult>)JSON.deserialize(responseResultJSON, List<LM_CalculationResult>.class))[0];
        System.debug('Calc_El');
        System.debug(cr);
// End Collout Calculate       
        
// Callout EffectiveDate
        String dateGetParams = '?LoanId=' + operationId + 
                    '&StartDate=' + CRMS_Util.DateToString(Date.today(), LMS_Constants.DATE_FORMAT_DWH) +
                    '&Days=' + String.valueOf(Integer.valueOf(notDays) + 1) +
                    '&EventType=' + 'Resume'.replaceAll(' ', '%20');
        
        Date EffectiveDate = Date.valueOf(((string)LMS_Callout.GetResultsMapFromResponse(LMS_Callout.CallOutGET(LMS_Constants.FirstRepDayEndPoint, dateGetParams)).get('repaymentDay')).replace('T', ' '));
        System.debug('Date_El');
        System.debug(EffectiveDate);
// End Callout EffectiveDate

// Deactivate Restructure/Top-up Event and Insert Resume
        //rejectedLME.IsActive__c = false;
        rejectedLME.Notes__c = 'whduljekklde';
        update rejectedLME;
        
        system.debug('rejectedLME >>>> '+rejectedLME);
        //System.enqueueJob(new AMP_Test(rejectedLME));
        
        /*
// Insert Resume Event
        Loan_Management_Event__c resumeLME = new Loan_Management_Event__c();
        resumeLME.Operation__c = operationId;
        resumeLME.Related_Event_Id__c = rejectedLME.Id;
        resumeLME.Event_Type__c = 'Resume';
        resumeLME.IsActive__c = true;
        resumeLME.Event_Date__c = Date.today();
        resumeLME.Effective_Date__c = EffectiveDate;
        resumeLME.IsApproved__c = true;
        resumeLME.ApprovedBy__c = UserInfo.getUserId();
        resumeLME.Approval_Date__c = Datetime.now();
        insert resumeLME;
        
        System.debug('resume_El');
        System.debug(resumeLME.Effective_Date__c);

// Update Loan Amounts
        Operation__c o = [SELECT Final_Repayment_Date__c, Actual_Interest_Amount__c, Actual_VAT_Amount__c, Loan_Outstanding_Interest__c, Loan_Outstanding_VAT_Amount__c,
                                Actual_Number_of_Repayments__c, Remaining_Number_of_Repayments__c, Status__c
                         FROM Operation__c WHERE Id = :operationId][0];
        o.Final_Repayment_Date__c = Date.valueOf(cr.LoanEndDate);
        o.Actual_Interest_Amount__c = cr.ActualTotalInterestAmount;
        o.Actual_VAT_Amount__c = cr.ActualTotalVATAmount;
        o.Loan_Outstanding_Interest__c = cr.InterestAmount;
        o.Loan_Outstanding_VAT_Amount__c = cr.InterestVATAmount;
        o.Actual_Number_of_Repayments__c = cr.ActualTotalRepaymentsNum;
        o.Remaining_Number_of_Repayments__c = cr.RepaymentsNum;
        o.Status__c = cr.LoanStatus;
        update o;
        System.debug('op_El');
        System.debug(o.Final_Repayment_Date__c);

*/
    }
}