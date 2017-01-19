/**
    Batch class for performing synchronization with DWH
    Author: Saket Joshi
    Version: 1.0
*/

public class CRMS_DwhSyncBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    
	private static final Integer BATCH_RUN_FREQUENCY_IN_MINUTES = 5;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = CRMS_SObjectUtility.generateQueryForQueueParents() + ' WHERE Queued_Record_Id__c != null AND DWH_Data_Type__c != null AND Sync_Status__c = \'Pending\'';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext info, List<SObject> lstSyncQueue) {
        Map<String, List<Sync_Queue__c>> mapDataTypeSyncQueue = new Map<String, List<Sync_Queue__c>> ();
        List<Sync_Queue__c> lstQueue = new List<Sync_Queue__c> ();
        Set<Sync_Queue__c> setQueueToUpdate = new Set<Sync_Queue__c> ();
        List<String> lstOfPreference = new List<String>{ 'User', 'Campaign', 'Lead', 'Account', 'Contact', 'Opportunity', 'ODG', 'Credit Assessment', 'Operation', 'Case', 'Task' ,	
            'Program', 'Product', 'Program Product Association', 'Reward', 'Loan Management', 'Loan Ledger'}; 
        try{
        if(lstSyncQueue != null && !lstSyncQueue.isEmpty()) {
            lstQueue = (List<Sync_Queue__c>) lstSyncQueue;
            system.debug('lstQueue ----- >'+lstQueue.size());
            for(Sync_Queue__c objQueue : lstQueue) {
                system.debug(System.LoggingLevel.ERROR, 'id***********' + objQueue.Id);
                if(!mapDataTypeSyncQueue.containsKey(objQueue.DWH_Data_Type__c) || mapDataTypeSyncQueue.get(objQueue.DWH_Data_Type__c) == null) {
                    mapDataTypeSyncQueue.put(objQueue.DWH_Data_Type__c, new List<Sync_Queue__c> { objQueue });
                } //If map does not contain the data type
                else {
                    mapDataTypeSyncQueue.get(objQueue.DWH_Data_Type__c).add(objQueue);
                } //If map contains the data type
            } //End of for loop for lstQueue
        } //End of if lstSyncQueue is not empty
        
        for(String strDataType : lstOfPreference ) {
            List<Sync_Queue__c> lstTempQueue = mapDataTypeSyncQueue.get(strDataType);
            if(lstTempQueue != null && !lstTempQueue.isEmpty()) {
                List<Id> lstQueueIdToDelete = new List<Id> ();
                Map<Id, Sync_Queue__c> mapRecordIdSyncQueue = new Map<Id, Sync_Queue__c> ();
                for(Sync_Queue__c objQueue : lstTempQueue) { 
                    mapRecordIdSyncQueue.put((Id)objQueue.get(CRMS_Constants.mapDataTypeObjectName.get(objQueue.DWH_Data_Type__c)), objQueue);
                    if(objQueue.Action__c != null && objQueue.Action__c.equals(CRMS_Constants.SYNC_ACTION_DELETE) && objQueue.Queued_Record_Id__c != null)
                        lstQueueIdToDelete.add(objQueue.Queued_Record_Id__c);
                }
                
                List<SObject> lstRecords = new List<SObject> ();
                Set<Id> setQueueId = new Set<Id> (mapRecordIdSyncQueue.keySet());
                String queryStr = getQueryFromObjectType(strDataType) + 'setQueueId';
                lstRecords = Database.query(queryStr);
                
                Map<String, List<SObject>> mapActionListRecords = new Map<String, List<SObject>> ();
                mapActionListRecords.put(CRMS_Constants.SYNC_ACTION_CREATE, new List<SObject> ());
                mapActionListRecords.put(CRMS_Constants.SYNC_ACTION_UPDATE, new List<SObject> ());
                mapActionListRecords.put(CRMS_Constants.SYNC_ACTION_DELETE, new List<SObject> ());
                List<SObject> lstPersonAccountToInsert = new List<SObject> ();
                List<SObject> lstPersonAccountToUpdate = new List<SObject> ();
                
                if(lstRecords != null && !lstRecords.isEmpty()) {
                    for(SObject sObj : lstRecords) {
                        if(sObj.get('DWH_Status__c') != null && sObj.get('DWH_Status__c').equals(CRMS_Constants.DWH_STATUS_QUEUED)) {
                            if(sObj.getSObjectType() == Account.getSObjectType() && ((Boolean)sObj.get('isPersonAccount')) == true) {
                                //Check Action__c for Sync Queue record
                                if(mapRecordIdSyncQueue.get(sObj.Id).Action__c.equals(CRMS_Constants.SYNC_ACTION_CREATE)) {
                                    lstPersonAccountToInsert.add(sObj);
                                } //End of if queue action is insert
                                else if(mapRecordIdSyncQueue.get(sObj.Id).Action__c.equals(CRMS_Constants.SYNC_ACTION_UPDATE)) {
                                    lstPersonAccountToUpdate.add(sObj);
                                } //End of if queue action is update
                                else if(mapRecordIdSyncQueue.get(sObj.Id).Action__c.equals(CRMS_Constants.SYNC_ACTION_DELETE)) {
                                    mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_DELETE).add(sObj);
                                } //End of if queue action is delete
                            } //End of if account is a person account
                            else {
                                //Check Action__c for Sync Queue record
                                if(mapRecordIdSyncQueue.get(sObj.Id).Action__c.equals(CRMS_Constants.SYNC_ACTION_CREATE)) {
                                    mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_CREATE).add(sObj);
                                } //End of if queue action is insert
                                else if(mapRecordIdSyncQueue.get(sObj.Id).Action__c.equals(CRMS_Constants.SYNC_ACTION_UPDATE)) {
                                    mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_UPDATE).add(sObj);
                                } //End of if queue action is update
                                else if(mapRecordIdSyncQueue.get(sObj.Id).Action__c.equals(CRMS_Constants.SYNC_ACTION_DELETE)) {
                                    mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_DELETE).add(sObj);
                                } //End of if queue action is delete
                            } //End of if account is not a person account
                        } //End of if DWH Status of lead is Queued
                        else if(sObj.get('DWH_Status__c') != null && sObj.get('DWH_Status__c').equals(CRMS_Constants.DWH_STATUS_SYNCED)) {
                            mapRecordIdSyncQueue.get(sObj.Id).Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                            if(mapRecordIdSyncQueue.get(sObj.Id).Notes__c == null)
                                mapRecordIdSyncQueue.get(sObj.Id).Notes__c = '';
                            mapRecordIdSyncQueue.get(sObj.Id).Notes__c += '\n' + Datetime.now().format() + CRMS_Constants.BATCH_NO_ACTION_NEEDED;
                            setQueueToUpdate.add(mapRecordIdSyncQueue.get(sObj.Id));
                        } //End of if DWH Status of lead is Synced
                    } //End of for loop for every lead
                    
                    if(lstPersonAccountToInsert != null && !lstPersonAccountToInsert.isEmpty()) {
                        CRMS_HttpResponseWrapper objResponseCreate = CRMS_DwhSyncHandler.doCallout(lstPersonAccountToInsert, CRMS_Constants.SYNC_ACTION_CREATE);
                        setQueueToUpdate.addAll(CRMS_DwhSyncHandler.processBatchResults(lstPersonAccountToInsert, objResponseCreate, CRMS_Constants.SYNC_ACTION_INSERT));
                    } //End of if person account to create list is NOT null
                    
                    if(lstPersonAccountToUpdate != null && !lstPersonAccountToUpdate.isEmpty()) {
                        CRMS_HttpResponseWrapper objResponseCreate = CRMS_DwhSyncHandler.doCallout(lstPersonAccountToUpdate, CRMS_Constants.SYNC_ACTION_CREATE);
                        setQueueToUpdate.addAll(CRMS_DwhSyncHandler.processBatchResults(lstPersonAccountToUpdate, objResponseCreate, CRMS_Constants.SYNC_ACTION_INSERT));
                    } //End of if person account to update list is NOT null
                    
                    if(mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_CREATE) != null && !mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_CREATE).isEmpty()) {
                        CRMS_HttpResponseWrapper objResponseCreate = CRMS_DwhSyncHandler.doCallout(mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_CREATE), CRMS_Constants.SYNC_ACTION_CREATE);
                        setQueueToUpdate.addAll(CRMS_DwhSyncHandler.processBatchResults(mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_CREATE), objResponseCreate, CRMS_Constants.SYNC_ACTION_INSERT));
                    } //End of if map for create is NOT null
                    
                    if(mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_UPDATE) != null && !mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_UPDATE).isEmpty()) {
                        CRMS_HttpResponseWrapper objResponseUpdate = CRMS_DwhSyncHandler.doCallout(mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_UPDATE), CRMS_Constants.SYNC_ACTION_UPDATE);
                        setQueueToUpdate.addAll(CRMS_DwhSyncHandler.processBatchResults(mapActionListRecords.get(CRMS_Constants.SYNC_ACTION_UPDATE), objResponseUpdate, CRMS_Constants.SYNC_ACTION_UPDATE));
                    } //End of if map for update is NOT null
                    
                } //End of if lstRecords is NOT empty
                
                if(lstQueueIdToDelete != null && !lstQueueIdToDelete.isEmpty()) {
                    system.debug('lstQueueIdToDelete in Batch:' + lstQueueIdToDelete);
                    CRMS_HttpResponseWrapper objResponseDelete = CRMS_DwhSyncHandler.doCalloutForDelete(lstQueueIdToDelete);
                    setQueueToUpdate.addAll(CRMS_DwhSyncHandler.processBatchResultsForDelete(lstQueueIdToDelete, objResponseDelete));
                    
                    system.debug('objResponseDelete in Batch after Delete:' + JSON.serialize(objResponseDelete));
                } //End of if lstQueueIdToDelete is NOT null
                
            } //End of if lstSyncQueue is not empty
        }
        List<Sync_Queue__c> lstToUpdate = new List<Sync_Queue__c> ();
        lstToUpdate.addAll(setQueueToUpdate);
        if( lstToUpdate.size() > 0 )
            update lstToUpdate;
        }catch( Exception e){
            system.debug('------ Exception Is -------------'+e.getMessage());
        }
        
    } //end of execute

    //Method to get the dynamic query based on the object type
    private String getQueryFromObjectType(String objectName) {
        String query = CRMS_SObjectUtility.generateQueryFromObjectName(objectName);
        return query + ' WHERE Id IN :';
    }

    public void finish(Database.BatchableContext info) {
        if(!Test.isRunningTest()){
            system.scheduleBatch(new CRMS_DwhSyncBatch (), 'CRMS_DwhSyncBatch:'+system.now(),BATCH_RUN_FREQUENCY_IN_MINUTES, Integer.valueOf(Label.Batch_Record_Size));
        }
    }
}