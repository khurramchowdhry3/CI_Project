/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used to maintain list of records which are not successfully Synced
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Class used to maintain Sync Queue.
 *
 */

public with sharing class AMPSyncApp_SyncQueue { 

   /*	 
	*	Create Queue record if external Id (Related Object Id) does not exist.
	*	Update Queue record if external Id (Related Object Id) is arleady exist.
	*
	*	@QueueObjects	:	list of AMPSync Queue Objects to insert	
	*
	*/
	
	public void AddToQueue(list<AMPSync_Queue__c> QueueObjects){		
		if(QueueObjects != null && QueueObjects.size() > 0){
			try{												
				Database.Upsertresult[] results = Database.upsert(QueueObjects, AMPSync_Queue__c.ObjectId__c,false);
				system.debug('<<< UPSERT RESULTS >>> '+results);
			}catch(DMLException ex){}
		}
	} 
	
   /*	
	*	Update Queue Records after getting Response from CAIROS.
	*	This function will update Sync Status, Pending Reason (if not successfully synced) and Last Synced DateTime
	*	of records which are synched with CAIROS.
	*
	*	@MapToUpdateQueue	:	Map of Synced Record Ids with its Status Message	
	*
	*/
	
	public void UpdateQueue(map<ID, string> MapToUpdateQueue){
		list<AMPSync_Queue__c> ListOfRecordsToUpdate = new list<AMPSync_Queue__c>();
		
		/* Query to Queue to get Records which synced with CAIROS and update their status one by one*/
		
		for(AMPSync_Queue__c Queue : [Select a.Id, a.ObjectId__c,
										a.Status__c,
										a.IsSynced__c,
										a.Object_Name__c,				
										a.Sync_Failure_Reason__c,
										a.Last_Sync_DateTime__c
										From AMPSync_Queue__c a 
										where ObjectId__c IN : MapToUpdateQueue.Keyset() limit 2000]){
			
			
			/* List of Queue Objects with updated status */
			
			ListOfRecordsToUpdate.add(new AMPSync_Queue__c(
				Id = Queue.Id,
				IsSynced__c = true,
			   /*	Check the Status Message if its empty for particular record 
				*	then update the status with Success else with Pending
				*/
				Status__c =  (MapToUpdateQueue.get(Queue.ObjectId__c) != '')   
								? AMPSyncApp_Constants.SYNC_STATUS_FAIL 
								: AMPSyncApp_Constants.SYNC_STATUS_SUCCESS, 
				Sync_Failure_Reason__c = MapToUpdateQueue.get(Queue.ObjectId__c),											
				Last_Sync_DateTime__c = Datetime.now()				
			));
		}
		
		if(ListOfRecordsToUpdate != null && ListOfRecordsToUpdate.size() > 0){
			update ListOfRecordsToUpdate;
		}
	}
	 		
	/*	
	*	Return 2500 records from Queue.
	*
	*/	 
	 
	public list<AMPSync_Queue__c> getRecordsFromQueue(){
		try{
			return [Select a.Id, 
				a.Status__c, 
				a.Name, 
				a.ObjectId__c,
				a.Object_Name_Link__c, 
				a.LastModifiedDate, 
				a.Last_Sync_DateTime__c,
				a.Sync_Failure_Reason__c, 
				a.DML_Operation__c 
			From AMPSync_Queue__c a order by Last_Sync_DateTime__c desc limit 2500];
		}catch(QueryException ex){
			return null;
		}	
	}
	
	public integer ToalPendingRecords(){
		try{
			return [Select count() from AMPSync_Queue__c Where Status__c = 'Pending'];			
		}catch(QueryException ex){
			return 200;
		}
	} 
	
   /*	
	*	Get pending records from Queue to Sync with CAIROS.
	*	This activity will be performed with the intveral of every 5 mins.
	*	A Schedule Job will get 250 pending records from Queue and try to Synced again with CAIROS .		
	*
	*/ 
	
	public list<AMPSync_Queue__c> getPendingRecordsFromQueue(){
		try{
			return [Select a.Status__c, 
				a.ObjectId__c,
				a.Object_Name__c,
				a.LastModifiedDate,
				a.Last_Sync_DateTime__c,  
				a.JSONData__c, 
				a.DML_Operation__c 
			From AMPSync_Queue__c a Where Status__c = 'Pending' Order by Last_Sync_DateTime__c ASC limit 250];
		}catch(QueryException ex){
			return null;
		}		 
	}
	
	/*
	*	Get single pending record from Queue to Sync with CAIROS.
	*	This activity will be performed from list view using Sync Button.	
	*
	*/  
	
	public list<AMPSync_Queue__c> getPendingRecordFromQueue(ID QueueId){
		try{
			return [Select a.Status__c, 
				a.ObjectId__c,
				a.Object_Name__c, 
				a.LastModifiedDate, 
				a.JSONData__c, 
				a.DML_Operation__c 
			From AMPSync_Queue__c a Where Id=: QueueId AND Status__c = 'Pending' ];
		}catch(QueryException ex){
			return null;
		}		 
	}
	
   /*	
	*	Update DWH Status Flag for Every record which Synced with CAIROS.
	*	This function is used to update DWH Status for a particular Object Record which synced with CAIROS. 
	*		
	*	@ObjectsMapToUpdate		:	Map of Synced Record Ids with its Status Messag
	*/
	
	public void UpdateDWHSyncFlagInObjects(map<ID, String> ObjectsMapToUpdate){	
		system.debug('ObjectsMapToUpdate >>> '+ObjectsMapToUpdate);	
		list<SObject> ObjectsToUpdate;				
		map<string, list<ID>> mapObjects = new map<string, list<ID>>();
		
		/* Create Map of Similar Objects with IDs */
		
		for(ID Key : ObjectsMapToUpdate.KeySet()){			
			string ObjectName = AMPSyncApp_Util.getSObjectAPIName(Key);
			if(mapObjects.get(ObjectName) == null){
				mapObjects.put(ObjectName, new list<ID>{Key});
			}else mapObjects.get(ObjectName).add(Key);			
		}
		
		/* Query to Particular Object to Update its DWH Status */
		
		for(string ObjectApiName : mapObjects.KeySet()){
			ObjectsToUpdate = new list<SObject>();
			list<ID> listOfIDs = mapObjects.get(ObjectApiName);
			string ExcludeConvertedLeads = '';
			if(ObjectApiName == 'Lead'){
				ExcludeConvertedLeads = ' AND IsConverted = false';
			}
			string Query = 'Select Id, DWH_Status__c, DWH_Last_Sync__c From '+ObjectApiName+ ' Where Id IN : listOfIDs '+ExcludeConvertedLeads+' limit 250';			
			system.debug('Query >>> '+Query);
			ObjectsToUpdate = Database.query(Query);
			for(SObject Obj : ObjectsToUpdate){				
				Obj.put('DWH_Status__c', (ObjectsMapToUpdate.get(Obj.Id) != '' )? 'Queued' : 'Synced');
				Obj.put('DWH_Last_Sync__c', Datetime.now());				
			}
			system.debug('ObjectsToUpdate >>> '+ObjectsToUpdate);			
			try{ 
				Database.update(ObjectsToUpdate,false);
			}catch(DMLException ex){}			
		}
	}		
}