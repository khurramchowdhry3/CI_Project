public class Loan_LoanManagementTriggerHandler {
 public static Boolean isTriggerCalled = false;
    // method to set Operation status as Queued when updated on SF end
    public void setAddDWHStatusQueued(List<Loan_Management__c> lstAdd) {
        
        for (Loan_Management__c tempItem : lstAdd){
            tempItem.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
        } 
        
    }
    
    // method to set Operation status as Synced when successfully synced with DWH
    public void setAddDWHStatusSynced(List<Loan_Management__c> lstAdd) {
        
        for (Loan_Management__c tempItem : lstAdd){
            tempItem.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            tempItem.DWH_Last_Sync__c = Datetime.now();
        }
        
    }
    // method to create/update Sync Queue records
    public void updateSyncQueueRecord(List<Loan_Management__c> lstAdd){
        Map<Id,List<Sync_Queue__c>> addIdToSynchQueListMap = new  Map<Id,List<Sync_Queue__c>>();
        Set<Id> addIdSet = new Set<Id>();
        Sync_Queue__c[] synchQueueUpdateList = new Sync_Queue__c[]{};
        Sync_Queue__c[] synchQueueCreateList = new Sync_Queue__c[]{};
        
        for (Loan_Management__c tempItem : lstAdd) {
            addIdSet.add(tempItem.Id);
        }
        List<Sync_Queue__c> syncQueueList = [
            SELECT Loan_Management__c
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING
                AND Loan_Management__c IN :addIdSet
         ];
         
        for (Sync_Queue__c syncQueue : syncQueueList) {
            if (addIdToSynchQueListMap.containsKey(syncQueue.Loan_Management__c) == true) {
                addIdToSynchQueListMap.get(syncQueue.Loan_Management__c).add(syncQueue);
            } else {
                addIdToSynchQueListMap.put(syncQueue.Loan_Management__c, new Sync_Queue__c[] {syncQueue});
            }
        }
        
        for (Loan_Management__c tempItem : lstAdd) {
            Sync_Queue__c[] synchQueueList = addIdToSynchQueListMap.get(tempItem.Id);
            if (synchQueueList != null && !synchQueueList.isEmpty()) {
                for (Sync_Queue__c synchQue : synchQueueList) {
                    if (synchQue.Action__c != CRMS_Constants.SYNC_ACTION_DELETE) {
                        synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    }
                    String currentDateTime = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                    synchQue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                    synchQue.Notes__c = currentDateTime;
                    synchQue.Queued_Record_ID__c = tempItem.Id;
                    synchQueueUpdateList.add(synchQue);
                }
            } 
            Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.Queued_Record_ID__c = tempItem.Id;
            syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_LOAN_MANAGEMENT;
            syncQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
            syncQueue.Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING;
            String currentDateTime = Datetime.now().format() + CRMS_Constants.SYNC_STATUS_LOAN_MANAGEMENT_DELETED;
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