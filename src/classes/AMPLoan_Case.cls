public with sharing class AMPLoan_Case {
	
	public void CreateNewCase(map<ID, Loan_Management_Event__c> LMEMap){
		list<Case> BounceBackCases = new list<Case>();
		map<string, ID> NLMUsersMap = this.NLMUsersToAssignCase(); 
		try{
			for(Operation__c Op : this.OpportunityForCase(LMEMap.keySet())){
				BounceBackCases.add(new Case(
			        Subject  =  Op.Account__r.Name+' has bounce back on '+string.valueOf(LMEMap.get(Op.Id).Event_Date__c),
			        Status   = 'New',
			        Priority = 'Medium',			        
			        OwnerId  = NLMUsersMap.get(Op.CurrencyIsoCode),
			        Operation__c = Op.Id,       
			        Description = Op.Account__r.Name+
			        			  ' has a bounce back on '+string.valueOf(LMEMap.get(Op.Id).Event_Date__c)+
			        			  ', please check the bounce back detail by following link and take the bounce back event accordingly. Thanks.\r\n\r\n'+
			        			  System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/LM_LoanDetails?Id='+Op.Id
		        ));
			}
			Database.insert(BounceBackCases);						
		}catch(DMLException ex){}			
	}
	
	private list<Operation__c> OpportunityForCase(set<ID> listOfOperations){
		return [Select o.Id, o.CurrencyIsoCode, o.Account__r.Name, o.Account__c From Operation__c o where Id IN:listOfOperations];
	}
	
	private map<string,ID> NLMUsersToAssignCase(){
		map<string, string> NLMUsers = new map<string, string>{
			'New Loan Manager User (UK)' => 'GBP',
			'New Loans Manager User (HK)' => 'HKD',
			'New Loans Manager User (SG)' => 'SGD',
			'New Loan Manager User (PH)'  => 'PHP'
		};
		
		map<string, ID> NLMUsersMap = new map<string, ID>(); 
		for(User U : [Select u.Name, u.Id From User u 
					where Name IN : NLMUsers.keyset()]){
			NLMUsersMap.put(NLMUsers.get(U.Name), U.Id);											
		}
		return NLMUsersMap;			
	}
}