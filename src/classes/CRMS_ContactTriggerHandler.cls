/**
    Handler class for the Contact trigger
    Author: Saket Joshi
    Version: 1.0
*/

public class CRMS_ContactTriggerHandler {
    
    public static Boolean isTriggerCalled = false;
    public static Boolean isTriggerCalledOnInsert = false;
    
    //Method to set the DWH_Status to Synced for contacts
    public void setDwhStatusSynced(List<Contact> lstContact) {
        for(Contact objContact : lstContact) {
            objContact.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            objContact.DWH_Last_Sync__c = Datetime.now();
        }
    }
    
    //Method to set the DWH_Status to Queued for contacts
    public void setDwhStatusQueued(List<Contact> lstContact) {
        for(Contact objContact : lstContact)
            objContact.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
    }
    
    //Method to process the update of contact record and create/update sync queue record resp
    public void updateSyncQueueRecord(List<Contact> lstContact) {
        Map<Id, List<Sync_Queue__c>> mapContactIdListQueue = new Map<Id, List<Sync_Queue__c>>();
        List<Sync_Queue__c> lstQueueToInsert = new List<Sync_Queue__c>();
        List<Sync_Queue__c> lstQueueToUpdate = new List<Sync_Queue__c>();
        
        for(Contact objContact : lstContact)
            mapContactIdListQueue.put(objContact.Id, new List<Sync_Queue__c> ());
        
        List<Sync_Queue__c> lstQueue = new List<Sync_Queue__c>();
        lstQueue = [SELECT Id,
                        Contact__c,
                        DWH_Data_Type__c,
                        Notes__c,
                        Queued_Record_ID__c,
                        Sync_Status__c
                        FROM Sync_Queue__c
                        WHERE 
                            Contact__c IN :mapContactIdListQueue.keySet()
                            AND Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING];
        
        for(Sync_Queue__c objQueue : lstQueue) {
            if(mapContactIdListQueue.containsKey(objQueue.Contact__c) && mapContactIdListQueue.get(objQueue.Contact__c) != null)
                mapContactIdListQueue.get(objQueue.Contact__c).add(objQueue);
            else
                mapContactIdListQueue.put(objQueue.Contact__c, new List<Sync_Queue__c> { objQueue });
        }
        
        for(Contact objContact : lstContact) {
            List<Sync_Queue__c> lstQueueWithContact = mapContactIdListQueue.get(objContact.Id);
            if(lstQueueWithContact != null && !lstQueueWithContact.isEmpty()) {
                for(Sync_Queue__c objQueue : lstQueueWithContact) {
                    if(!objQueue.Sync_Status__c.equals(CRMS_Constants.SYNC_STATUS_DELETE)) {
                        objQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                        objQueue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                        //objQueue.Notes__c = Datetime.now().format() + ' ' + CRMS_Constants.DWH_DELETE_TRIGGER;
                        objQueue.Queued_Record_ID__c = objContact.Id;
                        lstQueueToUpdate.add(objQueue);
                    }
                }
            }
            
            lstQueueToInsert.add(new Sync_Queue__c (Queued_Record_ID__c = objContact.Id,
                                    DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_CONTACT,
                                    Action__c = CRMS_Constants.SYNC_ACTION_DELETE,
                                    Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING));
            
        }
        
        if(lstQueueToUpdate != null && !lstQueueToUpdate.isEmpty()) {
            update lstQueueToUpdate;
        }
        
        if(lstQueueToInsert != null && !lstQueueToInsert.isEmpty())
            insert lstQueueToInsert;
    } // end of updateSyncQueueRecord
} // end of class