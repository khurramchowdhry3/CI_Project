/**
    Trigger on campaign to perform sync with DWH
    Author: Saket Joshi
    Created Date: 31/03/2015    Version: 1.0
*/

trigger CRMS_CampaignTrigger on Campaign (after insert, after update, before delete, 
before insert, before update) {

    //Before insert method
    if(trigger.isBefore && trigger.isInsert) {
        List<Campaign> lstImportedCampaigns = new List<Campaign> ();
        List<Campaign> lstNotImportedCampaigns = new List<Campaign> ();
        
        CRMS_CampaignTriggerHandler objHandler = new CRMS_CampaignTriggerHandler();
        
        for(Campaign objCampaign : trigger.new) {
            if(objCampaign.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED)
                lstImportedCampaigns.add(objCampaign);
            else
                lstNotImportedCampaigns.add(objCampaign);
        }
        
        if(lstImportedCampaigns != null && !lstImportedCampaigns.isEmpty())
            objHandler.setDwhStatusSynced(lstImportedCampaigns);
        if(lstNotImportedCampaigns != null && !lstNotImportedCampaigns.isEmpty())
            objHandler.setDwhStatusQueued(lstNotImportedCampaigns);
    }
    
    //After insert method
    if(trigger.isAfter && trigger.isInsert) {
    	if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !CRMS_CampaignTriggerHandler.isTriggerCalledOnInsert && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
            //AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_INSERT);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
            CRMS_CampaignTriggerHandler.isTriggerCalledOnInsert = true;
        }
    }
    
    //Before update method
    if(trigger.isBefore && trigger.isUpdate) {
        List<Campaign> lstImportedCampaigns = new List<Campaign> ();
        List<Campaign> lstNotImportedCampaigns = new List<Campaign> ();
        CRMS_CampaignTriggerHandler objHandler = new CRMS_CampaignTriggerHandler();
        
        for(Campaign objCampaign : trigger.new) {
            if (objCampaign.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                lstImportedCampaigns.add(objCampaign);
            } else  {  //if (objCampaign.DWH_Import__c == false && Trigger.oldMap.get(objCampaign.Id).DWH_Import__c == false)
                lstNotImportedCampaigns.add(objCampaign);
            }
        }
        if (!lstImportedCampaigns.isEmpty()) {
            objHandler.setDwhStatusSynced(lstImportedCampaigns);
        }
        if (!lstNotImportedCampaigns.isEmpty()) {
            objHandler.setDwhStatusQueued(lstNotImportedCampaigns);
        }
    }
    
    //After update method
    if(trigger.isAfter && trigger.isUpdate) {
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !CRMS_CampaignTriggerHandler.isTriggerCalled && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
            //AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
            CRMS_CampaignTriggerHandler.isTriggerCalled = true;
        }
    }
    
    //Before delete method
    if(trigger.isBefore && trigger.isDelete) {
        List<Campaign> lstCampaigns = new List<Campaign> ();
        CRMS_CampaignTriggerHandler objHandler = new CRMS_CampaignTriggerHandler();
        
        for(Campaign objCampaign : trigger.old)
            lstCampaigns.add(objCampaign);
        
        if(lstCampaigns != null && !lstCampaigns.isEmpty())
            objHandler.updateSyncQueueRecord(lstCampaigns);
    }
}