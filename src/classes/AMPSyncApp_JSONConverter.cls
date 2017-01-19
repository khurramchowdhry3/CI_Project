/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used to Convert Sobjects to JSON data format
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Class to convert SObjects to JSON data format
 *
 */
public with sharing class AMPSyncApp_JSONConverter {
	
	private string SObjectAPIName;	//Object API Name i.e. (Lead, Account, Contact, Opportunity... etc.)
	private string DMLOperation;	//DML Operation i.e. (Insert, Update, Delete)
	
	/*	
	*	Convert List Of Objects to JSON encoded format to Sync with CAIROS
	*	This function is used to convert list of records to JSON encoded format.
	*	Records which are inserted/updated or deleted.
	*	
	*	@ListOfObjects	: 	List of records which will be synched with CAIROS, 
	*	@CRUDOperation	:	Operation i.e. (Insert, Update, Delete) 				
	*  
	*/ 
	
	public string SObjectToJSON(list<SObject> ListOfObjects, string CRUDOperation){
		if(ListOfObjects != null && ListOfObjects.size() > 0){
			this.SobjectAPIName = AMPSyncApp_Util.getSObjectAPIName(ListOfObjects[0]);
			this.DMLOperation = CRUDOperation;
			
			if(this.DMLOperation == AMPSyncApp_Constants.SYNC_ACTION_DELETE){
				return this.JSONForDelete(ListOfObjects);
			}else return this.JSONForInsertAndUpdate(ListOfObjects);
		}
		return null;
	}
	
	
	/*	
	*	JSON for Deleted records
	*	Add Deleted records to Queue to update its status after getting response from CAIROS.	
	*	
	*	@SObjects	: 	List of records which is deleted in Salesforce and required to sync with CAIROS				
	*  
	*/ 
	
	private string JSONForDelete(list<SObject> SObjects){
		list<AMPSyncApp_Collection.DeleteWrapper> DeletedInfo = new list<AMPSyncApp_Collection.DeleteWrapper>();
		map<ID, AMPSync_Queue__c> SyncQueueMap = new map<ID, AMPSync_Queue__c>();
		
		for(SObject Obj : SObjects){
			DeletedInfo.add(new AMPSyncApp_Collection.DeleteWrapper(string.valueOf(Obj.Id)));
			SyncQueueMap.put(Obj.Id, new AMPSync_Queue__c(
            	ObjectId__c = Obj.Id,
               	DML_Operation__c = this.DMLOperation,               	
               	Last_Sync_DateTime__c = Datetime.now(),
               	Status__c = AMPSyncApp_Constants.SYNC_STATUS,
               	Sync_Failure_Reason__c = AMPSyncApp_Constants.SYNC_FAILURE_REASON,
               	Object_Name__c = (AMPSyncApp_Util.IsPersonAccount(Obj) == true ? 'Contact' : this.SobjectAPIName),
               	JSONData__c = JSON.serialize(new AMPSyncApp_Collection.DeleteWrapper(string.valueOf(Obj.Id)))                    
            ));
		}
		new AMPSyncApp_SyncQueue().AddToQueue(SyncQueueMap.Values());
		return JSON.serialize(DeletedInfo);
	}
	
	
	/*	
	*	JSON for inserted/updated records
	*	Add inserted/updated records to Queue to update its status after getting response from CAIROS.	
	*	
	*	@SObjects	: 	List of records which is inserted/updated in Salesforce and required to sync with CAIROS				
	*  
	*/
	
	private string JSONForInsertAndUpdate(list<SObject> SObjects){
		map<string, Schema.Sobjectfield> fieldsMap = AMPSyncApp_Util.getSobjectFields(SObjects[0]);
		list<AMPSyncApp_Collection.FieldInformation> FieldsAndValues = new list<AMPSyncApp_Collection.FieldInformation>();
		list<AMPSyncApp_Collection.Values> OperationAndInformation = new list<AMPSyncApp_Collection.Values>();
		map<ID, AMPSync_Queue__c> SyncQueueMap = new map<ID, AMPSync_Queue__c>();										
		
		for(Sobject Obj : SObjects){
			
			FieldsAndValues.clear();
			if(AMPSyncApp_Util.IsPersonAccount(SObjects[0])){
				for(string fieldapiname : fieldsMap.keySet()){	                
	                try{
	                	if(fieldsMap.get(fieldapiname).getDescribe().isAccessible()){
		                	String fieldValue = String.valueOf(Obj.get(fieldapiname));                    
		                	string fieldName = fieldsMap.get(fieldapiname).getDescribe().getName();
		                	fieldValue = fieldValue == null ? '' : fieldValue;                                     
		                	FieldsAndValues.add( new AMPSyncApp_Collection.FieldInformation(fieldName, fieldValue));
		                }	                	
	                }catch(Exception ex){}	                 
				}
			}
			else{
				
				for(Schema.FieldSetMember Member : AMPSyncApp_Util.getSobjectFieldsSet(SObjects[0].Id, this.SobjectAPIName)){
                	String fieldApiName = Member.getFieldPath();
                    if(fieldsMap.get(fieldApiName) != null){
                    	String fieldname = fieldsMap.get(fieldApiName).getDescribe().getName();
                        if(fieldsMap.get(fieldName).getDescribe().isAccessible()){
		                	String fieldValue = String.valueOf(Obj.get(fieldname));                    
		                	fieldValue = fieldValue == null ? '' : fieldValue;                                     
		                	FieldsAndValues.add( new AMPSyncApp_Collection.FieldInformation(fieldname, fieldValue));
		                }
                    }
				}
			}	
			OperationAndInformation.add(new AMPSyncApp_Collection.Values(this.DMLOperation,FieldsAndValues));
						
			SyncQueueMap.put(Obj.Id,new AMPSync_Queue__c(
            	ObjectId__c = Obj.Id,
               	DML_Operation__c = this.DMLOperation,
               	Last_Sync_DateTime__c = Datetime.now(),
               	Status__c = AMPSyncApp_Constants.SYNC_STATUS,
               	Sync_Failure_Reason__c = AMPSyncApp_Constants.SYNC_FAILURE_REASON,
               	Object_Name__c = (AMPSyncApp_Util.IsPersonAccount(Obj) == true ? 'Contact' : this.SobjectAPIName),
               	JSONData__c = JSON.serialize(new AMPSyncApp_Collection.Values(this.DMLOperation,FieldsAndValues))                    
        	));
			
		}
		new AMPSyncApp_SyncQueue().AddToQueue(SyncQueueMap.Values());
		return JSON.serialize(OperationAndInformation);
	}
}