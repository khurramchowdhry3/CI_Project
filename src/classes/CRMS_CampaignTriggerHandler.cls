/**
    Handler class for the campaign trigger
    Author: Saket Joshi
    Created Date: 31/03/2015    Version: 1.0
*/

public class CRMS_CampaignTriggerHandler {

    public static Boolean isTriggerCalled = false;
    public static Boolean isTriggerCalledOnInsert = false;
    
    //Method to set the DWH_Status to Synced for Campaign
    public void setDwhStatusSynced(List<Campaign> lstCampaigns) {
        for(Campaign objCampaign : lstCampaigns) {
            objCampaign.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            objCampaign.DWH_Last_Sync__c = Datetime.now();
        }
    }
    
    //Method to set the DWH_Status to Queued for Campaign
    public void setDwhStatusQueued(List<Campaign> lstCampaigns) {
        for(Campaign objCampaign : lstCampaigns)
            objCampaign.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
    }

    //Method to process the update of Campaign record and create/update sync queue record resp
    public void updateSyncQueueRecord(List<Campaign> lstCampaigns) {
        Map<Id, List<Sync_Queue__c>> mapCampaignIdListQueue = new Map<Id, List<Sync_Queue__c>>();
        List<Sync_Queue__c> lstQueueToInsert = new List<Sync_Queue__c>();
        List<Sync_Queue__c> lstQueueToUpdate = new List<Sync_Queue__c>();
        
        for(Campaign objCampaign : lstCampaigns)
            mapCampaignIdListQueue.put(objCampaign.Id, new List<Sync_Queue__c> ());
        
        List<Sync_Queue__c> lstQueue = new List<Sync_Queue__c>();
        lstQueue = [SELECT Id,
                        Campaign__c,
                        DWH_Data_Type__c,
                        Notes__c,
                        Queued_Record_ID__c,
                        Sync_Status__c
                        FROM Sync_Queue__c
                        WHERE 
                            Campaign__c IN :mapCampaignIdListQueue.keySet()
                            AND Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING];
        
        for(Sync_Queue__c objQueue : lstQueue) {
            if(mapCampaignIdListQueue.containsKey(objQueue.Campaign__c) && mapCampaignIdListQueue.get(objQueue.Campaign__c) != null)
                mapCampaignIdListQueue.get(objQueue.Campaign__c).add(objQueue);
            else
                mapCampaignIdListQueue.put(objQueue.Campaign__c, new List<Sync_Queue__c> { objQueue });
        }
        
        for(Campaign objCampaign : lstCampaigns) {
            List<Sync_Queue__c> lstQueueWithGuarantors = mapCampaignIdListQueue.get(objCampaign.Id);
            if(lstQueueWithGuarantors != null && !lstQueueWithGuarantors.isEmpty()) {
                for(Sync_Queue__c objQueue : lstQueueWithGuarantors) {
                    if(!objQueue.Sync_Status__c.equals(CRMS_Constants.SYNC_STATUS_DELETE)) {
                        objQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                        objQueue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                        //objQueue.Notes__c = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                        objQueue.Queued_Record_ID__c = objCampaign.Id;
                        lstQueueToUpdate.add(objQueue);
                    }
                }
            }
            
            lstQueueToInsert.add(new Sync_Queue__c (Queued_Record_ID__c = objCampaign.Id,
                                    DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_CAMPAIGN,
                                    Action__c = CRMS_Constants.SYNC_ACTION_DELETE,
                                    Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING));
        
        }
        
        if(lstQueueToUpdate != null && !lstQueueToUpdate.isEmpty())
            update lstQueueToUpdate;
        
        if(lstQueueToInsert != null && !lstQueueToInsert.isEmpty())
            insert lstQueueToInsert;
    } // end of updateSyncQueueRecord
} // end of class