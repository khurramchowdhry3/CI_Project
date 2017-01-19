/**
    Additional Debt trigger handler for sync with DWH
    Author: CRMS
    Version: 1.0
*/
public with sharing class CRMS_AdditionalDebtHandler {
    public static Boolean isTriggerCalled = false;
    // method to set Operation status as Queued when updated on SF end
    public void setAddDebtDWHStatusQueued(List<Additional_Debt__c> lstAddDebt) {
        
        for (Additional_Debt__c additionalDebt : lstAddDebt){
            additionalDebt.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
        }
        
    }
    
    // method to set Operation status as Synced when successfully synced with DWH
    public void setAddDebtDWHStatusSynced(List<Additional_Debt__c> lstAddDebt) {
        
        for (Additional_Debt__c additionalDebt : lstAddDebt){
            additionalDebt.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            additionalDebt.DWH_Last_Sync__c = Datetime.now();
        }
        
    }
    // method to create/update Sync Queue records
    public void updateSyncQueueRecord(List<Additional_Debt__c> lstAddDebt){
        Map<Id,List<Sync_Queue__c>> addDebtIdToSynchQueListMap = new  Map<Id,List<Sync_Queue__c>>();
        Set<Id> addDebtIdSet = new Set<Id>();
        Sync_Queue__c[] synchQueueUpdateList = new Sync_Queue__c[]{};
        Sync_Queue__c[] synchQueueCreateList = new Sync_Queue__c[]{};
        
        for (Additional_Debt__c additionalDebt : lstAddDebt) {
            addDebtIdSet.add(additionalDebt.Id);
        }
        List<Sync_Queue__c> syncQueueList = [
            SELECT Additional_Debt__c
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING
                AND Additional_Debt__c IN :addDebtIdSet
         ];
         
        for (Sync_Queue__c syncQueue : syncQueueList) {
            if (addDebtIdToSynchQueListMap.containsKey(syncQueue.Additional_Debt__c) == true) {
                addDebtIdToSynchQueListMap.get(syncQueue.Additional_Debt__c).add(syncQueue);
            } else {
                addDebtIdToSynchQueListMap.put(syncQueue.Additional_Debt__c, new Sync_Queue__c[] {syncQueue});
            }
        }
        
        for (Additional_Debt__c additionalDebt : lstAddDebt) {
            Sync_Queue__c[] synchQueueList = addDebtIdToSynchQueListMap.get(additionalDebt.Id);
            if (synchQueueList != null && !synchQueueList.isEmpty()) {
                for (Sync_Queue__c synchQue : synchQueueList) {
                    if (synchQue.Action__c != CRMS_Constants.SYNC_ACTION_DELETE) {
                        synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    }
                    String currentDateTime = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                    synchQue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                    synchQue.Notes__c = currentDateTime;
                    synchQue.Queued_Record_ID__c = additionalDebt.Id;
                    synchQueueUpdateList.add(synchQue);
                }
            } 
            Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.Queued_Record_ID__c = additionalDebt.Id;
            syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_OPERATION;
            syncQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
            syncQueue.Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING;
            String currentDateTime = Datetime.now().format() + CRMS_Constants.SYNC_STATUS_OPERATION_DELETED;
            syncQueue.Notes__c = currentDateTime;
            synchQueueCreateList.add(syncQueue);
            
        }
        if (!synchQueueUpdateList.isEmpty()) {
            update synchQueueUpdateList;
        }
        if (!synchQueueCreateList.isEmpty()) {
            insert synchQueueCreateList;
        }
    }
}