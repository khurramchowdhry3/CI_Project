/**
	Batch class for performing synchronization with DWH
	Author: Saket Joshi
	Version: 1.0
*/

public with sharing class CRMS_LeadSyncBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {

	public Database.QueryLocator start(Database.BatchableContext bc) {
		String query = CRMS_SObjectUtility.generateQueryForQueueParents() + ' WHERE Queued_Record_Id__c != null AND DWH_Data_Type__c = \'Operation\' AND DWH_Data_Type__c != null AND Sync_Status__c = \'Pending\'';
		return Database.getQueryLocator(query);
	}
	
	public void execute(Database.BatchableContext info, List<SObject> lstSyncQueue) {
		Map<String, List<Sync_Queue__c>> mapDataTypeSyncQueue = new Map<String, List<Sync_Queue__c>> ();
		List<Sync_Queue__c> lstQueue = new List<Sync_Queue__c> ();
		Set<Sync_Queue__c> setQueueToUpdate = new Set<Sync_Queue__c> ();
		
		system.debug('********lstSyncQueue' + lstSyncQueue);
		
		if(lstSyncQueue != null && !lstSyncQueue.isEmpty()) {
			lstQueue = (List<Sync_Queue__c>) lstSyncQueue;
			for(Sync_Queue__c objQueue : lstQueue) {
				if(!mapDataTypeSyncQueue.containsKey(objQueue.DWH_Data_Type__c) || mapDataTypeSyncQueue.get(objQueue.DWH_Data_Type__c) == null) {
					mapDataTypeSyncQueue.put(objQueue.DWH_Data_Type__c, new List<Sync_Queue__c> { objQueue });
				} //If map does not contain the data type
				else {
					mapDataTypeSyncQueue.get(objQueue.DWH_Data_Type__c).add(objQueue);
				} //If map contains the data type
			} //End of for loop for lstQueue
		} //End of if lstSyncQueue is not empty
		
		for(String strDataType : mapDataTypeSyncQueue.keySet()) {
			List<Sync_Queue__c> lstTempQueue = mapDataTypeSyncQueue.get(strDataType);
			if(lstTempQueue != null && !lstTempQueue.isEmpty()) {
				List<Id> lstQueueIdToDelete = new List<Id> ();
				Map<Id, Sync_Queue__c> mapLeadIdSyncQueue = new Map<Id, Sync_Queue__c> ();
				for(Sync_Queue__c objQueue : lstTempQueue) { 
					mapLeadIdSyncQueue.put((Id)objQueue.get(CRMS_Constants.mapDataTypeObjectName.get(objQueue.DWH_Data_Type__c)), objQueue);
					if(objQueue.Action__c.equals(CRMS_Constants.SYNC_ACTION_DELETE) && objQueue.Queued_Record_Id__c != null)
						lstQueueIdToDelete.add(objQueue.Queued_Record_Id__c);
				}
				
				List<SObject> lstLeads = new List<SObject> ();
				Set<Id> setQueueId = new Set<Id> (mapLeadIdSyncQueue.keySet());
				String queryStr = getQueryFromObjectType(strDataType) + 'setQueueId';
				lstLeads = Database.query(queryStr);
				
				Map<String, List<SObject>> mapActionListLeads = new Map<String, List<SObject>> ();
				mapActionListLeads.put(CRMS_Constants.SYNC_ACTION_CREATE, new List<SObject> ());
				mapActionListLeads.put(CRMS_Constants.SYNC_ACTION_UPDATE, new List<SObject> ());
				mapActionListLeads.put(CRMS_Constants.SYNC_ACTION_DELETE, new List<SObject> ());
				
				if(lstLeads != null && !lstLeads.isEmpty()) {
					for(SObject objLead : lstLeads) {
						if(objLead.get('DWH_Status__c').equals(CRMS_Constants.DWH_STATUS_QUEUED)) {
							//Check Action__c for Sync Queue record
							if(mapLeadIdSyncQueue.get(objLead.Id).Action__c.equals(CRMS_Constants.SYNC_ACTION_CREATE)) {
								mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_CREATE).add(objLead);
							} //End of if queue action is insert
							else if(mapLeadIdSyncQueue.get(objLead.Id).Action__c.equals(CRMS_Constants.SYNC_ACTION_UPDATE)) {
								mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_UPDATE).add(objLead);
							} //End of if queue action is update
							else if(mapLeadIdSyncQueue.get(objLead.Id).Action__c.equals(CRMS_Constants.SYNC_ACTION_DELETE)) {
								mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_DELETE).add(objLead);
							} //End of if queue action is delete
						} //End of if DWH Status of lead is Queued
						else if(objLead.get('DWH_Status__c').equals(CRMS_Constants.DWH_STATUS_SYNCED)) {
							mapLeadIdSyncQueue.get(objLead.Id).Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
							if(mapLeadIdSyncQueue.get(objLead.Id).Notes__c == null)
								mapLeadIdSyncQueue.get(objLead.Id).Notes__c = '';
							mapLeadIdSyncQueue.get(objLead.Id).Notes__c += '\n' + Datetime.now().format() + CRMS_Constants.BATCH_NO_ACTION_NEEDED;
							setQueueToUpdate.add(mapLeadIdSyncQueue.get(objLead.Id));
						} //End of if DWH Status of lead is Synced
					} //End of for loop for every lead
					
					if(mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_CREATE) != null && !mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_CREATE).isEmpty()) {
						CRMS_HttpResponseWrapper objResponseCreate = CRMS_DwhSyncHandler.doCallout(mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_CREATE), CRMS_Constants.SYNC_ACTION_CREATE);
						setQueueToUpdate.addAll(CRMS_DwhSyncHandler.processBatchResults(mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_CREATE), objResponseCreate, CRMS_Constants.SYNC_ACTION_INSERT));
					} //End of if map for create is NOT null
					
					if(mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_UPDATE) != null && !mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_UPDATE).isEmpty()) {
						CRMS_HttpResponseWrapper objResponseUpdate = CRMS_DwhSyncHandler.doCallout(mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_UPDATE), CRMS_Constants.SYNC_ACTION_UPDATE);
						setQueueToUpdate.addAll(CRMS_DwhSyncHandler.processBatchResults(mapActionListLeads.get(CRMS_Constants.SYNC_ACTION_UPDATE), objResponseUpdate, CRMS_Constants.SYNC_ACTION_UPDATE));
					} //End of if map for update is NOT null
					
				} //End of if lstLeads is NOT empty
				
				if(lstQueueIdToDelete != null && !lstQueueIdToDelete.isEmpty()) {
					CRMS_HttpResponseWrapper objResponseDelete = CRMS_DwhSyncHandler.doCalloutForDelete(lstQueueIdToDelete);
					setQueueToUpdate.addAll(CRMS_DwhSyncHandler.processBatchResultsForDelete(lstQueueIdToDelete, objResponseDelete));
				} //End of if lstQueueIdToDelete is NOT null
				
			} //End of if lstSyncQueue is not empty
		}
		List<Sync_Queue__c> lstToUpdate = new List<Sync_Queue__c> ();
		lstToUpdate.addAll(setQueueToUpdate);
		system.debug('****lstToUpdate' + lstToUpdate);
		update lstToUpdate;
	}

	//Method to get the dynamic query based on the object type
	private String getQueryFromObjectType(String objectName) {
		String query = CRMS_SObjectUtility.generateQueryFromObjectName(objectName);
		return query + ' WHERE Id IN :';
	}

	public void finish(Database.BatchableContext info) {
		
	}

}