/**
    Handler for the Owner/Director/Guarantor object trigger
    Author: Saket Joshi
    Version: 1.0
*/

public class CRMS_ODGTriggerHandler {
    
    public static Boolean isTriggerCalled = false;
    
    //Method to set the DWH_Status to Synced for ODG
    public void setDwhStatusSynced(List<Guarantors__c> lstGuarantors) {
        for(Guarantors__c objGuarantor : lstGuarantors) {
            objGuarantor.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            objGuarantor.DWH_Last_Sync__c = Datetime.now();
        }
    }
    
    //Method to set the DWH_Status to Queued for ODG
    public void setDwhStatusQueued(List<Guarantors__c> lstGuarantors) {
        for(Guarantors__c objGuarantor : lstGuarantors)
            objGuarantor.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
    }

    //Method to process the update of ODG record and create/update sync queue record resp
    public void updateSyncQueueRecord(List<Guarantors__c> lstGuarantors) {
        Map<Id, List<Sync_Queue__c>> mapGuarantorIdListQueue = new Map<Id, List<Sync_Queue__c>>();
        List<Sync_Queue__c> lstQueueToInsert = new List<Sync_Queue__c>();
        List<Sync_Queue__c> lstQueueToUpdate = new List<Sync_Queue__c>();
        
        for(Guarantors__c objGuarantor : lstGuarantors)
            mapGuarantorIdListQueue.put(objGuarantor.Id, new List<Sync_Queue__c> ());
        
        List<Sync_Queue__c> lstQueue = new List<Sync_Queue__c>();
        lstQueue = [SELECT Id,
                        ODG__c,
                        DWH_Data_Type__c,
                        Notes__c,
                        Queued_Record_ID__c,
                        Sync_Status__c
                        FROM Sync_Queue__c
                        WHERE 
                            ODG__c IN :mapGuarantorIdListQueue.keySet()
                            AND Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING];
        
        for(Sync_Queue__c objQueue : lstQueue) {
            if(mapGuarantorIdListQueue.containsKey(objQueue.ODG__c) && mapGuarantorIdListQueue.get(objQueue.ODG__c) != null)
                mapGuarantorIdListQueue.get(objQueue.ODG__c).add(objQueue);
            else
                mapGuarantorIdListQueue.put(objQueue.ODG__c, new List<Sync_Queue__c> { objQueue });
        }
        
        for(Guarantors__c objGuarantor : lstGuarantors) {
            List<Sync_Queue__c> lstQueueWithGuarantors = mapGuarantorIdListQueue.get(objGuarantor.Id);
            if(lstQueueWithGuarantors != null && !lstQueueWithGuarantors.isEmpty()) {
                for(Sync_Queue__c objQueue : lstQueueWithGuarantors) {
                    if(!objQueue.Sync_Status__c.equals(CRMS_Constants.SYNC_STATUS_DELETE)) {
                        objQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                        objQueue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                       // objQueue.Notes__c = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                        objQueue.Queued_Record_ID__c = objGuarantor.Id;
                        lstQueueToUpdate.add(objQueue);
                    }
                }
            }
            
            lstQueueToInsert.add(new Sync_Queue__c (Queued_Record_ID__c = objGuarantor.Id,
                                    DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_ODG,
                                    Action__c = CRMS_Constants.SYNC_ACTION_DELETE,
                                    Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING));
            
        }
        
        if(lstQueueToUpdate != null && !lstQueueToUpdate.isEmpty())
            update lstQueueToUpdate;
        
        if(lstQueueToInsert != null && !lstQueueToInsert.isEmpty())
            insert lstQueueToInsert;
        system.debug('**** lstQueueToInsert '+lstQueueToInsert);
    } // end of updateSyncQueueRecord method
} // end of class