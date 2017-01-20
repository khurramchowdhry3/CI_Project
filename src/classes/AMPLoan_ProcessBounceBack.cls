public class AMPLoan_ProcessBounceBack implements Database.Batchable<SObject>, Database.AllowsCallouts{
	
	private LM_CalculationResult cr;
		
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select Id,
        										Waive_Fee__c, 
        										Principal_Allocation__c, 
        										Payment_Received__c, 
        										Operation__c, 
        										Name, 
        										IsApproved__c, 
        										IsActive__c,        										 
        										Event_Type__c, 
        										Event_Process_Method__c, 
        										Event_Loan_Term__c, 
        										Event_End_Date__c, 
        										Event_Date__c, 
        										Event_Amount__c, 
        										Effective_Date__c, 
        										ApprovedBy__c, 
        										Approval_Date__c, 
	        									Operation__r.Program_Product_ASO__c
                                         	From Loan_Management_Event__c
                                        	Where Event_Type__c = 'Bounce Back' 
                                         	And IsApproved__c = false
                                         	And DAY_ONLY(CreatedDate) <: Date.today()                                      	
                                        ]);
    }

    public void execute(Database.BatchableContext BC, list<Loan_Management_Event__c> LoanEvents){
              
        if(LoanEvents.size() > 0 && !LoanEvents.isEmpty()){
            list<ID> ProgramProducts = new list<ID>();
            list<ID> RelatedOperationIds = new list<ID>();
            list<Operation__c> LoantoUpdate = new list<Operation__c>();
            list<Loan_Management_Event__c> LoanEventsList = new list<Loan_Management_Event__c>();
            
                                    
            for(Loan_Management_Event__c LME : LoanEvents){
            	ProgramProducts.add(LME.Operation__r.Program_Product_ASO__c);
            	RelatedOperationIds.add(LME.Operation__c);
            }
            
            map<ID, Loan_Management__c> RuleEngineMap = RepaymentMethod(ProgramProducts);
            map<ID, Operation__c> RelatedOperations = LoanDetail(RelatedOperationIds);
            
            
            for(Loan_Management_Event__c LoanEvent : LoanEvents){               
                
                if(RuleEngineMap.size() > 0 && !RuleEngineMap.isEmpty())
                	LoanEvent.Event_Process_Method__c = RuleEngineMap.get(LoanEvent.Operation__r.Program_Product_ASO__c).Repayment_method__c;
                                                
                if(Calculate(LoanEvent)){
                	Operation__c Loan = RelatedOperations.get(LoanEvent.Operation__c);
                	
                	LoanEvent.IsApproved__c = true;
			        LoanEvent.ApprovedBy__c = UserInfo.getUserId();
			        LoanEvent.Approval_Date__c = Datetime.now();
			       	
			       	LoanEventsList.add(LoanEvent);
			       			                
			        Loan.Outstanding_Fees__c = cr.AccFeesAmount + cr.EventFeeAmount;
			        Loan.Outstanding_Fees_VAT__c = cr.AccFeesVatAmount + cr.EventFeeVATAmount;
			        Loan.Final_Repayment_Date__c = Date.valueOf(cr.LoanEndDate);
			        Loan.Actual_Interest_Amount__c = cr.ActualTotalInterestAmount;
			        Loan.Actual_VAT_Amount__c = cr.ActualTotalVATAmount;
			        Loan.Loan_Outstanding_Interest__c = cr.InterestAmount;
			        Loan.Loan_Outstanding_Principal__c = cr.PrincipalAmount;
			        Loan.Actual_Number_of_Repayments__c = cr.ActualTotalRepaymentsNum;
			        Loan.Remaining_Number_of_Repayments__c = cr.RepaymentsNum;
			        Loan.Actual_Repayment_Per_Installment__c = cr.RepaymentPerInstallment;            
			        LoantoUpdate.add(Loan);                	
                }                                                           
            }
            
            if(LoanEventsList.size() > 0 && !LoanEventsList.isEmpty())
            	Database.update(LoanEvents);
            if(LoantoUpdate.size() > 0 && !LoantoUpdate.isEmpty())
            	Database.update(LoantoUpdate);            
        }        
    }
    
    private map<ID, Loan_Management__c> RepaymentMethod(list<ID> ProgramProductsList){
    	map<ID, Loan_Management__c> RuleEngineMap = new map<ID, Loan_Management__c>();
    	for(Loan_Management__c RE : [Select Id, 
    									Program_Product_ASO__c, 
    									Repayment_method__c 
    								From Loan_Management__c 
    								Where Program_Product_ASO__c IN:ProgramProductsList]){
    		RuleEngineMap.put(RE.Program_Product_ASO__c, RE);    									
    	}
    	return RuleEngineMap;
    }
    
    private map<ID, Operation__c> LoanDetail(list<ID> LMEOperations){
    	map<ID, Operation__c> Operations = new map<ID, Operation__c>([Select Id,
				    Outstanding_Fees__c, 
				    Outstanding_Fees_VAT__c, 
				    Final_Repayment_Date__c,
				    Actual_Interest_Amount__c,
				    Actual_VAT_Amount__c,
				    Loan_Outstanding_Interest__c,
				    Loan_Outstanding_Principal__c,
				    Actual_Number_of_Repayments__c,
				    Remaining_Number_of_Repayments__c,
				    Actual_Repayment_Per_Installment__c
			    From Operation__c Where Id IN : LMEOperations]);
		return Operations;
    }
    
    private boolean Calculate(Loan_Management_Event__c lme){
    	                
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
        return processResponse(calculateResponse, lme);        
    }
    
    private boolean processResponse(string response, Loan_Management_Event__c LoanEvent){
    	
        if(response == null){           
           return false;
        }
        
        list<LMS_CalculationFieldDescriptor> lstCalculationResultValues = new list<LMS_CalculationFieldDescriptor>();
        
        Map<String, Object> responseMap =  (Map<String, Object>)JSON.deserializeUntyped(response); 
        List<Object> responseResultsList = (List<Object>)responseMap.get('results');
        
        if (responseResultsList == null){            
            return false;
        }
        
        Map<String, Object> resultsMap = (Map<String, Object>)responseResultsList[0];          
        
        String responseResultJSON = JSON.serialize(responseMap.get('results'));
        cr = ((List<LM_CalculationResult>)JSON.deserialize(responseResultJSON, List<LM_CalculationResult>.class))[0];
        cr.lme = LoanEvent;
        if(cr.Result == 'Error'){
        	return false;
        }
        return true;
    }
    
    public void finish(Database.BatchableContext BC){}
}