public with sharing class AMPSales_DebtsController {
    public Additional_Debt__c Debt  {get; set;}{
        Debt = new Additional_Debt__c();
    }
    public string ReturnURL {get; set;}
    public string SObjectType {get; set;}
    public boolean DisableSaveBtn	{get; set;}{
    	DisableSaveBtn = false;
    }   
    
    public AMPSales_DebtsController(ApexPages.StandardController StdCntlr_Debt){
        if(StdCntlr_Debt != null){
            Additional_Debt__c ContexttRecord = (Additional_Debt__c)StdCntlr_Debt.getRecord();
            Debt = this.getDebtRecord(ContexttRecord.Id);
            Debt.Opportunity_Filter__c = Debt.Opportunity__c;
            ReturnURL = ApexPages.currentPage().getParameters().get('retURL');
            
            
            if(ReturnURL.contains('a02')){
            	this.ReferenceObject(Debt.Credit_Assessment__c);
            	SObjectType = string.valueOf(Debt.Credit_Assessment__c).substring(0,3);
            }else if(ReturnURL.contains('001')){
            	SObjectType = string.valueOf(Debt.Account__c).substring(0,3);
            	this.ReferenceObject(Debt.Opportunity__c);
            }else if(ReturnURL.contains('006')){
            	SObjectType = string.valueOf(Debt.Opportunity__c).substring(0,3);
            	this.ReferenceObject(Debt.Opportunity__c);
            }
        }
    }
    
    private void ReferenceObject(string SObjectId){
    	if(SObjectId.substring(0,3) == '006'){
            Opportunity Opp = [select StageName from Opportunity where Id =:SObjectId];
            
            if(Opp.StageName != 'In Progress'
					&& Opp.StageName != 'Pending Signature'
					&& Opp.StageName != 'Assessment In Progress' 
					&& Opp.StageName != 'Application Revised'){
				DisableSaveBtn = true;
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not update Debt record when Opportunity is in '+Opp.StageName+' stage.'));							
			}           
            
        }else if(SObjectId.substring(0,3) == 'a02'){
        	Credit_Assessment__c CA = [Select Status__c From Credit_Assessment__c where Id =:SObjectId];
        	
        	if(CA.Status__c == 'Approved' || CA.Status__c == 'Rejected'){
				DisableSaveBtn = true;
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not update Debt record when Credit Assessment is '+CA.Status__c));								
			}
        
        }
    }
    
    private Additional_Debt__c getDebtRecord(ID RecordId){
        try{
            return [Select a.RecordTypeId,                       
                        a.Owner.Name, 
                        a.Outstanding_Amount__c, 
                        a.Original_Debt_Amount__c, 
                        a.Opportunity__c,
                        a.Opportunity_Filter__c, 
                        a.Name, 
                        a.Monthly_Repayment__c, 
                        a.Legal_Entity__c, 
                        a.Id, 
                        a.Debt_Type__c, 
                        a.DWH_Status__c, 
                        a.DWH_Last_Sync__c, 
                        a.Credit_Assessment__c, 
                        a.Civil_Litigation__c, 
                        a.Account__c,
                        a.Account__r.Associated_Business__c 
                    From Additional_Debt__c a where Id =:RecordId limit 1];         
        }catch(QueryException ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
        return null;
    }
    
    public PageReference UpdateDebt(){
        try{
            Debt.Opportunity__c = Debt.Opportunity_Filter__c;
            Debt.Opportunity_Filter__c = null;
            string CurrencyCode = this.OpportunityCurrencyCode(Debt.Opportunity__c);
            if(CurrencyCode != null)
            	Debt.CurrencyIsoCode = CurrencyCode;
            database.update(Debt);
        }catch(DMLException ex){
            return null;
        }
        return new Pagereference(ReturnURL);
    }
    
    private string OpportunityCurrencyCode(ID OpportunityId){
    	try{
    		Opportunity Opp = [Select o.CurrencyIsoCode From Opportunity o where Id =: OpportunityId];
    		return Opp.CurrencyIsoCode;    		
    	}catch(QueryException ex){}
    	return null;    	
    } 
}