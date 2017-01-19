public with sharing class AMPSales_CreateDebts {
    public Additional_Debt__c Debt  {get; set;}{
        Debt = new Additional_Debt__c();
    }    
    public string ReturnURL {get; set;}
    public string SObjectType    {get; set;}
    private string LookupId;
    private string AccountId;
    private string OppId;
    
    
    public AMPSales_CreateDebts(){                  
        ReturnURL = ApexPages.currentPage().getParameters().get('retURL');
        LookupId = ApexPages.currentPage().getParameters().get('id');
        AccountId = ApexPages.currentPage().getParameters().get('aid');
        OppId = ApexPages.currentPage().getParameters().get('oid');                     
        SObjectType = LookupId.substring(0,3);
        
        if(SObjectType == '006'){
            Debt.Opportunity_Filter__c = LookupId;
            Debt.Account__c = AccountId; 
            
        }else if(SObjectType == 'a02'){
            Debt.Credit_Assessment__c = LookupId;
            Debt.Account__c = AccountId;
            Debt.Opportunity_Filter__c = OppId;
        
        }else if(SObjectType == '001'){
            Debt.Account__c = LookupId;
            Debt.Opportunity_Filter__c = OppId;
        } 
    }
    
    public PageReference SaveDebt(){
        try{                
            Debt.Opportunity__c = Debt.Opportunity_Filter__c;
            Debt.Opportunity_Filter__c = null;
            string CurrencyCode = this.OpportunityCurrencyCode(Debt.Opportunity__c);
            if(CurrencyCode != null)
            	Debt.CurrencyIsoCode = CurrencyCode;
            Database.insert(Debt);          
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