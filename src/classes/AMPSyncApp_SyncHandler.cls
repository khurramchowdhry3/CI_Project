/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used to Sync Sobjects with CAIROS
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Class to Sync SObjects with CAIROS.
 * 
 */
   
public with sharing class AMPSyncApp_SyncHandler {
   
    public static boolean DoASyncCall {get; set;}{
    	 DoASyncCall = true;
    }
    
    private static void StartSync(list<ID> Objectslist, string JSONString, string SobjectEndpoint, string Operation){		
				
		/* Set Callout Method from Operation */
		AMPSyncApp_Callout.setCallOutMethod(AMPSyncApp_Constants.CALLOUT_METHOD_MAP.get(Operation));	
		
		/*  Do Callout for Operation 'Insert/Update/Delete' */
		
		string CalloutResponse = AMPSyncApp_Callout.CallOutPOST(SobjectEndpoint, JSONString);
		new AMPSyncApp_Response().ProcessCalloutResponse(CalloutResponse, Objectslist);				
	}
   
      
   /*
	*
	*	Future method to Sync SObject Records with CAIROS
	*	Requires following Parameters
	*
	*	@JSONString : JSON Encoded Data to Sync
	*	@SObjectEndPoint : API EndPoint i.e. '/api/leads'
	*	@Operation	: Sync Operation i.e. Insert/Update/Delete
	*	@Objectslist : List of Records which are syncing with CAIROS, used to update response in Queue 	
	*
	*/ 
			
	@future (callout=true)
	private static void StartASync(list<ID> Objectslist, string JSONString, string SobjectEndpoint, string Operation){		
				
		/* Set Callout Method from Operation */
		AMPSyncApp_Callout.setCallOutMethod(AMPSyncApp_Constants.CALLOUT_METHOD_MAP.get(Operation));	
		
		/*  Do Callout for Operation 'Insert/Update/Delete' */
		
		string CalloutResponse = AMPSyncApp_Callout.CallOutPOST(SobjectEndpoint, JSONString);
		new AMPSyncApp_Response().ProcessCalloutResponse(CalloutResponse, Objectslist);				
	}
	
	 
	/*
	*
	*	Method which is called from Trigger or any other Class to Sync Salesforce Data with CAIROS
	*	Requires following Parameters
	*
	*	@SobjectList : List of Records of any SObject i.e. (Lead, Account, Opportunity, ...)
	*	@DMLOperation	: Sync Operation i.e. Insert/Update/Delete
	*
	*/
	
	public static void SyncWithCAIROS(list<SObject> SobjectList, string DMLOperation){
		if(SobjectList != null && SobjectList.size() > 0){									
			
			/* Convert list of Records to JSON String */
			string JSONString = AMPSyncApp_Encoding.JSON_Encode().SObjectToJSON(SobjectList, DMLOperation);
									
			if(JSONString != null && SobjectList.size() <= 250){				
				string SObjectName = AMPSyncApp_Util.getSObjectAPIName(SobjectList[0]);
				string EndPoint = (AMPSyncApp_Util.IsPersonAccount(SobjectList[0]) == true ?  
										AMPSyncApp_Constants.SOBJECT_ENDPOINTS_MAP.get('Contact').Value__c :
										AMPSyncApp_Constants.SOBJECT_ENDPOINTS_MAP.get(SObjectName).Value__c); 
				list<ID> ObjectIDList = new list<ID>();
				for(Sobject Obj : SobjectList)
					ObjectIDList.add(Obj.Id);
				
				//if(DoASyncCall)
					StartASync(ObjectIDList, JSONString, EndPoint, DMLOperation);
				//else StartSync(ObjectIDList, JSONString, EndPoint, DMLOperation);
			}
		}
	}
	 
	
	/*
	*
	*	Method to Sync Pending records in Queue with CAIROS
	*	A Schedule Job which execute with the intveral of every 5 minutes to Sync Pending records from Queue.	
	*
	*/
	
	public static void SyncQueueWithCAIROS(){
		
		map<string, list<AMPSync_Queue__c>> mapDeletedRecordsQueue = new map<string, list<AMPSync_Queue__c>>();
		map<string, list<AMPSync_Queue__c>> mapOtherRecordsQueue = new map<string, list<AMPSync_Queue__c>>();
		list<ID> ObjectIDListForInsert = new list<ID>();list<ID> ObjectIDListForUpdate = new list<ID>();
		list<ID> ObjectIDListForDel = new list<ID>();
		string JSONForInsert, JSONForUpdate, JSONForDel;
		
		/* Get 300 pending records from Queue to Sync with CAIROS */
		
		list<AMPSync_Queue__c> Queue = new AMPSyncApp_SyncQueue().getPendingRecordsFromQueue();
									 
		if(Queue != null && Queue.size() > 0){
			for(AMPSync_Queue__c Q : Queue){
											
			   /*  
				*
				*	Create Map for Deleted Records
				*
				*/
				
				if(Q.DML_Operation__c == AMPSyncApp_Constants.SYNC_ACTION_DELETE){			
					
					if(mapDeletedRecordsQueue.get(Q.Object_Name__c) == null){
						mapDeletedRecordsQueue.put(Q.Object_Name__c,new list<AMPSync_Queue__c>{Q});
					}else mapDeletedRecordsQueue.get(Q.Object_Name__c).add(Q);
											
			   /*  
				*
				*	Create Map for Inserted/Updated Records
				*
				*/
				
				}else{  
					
					if(mapOtherRecordsQueue.get(Q.Object_Name__c) == null){
						mapOtherRecordsQueue.put(Q.Object_Name__c,new list<AMPSync_Queue__c>{Q});
					}else mapOtherRecordsQueue.get(Q.Object_Name__c).add(Q);
				}				
			}
			
			
		   /*
			*
			*	Sync Inserted/Updated Records from Map
			*
			*/			
			
			for(string Key : mapOtherRecordsQueue.KeySet()){
				JSONForInsert = '';	JSONForUpdate = ''; ObjectIDListForInsert.clear(); ObjectIDListForUpdate.clear();
												
				for(AMPSync_Queue__c MQ : mapOtherRecordsQueue.get(Key)){					
					string JSONStr = MQ.JSONData__c.removeStart('[').removeEnd(']');
					
					
					/* Concatenate JSON string of Updated records for Particular SObject */
					
					if(MQ.DML_Operation__c == AMPSyncApp_Constants.SYNC_ACTION_UPDATE){
						
						JSONForUpdate += JSONStr + ',';
						ObjectIDListForUpdate.add(MQ.ObjectId__c);
						
					/* Concatenate JSON string of Inserted/Created records for Same SObject */
					
					}else{
						JSONForInsert += JSONStr + ',';
						ObjectIDListForInsert.add(MQ.ObjectId__c);
					}					 
				}
				
				/* Sync Inserted Records */
				
				if(JSONForInsert != null && JSONForInsert != ''){					
					JSONForInsert = '[' + JSONForInsert.removeEnd(',') + ']';
					string EndPoint = AMPSyncApp_Constants.SOBJECT_ENDPOINTS_MAP.get(Key).Value__c;
					StartASync(ObjectIDListForInsert, JSONForInsert, EndPoint, AMPSyncApp_Constants.SYNC_ACTION_INSERT);
				
				
				/* Sync Updated Records */
				
				}else if(JSONForUpdate != null && JSONForUpdate != ''){	
					JSONForUpdate = '[' + JSONForUpdate.removeEnd(',') + ']';
					string EndPoint = AMPSyncApp_Constants.SOBJECT_ENDPOINTS_MAP.get(Key).Value__c;
					StartASync(ObjectIDListForUpdate, JSONForUpdate, EndPoint, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
				}
			}
			
			
			/*
			*
			*	Sync Deleted Records from Map
			*
			*/
			
			
			for(string Key : mapDeletedRecordsQueue.KeySet()){
				JSONForDel = ''; ObjectIDListForDel.clear();
				
				for(AMPSync_Queue__c MQ : mapDeletedRecordsQueue.get(Key)){					
					
					/* Concatenate JSON string of Deleted records for Particular SObject */
					
					string JSONStr = MQ.JSONData__c.removeStart('[').removeEnd(']');
					JSONForDel += JSONStr + ',';
					ObjectIDListForDel.add(MQ.ObjectId__c);
				
				}
				
				/* Sync Deleted Records */
				
				if(JSONForDel != null && JSONForDel != ''){					
					JSONForDel = '[' + JSONForDel.removeEnd(',') + ']';
					string EndPoint = AMPSyncApp_Constants.SOBJECT_ENDPOINTS_MAP.get(Key).Value__c;
					StartASync(ObjectIDListForDel, JSONForDel, EndPoint, AMPSyncApp_Constants.SYNC_ACTION_DELETE);				
				}
			}
		}
	}
	
	/*
	*
	*	Sync Pending record with CAIROS
	*	This method is used to sync single pending record from Queue list view. 
	*
	*	@QueueId : Queue Record Id to Sync
	*
	*/
	
	public static void SyncQueueWithCAIROS(ID QueueId){
		list<AMPSync_Queue__c> Queue = new AMPSyncApp_SyncQueue().getPendingRecordFromQueue(QueueId);
		list<ID> syncedRecords = new list<ID>();
				 
		if(Queue != null && Queue.size() > 0){
			for(AMPSync_Queue__c Q : Queue){
				
				string JSONStr = '[' + Q.JSONData__c + ']';
				syncedRecords.add(Q.ObjectId__c);
				
				string EndPoint = AMPSyncApp_Constants.SOBJECT_ENDPOINTS_MAP.get(Q.Object_Name__c).Value__c;
				StartASync(syncedRecords, JSONStr, EndPoint, Q.DML_Operation__c);
			}
		}
	}  
}