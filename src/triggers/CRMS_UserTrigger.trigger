/**
    Trigger on User object for sync with DWH
    Author: Saket Joshi
    Version: 1.0
*/

trigger CRMS_UserTrigger on User (after insert, after update, before delete, 
before insert, before update) {
    //Before insert method
    if(trigger.isBefore && trigger.isInsert) {
        List<User> lstImportedUsers = new List<User> ();
        List<User> lstNotImportedUsers = new List<User> ();
        
        CRMS_UserTriggerHandler objHandler = new CRMS_UserTriggerHandler();
        
        for(User objUser : trigger.new) {
            if(objUser.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED)
                lstImportedUsers.add(objUser);
            else
                lstNotImportedUsers.add(objUser);
        }
        
        if(lstImportedUsers != null && !lstImportedUsers.isEmpty())
            objHandler.setDwhStatusSynced(lstImportedUsers);
        if(lstNotImportedUsers != null && !lstNotImportedUsers.isEmpty())
            objHandler.setDwhStatusQueued(lstNotImportedUsers);
    }
    
    //After insert method
    if(trigger.isAfter && trigger.isInsert) {
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !CRMS_UserTriggerHandler.isTriggerCalledInsert && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
    		AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_CREATE);
    		//CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_CREATE);
    		CRMS_UserTriggerHandler.isTriggerCalledInsert = true;
        } 
    }
    
    //Before update method
    if(trigger.isBefore && trigger.isUpdate) {
        List<User> lstImportedUsers = new List<User> ();
        List<User> lstNotImportedUsers = new List<User> ();
        CRMS_UserTriggerHandler objHandler = new CRMS_UserTriggerHandler();
        
        for(User objUser : trigger.new) {
            if (objUser.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                lstImportedUsers.add(objUser);
            } else  { //if (objUser.DWH_Import__c == false && Trigger.oldMap.get(objUser.Id).DWH_Import__c == false)
                lstNotImportedUsers.add(objUser);
            }
        }
        if (!lstImportedUsers.isEmpty()) {
            objHandler.setDwhStatusSynced(lstImportedUsers);
        }
        if (!lstNotImportedUsers.isEmpty()) {
            objHandler.setDwhStatusQueued(lstNotImportedUsers);
        }
    }
    
    //After update method
    if(trigger.isAfter && trigger.isUpdate) {
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !CRMS_UserTriggerHandler.isTriggerCalled && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
    		AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
    		//CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
    		CRMS_UserTriggerHandler.isTriggerCalled = true;
        }
    }
}