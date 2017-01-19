public with sharing class AMP_Test implements Queueable, Database.AllowsCallouts { 
    
   public list<SObject> LMESObject {get; set;}
   public AMP_Test(SObject LMEObject){
        LMESObject.add(LMEObject);
   }
    
    public void execute(QueueableContext context) {    	
    	system.debug('LMESObject >>> '+LMESObject);
    	AMPSyncApp_SyncHandler.SyncWithCAIROS(LMESObject, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
    }
   
   /*
   public void FieldsLable(){
   		Account Ac = [Select a.Industry, a.HKID_Card_No__pc, a.Account_Manager__c, a.Accepts_Credit_Cards__c From Account a where Id=:'0012600000CPSr9'];
   		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();		
		Schema.SObjectType leadSchema = schemaMap.get('Lead');		
		Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
		
		list<string> fieldslist = new list<string>();
		for(String fieldName: fieldMap.keySet()) {
			fieldslist.add(String.valueOf(Ac.get(fieldName)));
			system.debug(fieldName);			
		}
		system.debug(fieldslist);
		   		
   }
   
   public string getDateTimeFromUnix(){
   		integer UnixTimeStamp = 147277440;   		
		DateTime dateInstance = datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
		String dateTimeValue = dateInstance.addSeconds(UnixTimeStamp).format();
		return dateTimeValue;
   }
   public integer OprphansSize {get; set;}
   public void DeleteOrphanCreditAssesments(){
   		list<Credit_Assessment__c> Orphans = new list<Credit_Assessment__c>();
	   	for(Credit_Assessment__c CS :[Select c.Id From Credit_Assessment__c c where c.Opportunity__c = null]){
	   		Orphans.add(CS);
	   	}
	   	OprphansSize = Orphans.size();
	   	
	   	delete(Orphans);
   } */
        
}