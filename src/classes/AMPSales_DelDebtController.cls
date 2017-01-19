public with sharing class AMPSales_DelDebtController {
	private Additional_Debt__c Debt;       
    public string ReturnURL {get; set;} 
    private Additional_Debt__c ContexttRecord;    
    
    public AMPSales_DelDebtController(ApexPages.StandardController StdCntlr_Debt){
        if(StdCntlr_Debt != null){
            ContexttRecord = (Additional_Debt__c)StdCntlr_Debt.getRecord(); 
            Debt = DebtRecordToDel(ContexttRecord.Id);          
        }
		ReturnURL = ApexPages.currentPage().getParameters().get('retURL');
    }
    
    public PageReference DelDebt(){
    	
    	if(Debt == null)
    		return new PageReference(ReturnURL);
    	system.debug('Debt >>> '+Debt);	
    	if(ReturnURL.contains('a02') && Debt.Credit_Assessment__c != null){
        	Credit_Assessment__c CA = [Select Status__c From Credit_Assessment__c where Id =:Debt.Credit_Assessment__c];
        	
        	if(CA.Status__c == 'Approved' || CA.Status__c == 'Rejected'){				
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not delete Debt record when Credit Assessment is '+CA.Status__c));
				return null;								
			}else{
				 database.delete(Debt);				 
        	}
    	
    	}else {            
            Opportunity Opp = [select StageName from Opportunity where Id =:Debt.Opportunity__c];
            
            if(Opp.StageName != 'In Progress'
					&& Opp.StageName != 'Pending Signature'
					&& Opp.StageName != 'Assessment In Progress' 
					&& Opp.StageName != 'Application Revised'){
				
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not delete Debt record when Opportunity is in '+Opp.StageName+' stage.'));
				return null;							
			}else{
				 database.delete(Debt);				 
			}
        }
        
        return new PageReference(ReturnURL); 
    }
    
    private Additional_Debt__c DebtRecordToDel(ID RecordId){
        try{
            system.debug('RecordId >>> '+RecordId);
            return [Select a.Id,a.Opportunity__c,                       
                        a.Credit_Assessment__c,                       
                        a.Account__c 
                    From Additional_Debt__c a where Id =:RecordId limit 1];         
        }catch(QueryException ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
        return null;
    }
}