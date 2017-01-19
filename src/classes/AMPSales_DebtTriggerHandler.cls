public with sharing class AMPSales_DebtTriggerHandler {
	
	public void DebtsOnInsert(list<Additional_Debt__c> Debts){
				
		list<ID> ListOfAccounts = new list<ID>();
		list<ID> ListOfOpportunities = new list<ID>();
		map<ID, Credit_Assessment__c> MapCreditAssessment = new map<ID, Credit_Assessment__c>();
		map<ID, Credit_Assessment__c> MapCreditAssessmentPersonAccount = new map<ID, Credit_Assessment__c>();		
						 
		for(Additional_Debt__c debt: Debts){
			if(debt.Opportunity__c != null){
				ListOfOpportunities.add(debt.Opportunity__c);
			}else if(debt.Account__c != null){
				ListOfAccounts.add(debt.Account__c);				
			}
		}
		
		if(ListOfOpportunities.size() > 0 && !ListOfOpportunities.isEmpty()){		
			MapCreditAssessment = this.getCreditAssessmentMapForOpportunity(ListOfOpportunities);			
		
		}else if(ListOfAccounts.size() > 0 && !ListOfAccounts.isEmpty()){			
			MapCreditAssessmentPersonAccount = this.getCreditAssessmentMapForPersonAccounts(ListOfAccounts);			
			MapCreditAssessment = this.getCreditAssessmentMapForBusinessAccounts(ListOfAccounts);			
		}
		
		for(Additional_Debt__c debt: Debts){
			if(debt.Opportunity__c != null){				
				if(MapCreditAssessment != null && MapCreditAssessment.size() >0)
					debt.Credit_Assessment__c = MapCreditAssessment.get(debt.Opportunity__c).Id;
			
			}else if(debt.Account__c != null){				
				if(MapCreditAssessmentPersonAccount != null && MapCreditAssessmentPersonAccount.size() >0){
					debt.Credit_Assessment__c = MapCreditAssessmentPersonAccount.get(debt.Account__c).Id;
				}else if(MapCreditAssessment != null && MapCreditAssessment.size() > 0){
					debt.Credit_Assessment__c = MapCreditAssessment.get(debt.Account__c).Id;
				}			
			}			
		}						
	}
	
	
	private map<Id, Credit_Assessment__c> getCreditAssessmentMap(list<ID> CreditAssessments){
		try{
			map<ID,Credit_Assessment__c> CreditAssesments = new map<ID, Credit_Assessment__c>(
					[Select c.Id, c.Status__c, c.RecordType.DeveloperName, c.Opportunity__c From Credit_Assessment__c c 
						where Id IN:CreditAssessments 
						AND Status__c != 'Approved' AND  Status__c != 'Rejected'
					]);
			return CreditAssesments;
		}catch(QueryException ex){}
		return null;		
	}
	
	private map<Id, Credit_Assessment__c> getCreditAssessmentMapForBusinessAccounts(list<ID> BAccounts){
		try{
			map<ID,Credit_Assessment__c> CreditAssesments = new map<ID, Credit_Assessment__c>();
			
			for(Credit_Assessment__c CA : [Select c.Id, c.Business_Trading_Name__c From Credit_Assessment__c c 
					where Business_Trading_Name__c IN:BAccounts]){					
				CreditAssesments.put(CA.Business_Trading_Name__c,CA);		
			}
			return CreditAssesments;
		}catch(QueryException ex){}
		return null;		
	}
	
	private map<Id,Credit_Assessment__c> getCreditAssessmentMapForPersonAccounts(list<ID> PAccounts){
		try{
			map<ID,Credit_Assessment__c> CreditAssesments = new map<ID, Credit_Assessment__c>();
			
			for(Credit_Assessment__c CA : [Select c.Id,	c.Applicant_Name__c	From Credit_Assessment__c c 
					where Applicant_Name__c IN:PAccounts]){
				CreditAssesments.put(CA.Applicant_Name__c,CA);		
			}
			return CreditAssesments;
		}catch(QueryException ex){}
		return null;
	}
	
	private map<Id,Credit_Assessment__c> getCreditAssessmentMapForOpportunity(list<ID> Opportunities){
		try{
			map<ID,Credit_Assessment__c> CreditAssesments = new map<ID, Credit_Assessment__c>();
			for(Credit_Assessment__c CA : [Select c.Id, c.Opportunity__c From Credit_Assessment__c c 
					where Opportunity__c IN:Opportunities]){
				CreditAssesments.put(CA.Opportunity__c,CA);			
			}
			return CreditAssesments;
		}catch(QueryException ex){}
		return null;
	}
	
	private map<Id, Opportunity> getOpportunityMapForBusinessAccounts(list<ID> BAccounts){
		try{
			map<ID,Opportunity> Opportunities = new map<ID, Opportunity>();
			for(Opportunity Opp: [Select o.Id, o.AccountId, o.Primary_Contact__c From Opportunity o
					where AccountId IN:BAccounts 
					AND StageName IN('In Progress','Pending Signature','Assessment In Progress','Application Revised')]){
				Opportunities.put(Opp.AccountId, Opp);				
			}
			return Opportunities;
		}catch(QueryException ex){}
		return null;
	}
	
	private map<Id, Opportunity> getOpportunityMapForPersonAccounts(list<ID> PAccounts){
		try{
			map<ID,Opportunity> Opportunities = new map<ID, Opportunity>();
			for(Opportunity Opp: [Select o.Id, o.AccountId, o.Primary_Contact__c From Opportunity o
					where Primary_Contact__c IN:PAccounts 
					AND StageName IN('In Progress','Pending Signature','Assessment In Progress','Application Revised')]){
				Opportunities.put(Opp.Primary_Contact__c, Opp);			
			}
			return Opportunities;
		}catch(QueryException ex){}
		return null;
	}
			
	public void DebtsOnDelete(list<Additional_Debt__c> Debts){
		for(Additional_Debt__c debt: Debts){
			system.debug('Record Type >>>> '+debt.RecordTypeId);
			string RecTypeName = this.getDebtsRecordTypeName(debt.RecordTypeId);
			system.debug('Record Type Name >>>> '+RecTypeName);
			if(debt.Credit_Assessment__c != null && RecTypeName == 'Credit Assessment Debts'){
				Credit_Assessment__c CA = this.getCreditAssessment(debt.Credit_Assessment__c);	
				
				if(CA.Status__c == 'Approved' || CA.Status__c == 'Rejected'){
					debt.addError('You can not delete Debt record when Credit Assessment is '+CA.Status__c);
				}
			}else if(debt.Opportunity__c != null){
				Opportunity Opp = this.getOpportunityRecord(debt.Opportunity__c);
				if(Opp.StageName != 'In Progress'
					&& Opp.StageName != 'Pending Signature'
					&& Opp.StageName != 'Assessment In Progress' 
					&& Opp.StageName != 'Application Revised'){
						
					debt.addError('You can not delete Debt record when Opportunity is in '+Opp.StageName+' stage.');
				}
			}					
		}
	}
	
	private Credit_Assessment__c getCreditAssessment(ID CreditAssessmentId){
		try{
			return [Select c.Id, c.Status__c, c.RecordType.DeveloperName From Credit_Assessment__c c 
						where Id =: CreditAssessmentId];			
		}catch(QueryException ex){}
		return null;		
	}
	
	private Opportunity getOpportunityRecord(ID OppId){
		try{
			return [Select o.Id, o.StageName From Opportunity o	where Id =:OppId];
		}catch(QueryException ex){}
		return null;
	}
	
	private string getDebtsRecordTypeName(Id RecordtypeId){
		try{
			RecordType RC = [Select Name from RecordType where Id =:RecordtypeId];
			return RC.Name;	
		}catch(QueryException ex){}
		return null;		
	} 
	
}