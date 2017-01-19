public with sharing class AMPSales_PersonalAccount {
	
	public void CreatePersonAccountFromLead(list<Lead> SObjectListOfLead){		 
		map<ID, Account> PersonAccountMap = new map<ID, Account>();	
		
		for(Lead L: SObjectListOfLead){
			
			PersonAccountMap.put(L.Id, new Account(
				FirstName 					= L.FirstName,
                LastName 					= L.LastName,               
                Phone 						= L.Phone,
                Partner_Website_Tracker__c 	= L.Partner_Website_Tracker__c,
                PersonEmail 				= L.Email,
                PersonLeadSource 			= L.LeadSource,
               	Business_Position__pc	 	= L.Business_Position__c,
                Salutation 					= L.Salutation,
                Salutation__pc 				= L.Salutation,
                Owner_Name__pc 				= L.Owner_Name__c,
                Home_Country__pc 			= L.TA_Country__c,
                PersonHasOptedOutOfEmail 	= L.HasOptedOutOfEmail,
                PersonDoNotCall 			= L.DoNotCall,
                Do_Not_Txt__pc 				= L.Do_Not_Txt__c,
                Do_Not_Mail__pc 			= L.Do_Not_Mail__c
			));			
		}
		if(PersonAccountMap.size() > 0 && PersonAccountMap != null){
			Database.insert(PersonAccountMap.values());			
			
			for(Lead L: SObjectListOfLead){				
				L.PersonAccountId__c = PersonAccountMap.get(L.Id).Id;					
			}
		}
	}
}