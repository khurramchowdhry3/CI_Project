/**
    Handler for trigger on Case object
    Author: Saket Joshi
    Version: 1.0
*/

public class CRMS_CaseTriggerHandler {

    public static Boolean isTriggerCalled = false;
    public static Boolean isTriggerCalledInsert = false;
    //Method to set the DWH_Status to Synced for Case
    public void setDwhStatusSynced(List<Case> lstCases) {
        for(Case objCase : lstCases) {
            objCase.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            objCase.DWH_Last_Sync__c = Datetime.now();
        }
    }
    
    //Method to set the DWH_Status to Queued for Case
    public void setDwhStatusQueued(List<Case> lstCases) {
        for(Case objCase : lstCases)
            objCase.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
    }

    //Method to process the update of Case record and create/update sync queue record resp
    public void updateSyncQueueRecord(List<Case> lstCases) {
        Map<Id, List<Sync_Queue__c>> mapCaseIdListQueue = new Map<Id, List<Sync_Queue__c>>();
        List<Sync_Queue__c> lstQueueToInsert = new List<Sync_Queue__c>();
        List<Sync_Queue__c> lstQueueToUpdate = new List<Sync_Queue__c>();
        
        for(Case objCase : lstCases)
            mapCaseIdListQueue.put(objCase.Id, new List<Sync_Queue__c> ());
        
        List<Sync_Queue__c> lstQueue = new List<Sync_Queue__c>();
        lstQueue = [SELECT Id,
                        Case__c,
                        DWH_Data_Type__c,
                        Notes__c,
                        Queued_Record_ID__c,
                        Sync_Status__c
                        FROM Sync_Queue__c
                        WHERE 
                            Case__c IN :mapCaseIdListQueue.keySet()
                            AND Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING];
        
        for(Sync_Queue__c objQueue : lstQueue) {
            if(mapCaseIdListQueue.containsKey(objQueue.Case__c) && mapCaseIdListQueue.get(objQueue.Case__c) != null)
                mapCaseIdListQueue.get(objQueue.Case__c).add(objQueue);
            else
                mapCaseIdListQueue.put(objQueue.Case__c, new List<Sync_Queue__c> { objQueue });
        }
        
        for(Case objCase : lstCases) {
            List<Sync_Queue__c> lstQueueWithGuarantors = mapCaseIdListQueue.get(objCase.Id);
            if(lstQueueWithGuarantors != null && !lstQueueWithGuarantors.isEmpty()) {
                for(Sync_Queue__c objQueue : lstQueueWithGuarantors) {
                    if(!objQueue.Sync_Status__c.equals(CRMS_Constants.SYNC_STATUS_DELETE)) {
                        objQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                        objQueue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                        //objQueue.Notes__c = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                        objQueue.Queued_Record_ID__c = objCase.Id;
                        lstQueueToUpdate.add(objQueue);
                    }
                }
            }
            
            lstQueueToInsert.add(new Sync_Queue__c (Queued_Record_ID__c = objCase.Id,
                                    DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_CASE,
                                    Action__c = CRMS_Constants.SYNC_ACTION_DELETE,
                                    Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING));
            
        }
        
        if(lstQueueToUpdate != null && !lstQueueToUpdate.isEmpty())
            update lstQueueToUpdate;
        
        if(lstQueueToInsert != null && !lstQueueToInsert.isEmpty())
            insert lstQueueToInsert;
    } // end of updateSyncQueueRecord
} // end of class